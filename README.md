# female_lfpr_wealth_india
This project analyzes labor force participation among married women in India using NFHS data. It examines the impact of household wealth on female labor market outcomes. The analysis is implemented in Stata, including data cleaning, regression analysis with village fixed effects, robustness checks, and bound analysis.



##  Overview
This project analyses the relationship between **female labor force participation (LFPR)** and **household wealth** among married women above age 25 in India using NFHS (National Family Health Survey) 2005 data.  

The results are exported using the `asdoc` package, and robustness is checked through **bound analysis** using `psacalc`.

##  Requirements
To run this project, you need:

- **Stata 16 or later**
- Installed packages:
  ```stata
  ssc install asdoc
  ssc install psacalc
## Data

The analysis uses the NFHS dataset `IAIR7EFL.DTA`.  
**Note:** The dataset is proprietary and **cannot be included** in this repository.  

You can download the dataset from the NFHS website. 



## Folder Structure

female_lfpr_wealth_india/

  code/
    analysis.do        # Main Stata script

  data/
    IAIR7EFL.DTA       # Place your downloaded data here (dataset not included)
    
  docs/
    paper.pdf          # Research paper
    
  README.md            # Project documentation





## Methodology

Sample Selection: Married women aged 25 and above.

Dependent Variable: Labor Force Participation Rate (LFPR)

Key Independent Variable: Household wealth indicator (Rich)

Controls: Education, religion, caste, household ownership, children, husband’s occupation, and village-level fixed effects.

## Regression specifications include:

Simple OLS regression

Village fixed effects model

Individual controls + Village fixed effects

Individual controls + family characteristics + village fixed effects

## Heterogeneity and robustness
Heterogeneity analysis was done by checking if the relationship holds for different education levels of women

Robustness: Oster bound analysis




## Output

The regression results are exported as a .doc file in your working directory using the asdoc command.
Summary statistics and regression tables can be viewed directly from these exported files.

## Reference

Emily Oster. “Unobservable selection and coefficient stability: theory and evidence”. In: Journal of Business & Economic Statistics (2017), pp. 1–18.

Farzana Afridi, Taryn Dinkelman, and Kanika Mahajan. “Why are fewer married women joining the workforce in India? A decomposition analysis over two decades”. In: Journal of Population Economics 31.3 (2018), pp. 783–818.

Stephan Klasen and Janneke Pieters. “What explains the stagnation of female labor force participation in urban India?” In: World Bank Economic Review 29.3 (2015), pp. 449–478



