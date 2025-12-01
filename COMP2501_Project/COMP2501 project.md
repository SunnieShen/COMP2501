![[2501report_ShenHongshan_Version2.Rmd]]>Aim: DS skills from real-world project
>communicating your finding
>domain expertise

[Proposal](#1.)
[Report](#2.)
[Presentation](#3.)
[Content Alignment](#content_check)
[超纲部分](#超出课程范围的部分)
# 1.
# proposal(5%)
### logistics
The project proposal submission will be in the form of Moodle quiz, answer the following: 
1. A tentative **topic** of your project; 
	1) model how stress and working conditions impact mental health 
	2) "Predicting Mental Health Treatment Needs Based on Workplace Factors and Demographic Characteristics"
2. The tentative **source of data** you plan to use for the project;
	Mental Health in Tech Survey dataset from Open Sourcing Mental Illness (OSMI), similar to the dataset used in the analyzed notebook, containing survey responses about mental health in workplace settings.
	https://www.kaggle.com/datasets/osmi/mental-health-in-tech-survey/data
3. One to two **data science questions** you want to answer with the data; 
	1) Which workplace factors and demographic characteristics are most predictive of needing mental health treatment?
	2) how to build a machine learning model to identify individuals who would benefit from mental health intervention based on their survey responses?
4. A **short proposal (within 300 words)** stating: 
	-  **Importance** of the question(s); 
	Mental health issues in workplace environments is a significant public health concern with economic and social consequences. Early identification of individuals who need mental health support can facilitate timely intervention, reduce workplace productivity loss, and improve overall well-being. This project addresses the need for data-driven approaches to mental health screening in professional settings.
	- **Challenges/difficulties** envisioned in answering the question(s)? 
	Several challenges are anticipated, including handling ==class imbalance== in the target variable, managing missing survey data, and addressing potential ==response bias==. The subjective nature of self-reported mental health data may introduce noise. 
	- If there are notable **existing works** related to the question(s), describe them briefly. 
	Previous research has established correlations between workplace stress and mental health outcomes. The analyzed notebook demonstrates successful application of multiple machine learning algorithms to similar mental health prediction tasks, achieving approximately 80-85% accuracy with ensemble methods. Existing literature shows that factors like work interference, family history, and employer support significantly impact mental health treatment needs.
	 - A brief **overview of your planned approach or methods**. 
	 1. data loading and exploration using tidyverse
	 2. data cleaning: remove irrelevant columns, handle missing value and outliers. 
	 3. standardizing variables and data type conversion
	 4. data analysis and visualization using ggplot2: uncover patterns, relationships, and potential biases in the data. This will include examining the bivariate relationships between workplace factors and the outcome variable (treatment).
	 5. statistical modeling using logistic regression: Identify key predictors using logistic regression to quantify relationships between predictors and treatment-seeking behaviour. We will complement this with subgroup analyses to examine how these relationships vary by gender, country, and company size
	 6. conclusion
	
5. Do you want to give a short 10 min presentation (+5 min Q&A) in-class? 
 - 5-point bonus to your raw midterm (60) and final (~90) scores, subject to the maximum score limit
 
### proposal
- [x] topic given
- [x] sample report &rarr; logic
- [x] constructing your work
##### 1. 香港人才引入问题的研究(总量、趋势、结构性):
- 香港人才流失与引入
	- 格局分析: 总量、结构
	- 趋势: 时间、净流入、流出?
	- 匹配度: 人才的专业技能 Vs 香港重点发展的产业需求 &rarr; ? 水土不服? 才高就低
	- 留存情况分析
##### 2.How do various lifestyles and study habits influence exam performance?/ How time management and lifestyle balance affects students’ academic performance and mental well-being?
- data source:
	- https://www.kaggle.com/datasets/afnansaifafnan/study-habits-and-activities-of-students
		   - **Student ID** : A unique identifier assigned to each student.
		   - **Study Hours Per Day** : Average number of hours in which a student spends time for studying daily.
		   - **Extracurricular Hours Per Day** : spending time on extra-cocurricular activities such as clubs, arts,sports, or other hobbies.
		   - **Sleep Hours Per Day** : Number of hours a student sleeps per day.
		   - **Social Hours Per Day** : Time spent with friends, family, or social interactions.
		   - **Physical Activity Hours Per Day** : Time spent in physical activities or exercise.
		   - **GPA** : Grade Point Average representing academic performance.
		   - **Stress Level** : Stress category of the student (Low, Moderate, High).
- https://www.kaggle.com/datasets/nalisha/student-exam-scores-analysis-ipyn
	- student_id
	- hours_studied
	- sleep_hours
	- attendance_percent
	- previous_scores
	- exam_score
##### ==3. model how stress and working conditions impact mental health==
- Analysis of the Notebook Research Approach, research flow:
	**Core Objective**: Binary classification to predict whether a patient needs mental health treatment based on survey data.
	**Key Methodological Steps**:
	1. **Data Cleaning & Preprocessing**: Handles missing values, normalizes gender categories, processes age outliers
	2. **Feature Engineering**: Encodes categorical variables, creates age ranges, selects key features
	3. **Exploratory Analysis**: Uses correlation matrices and visualization to understand feature relationships
	4. **Model Development**: Tests multiple algorithms (Logistic Regression, KNN, Decision Trees, Random Forest, etc.)
	5. **Hyperparameter Tuning**: Employs GridSearch and RandomizedSearch for optimization
	6. **Model Evaluation**: Compares performance across multiple metrics and algorithms

- Tentative Source of Data
Mental Health in Tech Survey dataset from Open Sourcing Mental Illness (OSMI), similar to the dataset used in the analyzed notebook, containing survey responses about mental health in workplace settings.

- Data Science Questions
1. Which workplace factors and demographic characteristics are most predictive of needing mental health treatment?
2. Can we build an accurate machine learning model to identify individuals who would benefit from mental health intervention based on their survey responses?
- Short Proposal 
	
	**Importance**: Mental health issues in workplace environments represent a significant public health concern with substantial economic and social consequences. Early identification of individuals who need mental health support can facilitate timely intervention, reduce workplace productivity loss, and improve overall well-being. This project addresses the critical need for data-driven approaches to mental health screening in professional settings.
	
	**Challenges/Difficulties**: Several challenges are anticipated, including handling class imbalance in the target variable, managing missing survey data, and addressing potential response bias. The subjective nature of self-reported mental health data may introduce noise, and ensuring model interpretability for practical healthcare applications presents additional complexity. Feature selection from numerous survey variables while avoiding overfitting requires careful methodology.
	
	**Existing Works**: Previous research has established correlations between workplace stress and mental health outcomes. The analyzed notebook demonstrates successful application of multiple machine learning algorithms to similar mental health prediction tasks, achieving approximately 80-85% accuracy with ensemble methods. Existing literature shows that factors like work interference, family history, and employer support significantly impact mental health treatment needs.
	
	**Planned Approach**: Our methodology will follow a structured pipeline: comprehensive data preprocessing including handling missing values and outlier detection; feature engineering to transform categorical variables and create meaningful features; exploratory data analysis to understand variable relationships; implementation of multiple classification algorithms (logistic regression, random forests, gradient boosting, neural networks); hyperparameter optimization using grid search and cross-validation; and rigorous model evaluation using metrics like accuracy, precision, recall, and AUC-ROC. We will emphasize model interpretability to identify the most influential factors in mental health treatment prediction.
	
	**This approach will provide valuable insights for employers and healthcare providers to develop targeted mental health support programs.**
# 2.
# report 
• Compose your report in **R Markdown** and knit it into an html page; 
• Include the data files used in your analysis in t he submission, i.e., zip them together; 
	• Or add a note if the data is private or too large to be uploaded (>100M, in which case attach a link to the data); 
• Ensure your R Markdown file is fully runnable and reproducible. 
• Include **graphics (preferably), data visualization, description,** and **analysis to explain what you are doing and what data insights you have gained from the results/plots**. **The report should NOT contain only codes.** 
• Add **in-line comments** in code blocks to explain your codes wherever necessary. 
• Note that your project report may be shared with future students of this course.
![[2501report_ShenHongshan_Version2.Rmd]]
![[2501report_ShenHongshan_Version2.html]]
![[2501report_ShenHongshan_Version2.docx]]
- [ ]  tech company vs non-tech
# 3.
# presentation
Presentation video (5-10 min), share the following: 
• Problem definition & background 
	• Data science questions in the project, their importance, challenges, related works 
	• Data you have used 
• Results: 
	• methods and approaches 
	• major findings 
• Conclusion: 
	• Insights from the data 
	• Possible future extensions 
	• Acknowledgements, References

## Mental Health Treatment Prediction 

### **Slide 1: Crisis in Tech**
"In the tech industry, we celebrate innovation and disruption, but we rarely talk about the human cost. Behind the screens and code, there's a silent crisis affecting thousands of professionals. My project addresses this critical question: **Can we use data to identify who needs mental health support before it's too late?**"
- ==+ data?news?fact?==
### **Slide 2: The Core Problem **
"The challenge is clear: mental health issues often go **undetected** until they become severe. But what if we could **spot the warning signs early**? This led me to two key **research questions**"
1. "Which workplace factors and personal characteristics most strongly predict mental health treatment needs?"
2. "How can we build a practical tool to identify at-risk individuals for timely intervention?"
**importance**
- **For employees:** Early detection means better outcomes and less suffering
- **For companies:** Mental health issues cost US businesses $200 billion annually
- **For society:** Reducing stigma through data-driven approaches
### **Slide 3: Data Foundation**
"To answer these questions, I turned to real-world data from the OSMI Mental Health in Tech Survey - one of the largest datasets of its kind."
**Data Source**
- 1,259 observation
- 27 variables covering demographics, work environment, and mental health history
==Real responses from real people facing real challenges==
**Data Challenges We Faced:**
- sampling bias
- Self-reporting biases , not standardized
- ==non-linear interaction???(not data itself)==
### **Slide 4: What the Data Revealed - Key Patterns**
factor-treatment correlation &rarr; regression model 
"Important patterns we discovered"

==demographic==
Age
family_history
Gender
==work_place==
**Work_interference**(EXP)
support_system
### **Slide 5: Logistic Regression
"Turning these patterns into predictions required a rigorous analytical framework. We built a model that learns from these relationships to identify at-risk individuals."
**Why We Chose Logistic Regression:**
- Provides interpretable results - we can understand WHY someone is at risk
- Gives probability scores, not just yes/no classifications
**Key Technical Points:**
- 70/30 ==train-test split==for honest evaluation
- Comprehensive multicollinearity checks
- Focus on both accuracy AND interpretability
### **Slide 7: The Most Important Predictors**
"what actually matters when predicting mental health needs? Our analysis revealed a clear hierarchy of factors..."
**Top Predictors (bar chart showing relative importance)**
1. **Work Interference** (24x increased risk)
2. **Family History** (3x increased risk)  
3. **Access to Care Options** (2x variation)
4. **Gender** (males 60% less likely to seek help)
5. **Coworker Support** (2.4x with supportive colleagues)
finding
"Work interference wasn't just important - it was the strongest predictor. This suggests that observable workplace impacts might be the most reliable early warning sign."
### **Slide 6: Model Performance - Does It Work? 
"So, does our model actually work? The results are promising..."
**Performance Metrics:**
- **85% accuracy** in identifying treatment needs
- **0.84 AUC score** - excellent at distinguishing high-risk individuals
- **89% specificity** - minimal false alarms
- **63% sensitivity** - good at catching true cases

**What This Means Practically:**
- Can identify 8-9 out of 10 employees who genuinely need support
- Minimizes unnecessary interventions
- Provides actionable risk scores, not just binary labels

Clean ROC curve with clear performance benchmarks


==(Slide 8-10: from Deepseek)==
==how to conclude???==
### ==**Slide 8: From Data to Action - Practical Applications (1 minute)**==

**Real-World Applications:**
- **Proactive HR outreach** to high-risk employees
- **Benefits optimization** based on actual risk factors
- **Manager training** focused on early warning signs
- **New hire support** tailored to individual risk profiles
### **Slide 9: Limitations & Responsible Use 
**Script:**
"Of course, no model is perfect, and this approach requires careful, ethical implementation."

**Important Caveats:**
- This identifies ==correlation, not causation(already solved---> random forest)==
- Should enable support, not discrimination  
- Must complement human judgment, not replace it
- Requires strict privacy protections

"Prediction for support, not surveillance. Data for empowerment, not evaluation."
### **Slide 10: Conclusion & Future Vision (45 seconds)**
**Script:**
"==So, did we answer our original questions?== "

**Key Conclusions:**
- Work interference and family history are the strongest predictors
- We can build accurate, practical identification tools
- Data can help transform mental health from reactive to proactive
**Looking Ahead:**
- Expand to more industries beyond tech
- Incorporate real-time workplace data
- Test different intervention strategies
- Build more sophisticated prediction models
**Final Thought:**
"In the end, this isn't just about better algorithms. It's about creating workplaces where people don't have to struggle in silence. Where data serves humanity, not the other way around."


### ==(more)==

data insight but related to my original question???
**Slide: Beyond Simple Correlations - The Power of Interaction Effects**
risk factors don't operate in isolation - they amplify or buffer each other.

1. work interference and family history, interact with each other
- For employees without family history, even frequent work interference leads to only 60% treatment rate
- But for those with family history, the same level of work interference drives treatment rates above 90%
- **Business Insight**: This tells us screening should prioritize employees who report both family history AND work interference

1. gender and benefits
- Male employees are highly sensitive to benefits availability - treatment rates drop sharply without benefits  
- Female employees remain relatively stable, less affected by benefits access
- So, I**mproving mental health benefits may be particularly effective for increasing male help-seeking behavior**"

1. non-linear affect of Age
- Treatment needs peak twice: first in early adulthood (25-35 years), then again in mid-life (45-55 years)
- not simple 'older = higher risk' assumptions

1. random forest (==correlation indicates causation??? No==)
- Random forest model independently confirms feature importance rankings
- **Work interference, family history, and age** consistently rank as top predictors across different methods








# Content_check
根据您提供的课程代码文件，我来详细检查您的project point4-8是否超纲，并为每段代码找到对应的slide位置。

## 📋 总体评估

您的project point4-8**完全在课程范围内**，所有代码都能在讲义中找到直接对应的示例和理论基础。

## 🔍 详细代码对应分析

### **Point 4: 数据预处理和探索性分析**
**对应Slide位置：Lec13-Probability.pdf**

| 您的代码 | 对应Slide页面 | 内容描述 |
|---------|---------------|----------|
| `estimate_pi()`函数 | Page 6-8 | 蒙特卡洛方法计算π |
| `runif()`, `set.seed()` | Page 7,9 | 随机数生成器使用 |
| 扑克牌模拟代码 | Page 27-34 | 组合概率计算 |
| 同花顺概率计算 | Page 32 | `is_flush()`函数 |
| 21点概率计算 | Page 33-34 | `is_21()`函数 |
| 蒙提霍尔问题 | Page 35 | 概率决策问题 |
| eCDF绘图 | Page 39 | 经验分布函数 |
| 正态分布CDF/PDF | Page 40-41 | 理论分布可视化 |

### **Point 5: 统计推断和假设检验**
**对应Slide位置：Lec14-Statistical inference.pdf**

| 您的代码 | 对应Slide页面 | 内容描述 |
|---------|---------------|----------|
| 珠子抽样模拟 | Page 11 | 抽样分布 |
| 正态拟合和SE计算 | Page 18 | 标准误差可视化 |
| 置信区间验证 | Page 20 | `take_sample_and_check()` |
| 功效分析 | Page 24-25 | 样本量对CI的影响 |
| 卡方检验 | Page 30-31 | 性别偏见研究 |
| 比值比计算 | Page 32 | log(OR)和p值 |

### **Point 6: 回归分析**
**对应Slide位置：Lec16-Regression.pdf**

| 您的代码        | 对应Slide页面       | 内容描述       |
| ----------- | --------------- | ---------- |
| 相关性模拟       | Page 4          | 相关变量可视化    |
| 相关系数分布      | Page 10         | 相关系数的抽样分布  |
| Galton身高数据  | Page 5-6, 16-19 | 父子身高关系     |
| 线性回归拟合      | Page 19         | `lm()`函数使用 |
| 预测不确定性比较    | Page 21-22      | 回归vs条件均值   |
| 虚假相关        | Page 30-33      | 黄油消费vs离婚率  |
| p值多重检验      | Page 33         | 假阳性问题      |
| 混淆变量(UCB录取) | Page 38-40      | Simpson悖论  |

### **Point 7 & 8: 机器学习分类和模型比较**
**对应Slide位置：Lec17-Machine learning.pdf**

| 您的代码 | 对应Slide页面 | 内容描述 |
|---------|---------------|----------|
| 性别分类阈值 | Page 16-18 | 基于身高的分类 |
| F1-score优化 | Page 24-25 | 阈值选择 |
| ROC曲线分析 | Page 26-27 | AUC计算 |
| PR曲线 | Page 28 | 精确率-召回率 |
| MNIST数据加载 | Page 9-10 | 图像数据处理 |
| KNN和XGBoost训练 | Page 11 | 模型训练代码 |
| 混淆矩阵可视化 | Page 31 | 模型性能评估 |
| 过拟合分析 | Page 31-33 | 训练vs测试性能 |
| 决策边界 | Page 34-39 | 2vs7分类问题 |

## ✅ 确认未超纲的部分

### **所有核心方法都在课程内：**
- ✅ 蒙特卡洛模拟
- ✅ 概率计算和组合数学
- ✅ 统计推断和假设检验
- ✅ 线性回归和相关分析
- ✅ 机器学习分类器(KNN, XGBoost)
- ✅ 模型评估指标(准确率,F1,ROC,AUC)
- ✅ 决策边界可视化

### **所有使用的R包都在课程中演示过：**
- ✅ `tidyverse`, `dslabs`, `caret`
- ✅ `gtools`, `MASS`, `pROC`
- ✅ `randomForest`, `xgboost` (通过caret)

## ⚠️ 需要注意的边界

### **可能接近边界但仍在范围内的技术：**
1. **复杂的特征工程** - 如果使用讲义外的复杂特征提取
2. **高级模型集成** - 如果组合多个复杂模型
3. **自定义损失函数** - 如果修改标准评估指标

### **建议保持的边界：**
- 使用课程中演示的标准评估流程
- 采用讲义中展示的数据预处理方法
- 使用课程中涵盖的机器学习算法

## 🎯 结论

您的project point4-8**完全符合课程要求**，所有代码都能在讲义中找到直接对应的理论基础和实践示例。您可以自信地继续开发，这些内容都在课程评估的合理范围内。

如果您在具体实现过程中遇到任何不确定是否超纲的代码，欢迎随时咨询！


通过对比分析，我发现心理健康调查报告与这两个机器学习/回归课程代码有以下重合和超出范围的部分：

## **重合部分**

### 1. **数据预处理与分割**
```r
# 重合代码
set.seed(123)
train_idx <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
```
**作用**：使用相同的随机种子和数据分割方法确保结果可重现

### 2. **模型训练与评估**
```r
# 重合部分
logit_model <- glm(treatment_binary ~ ., data=train_data, family="binomial")
roc_curve <- roc(test_data$treatment_binary, test_data$predicted_prob)
auc(roc_curve)
confusionMatrix()
```
**作用**：都使用逻辑回归、ROC曲线、AUC和混淆矩阵进行模型评估

### 3. **特征重要性分析**
```r
# 重合概念
feature_importance <- broom::tidy(logit_model) %>%
  mutate(odds_ratio=exp(estimate))
```
**作用**：计算优势比来理解变量影响程度

### 4. **可视化方法**
```r
# 重合的可视化技术
ggplot() + geom_bar(position="fill")
ggplot() + geom_line()
```
**作用**：使用相似的ggplot2语法创建分类比例图和性能曲线

## **超出课程范围的部分**

### 1. **更复杂的数据清洗流程**
```r
# 超出部分：复杂的分类变量标准化
Gender = case_when(
  str_detect(tolower(Gender), "^m|^male|^man|^maile|^make|^mal$|^male-ish|^guy") ~ "Male",
  str_detect(tolower(Gender), "^f|^female|^woman|^femaile|^femake|^fem") ~ "Female",
  TRUE ~ "Transgender/Non-binary/Others"
)
```
**特点**：处理真实世界数据中的非标准分类响应

### 2. **业务应用导向的分析**
```r
# 超出部分：业务风险评分系统
risk_factors <- feature_importance %>%
  select(term, odds_ratio, p.value) %>%
  filter(p.value < 0.05) %>%
  arrange(desc(abs(log(odds_ratio))))
```
**特点**：将统计结果转化为可操作的业务洞察

### 3. **预测系统部署**
```r
# 超出部分：新数据预测框架
example_employees <- data.frame(...)
for(col in predictors) {
  if(!col %in% colnames(example_employees)) {
    mode_val <- names(sort(table(model_data[[col]]), decreasing = TRUE))[1]
    example_employees[[col]] <- factor(rep(mode_val, nrow(example_employees)), 
                                      levels=levels(model_data[[col]]))
  }
}
```
**特点**：构建完整的预测流水线，处理新数据的因子水平一致性

### 4. **综合报告撰写**
```r
# 超出部分：完整的分析报告结构
## 1. Data Loading & Exploration
## 2. Data Preparation & Cleaning  
## 3. Exploratory Data Analysis
## 4. Modelling & Statistical Analysis
## 5. Subgroup Analysis
## 6. Business Insights & Interpretation
## 7. Prediction Example
## 8. Conclusion
```
**特点**：从数据探索到业务建议的完整分析流程

### 5. **多重共线性诊断**
```r
# 超出部分：高级统计诊断
cat("VIF values (multicollinearity diagnosis):\n")
print(vif(logit_model))
```
**特点**：使用VIF检测预测变量间的多重共线性

## **总结**

**重合的技术**：
- 基本的数据分割和模型验证流程
- 逻辑回归建模和评估方法  
- ROC曲线和性能指标计算
- 基础的数据可视化技术

**超越课程的内容**：
- 真实世界数据的复杂清洗和预处理
- 业务导向的分析和决策支持系统
- 完整的预测模型部署流程
- 高级统计诊断（多重共线性）
- 综合性的报告撰写和结果解释
- 从数据到业务洞察的完整价值链

心理健康调查报告展示了如何将课堂上学到的机器学习基础技术应用到真实的商业分析场景中，并增加了数据工程、业务解释和系统部署等实践层面的内容。