## Table of contents
2. [R Basics](#2.R_basics)
3. [Markdown](#3.Markdown)
4. [Tidyverse](#4.Tidyverse)
5. [Data.table](#5.Data.table)
6. [Importing data](#6.Importing_data)
7. [Data visualization](#7.Data_visualization_distribution)
8. [ggplot2](#)
9. [Data visualization principles](#)
10. [Data visualization in practice](#)
11. [Reshaping data](#)
12. [Joining tables]
13. [Parsing dates and times]
14. [Locales]
15. [Web scraping]
16. [String processing]
17. [Text analysis]
```R
# Load the required packages
install.packages(c("dslabs", "dplyr", "ggplot2", "lubridate","geomtextpath"))
library(c("dslabs", "dplyr", "ggplot2", "lubridate", "geomtextpath"))
data(...)
```
# 2. R_basics 

### Basics
- <- for assigning values  = for providing values to argument
```R
> a <- 1 ##assign value to variable
[1] 1 ## ???
> print(a)
[1] 1
> ls()
[1] "a"
> TRUE ## FLASE
```
- naming: descriptive, lowercase, underscore(not blank space)
- function
```R
> log(x, base) ##sequence!!! or state: log(base=2, x=8)
> ?"^" ##help funstion, or: help("^")
> rm(x) ##remove object
```
### Data types & data structures
- major atomic data types: numeric(float/ double), integer(byte/ short/ long / int), logical (bool), factor
	- ==? interchange between integer and numeric==
	- mostly using numeric, integer is rarely used
```R
> class(a) ## check data type
[1] "numeric"
```
- data.frame: a class of  object, row(observation), col(variable, can be of different types)
	- "data.frame" "." is not format
	- ==?, str, head==
- accessor: $ : variables in this col
- names(): available variable names, preserves the order of the rows in the original data frame
![[Pasted image 20250901123609.png]]
![[Pasted image 20250901123737.png]]
 **vector**
- All entries in a vector need to be of the **same atomic data type**
- length(), class(),\==, = 
- define vector: c(), seq(), rep()
c()
```R 
##defining vector
> codes <- c(380, 124, 818) ## c() to concentrate
> codes
[1] 380 124 818
```
seq()
```R
> seq(1, 10)
> 1:10 ##shorthand for consecutive integer
#>  [1]  1  2  3  4  5  6  7  8  9 10
class(1:10)
#> [1] "integer"
class(seq(1, 10, 0.5))
#> [1] "numeric"
```
rep()
```R
> rep(seq(1:3), times=2)##repeat this pattern
[1] 1 2 3 1 2 3 
> rep(seq(1:3), each=2)##repeat each element
[1] 1 1 2 2 3 3 
```
name entry
```R
> codes_with_name <- c("italy" = 380, "canada" = 124, "egypt" = 818) ## name the entries of a vector
> codes_with_name
italy canada  egypt 
  380    124    818
class(codes)
#> [1] "numeric"
names(codes)
#> [1] "italy"  "canada" "egypt"
```
- coercion强制转换 & Not availables(NA)
	- logical → integer → numeric → character
```R
> x <- 1:5
> y <- as.character(x)## cast to char
> y
[1] "1" "2" "3" "4" "5" 
> as.numeric(y)## cast to numeric
[1] 1 2 3 4 5
> x <- c("1", "b", "3")
> as.numeric(x) ## Not availables(NA)
Warning: NAs introduced by coercion
[1]  1 NA  3
```
- subsetting
```R
codes[2]## output both entry names and value
codes[1:2]##first two, slicing
codes[c(1,3)]## element 1 and 3
```
- factors: categorial data
```R
> class(murders$region)
[1] "factor"
> levels(murders$region)
[1] "Northeast" "South" "North Central" "West"
> region <- murders$region
> value <- murders$total
> region <- reorder(region, value, FUN = sum)##takes the sum of the total murders in each region
> levels(region)
[1] "Northeast"  "North Central" "West"          "South"
```
**list**
- ==arbitrary combinations of different data types, Data frames are a special case of lists???==
- indexing: 
	- Double brackets ([[ ]]) return the value.
	  Single bracket ([ ]) returns a list with the key and the value
	- ==R index start with 1==
	- could be integer, vector [c(1,3)], [seq(1,10)], names["canada"], [c("name", "id")]
	- index with 0: [0] gives you the data type of the object, numeric(0), list()
	- index with -1: gives the same data structure, but with the specified item excluded
```R
> record$student_id ##Access component with the accessor $
[1] 1234
> record[["student_id"]] ##Access with [[ ]]
[1] 1234
> record["student_id"]
$student_id
[1] 1234
> v<-c(1,2,3)
```
![[Pasted image 20250902164704.png]]
- ==indexing with -1, summary table==
**matrix**
- All entries have to be of the same atomic data type
```R
mat <- matrix(1:12, 4, 3)##row and col specified
mat
#>      [,1] [,2] [,3]
#> [1,]    1    5    9
#> [2,]    2    6   10
#> [3,]    3    7   11
#> [4,]    4    8   12
mat[2, 3]##access one entry
#> [1] 10
mat[2, ]##entire row
#> [1]  2  6 10
mat[, 3]##entire col
#> [1]  9 10 11 12
mat[1:2, 2:3]##sub matrix
#>      [,1] [,2]
#> [1,]    5    9
#> [2,]    6   10
```
![[Pasted image 20250904153928.png]]
### Operations
**sorting**
```R
> x <- c(31, 4, 15, 92, 65)
> sort(x)##directly sort the value, without knowing the index
[1]  4 15 31 65 92
> index <- order(x)##returns the index that sorts input vector
> x[index]##"index" is a sequence
[1]  4 15 31 65 92##output the value sequence
> x##sort/order does on make change to the sequence itself
[1] 31 4 15 92 65
> order(x)
[1] 2 3 1 5 4##output the index sequence
```
- **sort()**: directly sort the value (number of total murders in each state), does not give us information about which states have which murder totals
- **order()**:returns the **index** that sorts input vector
	- sort/order does on make change to the vector itself
```R
> sort(murders$total)
[1]    2    4    5    5    7    8   11   12   12   16   19   21   22
> ind <- order(murders$total) ##order the state names by their total murders
> murders$state[ind] 
[1] "VT" "ND" "NH" "WY" "HI" "SD" "ME" "ID" "MT" "RI" "AK" "IA" "UT"
```
- **max**: max value
- **which.max**: index with max value
```R
> max(murder$total)
[1] 1257
> i_max <- which.max(murder$total)
> murders$state[i_max]
[1] "CL"
```
- **rank**: returns a vector with the rank of the first entry, second entry
```R
x <- c(31, 4, 15, 92, 65)
rank(x)
#> [1] 3 1 2 5 4
```
![[Pasted image 20250904144242.png]]
**vector arithmetic**
- recycling
```R
x <- c(1, 2, 3)
y <- c(10, 20, 30, 40, 50, 60, 70)
x+y
#> Warning in x + y: longer object length is not a multiple of shorter
#> object length
#> [1] 11 22 33 41 52 63 71
```
**indexing**
- which: which entries of a logical operator is TRUE
	- more than one: return value is automatically sorted
```R
> nurder$state == "California"
[1] FALSE FALSE FALSE FALSE TRUE FALSE FALSE ...
> which(murder$state == "California")
[1] 5 ##return the index
> murder_rate[which(murder$state == "California")]
[1] 3.374183
> murder_rate[which(murder$state == "California" | murder$state == "Florida")]##sequence donnot change
[1] 3.374183 3.393789
> murder_rate[which(murder$state == "Florida" | murder$state == "California")]##sequence donnot change
[1] 3.374183 3.393789
```
- match({vector of several entries}, {vector}): which indexes of a second vector match each of the entries of a first vector
	- match output indices in the same order as the input vector
	- return a vector of same length
	- case with mismatch
```R
> match(c("New York", "Florida", "Texas"), murders$state)
[1] 33 10 44
> murder_rate[match(c("Hong Kong", "Florida"), murders$state)]
[1]      NA 3.34582 ##same length
```
- %in%: whether element of the first vector is in the second vector
```R
c("Boston", "Dakota", "Washington") %in% murders$state
#> [1] FALSE FALSE  TRUE
```
similar expression: 
```R
match(c("New York", "Florida", "Texas"), murders$state)
#> [1] 33 10 44
which(murders$state%in%c("New York", "Florida", "Texas"))## which return which entries the statement is true
#> [1] 10 33 44
```
**indexing with a logical vector**
- ind: logical vector
- index the state vector with a logical vector &rArr; return states that satisfies the logic (logical value is true)
- sum(ind): counting numbers of trues (TRUE&rArr;1; FALSE&rArr;0)
![[Pasted image 20250913210832.png]]

**logical operator**
- TRUE is the logical value
- &: “bitwise and”
- &&: only looks for the first element
- Always use & and |
**basic plot**
- scatter plot
- histogram
- box plot
```R
> plot(murder$population / 10^6, murder$total)##scatter
> with(murders, plot(population / 10^5, total))##scatter
> with(murders, hist(total / population* 10^6))##histogram
> murders$rate ,_ with(murders, total . population*100000)
> boxplot(rate~region, data = murders)
```
**control flow in R**
# 4.Tidyverse
##  4.1.Tidy_data
- row(==**1 observation** towards 1 value)
- col(1 diff variable available for observation)
```r
tidy format
#>       country year fertility
#> 1     Germany 1960      2.41
#> 2 South Korea 1960      6.16
#> 3     Germany 1961      2.44
#> 4 South Korea 1961      5.99
#> 5     Germany 1962      2.47
#> 6 South Korea 1962      5.79
not tidy: 1.row include several observation 2.(variable) year stored inthe header
#>       country 1960 1961 1962
#> 1     Germany 2.41 2.44 2.47
#> 2 South Korea 6.16 5.99 5.79

(should be converted into 1 number of people for 1 row)
, , Dept = A
          Gender
Admit      Male Female
  Admitted  512     89
  Rejected  313     19
, , Dept = B
          Gender
Admit      Male Female
  Admitted  353     17
  Rejected  207      8
...

```
## 4.2.Refining data frames
> - first arg: data frame
> - not directly change the data frame
- Adding columns: mutate `murders <- mutate(murders, rate = total/population*100000)`
	- look for variables in the data frame provided in the first argument (otherwise, object not defined ⇒ error)
	- `total ~ murders$total; population ~ murders$population`
- subsetting rows: filter `filter(murders, rate <= 0.71)`
- subsetting columns: select `select(murders, state, region, rate)`
	- helper function to select columns: 
		- `where(fn)` only numeric columns
		- `starts_with`, `ends_with`, `contains`, `matches`, and `num_range`, select column based on column name
	```R
	new_dataframe <- select(murders,where(is.numeric))
	names(new_dataframe)
	#> [1] "population" "total" "rate"
	new_dataframe <- select(nurders,starts_with("r")
	names(new_dataframe)
	#> [1] "region" "rate"
	```
## 4.3.Pipe
`2 |> log(8, base = _)`
-  `|>` or `%>%` to first arg by default
- ==placeholder __???==


- trace variables in data frames, similar to mutate, with no error
## 4.4.Summaries
`library(dplyr)` `library(dslabs)`
```r
s <- heights |> 
  filter(sex == "Female") |>
  summarize(average = mean(height), standard_deviation = sd(height))
s 
#>   average standard_deviation
#> 1    64.9               3.76
s$average # $ to access component of s(data frame)
#> [1] 64.9
```
>average: `murder|> summarize(rate=mean(rate))`
weighted average: `murders |> summarize(avg_rate = sum(total) / sum(popppulation * 100000))`
- multiple summaries
	- reframe: 
	  >we can’t use `summarize` because it expects one value per row (Warning: Returning more (or less) than 1 row per `summarise()` group was deprecated in dplyr)

    - data.frame: create frame/ reframe
```R
heights |> reframe(quantiles = quantile(height, c(0.5, 0, 1)))
#>   quantiles
#> 1      68.5
#> 2      50.0
#> 3      82.7
```
```r
median_min_max <- function(x){
  qs <- quantile(x, c(0.5, 0, 1))
  data.frame(median = qs[1], minimum = qs[2], maximum = qs[3]) ##return this dataframe
}
heights |> summarize(median_min_max(height))
#>   median minimum maximum
#> 1     65      51      79
```

- group_by then summarize

```r
 heights |> group_by(sex) |>
  summarize(average = mean(height), standard_deviation = sd(height))
#> # A tibble: 2 × 3
#>   sex    average standard_deviation
#>   <fct>    <dbl>              <dbl>
#> 1 Female    64.9               3.76
#> 2 Male      69.3               3.61
```
## 4.5.Sorting
- arrange: sorting data frames according to one column
    - `murders |> arrange(desc(rate)) |> head() 
    - default: ascending; desc(variable): descending
- nested sorting: `murders|>arrange(region, rate)|>head()`
- top_n: max top n
	- `murders |> slice_max(rate, n=5)`
	- top_n(\_, n) \==`head(): return first part, first 6 lines by default`
	- `top_n(-3)` find min instead of max
- between
## 4.6.Tibbles
## 4.7.Tibbles vs data frames
## 4.8.placeholder
```R
log(8, base = 2)
2 |> log(8, base = _)##|> 对应 __
2 %>% log(8, base = .)## %>% 对应 .
```
## 4.9.Purr package
- map series  
     ![Pasted image 20250925134234.png](app://c4ba962209a7a39e2c6406c2014c678a16a9/Users/sunnie/Desktop/Obsidian%20Vault/Pasted%20image%2020250925134234.png?1758778954534)
## 4.10.Tidyverse conditionals
- case_when
```R
x <- c(-2, -1, 0, 1, 2)
case_when(x < 0 ~ "Negative", x > 0 ~ "Positive", TRUE  ~ "Zero")
#> [1] "Negative" "Negative" "Zero"     "Positive" "Positive"
murders |> mutate(group = case_when(
    abb %in% c("ME", "NH", "VT", "MA", "RI", "CT") ~ "New England",
    abb %in% c("WA", "OR", "CA") ~ "West Coast",
    region == "South" ~ "South",
    TRUE ~ "Other")) |>
  group_by(group) |> summarize(rate = sum(total)/sum(population)*10^5) 
#> # A tibble: 4 × 2
#>   group        rate
#>   <chr>       <dbl>
#> 1 New England  1.72
#> 2 Other        2.71
#> 3 South        3.63
#> 4 West Coast   2.90
```
- between: `between(x, a, b)` same as `x>=a & x<=b`
`between(rnorm(100), seq(-2,-1,length.out=100), rep(1, times=100))`
# 6.Importing_data
- external data files and files format
	- file format: csv, tsv, xls/xlsx, 
- work with file system
	- relative path:
	  absolute path:
	- working directory: `getwd()`
- import data files
	- `murders <- read_csv("murders.csv")`
# 7.Data_visualization_distribution
- variable types
	- categorical: ordinal(with order), nominal (no order)
	- numerical: discrete, continuous
	`str(<data.frame>)` to see the structure of a data frame, type of its component variable
- scatter plot散点图: **(see in 8.ggplot2**)
- bar plot
	- (categorical, discrete): `heights |> ggplot(aes(sex)) + geom_bar()`
	- (categorical, proportion): `height |> cout(sex) |> mutate(proportion = n/sum(n)) |> ggplot(aes(sex, proportion)) + geom_col()`
- histogram : (numerical) split intervals if continuous
	- `height |> ggplot(aes(height)) |> geom_histogram(binwidth=2.5, fill = 'paleturquose', col = 'whitesmoke`) 
	- choose the best binwidth
	- by default: counts as y axes ; change to density scale`aes(y=after_stat(density))`
>eCDF: empirical cumulative distribution function
- smoothed density plot: (can: compare 2 distribution with the same axes)
	- `geom_density(adjust=1, alpha = 0.5)` 
	- adjust 1/2 : using half of the binwidth
```R
##compare distribution
geom_histogram(aes(y=after_stat(density)),binwidth,alpha, position)
geom_density(adjust=1, alpha=0.5)
```
- Normal/ Gaussian distribution
	- most values (about 95%) are within 2 SDs from the average
- Q-Q plot (quantile-quantile)
	- `geom_qq()+geom_qq_line()`
- box plot
	- outliers: independent points, ignore _outliers_ when computing the range
	- box: 0.25, 0.5, 0.75 quantile
	- whiskers: to max & min regardless of outliers
- violin plot
- stratification: split groups based on one or more variables
- grids of plot
```R
library(gridExtra)
grid.arrange(p5, p6, ncol = 2)
```
# 8.ggplot2
`library(ggplot2)` `library(tidyverse)`
"grammar of graphics" only for tidy data
- component of graph: data, geometry(type of plot), aesthetic mapping(axes), other layers(labels, title, legend图例, caption)
>DATA |> ggplot() + LAYER1 + LAYER2 + ...
- Initializing an object with data: 
	- `library(dslabs)`, `p <- murders |> ggplot()`
	- equivalent expression: `ggplot(data = muders)` /  `murders|>ggplot()`
- aesthetic mapping: link visual cues with data information
	`aes(x_axe, y_axe)`
	`aes(label = region)`(assign colors according to region, data-dependent)
	- non-aesthetic argument: `nudge_x = 1.5, nudge_y = 1.5`
```R
murders|> ggplot() ## initializing an object with data
+ geom_point(aes(population/10^6,total), size=3)## aes(aes_x, aes_y)
+ geom_text(aes(population/10^6, total, label = abb), nudge_x = 2, nudge_y = 2) 
```
- global aesthetic mapping
	- define a mapping in `ggplot`, all the geometries that are added as layers will default to this mapping
	  `ggplot(aes(population/10^6, total))`
	- override global mapping with local mapping
	  `geom_text(x=10, y=800, label = "Hello there!")`
- colors: 
	- data independent(1 color for all): `geom_point(color="blue")`
	- data dependent color: `geom_point(aes(color = region))`
- scaling axes: `scale_x_continuous(trans = "log10")`
- annotation: `labs(x="population in millions(log scale)", y = "total number of murders(log scale)", title = "US gun murders in 2010", color = "Region", <AES> = "New <AES> legend name")`
	- adding global trend: `geom_abline(slope=1, interception=log(rate, base=10))`
- ggrepel: `Install.packages(ggrepel)`, `library(ggrepel)`
	- display all labels(Inf) & automatically adjust `geom_text_repel(aes(label = state), max.overlaps = Inf)`
# 9. Data_visualization_principle
Good visualization?
- primary message: show/compare? quantity/ distribution/ relationship?
	- numerical variable: X/Y length , motion >> size/ angle/ orientation > color/ opacity&shade亮度
	- avoid Pie chart &lArr; 
- where to put 0
	```r
	
	```
- don't distort quantities
- order categories in a meaningful way
- show data
- ease comparison
- log transformation
	- right-skewed
	- ratios
- 2 variable plot
- 3 variabel plot
- no 3D 
# 10. Data_visualization_practice
>**10.1.Case1: fertility rate**
- scatterplots and faceting
	- facet 2D: `facet_grid(year~continent)`
	- facet 1D: `facet_grid(. ~ year)`, `facet_wrap(~ year, ncol=3)`
	- free scaling: `facet_wrap(.~year, scales="free"`, 
	  每张分图的坐标比例尺不同, 不利于数据对比, 不建议用 &lArr; Aim: facilitate comparison
	- fixed scale for better comparison
- time series (continuous trend over time): `geom_line()`
	- multiple lines &rarr; **set groups**: `ggplot(aes(x,y, group = country))`
	  **set color &rArr; automatic grouping:** `ggplot(aes(x,y, color = country))`
	- labels on the line: **package:** `geomtextpath`
	  `geom_textpath() + theme(legend/position = "none)`

>**10.2.Case2: income**
>GDP per capita = GDP/population
- data transformation
	- log(value) &rarr; heavy-tailed/ skewed: `ggplot(aes(log2(dollars_per_day)))`
	- **log(scale)** : `scale_x_continuous(transform = "log2")`, `scale_x_log10()`
>multimodal distribution (多个众数 mode)
- comparing multiple distribution
	- median representing 1 country's stat: `mutate(region = reorder(region, dollars_per_day, FUN = median) |> 
	  ggplot(aes(dollars_per_day, region))`
	- rotate x label: `theme(axis.text.x = element_text(angle=90, hjust=1))`
	-  **`geom_boxplot() + geom_beewarm()`**
	- stacked density: **Package:** `ggridges`, ` geom_density_ridges() `
		- ridge density + jitter: **`geom_density_ridges(jitter_points = TRUE)`**
		- ridge density + rug竖条:
		```R
		geom_density_ridges(jittered_points = TRUE, 
			position = position_points_jitter(height = 0),
			point_shape = '|', point_size = 3, point_alpha = 1, alpha = 0.7)
		```
	- vertical density: `geom_vioin(fill = "gray")`
- intersect of list: `country_list <- intersect(country_list1, country_list2)`
- set group, change to **factor**(control order of levels): 
```R
gapminder <- gapminder |> 
	mutate(group = case_when(
	    region %in% c("Western Europe", ...) ~ "West",
	    continent == "Africa" & region != "Northern Africa" ~ "Sub-Saharan",
		TRUE ~ "Others"))|>
	mutate(group = factor(group, levels = c("Others", "Sub-Saharan", "West" )))   
```
>10.3.Case study 2: ecological fallacy

>10.4.Case study 3:vaccines and infectious diseases

# 11.Reshaping_data
## 11.1.Data wrangling
- purpose: missing data, outliers & incorrect, standard format
- steps: data table operation, string processing, date/ time processing, wb page (html)parsing
## 11.2.tidy, long, wide
tidy: 1 row 1 observation, 1 col 1 diff variable
wide: var spread across col (names contain variable)
long: 相对于wide
- Wide &rarr; Long: `pivot_longer()`
	- \`col name\`  back quote to specify column name; "name" & "value" by default
	- indexing with negative sign (specify which col is not included in the pivot): `-country`, `[-1]`
	- names_to, values_to, names_from, values_from
	- **convert names(char by default) type** accordingly
```r
pivot_longer(wide_data, `1960`:`2015`, names_to = "year", values_to = "fertility")
pivot_longer(wide_data, -country, names_to = "year", values_to = "fertility")
... |> mutate(year = as.integer(year)) ## convert new col type to intendede ones
```
- Long &rarr; Wide: `pivot_wider()`
```r
new_wide_data <- new_tidy_data |>
	pivot_wider(names_from = year, values_from = fertility)
select(new_wide_data, country, `1960`:`1970` )
```
- separate: `separate(col_name, c("new_col_1", "new_col_2"), "separator")`
	- many delim: `separate_wider_delim(name, delim = "_", names = c("year", "name"), too_many = "merge")` 
```r
dat |> separate(name, c("year", "name"), "_", extra = "merge") |> 
	pivot_wider() |> 
	mutate(year = as.integer(year))## convert varible type
```
pivot_longer (separate individual number) &rarr; separate(specify variable name) &rarr; pivot_wider (combine rows)
# 12.joining_tables (joining and binding)
- joining: join col by matching

`left_join(tab1, tab2, by = "state")` matching col same as left (tab1)
`right_join(tab1, tab2, by = "state")` matching col same as right(tab2)
`inner_join()` 交集
`full_join()` 并集 
`semi_join()` 交集, 只保留tab1 col, 不添加tab2 col
`anti_join(A,B,by=...)`  A\B, 只保留tab1 col, 不添加tab2 col

- bind without matching: `bind_rows(tab1, tab2)`, `bind_cols(tab1,tab2)`
	- bind_cols: tab1 tab2 have same variable name
	- bind_rows: tab1 tab2 have diff var
	![[Pasted image 20251016172958.png]]
## 12.3.set_operator
`intersect()`, `union()`, `setdiff(A,B)`A\B, `setequal()`&rArr; `TRUE/FALSE`, 
# 15.Web_scraping
tidyverse &rArr; rvest &rArr; read_html
`read_html()` read from url link
`html_text()` display raw code
`html_elements()` extract only some element
`html_table()` convert the extracted nodes to R data frames
`setNames(c("state", "population", "total", "murder_rate"))` set col names 
```r
tab <- read_html("some_URL") |> 
	html_elements("table")
murders <- tab[[1]] |>
	html_table() |>
	setNames(c("state", "population", "total", "murder_rate"))
```
# 16.String_processing
## 16.1.stringr
`library(tidyverse)`, `library(stringr)` 
tidyverse &rArr; stringr &rArr; piping, operation are vectorized
`str_detect(murders_raw$population, ",")` whether certain col contain comma
```r
reported_heights |> 
  mutate(new_height = as.numeric(height)) |>
  filter(is.na(new_height)) |> 
  head(n = 4)
#>             time_stamp    sex                 height new_height
#> 1  2014-09-02 15:16:28   Male                  5' 4"         NA
#> 2  2014-09-02 15:16:37 Female                  165cm         NA
#> 3  2014-09-02 15:16:52   Male                    5'7         NA
#> 4  2014-09-02 15:16:56   Male                  >9000         NA
```
## 16.2.regular_expression
## 16.3.Parsing_date_and_time

# 17.Text_mining