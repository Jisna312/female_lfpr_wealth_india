*******************************************************
* Labor Force Participation Analysis - Stata Code
* 
* Data: IAIR7EFL.DTA (NFHS)
* Note: Dataset is proprietary and not included in this repo.
* Place the dataset in the 'data/' folder before running the code.
*******************************************************





clear
clear matrix
clear mata
set more off
set maxvar 10000
cd "data"
use IAIR7EFL.DTA, clear



*select married woman
tab v501
gen marital_status_str = string(v501)
tab marital_status_str
keep if marital_status_str == "1" 

* respondent's age group selection
rename v012 age
keep if age>=25 
tab age

* LFPR
count if missing(v731) 
gen lfprstr = string(v731)
gen lfpr = (lfprstr != "0" )
tab v731


*husband employed or not
tab v704a
drop if missing(v704a)
gen partner_work = string(v704a)
gen hus_work = (partner_work != "0")


*children
rename v218 total_children
rename v137 children_below_5



*caste
drop if missing(s116)
gen castestr = string(s116)
drop if castestr =="8"|| castestr == "."
tab castestr
gen dummy_SC =  (castestr == "1")
gen dummy_ST =  (castestr == "2")
gen dummy_OBC =  (castestr == "3")

*religion
gen religionstr = string(v130)
gen dummy_hindu =  (religionstr == "1")
gen dummy_muslim =  (religionstr == "2")
gen dummy_christian =  (religionstr == "3")



gen urbanstr = string(v102)
tab urbanstr
gen dummy_urban = (urbanstr == "1")

*Wealth quartile
rename v190 w_ind
count if missing(w_ind)
tab w_ind
gen w_indstr = string(w_ind)
tab w_indstr
gen dummy_poor  = (w_indstr =="1" || w_indstr == "2")
mean(dummy_poor)
gen dummy_middle = (w_indstr == "3" )
gen dummy_rich = (w_indstr == "4"  || w_indstr == "5")
gen Rich =  (w_indstr =="3" | w_indstr == "4"  | w_indstr == "5")

*house ownership
gen house_own_str = string(v745a)
count if missing(house_own_str)
gen dummy_house_own = (house_own_str !="0")

*respondent's education
count if missing(v106)
gen edu_str = string(v106)
gen dummy_no_education = (edu_str == "0")
gen dummy_primary = (edu_str == "1")
gen dummy_secondary = (edu_str == "2")
gen educated = (edu_str == "2" || edu_str =="3")

*weight
gen weight = v005/1000000

*Husband's occupation
gen hus_workstr = string(v705)
tab hus_workstr
count if missing(hus_workstr)
gen husband_work_type =  (hus_workstr == "1" || hus_workstr == "3")

 

*village fixed effects sampling
bysort v021: gen village_count = _N
count if village_count == 1

gen village_group = (village_count > 1)
preserve
gen Richstr = string(Rich)
keep if Richstr == "1"
ttest lfpr, by(village_group)
restore
ttest Rich, by(village_group)
rename v021 village

keep if village_count>=2

asdoc summarize dummy_poor Rich dummy_house_own  hus_work dummy_primary dummy_no_education dummy_secondary dummy_christian dummy_hindu dummy_muslim dummy_OBC dummy_SC dummy_ST age total_children children_below_5 husband_work_type[pweight = weight],replace
preserve
gen Richstr = string(Rich)
keep if Richstr == "0"
asdoc summarize lfpr [pweight=weight],replace
restore

*OLS regression robust

* no controls
reg lfpr Rich [pweight = weight],robust cluster(v001)replace


* no control + village fixed effects
 areg lfpr Rich [pweight = weight], absorb(village) robust cluster(v001)


*Individual control
areg lfpr Rich dummy_house_own hus_work dummy_primary dummy_no_education dummy_secondary c.age##c.age total_children children_below_5 husband_work_type [pweight = weight], absorb(village) robust cluster(v001)

* controls interaction village FE
areg lfpr Rich dummy_house_own hus_work dummy_primary dummy_no_education dummy_secondary dummy_christian dummy_hindu dummy_muslim dummy_OBC dummy_SC dummy_ST c.age##c.age total_children children_below_5 husband_work_type [pweight = weight], absorb(village) robust cluster(v001)


* First Regression: Simple LFPR and Rich
asdoc reg lfpr Rich [pweight = weight], robust cluster(v001) replace nest title(Simple Regression) save(results.doc)

* Second Regression: No Control + Village Fixed Effects
asdoc areg lfpr Rich [pweight = weight], absorb(village) robust cluster(v001) append nest title(No Control + Village Fixed Effects)

* Third Regression: Individual Control + Village Fixed Effects
asdoc areg lfpr Rich dummy_house_own hus_work dummy_primary dummy_no_education dummy_secondary c.age##c.age total_children children_below_5 husband_work_type [pweight = weight], absorb(village) robust cluster(v001) append nest title(Individual Control)

* Fourth Regression: Individual Control + Family characteristics + Village Fixed Effects
asdoc areg lfpr Rich dummy_house_own hus_work dummy_primary dummy_no_education dummy_secondary dummy_christian dummy_hindu dummy_muslim dummy_OBC dummy_SC dummy_ST c.age##c.age total_children children_below_5 husband_work_type [pweight = weight], absorb(village) robust cluster(v001) append nest title(Controls Interaction Village FE)


gen dummy_no_educationstr = string(dummy_no_education)
gen dummy_primarystr = string(dummy_primary)
gen dummy_secondarystr = string(dummy_secondary)

hetrogeneity
preserve
keep if dummy_no_educationstr == "0" & dummy_primarystr == "0" & dummy_secondarystr == "0"
areg lfpr Rich##dummy_house_own hus_work dummy_primary dummy_no_education dummy_secondary dummy_christian dummy_hindu dummy_muslim dummy_OBC dummy_SC dummy_ST c.age##c.age total_children children_below_5 husband_work_type [pweight = weight], absorb(village) robust cluster(v001) 
restore


* Bound analysis
ssc install psacalc

*base regression
xi:areg lfpr Rich dummy_house_own hus_work dummy_primary dummy_no_education dummy_secondary dummy_christian dummy_hindu dummy_muslim dummy_OBC dummy_SC dummy_ST c.age##c.age total_children children_below_5 husband_work_type [pweight=weight],absorb(village)robust cluster(v001)



psacalc beta Rich, rmax(0.4563) 

psacalc delta Rich, rmax(0.4563) 

psacalc beta dummy_middle, delta(.5) mcontrol (dummy_rich)

*bound analysis for dummy_rich
psacalc beta dummy_rich, rmax(0.4797) 
psacalc delta dummy_rich, rmax(0.4797)


 summarize dummy_poor[pweight = weight]
 


