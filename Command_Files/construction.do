/*Mia Mac
  ECON 398 Project
  04/09/2024*/

clear
set more off
capture log close
********************DATA & METHOD*************************************


//Setting working directory
cd "C:\Users\macmia\OneDrive - Dickinson College\Mac-398-Project"
log using Analysis_Data/construction.log, replace
********************************************************************************

//Open the base file
use "Original_Data\base_file.dta"

//Remove variables that do not need

drop agriculture
drop waste
drop landuse_forestry
drop transportation
drop total_energyuse
drop certified_operations
drop crops
drop pasture_rangeland
drop _merge
drop energy

//Re-scale the total_organic_arces to total_organic_thousands_of_arces
gen total_organic_thousands_of_arces = total_organic_arces / 1000

save "Analysis_Data\analysis.dta", replace

describe


log close
exit
