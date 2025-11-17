library(tidyverse)
library(dslabs)
library(gtools)
library(ggridges)

# MC simulation for calculating pi
estimate_pi <- function(n_iter, seed=42){
  set.seed(seed)

  x <- runif(n_iter, min=0, max=1) - 0.5
  y <- runif(n_iter, min=0, max=1) - 0.5
  dist <- sqrt(x**2 + y**2)
  area <- mean(dist <= 0.5)
  
  pi <- 4 * area
  pi
}

n_iters <- c(1e1, 1e2, 1e3, 1e4, 1e5)#
seeds <- seq(1:100)
df <- expand.grid(n_iters, seeds) |> setNames(c("n_iter", "seed"))
df$pi_estimates <- mapply(estimate_pi, df$n_iter, df$seed)

df |>
  group_by(n_iter) |>
  summarize(mean=mean(pi_estimates), sd=sd(pi_estimates)) |>
  mutate(mean=format(mean, digits=5))

df |>
  ggplot(aes(x = n_iter, y = pi_estimates, group = n_iter)) +
  geom_hline(yintercept = pi, linetype = "dashed") +
  geom_boxplot() +
  scale_x_log10() +
  theme_minimal()

# Simulations for pokers
suits <- c("Diamonds", "Clubs", "Hearts", "Spades")
numbers <- c(
  "Ace", "Deuce", "Three", "Four", "Five", "Six", "Seven", 
  "Eight", "Nine", "Ten", "Jack", "Queen", "King")
deck <- expand.grid(number=numbers, suit=suits)
deck <- paste(deck$number, deck$suit)
sample(deck, 5, replace=FALSE)

# Three-card scenarios
three_card_combinations <- permutations(52, 3, v=deck)

heart_cards <- paste(numbers, "Hearts")
p_first_is_heart <- mean(three_card_combinations[,1] %in% heart_cards)
p_second_is_heart <- mean(three_card_combinations[,2] %in% heart_cards)
p_third_is_heart <- mean(three_card_combinations[,3] %in% heart_cards)

p_all_are_heart <- mean(
  three_card_combinations[,1] %in% heart_cards &
  three_card_combinations[,2] %in% heart_cards &
  three_card_combinations[,3] %in% heart_cards)

print(p_first_is_heart * p_second_is_heart * p_third_is_heart)
print(p_all_are_heart)

# Event A: first card is heart
# Event B: second card is heart
# Event C: third card is heart
# P(A)
three_card_combinations |>
  as.data.frame() |>
  summarize(first_is_heart = mean(V1 %in% heart_cards))

# P(B|A)
three_card_combinations |>
  as.data.frame() |>
  filter(V1 %in% heart_cards) |>
  summarize(second_is_heart = mean(V2 %in% heart_cards))

# P(C|A,B)
three_card_combinations |>
  as.data.frame() |>
  filter(V1 %in% heart_cards & V2 %in% heart_cards) |>
  summarize(second_is_heart = mean(V3 %in% heart_cards))

# MC simulation of getting flush
is_flush <- function(seed=NA){
  if (!is.na(seed)){
    set.seed(seed)
  }

  hand <- sample(deck, 5, replace=FALSE)
  suits_in_hand <- str_split(hand, "\\s", simplify = TRUE)
  length(unique(suits_in_hand[,2])) == 1
}

set.seed(42)
mean(replicate(1e5, is_flush()))

# Natural 21
aces <- paste("Ace", suits)
facecard <- expand.grid(number=c("King", "Queen", "Jack", "Ten"), suit=suits)
facecard <- paste(facecard$number, facecard$suit)

hands <- combinations(52, 2, v=deck)
mean((hands[,1] %in% aces & hands[,2] %in% facecard) |
     (hands[,2] %in% aces & hands[,1] %in% facecard))

# MC simulation of getting natural 21
is_21 <- function(seed=NA){
  if (!is.na(seed)){
    set.seed(seed)
  }
  
  hand <- sample(deck, 2, replace=FALSE)
  flag1 <- hand[[1]] %in% aces & hand[[2]] %in% facecard
  flag2 <- hand[[2]] %in% aces & hand[[1]] %in% facecard
  flag1 | flag2
}

set.seed(42)
mean(replicate(1e5, is_21()))

# 蒙提霍尔问题模拟
simplified_monty_hall <- function(n = 10000) {
  # 随机生成汽车位置和初始选择
  cars <- sample(1:3, n, replace = TRUE)
  initial_choices <- sample(1:3, n, replace = TRUE)
  
  # 换门策略：总是换到另一扇未开的门
  switch_wins <- mean(initial_choices != cars)  # 初始选错时换门就赢
  
  # 不换门策略：坚持初始选择
  stay_wins <- mean(initial_choices == cars)    # 初始选对时就赢
  
  return(list(switch = switch_wins, stay = stay_wins))
}

results <- simplified_monty_hall(10000)
cat("换门胜率:", results$switch, "不换门胜率:", results$stay, "\n")


# eCDF for student heights
data(heights)
height_cdf <- function(threshold){
  heights |> summarize(value = mean(height <= threshold)) |> pull(value)
}
height_cdf(170 / 2.53)

df <- data.frame(val = seq(120, 220, 1))
df <- df |>
  mutate(val_in_inch = val / 2.53,
         ecdf = sapply(val_in_inch, height_cdf))
df |> ggplot(aes(val, ecdf)) + 
  geom_line() + 
  xlab("Height (cm)") +
  ylab("empirical CDF of student height") +
  theme_minimal()

# Plot CDF/PDF of Gaussian
df <- data.frame(
  val = seq(-5, 5, 0.01),
  cdf = pnorm(seq(-5, 5, 0.01), 0, 1)
)
df |> ggplot(aes(val, cdf)) +
  geom_line() + 
  ylab("CDF of a standard normal\n(mean=0, sd=1)") +
  theme_minimal()

df <- data.frame(
  val = seq(-5, 5, 0.01),
  pdf = dnorm(seq(-5, 5, 0.01), 0, 1)
)
df |> ggplot(aes(val, pdf)) + 
  geom_line() + 
  ylab("PDF of a standard normal\n(mean=0, sd=1)") +
  theme_minimal()
  
# Histogram/density estimate of heights
height_summary <- heights |>
  filter(sex == "Male") |>
  summarize(mean=mean(height), sd=sd(height))

heights |>
  filter(sex == "Male") |>
  ggplot(aes(height)) +
  geom_density(fill="blue", alpha=0.2) +
  stat_function(
    fun=dnorm,
    args=list(mean=height_summary$mean, sd=height_summary$sd),
    color="red") +
  ylab("Density") +
  theme_minimal()

sampled_heights <- data.frame(
  height = rnorm(500, mean=height_summary$mean, sd=height_summary$sd))
sampled_heights |> ggplot(aes(height)) + geom_histogram() + theme_minimal()

top_out_of_1000 <- function(){
  sampled_heights <- rnorm(1000, mean=height_summary$mean, sd=height_summary$sd)
  max(sampled_heights)
}
top_heights <- data.frame(height = replicate(1e5, top_out_of_1000()))
top_heights |> ggplot(aes(height)) + geom_histogram() + theme_minimal()

# Case study: loan
principal_per_loan <- 180000
operational_loss <- 20000
loss_per_foreclosure <- -(principal_per_loan + operational_loss)

sim_average_return <- function(interest_rate=0.02, default_rate=0.02, loans=1000){
  defaults <- sample(
      c(0,1), loans, prob=c(1-default_rate, default_rate), replace = TRUE)
  balance <- sum(defaults * loss_per_foreclosure) +
      sum((1 - defaults) * principal_per_loan * interest_rate)
  balance / loans
}

# MC at interest rate = 0.02
return_sampled <- data.frame(
  return=replicate(1e5, sim_average_return(0.02, 0.02))
)
return_sampled |>
  ggplot(aes(return)) + 
  geom_density(adjust = 1.5, fill = "blue", alpha = 0.2) + 
  geom_vline(xintercept = 0) +
  theme_minimal()

# MC at interest rate = 0.02~0.04
return_sampled <- data.frame(
  interest_rate=rep(seq(0.02, 0.04, 0.001), 1e5))

return_sampled <- return_sampled |>
  mutate(return=sapply(interest_rate, sim_average_return))

return_sampled |>
  mutate(interest_rate=as.factor(interest_rate)) |>
  ggplot(aes(return, interest_rate)) + 
    geom_density_ridges(bandwidth=300, fill="blue", alpha=0.2) +
    geom_vline(xintercept=0., lty="dashed") +
    theme_minimal()

return_sampled |>
  filter(interest_rate==0.023) |>
  ggplot(aes(return)) +
    stat_ecdf(geom = "step", color = "black") +
    geom_vline(xintercept=0., lty="dashed") +
    theme_minimal() +
    xlab("return (interest rate = 2.3%)") +
    ylab("eCDF")

return_sampled |>
  group_by(interest_rate) |>
  summarize(loss_prob = mean(return < 0)) |>
  ggplot(aes(interest_rate, loss_prob)) +
    geom_point() +
    geom_line() +
    geom_hline(yintercept=0.01, lty="dashed") +
    theme_minimal()

# MC at interest rate = 0.03, altering size
return_sampled <- data.frame(
  loans=rep(seq(1000, 5000, 500), 1e4))

f <- function(loans){
  sim_average_return(interest_rate=0.03, default_rate=0.02, loans=loans)
}

return_sampled <- return_sampled |>
  mutate(return=sapply(loans, f))

return_sampled |>
  group_by(loans) |>
  summarize(loss_prob = mean(return < 0)) |>
  ggplot(aes(loans, loss_prob)) +
  geom_point() +
  geom_line() +
  geom_hline(yintercept = 0.01, lty = "dashed") +
  theme_minimal()

# MC at default rate = 0.04
return_sampled <- data.frame(
  interest_rate=rep(seq(0.03, 0.1, 0.005), 1e5))

f <- function(i){
  sim_average_return(interest_rate=i, default_rate=0.04, loans=1000)
}

return_sampled <- return_sampled |>
  mutate(return=sapply(interest_rate, f))

return_sampled |>
  group_by(interest_rate) |>
  summarize(loss_prob = mean(return < 0)) |>
  ggplot(aes(interest_rate, loss_prob)) +
  geom_point() +
  geom_line() +
  geom_hline(yintercept = 0.01, lty = "dashed") +
  theme_minimal()

# When default rate is no longer independent
sample_return_when_default_rate_fluc <- function(){
  default_rate_fluc <- runif(1, -0.02, 0.02)
  default_rate <- 0.02 + default_rate_fluc
  balances <- sim_average_return(
      interest_rate = 0.03, default_rate = default_rate, loans = 3000)
  balances
}

returns_with_fluc <- replicate(1e5, sample_return_when_default_rate_fluc())
returns_flat <- data.frame(return = returns_with_fluc)

returns_flat |>
  ggplot(aes(return)) + 
    geom_density(fill="blue", alpha=0.2) +
    geom_vline(xintercept=0., lty="dashed") +
    xlab("return (interest rate = 3%, 3000 loans)") +
    theme_minimal()

returns_flat |> 
  summarize(loss_prob = mean(return < 0))
