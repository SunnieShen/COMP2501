>Aim: DS skills from real-world project
>communicating your finding
>domain expertise
# proposal (5%)
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
	• **Importance** of the question(s); 
	Mental health issues in workplace environments is a significant public health concern with economic and social consequences. Early identification of individuals who need mental health support can facilitate timely intervention, reduce workplace productivity loss, and improve overall well-being. This project addresses the need for data-driven approaches to mental health screening in professional settings.
	• **Challenges/difficulties** envisioned in answering the question(s)? 
	Several challenges are anticipated, including handling class imbalance in the target variable, managing missing survey data, and addressing potential response bias. The subjective nature of self-reported mental health data may introduce noise, and ensuring model interpretability for practical healthcare applications presents additional complexity. Feature selection from numerous survey variables while avoiding overfitting requires careful methodology.
	• If there are notable **existing works** related to the question(s), describe them briefly. 
	• A brief **overview of your planned approach or methods**. 
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
# report 
• Compose your report in **R Markdown** and knit it into an html page; 
• Include the data files used in your analysis in t he submission, i.e., zip them together; 
	• Or add a note if the data is private or too large to be uploaded (>100M, in which case attach a link to the data); 
• Ensure your R Markdown file is fully runnable and reproducible. 
• Include graphics (preferably), data visualization, description, and analysis to explain what you are doing and what data insights you have gained from the results/plots. **The report should NOT contain only codes.** 
• Add in-line comments in code blocks to explain your codes wherever necessary. 
• Note that your project report may be shared with future students of this course.
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
