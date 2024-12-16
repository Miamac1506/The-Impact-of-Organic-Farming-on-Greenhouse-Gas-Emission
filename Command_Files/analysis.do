/*Mia Mac
  ECON 398 Project
  04/30/2024*/

clear
set more off
capture log close
********************RESULTS*************************************


//Setting working directory
cd "C:\Users\macmia\OneDrive - Dickinson College\Mac-398-Project"
log using Analysis_Data/analysis.log, replace
********************************************************************************

//Open the analysis file
use "Analysis_Data\analysis.dta"


// Estimate the relationship of organic_farming and greenhouse gas emission

// One way fixed effects control only for GDP and population
ssc install outreg2
reg totalCO2 total_organic_thousands_of_arces state_gdp population, robust
outreg2 using Analysis_Data/analysisregs.xls,  ctitle(OLS) replace

// Add in state fixed effects
egen stateID = group(state)

xtset stateID year

xtreg totalCO2 total_organic_thousands_of_arces state_gdp population, fe vce(cluster state)
outreg2 using Analysis_Data/analysisregs.xls, ctitle (FE-1) append
// Add in both year fixed effect and state fixed effect 

xtset stateID year

xtreg totalCO2 total_organic_thousands_of_arces state_gdp population i.year, fe vce(cluster state)
outreg2 using Analysis_Data/analysisregs.xls, ctitle (FE-2) append


log close
exit

