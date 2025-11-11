library(tidyverse)
library(gtools)

# MC simulation of disease detection
prevalence <- 100 / 100000  # 100 cases per 100k population
N <- 1e6  # population size
outcome <- sample(c('Disease', 'Healthy'), N, replace=TRUE,
                  prob=c(prevalence, 1 - prevalence))

test_acc <- 0.95
test <- vector("character", N)
N_D <- sum(outcome == 'Disease')
test[outcome == 'Disease'] <- sample(c('+', '-'), N_D, replace=TRUE,
                                     prob=c(test_acc, 1 - test_acc))
N_H <- sum(outcome == 'Healthy')
test[outcome == 'Healthy'] <- sample(c('-', '+'), N_H, replace=TRUE,
                                     prob=c(test_acc, 1 - test_acc))
table(outcome, test)

# Bayesian modeling of coin toss: observed two heads
df <- data.frame(p=seq(0, 1, 0.01))
df <- df |> mutate(posterior=p**2)

step_size <- 0.01  # Approximate the area under the curve
total_area <- sum(df$posterior * step_size)
df <- df |> mutate(posterior = posterior / total_area)  # Normalize

df |> ggplot(aes(p, posterior)) +
  geom_line() +
  ylab("Probability density (posterior)") +
  theme_minimal()

# Bayesian modeling of coin toss: observed 10 heads out of 14 tosses
cons = length(combinations(14, 10))
df <- data.frame(p=seq(0, 1, 0.01))
df <- df |> mutate(posterior=cons * ((1 - p)**4) * (p**10))

step_size <- 0.01
total_area <- sum(df$posterior * step_size)
df <- df |> mutate(posterior = posterior / total_area)  # Normalize

df |> ggplot(aes(p, posterior)) +
  geom_line() +
  ylab("Probability density (posterior)") +
  theme_minimal()
