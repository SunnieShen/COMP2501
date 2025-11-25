library(dslabs)
library(caret)
library(ggrepel)
library(tidyverse)
library(pROC)

##############################
# Case study: height => gender
data(heights)
y <- heights$sex
x <- heights$height

set.seed(42)
test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
test_set <- heights[test_index, ]
train_set <- heights[-test_index, ]

## Random guess
y_hat_test <- sample(c("Male", "Female"), length(test_index), replace=TRUE)
acc <- mean(y_hat_test == test_set$sex)

## Threshold
train_set |>
  ggplot(aes(height, fill=sex, group=sex)) +
  geom_density(alpha=0.25) +
  theme_minimal() +
  geom_vline(xintercept=67.23, lty="dashed")

predict_by_threshold <- function(threshold){
  y_hat <- ifelse(train_set$height >= threshold, "Male", "Female")
  mean(y_hat == train_set$sex)
}

predict_by_threshold_f1 <- function(threshold){
  y_hat <- ifelse(train_set$height >= threshold, "Male", "Female")
  F_meas(
    data = factor(y_hat, levels=c("Female", "Male")),
    reference = train_set$sex)
}

## Acc and F1 score
thresholding_performance <- data.frame(thr=seq(60, 70, 0.05))
thresholding_performance <- thresholding_performance |>
  mutate(acc=sapply(thr, predict_by_threshold)) |>
  mutate(f1=sapply(thr, predict_by_threshold_f1))

thresholding_performance |>
  ggplot() +
  geom_line(aes(thr, f1), color="red") +
  geom_vline(xintercept = 66.15, lty="dashed", color="red") +
  geom_line(aes(thr, acc), color="blue") +
  geom_vline(xintercept = 65, lty="dashed", color="blue") +
  ylab("Acc (blue), F1 (red)") +
  theme_minimal()

## ROC-AUC
labels <- ifelse(train_set$sex == "Female", 1, 0)
preds <- train_set$height
roc_curve <- roc(labels, preds)
random_roc_curve <- roc(labels, sample(c(0, 1), length(labels), replace=TRUE))

roc_df <- data.frame(
  thresholds = roc_curve$thresholds,
  tprs = roc_curve$sensitivities,
  fprs = 1 - roc_curve$specificities)

r_roc_df <- data.frame(
  thresholds = random_roc_curve$thresholds,
  r_tprs = random_roc_curve$sensitivities,
  r_fprs = 1 - random_roc_curve$specificities
)

ggplot() +
  geom_line(aes(fprs, tprs), data=roc_df, color="blue") +
  geom_line(aes(r_fprs, r_tprs), data=r_roc_df, color="black", lty="dashed") +
  xlab("False Positive Rate") +
  ylab("True Positive Rate") +
  theme_minimal()

print(auc(random_roc_curve))
print(auc(roc_curve))

## auPRC
library(PRROC)
pr <- pr.curve(scores.class0 = -train_set$height[train_set$sex == "Male"],
               scores.class1 = -train_set$height[train_set$sex == "Female"],
               curve = TRUE)
cat("AUC-PRC:", pr$auc.integral, "\n")
plot(pr, main = "Precision-Recall Curve")

##############################
# MNIST case study
mnist <- read_mnist()

## Visualize an example image
visualize_sample <- function(img, label, pred=NA){
  img_df <- expand.grid(x=seq(1:28), y=seq(1:28)) |>
    mutate(val = img)
  title <- paste("MNIST digit – label:", label)
  if (!is.na(pred)){
    title <- paste(title, "prediction:", pred)
  }
  img_df |>
    ggplot(aes(x, y, fill = val)) +
    geom_raster() +
    scale_fill_gradient(low = "white", high = "black") +
    scale_y_reverse() +   # top-left = (1,1)
    coord_fixed() +
    # theme_void() +
    labs(title = title)
}

idx <- 42
img <- mnist$train$images[idx,]
label <- mnist$train$labels[idx]
visualize_sample(img=img, label=label)

## Sample 1,000 training examples
set.seed(123)  # For reproducibility
train_index <- sample(nrow(mnist$train$images), 1000)
x_train <- mnist$train$images[train_index, ] / 255.
y_train <- factor(mnist$train$labels[train_index])

## Sample 1,000 test examples
test_index <- sample(nrow(mnist$test$images), 1000)
x_test <- mnist$test$images[test_index, ] / 255.
y_test <- factor(mnist$test$labels[test_index])

## Add column names (required for caret)
colnames(x_train) <- paste0("pxl_", 1:ncol(x_train))
colnames(x_test) <- colnames(x_train)

## Create data frames
train_df <- data.frame(x_train, y = y_train)
test_df <- data.frame(x_test, y = y_test)

## Train two models: a KNN model and a XGBoost tree classifier
knn_grid <- expand.grid(k = 5)
knn_model <- train(
  y ~ .,
  method = "knn",
  data = train_df,
  tuneGrid = knn_grid,
  trControl = trainControl(method = "none"))

xgb_grid <- expand.grid(
  nrounds = 100, max_depth = 6, eta = 0.3, gamma = 0,
  colsample_bytree = 0.8, min_child_weight = 1, subsample = 0.8)
xgb_model <- train(
  y ~ .,
  method = "xgbTree",
  data = train_df,
  tuneGrid = xgb_grid,
  trControl = trainControl(method = "none"))

plot_conf_mat <- function(labels, preds){
  confusion_matrix <- table(labels, preds)
  confusion_df <- as.data.frame(as.table(confusion_matrix))
  colnames(confusion_df) <- c("True", "Predicted", "Frequency")
  # Plot the confusion matrix using a heatmap
  ggplot(confusion_df, aes(x = Predicted, y = True, fill = Frequency)) +
    geom_tile(color = "white") +
    geom_text(aes(label = Frequency), color = "black", size = 5) +
    scale_fill_gradient(low = "white", high = "blue") +
    labs(
      title = "Confusion Matrix",
      x = "Predicted Labels",
      y = "True Labels"
    ) +
    theme_minimal()
}

y_hat_knn <- predict(knn_model, test_df, type = "raw")
print(paste("Accuracy", mean(y_hat_knn == test_df$y)))
plot_conf_mat(test_df$y, y_hat_knn)

y_hat_xgb <- predict(xgb_model, test_df, type = "raw")
print(paste("Accuracy", mean(y_hat_xgb == test_df$y)))
plot_conf_mat(test_df$y, y_hat_xgb)

## Overfitting
y_hat_xgb_train <- predict(xgb_model, train_df, type = "raw")
print(paste("Train set accuracy:", mean(y_hat_xgb_train == train_df$y)))
plot_conf_mat(train_df$y, y_hat_xgb_train)

y_hat_xgb <- predict(xgb_model, test_df, type = "raw")
print(paste("Test set accuracy:", mean(y_hat_xgb == test_df$y)))
plot_conf_mat(test_df$y, y_hat_xgb)


## Underfitting
set.seed(123)
train_index <- sample(nrow(mnist$train$images), 1000)
x_train <- mnist$train$images[train_index, ] / 255.
y_train <- factor(mnist$train$labels[train_index])
uf_train_df <- data.frame(x_train[,1:150], y = y_train)

test_index <- sample(nrow(mnist$test$images), 1000)
x_test <- mnist$test$images[test_index, ] / 255.
y_test <- factor(mnist$test$labels[test_index])
uf_test_df <- data.frame(x_test[,1:150], y = y_test)

xgb_grid <- expand.grid(
  nrounds = 100, max_depth = 6, eta = 0.3, gamma = 0,
  colsample_bytree = 0.8, min_child_weight = 1, subsample = 0.8)
uf_xgb_model <- train(
  y ~ .,
  method = "xgbTree",
  data = uf_train_df,
  tuneGrid = xgb_grid,
  trControl = trainControl(method = "none"))

y_hat_xgb_train <- predict(uf_xgb_model, uf_train_df, type = "raw")
print(paste("Train set accuracy:", mean(y_hat_xgb_train == uf_train_df$y)))
plot_conf_mat(uf_train_df$y, y_hat_xgb_train)

y_hat_xgb <- predict(uf_xgb_model, uf_test_df, type = "raw")
print(paste("Test set accuracy:", mean(y_hat_xgb == uf_test_df$y)))
plot_conf_mat(uf_test_df$y, y_hat_xgb)


##############################
# MNIST case study: 2 versus 7
data("mnist_27")
mnist_27$train |>
  ggplot(aes(x_1, x_2, color = y)) +
  geom_point() +
  theme_minimal()

fit <- mnist_27$train |>
  mutate(y = ifelse(y==7, 1, 0)) |>
  lm(y ~ x_1 + x_2, data = _)

p_hat <- predict(fit, newdata = mnist_27$test)
y_hat <- factor(ifelse(p_hat > 0.5, 7, 2))
print(paste("Accuracy:", mean(y_hat == mnist_27$test$y)))

knn_grid <- expand.grid(k = 10)
knn_model_27 <- train(
  y ~ .,
  method = "knn",
  data = mnist_27$train,
  tuneGrid = knn_grid,
  trControl = trainControl(method = "none"))

p_hat <- predict(knn_model_27, newdata = mnist_27$test, type="prob")["7"]
y_hat <- factor(ifelse(p_hat > 0.5, 7, 2))
print(paste("Accuracy:", mean(y_hat == mnist_27$test$y)))

xgb_grid <- expand.grid(
  nrounds = 100, max_depth = 6, eta = 0.3, gamma = 0,
  colsample_bytree = 0.8, min_child_weight = 1, subsample = 0.8)
xgb_model_27 <- train(
  y ~ .,
  method = "xgbTree",
  data = mnist_27$train,
  tuneGrid = xgb_grid,
  trControl = trainControl(method = "none"))

p_hat <- predict(xgb_model_27, newdata = mnist_27$test, type="prob")["7"]
y_hat <- factor(ifelse(p_hat > 0.5, 7, 2))
print(paste("Accuracy:", mean(y_hat == mnist_27$test$y)))

mnist_27$true_p |> ggplot(aes(x_1, x_2, z=p, fill=p)) +
  geom_raster() +
  scale_fill_gradientn(colors=c("#F8766D", "white", "#00BFC4")) +
  stat_contour(breaks=c(0.5), color="black") +
  theme_minimal()

grid_input <- mnist_27$true_p |> select(x_1, x_2)
grid_input |>
  mutate(pred = predict(fit, newdata = grid_input)) |>
  mutate(pred = pmax(0, pmin(pred, 1))) |>
  ggplot(aes(x_1, x_2, z=pred, fill=pred)) +
  geom_raster() +
  scale_fill_gradientn(
    colors=c("#F8766D", "white", "#00BFC4"),
    limits = c(0, 1)) +
  stat_contour(breaks=c(0.5), color="black") +
  theme_minimal()

grid_input |>
  mutate(pred = predict(knn_model_27, newdata = grid_input, type = "prob")["7"]) |>
  mutate(pred = pmax(0, pmin(pred, 1))) |>
  ggplot(aes(x_1, x_2, z=pred, fill=pred)) +
  geom_raster() +
  scale_fill_gradientn(
    colors=c("#F8766D", "white", "#00BFC4")) +
  stat_contour(breaks=c(0.5), color="black") +
  theme_minimal()

grid_input |>
  mutate(pred = predict(xgb_model_27, newdata = grid_input, type = "prob")["7"]) |>
  mutate(pred = pmax(0, pmin(pred, 1))) |>
  ggplot(aes(x_1, x_2, z=pred, fill=pred)) +
  geom_raster() +
  scale_fill_gradientn(
    colors=c("#F8766D", "white", "#00BFC4")) +
  stat_contour(breaks=c(0.5), color="black") +
  theme_minimal()


## Plot decision boundaries for the full model

extract_predictors <- function(img_vec) {
  img_df <- expand.grid(x=seq(1:28), y=seq(1:28)) |>
    mutate(val = img_vec)
  
  ul <- img_df |> filter(x <= 14, y <= 14) |> pull(val)
  lr <- img_df |> filter(x > 14, y > 14) |> pull(val)
  
  p_ul <- mean(ul > 0)
  p_lr <- mean(lr > 0)
  
  c(X1 = p_ul, X2 = p_lr)
}

dr_2 <- t(apply(mnist$test$images[test_index, ], 1, extract_predictors))
mnist_dr <- data.frame(
  x_1 = dr_2[, "X1"],
  x_2 = dr_2[, "X2"],
  y = factor(y_test),
  y_pred = predict(knn_model, newdata = test_df)
)
mnist_dr |>
  ggplot(aes(x_1, x_2, color=y_pred)) +
  geom_point(alpha=0.5) +
  theme_minimal()



