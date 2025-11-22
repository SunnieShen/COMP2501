library(MASS)
library(tidyverse)
install.packages("HistData")
library(HistData)

# Plotting of two variables
mu <- c(2, 5)
sigma <- matrix(c(2, 0, 0, 3), nrow = 2)  # No correlation

set.seed(42)
samples <- mvrnorm(n = 1000, mu = mu, Sigma = sigma)
samples <- data.frame(x = samples[,1], y = samples[,2])
samples |> ggplot(aes(x, y)) +
  geom_point() +
  scale_x_continuous(limits = c(-3, 7)) +
  scale_y_continuous(limits = c(-1, 9)) +
  theme_minimal()


sigma_correlated <- matrix(c(2, 1.5, 1.5, 3), nrow = 2)  # With correlation

set.seed(42)
samples <- mvrnorm(n = 1000, mu = mu, Sigma = sigma_correlated)
samples <- data.frame(x = samples[,1], y = samples[,2])
samples |> ggplot(aes(x, y)) +
  geom_point() +
  scale_x_continuous(limits = c(-3, 7)) +
  scale_y_continuous(limits = c(-1, 9)) +
  theme_minimal()

# Simulation of correlated variables
n <- 1000
mu <- c(0, 0)
sigma <- matrix(c(1, 0.5, 0.5, 1), nrow = 2)

sample_correlation <- function(){
  data <- mvrnorm(n = n, mu = mu, Sigma = sigma)
  cor(data[,1], data[,2])
}
sampled_cors <- data.frame(cor=replicate(1e4, sample_correlation()))
sampled_cors |>
  summarize(mean=mean(cor), sd=sd(cor))
cor_hat <- mean(sampled_cors$cor)
sampled_cors |>
  ggplot(aes(cor)) +
  geom_density(fill="blue", alpha=0.2) +
  stat_function(
    fun=dnorm,
    args=list(mean=cor_hat, sd=sqrt((1 - cor_hat**2)/(n - 2))),
    color="red") +
  ylab("density") +
  xlab("cor (n = 1000)") +
  scale_x_continuous(limits = c(0.2, 0.8)) +
  theme_minimal()

# Datasaurus dozen
library(datasauRus)
datasaurus_dozen |>
  ggplot(aes(x, y, color = dataset)) +
  geom_point(show.legend = FALSE) +
  facet_wrap(~dataset, ncol = 5) +
  theme_minimal()

# Case study: height
data("GaltonFamilies")

galton_heights <- GaltonFamilies |>
  filter(gender == "male") |>
  group_by(family) |>
  sample_n(1) |>  # Sample one child per family
  ungroup() |>
  dplyr::select(father, childHeight) |>
  rename(son = childHeight)

galton_heights |>
  ggplot(aes(father, son)) +
  geom_point(alpha=0.5) +
  theme_minimal()

x <- galton_heights$father
y <- galton_heights$son
n <- length(x)
mean(scale(x) * scale(y))
mean((scale(x) * scale(y)) * n / (n-1))
cor(x, y)
cor(y, x)

# Case study: height, two ways of calculating slope / intercept
mu_x <- mean(x)
s_x <- sd(x)
mu_y <- mean(y)
s_y <- sd(y)
rho <- cor(x, y)

galton_heights |>
  ggplot(aes(father, son)) +
  geom_point(alpha=0.5) +
  geom_abline(
    slope=rho * s_y/s_x,
    intercept=mu_y - mu_x * (rho * s_y/s_x)) +
  theme_minimal()

model <- lm(son ~ father, data=galton_heights)
galton_heights |>
  ggplot(aes(father, son)) +
  geom_point(alpha=0.5) +
  geom_abline(
    slope=model$coefficients[2],
    intercept=model$coefficients[1]) +
  theme_minimal()

# Case study: comparing uncertainty
rep <- 200
N <- 100

predict_using_conditional_avg <- function(father_height){
  dat <- sample_n(galton_heights, N)
  dat |> filter(between(father, father_height-1, father_height+1)) |>
    summarize(avg = mean(son)) |>
    pull(avg)
}

predict_using_regression <- function(father_height){
  dat <- sample_n(galton_heights, N)
  model <- lm(son ~ father, data=dat)
  predict(model, newdata=data.frame(father=c(father_height)))
}

predictions <- expand.grid(father_height=seq(66, 74, 1), i_sample=seq(1:rep))
predictions <- predictions |>
  mutate(predicted_cond_avg = sapply(father_height, predict_using_conditional_avg)) |>
  mutate(predicted_reg = sapply(father_height, predict_using_regression))

predictions |>
  pivot_longer(c("predicted_cond_avg", "predicted_reg")) |>
  filter(!is.na(value)) |>
  mutate(father_height=factor(father_height)) |>
  ggplot(aes(x=father_height, y=value, color=name)) +
  geom_boxplot() +
  xlab("Father height (inch)") +
  ylab("Son height (inch)") +
  theme_minimal()
  
predictions |>
  pivot_longer(c("predicted_cond_avg", "predicted_reg")) |>
  group_by(father_height, name) |>
  summarize(prediction_sd=sd(value)) |>
  ggplot(aes(x=father_height, y=prediction_sd, color=name)) +
  geom_line() +
  xlab("Father height (inch)") +
  ylab("SD of son height predictions (inch)") +
  theme_minimal()

# Divorce rate versus Margarine consumption
data("divorce_margarine")
divorce_margarine |> head(3)

divorce_margarine |>
  ggplot(aes(margarine_consumption_per_capita, divorce_rate_maine)) +
  geom_point() +
  geom_smooth(method="lm") +
  theme_minimal()

# MC for spurious correlation
set.seed(42)
N <- 25
g <- 1000000
sim_data <- data.frame(
  group = rep(1:g, each=N), 
  x = rnorm(N * g),
  y = rnorm(N * g))
sim_data |>
  group_by(group) |>
  summarize(cor = cor(x, y)) |>
  arrange(desc(cor)) |>
  head(5)

sim_data |>
  filter(group == 117480) |>
  ggplot(aes(x, y)) +
  geom_point() +
  geom_smooth(method="lm") +
  theme_minimal()

# Calculating p-value for associations
subset <- sim_data |>
  filter(group == 117480)
rho <- cor(subset$x, subset$y)
t_stat <- rho / sqrt((1 - rho**2)/(N - 2))
p_value <- 2 * pt(t_stat, df=N-1, lower.tail=FALSE)

cor.test(subset$x, subset$y, method = "pearson")

sim_data_with_p_value <- sim_data |>
  group_by(group) |>
  summarize(cor_pvalue = cor.test(x, y, method = "pearson")$p.value)

get_n_points_at_p_threshold <- function(p){
  sim_data_with_p_value |>
    filter(cor_pvalue <= p) |>
    pull(group) |>
    length()
}
df <- data.frame(p_thresholds = 10 ** seq(-5, -1, 0.5))
df |>
  mutate(n_points = sapply(p_thresholds, get_n_points_at_p_threshold)) |>
  ggplot(aes(p_thresholds, n_points)) +
  geom_point() +
  stat_function(fun = function(x) 1e6 * x, color = "red", linetype = "dashed") +
  scale_x_log10() +
  scale_y_log10() +
  xlab("p value threshold") +
  ylab("Number of groups passing the hypothesis test at the specified p-value thresholds")

# Demonstration of outliers
set.seed(42)
x <- rnorm(100,100,1)
y <- rnorm(100,84,1)
x[-23] <- scale(x[-23])
y[-23] <- scale(y[-23])
qplot(x, y)

cor(x, y)
cor(x[-23], y[-23])

# Confounder: UCB case study
data(admissions)
two_by_two <- admissions |> group_by(gender) |> 
  summarize(total_admitted = round(sum(admitted / 100 * applicants)), 
            not_admitted = sum(applicants) - sum(total_admitted)) |>
  select(-gender) 

chisq.test(two_by_two)$p.value

admissions |> select(major, gender, admitted) |>
  pivot_wider(names_from = "gender", values_from = "admitted") |>
  mutate(women_minus_men = women - men)

admissions |> 
  group_by(major) |> 
  summarize(admission_rate = sum(admitted * applicants)/sum(applicants),
            percent_women_applicants = sum(applicants * (gender=="women")) /
              sum(applicants) * 100) |>
  ggplot(aes(admission_rate, percent_women_applicants, label = major)) +
  geom_text() +
  theme_minimal()

admissions |> 
  ggplot(aes(major, admitted,
             col = gender, size = applicants)) +
  geom_point() +
  theme_minimal()


