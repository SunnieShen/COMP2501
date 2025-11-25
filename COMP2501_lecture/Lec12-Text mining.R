library(tidyverse)
library(lubridate)
library(tidytext)
library(textdata)

all_tweets <- jsonlite::fromJSON("Lec12-trump_tweets.json",
                                 simplifyDataFrame = TRUE)

# Filter out retweets and tweets start with quote symbols
trump_tweets <- all_tweets |>
  filter(isRetweet == "f" & !str_detect(text, '^["\']')) |>
  mutate(date = ymd_hms(date))

# Count devices
trump_tweets |> count(device) |> arrange(desc(n)) |> head(5)

# Select tweets from iPhone/Android during the campaign period
campaign_tweets <- trump_tweets |> 
  extract(device, "source", "Twitter for (.*)") |>
  filter(source %in% c("Android", "iPhone") &
         date >= ymd("2015-06-17") & 
         date < ymd("2016-11-08")) |>
  arrange(date)

# Plot and examine time in the day
# when tweets are posted from the two platforms
campaign_tweets |>
  mutate(hour = hour(with_tz(date, "EST"))) |>
  group_by(source) |>
  count(hour) |>
  mutate(percent = n / sum(n)) |>
  ungroup() |>
  ggplot(aes(hour, percent, color = source)) +
    geom_line() +
    geom_point() +
    scale_y_continuous() +#labels = percent_format()) +
    labs(x = "Hour of day (EST)", y = "proportion of tweets", color = "") +
    theme_minimal()

# An example tweet
example_tweet <- campaign_tweets[3008,]
example_tweet |> pull(text) |> str_wrap(width = 65) |> cat()

# Use regex to remove links and tokenize the example tweet
links_re <- "https://t.co/[A-Za-z\\d]+|&amp;"
example_tweet |> 
  mutate(text = str_replace_all(text, links_re, ""))  |>
  unnest_tokens(word, text) |>
  pull(word)

# Remove occurrences of stop words
all_campaign_tweet_words <- campaign_tweets |> 
  mutate(text = str_replace_all(text, links_re, "")) |>
  unnest_tokens(word, text) |>
  filter(!word %in% stop_words$word)

# The most common words
all_campaign_tweet_words |>
  count(word) |>
  top_n(10, n) |>
  arrange(desc(n))

# Remove pure numbers
all_campaign_tweet_words_no_number <- all_campaign_tweet_words |>
  filter(!str_detect(word, "^[\\d,.]+$"))

# Count the occurrences of each word by platform
all_campaign_tweet_words_no_number |>
  group_by(source) |>
  count(word) |>
  pivot_wider(names_from = "source", values_from = "n", values_fill = 0) |>
  top_n(10, Android + iPhone)
  
# Calculate the occurrences of each word and its odd ratio
word_by_source_odd_ratio <- all_campaign_tweet_words_no_number |>
  group_by(source) |>
  count(word) |>
  pivot_wider(names_from = "source", values_from = "n", values_fill = 0) |>
  mutate(odd_ratio = ((Android + 0.5) / (sum(Android) - Android + 0.5)) / 
                     ((iPhone + 0.5) / (sum(iPhone) - iPhone + 0.5)))

# Top words by platforms
top_android_words <- word_by_source_odd_ratio |>
  filter(Android + iPhone > 100) |>
  arrange(desc(odd_ratio)) |>
  head(10)

top_iphone_words <- word_by_source_odd_ratio |>
  filter(Android + iPhone > 100) |>
  arrange(odd_ratio) |>
  head(10)

# Sentiment analysis
nrc <- get_sentiments("nrc") |>
  select(word, sentiment)

# Add sentiment annotation to each word
word_by_source_odd_ratio <- word_by_source_odd_ratio |> 
  inner_join(nrc, by = "word", relationship = "many-to-many")

word_by_source_odd_ratio |>
  arrange(desc(Android + iPhone)) |>
  head(10)

# Calculate the occurences of sentiments (according to words)
sentiment_by_source <- word_by_source_odd_ratio |>
  group_by(sentiment) |>
  summarize(Android_s = sum(Android), iPhone_s = sum(iPhone)) |>
  mutate(Android_s_r = Android_s / (sum(Android_s) - Android_s) , 
         iPhone_s_r = iPhone_s / (sum(iPhone_s) - iPhone_s)) |>
  mutate(odd_ratio = Android_s_r / iPhone_s_r) |>
  arrange(odd_ratio)

# Odd Ratio, log(OR) and its SE
sentiment_by_source <- sentiment_by_source |>
  mutate(log_or = log(odd_ratio),
         se = sqrt(1/Android_s + 1/(sum(Android_s) - Android_s) + 
                   1/iPhone_s + 1/(sum(iPhone_s) - iPhone_s)),
         conf.low = log_or - qnorm(0.975)*se,
         conf.high = log_or + qnorm(0.975)*se)

# Plot the distribution of sentiment ORs
sentiment_by_source |>
  mutate(sentiment = reorder(sentiment, log_or)) |>
  ggplot(aes(x = sentiment, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point(aes(sentiment, log_or)) +
  ylab("Log odds ratio for association between Android and sentiment") +
  coord_flip() 

# Plot the top words for each sentiment
word_by_source_odd_ratio |>
  mutate(sentiment = factor(
    sentiment, levels = sentiment_by_source$sentiment)) |>
  mutate(log_or = log(odd_ratio)) |>
  filter(Android + iPhone > 10 & abs(log_or)>1) |>
  mutate(word = reorder(word, log_or)) |>
  ggplot(aes(word, log_or, fill = log_or < 0)) +
  facet_wrap(~sentiment, scales = "free_x", nrow = 2) + 
  geom_bar(stat="identity", show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
