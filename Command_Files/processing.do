/*Mia Mac
  ECON 398 Project
  03/25/2024*/

clear
set more off
capture log close
********************DATA COLLECTION*************************************


//Setting working directory
cd "C:\Users\macmia\OneDrive - Dickinson College\Mac-398-Project"
log using Analysis_Data/processing.log, replace
********************************************************************************
//IMPORT AND CLEAN EMISSIONS DATA

//Import the original data from climatewatch-usemissions_importable.xlsx and retain only the variables relevant for the research
import excel "Original_Data\climatewatch-usemissions_importable.xlsx", firstrow 
keep State Year TotalCO2excludingLUCFMtCO EnergyMtCO2e AgricultureMtCO2e WasteMtCO2e LandUseandForestryMtCO2e TransportationMtCO2e StateGDPMillionUSchained PopulationPeople TotalEnergyUseThoustonnes

//Rename teh variabls to make it more managable
rename State state
rename Year year
rename TotalCO2excludingLUCFMtCO totalCO2
rename EnergyMtCO2e energy
rename AgricultureMtCO2e agriculture
rename WasteMtCO2e waste
rename LandUseandForestryMtCO2e landuse_forestry
rename TransportationMtCO2e transportation
rename StateGDPMillionUSchained state_gdp
rename PopulationPeople population
rename TotalEnergyUseThoustonnes total_energyuse

//Since we are only examining organic agriculture and emission across the 50 states of the United States from 2000 to 2008, exclude entries for the "United States" and the "District of Columbia," as they are not among the 50 states, and remove data for non-relevant years
drop if state == "United States"
drop if state == "District Of Columbia"
drop if year == 1990
drop if year == 1991
drop if year == 1992
drop if year == 1993
drop if year == 1994
drop if year == 1995
drop if year == 1996
drop if year == 1997
drop if year == 1998
drop if year == 1999
drop if year == 2009
drop if year == 2010
drop if year == 2011
drop if year == 2012
drop if year == 2013
drop if year == 2014
drop if year == 2015
drop if year == 2016
drop if year == 2017
drop if year == 2018

// Save the original data as emission.dta in the Original_Data folder
save "Original_Data\emission.dta", replace

********************************************************************************
// IMPORT AND CLEAN THE ORGANIC AGRICULTURE DATA

//Import PastrCropbyState_importable.xlsx
clear
local excel_file "Original_Data\PastrCropbyState_importable.xlsx"

//Since this dataset has multiple sheets for different years, to import them into Stata, creating a variable indicating the year and then save each dataset seperately. 
// List of years
local years "08 07 06 05 04 03 02 01 00" 

// Loop over each year
foreach year in `years' {
    // Import data from Excel sheet
    import excel "`excel_file'", sheet("pastcrop`year'") firstrow

    // Create a variable for the year
    gen year = 20`year'

    // Save the dataset as a Stata file
    save "Original_Data\pastcrop`year'.dta", replace
	clear
}

clear
//Cleaning specific years manually
//In the variable "crops", replacing '--' with '0' indicating missing or unspecific data to make it consistent with the rest of the dataset.
use "Original_Data\pastcrop01.dta"
replace crops = "0" if crops == "--"
replace pasture_rangeland = "0" if pasture_rangeland == "--"
replace total_organic_arces = "0" if total_organic_arces == "--"
replace state = "Colorado" if state == "Colorado 1/"
replace state = "Louisiana" if state == "Louisana"
replace state = "Mississippi" if state == "Mississippi "

destring crops, replace
destring pasture_rangeland, replace
destring total_organic_arces, replace

save "Original_Data\pastcrop01.dta", replace

clear
use "Original_Data\pastcrop00.dta"
replace crops = "0" if crops == "--"
replace pasture_rangeland = "0" if pasture_rangeland == "--"
replace total_organic_arces = "0" if total_organic_arces == "--"
replace state = "Colorado" if state == "Colorado 1/"
replace state = "Louisiana" if state == "Louisana"
replace state = "Mississippi" if state == "Mississippi "

destring crops, replace
destring pasture_rangeland, replace
destring total_organic_arces, replace

save "Original_Data\pastcrop00.dta", replace

clear

//Appending data for years 2000 to 2007 to pastcrop08.dta
use "Original_Data\pastcrop08.dta"
//List of years
local years "07 06 05 04 03 02 01 00" 

// Loop over each year
foreach year in `years' {
	append using "Original_Data\pastcrop`year'.dta", force
}

//Drop the irrelevant variables of the research
drop F-M

save "Original_Data\pastcrop.dta", replace
********************************************************************************
//COMBINING THE TWO DATASETS

clear

use "Original_Data\emission.dta"

merge 1:m state year using "Original_Data\pastcrop.dta"
drop if state == ""

save "Original_Data\base_file.dta", replace
use "Original_Data\base_file.dta"

log close
exit