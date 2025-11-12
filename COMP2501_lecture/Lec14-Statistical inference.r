library(tidyverse)
library(dslabs)

# Poll - a jar of bead
p <- 0.4 # Ground truth proportion of blue beads
population_size <- 1e7
jar <- sample(c(0, 1), population_size, p=c(1 - p, p), replace=TRUE) 

take_sample <- function(n){
  sampled_beads <- sample(jar, n, replace=TRUE) 
  mean(sampled_beads)
}

results <- data.frame(prop=replicate(1e4, take_sample(1000)))
results |> ggplot(aes(prop)) +
  geom_histogram(binwidth = 0.003) +
  theme_minimal()

# Add normal fit
X_bar <- mean(results$prop)
X_se <- sqrt(sum((results$prop - X_bar)**2 / length(results$prop)))
results |> ggplot(aes(x=prop)) +
  geom_histogram(aes(y=after_stat(density))) +
  stat_function(
    fun=dnorm,
    args=list(mean=X_bar, sd=X_se),
    color="red") +
  geom_vline(xintercept=(X_bar - X_se * seq(-2, 2)), lty="dashed") + 
  theme_minimal()

# Confidence interval
take_sample_and_check <- function(n){
  sampled_beads <- sample(jar, n, replace=TRUE) 
  X_bar <- mean(sampled_beads)
  X_se <- sqrt(X_bar * (1 - X_bar) / n)
  between(p, X_bar - 1.96 * X_se, X_bar + 1.96 * X_se)
}

set.seed(42)
mean(replicate(1e4, take_sample_and_check(1000)))
mean(replicate(1e4, take_sample_and_check(25)))

# Power analysis at different p
ps <- c(0.501, 0.51, 0.53, 0.55, 0.6, 0.7, 0.8)
sample_size <- c(10, 30, 100, 300, 1000, 3000, 1e4, 3e4, 1e5, 3e5, 1e6, 3e6)
power_analysis <- expand.grid(p=ps, n=sample_size)
power_analysis <- power_analysis |>
  mutate(se=sqrt(p * (1-p) / n)) |>
  mutate(CI_lower=p - se * 1.95, CI_upper=p + se * 1.96)

power_analysis |>
  mutate(p = factor(p)) |>
  ggplot() +
  geom_line(aes(x=n, y=CI_lower, color=p)) +
  geom_line(aes(x=n, y=CI_upper, color=p), lty="dashed") +
  geom_hline(yintercept=0.5, color="black") +
  scale_x_log10() +
  scale_y_continuous(limits=c(0.49, 0.51)) +
  ylab("CI on estimate of p") +
  xlab("Sample size") +
  theme_minimal()

# Funding  / gender bias
data("research_funding_rates")
totals <- research_funding_rates |> 
  select(-discipline) |> 
  summarize_all(sum) |>
  summarize(yes_men = awards_men, 
            no_men = applications_men - awards_men, 
            yes_women = awards_women, 
            no_women = applications_women - awards_women) 

# Chi-square test
two_by_two <- data.frame(
  awarded = c("no", "yes"), 
  men = c(totals$no_men, totals$yes_men),
  women = c(totals$no_women, totals$yes_women))

chisq_test <- two_by_two |> select(-awarded) |> chisq.test()
chisq_test$p.value

# log(OR)
odds_ratio <- totals$no_men * totals$yes_women / (totals$yes_men * totals$no_women)
logor <- log(odds_ratio)
logor_se <- sqrt(sum(1 / totals))
z <- logor / logor_se

logor_pval <- 2 * pnorm(abs(z), lower.tail = FALSE)
logor_pval
