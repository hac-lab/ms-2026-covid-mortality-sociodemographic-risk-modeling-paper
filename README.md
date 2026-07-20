## Supplemental Materials: Predictive Spatial Modeling of Sociodemographic Risk for COVID-19 Mortality

Revision 6 material submitted July 2026

Erich Seamon, Benjamin J. Ridenhour, Craig R. Miller, Jennifer Johnson-Leung
University of Idaho

## Overview:

The following github repository provides all code and data for generating analyses and supplemental materials for the aforementioned manuscript.

## How do I regenerate the Supplemental Appendix?

- If you want to generate the supplemental appendix pdf on your own, you may run the Supplemental.Rmd (also at the root level).  All of the folders and datasets support running the Supplemental.Rmd.  The published manuscript from the journal provides the fully compiled Supplemental Appendix pdf.

## Folder Descriptions

- /data  - folder which contains all data accessed as part of Supplemental.Rmd.  Descriptions of datasets are noted below under "Data Descriptions".
- /figures - contains .png image files that are used in the Supplemental.Rmd.  
- /html - contains regression output tables for each United States Health and Human Services regions.  Each of the tables is embedded in the Supplemental.Rmd.
- /region_pngs - contains .png images of regional Health and Human Services maps.


## Data Descriptions

Within the /data folder, there are a number of datasets.  Each dataset is described below, with key field names and usage.

sevenday_combined.csv: This csv contains daily cases and deaths for all United States counties, for each day from January 2020 to April 2022.  Given the large size of this .csv, it is split into TWO zip files, and is automatically merged together and loaded as the Supplemental.Rmd is run.

Column descriptions:

- County: county name
- state: state name
- size: population count (raw population number)
- fips: fips number (five digit unique county ID)
- cuml.cases: cumulative cases per county (counts)
- past.cases: past cases per county (counts)
- new.cases: new cases per county (counts)
- daily.cases: cases for that day, per county
- act.pt: frequency calculations (not used)
- act.low: frequency calculations (not used)
- act.hi: frequency calculations (not used)
- freq.act: frequency calculations (not used)
- freq.act.low: frequency calculations (not used)
- freq.act.hi: frequency calculations (not used)
- one_act: frequency calculations (not used)
- one.act.low: frequency calculations (not used)
- one.act.hi: frequency calculations (not used)
- trans.pt: frequency calculations (not used)
- trans.pt.low: frequency calculations (not used)
- trans.pt.hi: frequency calculations (not used)
- freq.trans_low: frequency calculations (not used)
- freq.trans_hi: frequency calculations (not used)
- one.trans: frequency calculations (not used)
- one.trans_low: frequency calculations (not used)
- one.trans_hi: frequency calculations (not used)
- county2: lowercase county name
- date: date (YYYY-MM-DD)

deaths_nationwide_cumulative.csv: This csv provides daily deaths for all United States counties, as well as cumulative deaths.  

Column descriptions

- date: date (YYYY-MM-DD)
- FIPS: fips number (five digit unique county ID)
- deaths: number of cumulative deaths (raw count)
- daily_deaths: number of daily deaths for a specific date (raw count)

vaccinationrate.csv: This .csv provides vaccination rates as collected by the Centers for Disease Control and Prevention (CDC). 

Column descriptions:

- Date: date (DD/MM/YYYY)
- FIPS: fips number (five diget unique county ID)
- MMWR_week: week within the year
- Recip_County: county
- Recip_State: state
- Series_Complete_Pop_Pct: vaccination rate (percentage)
  
voting_nationwide_liberal.csv: This .csv contains voting data from the 2020 general election, using the Biden/Trump voter breakdown.  The voting percentage refers to the % of people, per county, who voted for Biden.

Column descriptions:

- FIPS: fips number (five diget unique county ID)
- lname: name of candidate
- votes: number of votes cast for candidate
- totalvotes: total votes cast for all candidates
- state: state where votes were cast
- county: county where votes were cast
- pct: democratic voting percentage (percentage)

age65_over.csv: This .csv contains the population of adults over the age of 65, per county (2020 US Census).

Column descriptions:

- FIPS: fips number (five diget unique county ID)
- Age_over_65 - the raw number of adults age 65+

broadband.csv: This .csv contains the number of people per county who have access to broadband, by county.

Column descriptions:

- FIPS: fips number (five digit unique county ID)
- State: state name
- County: county name
- broadband_access: percentage of households that have broadband access (percentage)

countyrankings_refined.csv: This .csv file contains county level health rankings that are taken from the University of Wisconsin's Population Health Institute.  For this analysis, we only use a limited number of these variables in our final analysis.

Column descriptions:

- FIPS: fips number (five diget unique county ID)
- State: state name
- County: county name
- Smoking: percentage of people who smoke (percentage)
- Obesity: percentage of people who are obese (percentage)
- FEI: The food environment index combines two measures of food access: the percentage of the population that is low-income and has low access to a grocery store, and the percentage of the population that did not have access to a reliable source of food during the past year (food insecurity)
- Excessive_Drinking: percentage of people who excessively drink (percentage)
- Uninsured: percentage of adults who are uninsured (percentage)
- Flu_Vaccination: percentage of people who have had a flu vaccination (percentage)
- HS_graduation: percentage of people who graduated HS (percentage)
- Some_College: percentage of people who have some college (percentage)
- Unemployed: percentage of people who are unemployed (percentage)
- Children_in_Poverty: percentage of children listed as in poverty (percentage)
- Income_Ratio: percentage of people who smoke (percentage)
- Single_Parent: percentage of people who are single parents (percentage)
- Associations: percentage of people who engage in social associations/clubs (percentage)
- Violent_Crime: percentage of violent crime (percentage)
- Severe_Housing_Problems: percentage of people who have housing problems (percentage)
- Diabetes: percentage of people who have diabetes (percentage)
- Food_Insecurity: percentage of people who are food insecure (percentage)
- Uninsured_Adults: percentage of adults who are uninsured (percentage)
- African_Americans: percentage of African_Americans (percentage)
- American_Native: percentage of American_Native (percentage)
- Asian: percentage of Asian (percentage)
- Pacific_Islander: percentage of Pacific_Islander (percentage)
- Hispanic: percentage of Hispanic (percentage)
- Non_Hispanic_White: percentage of Non_Hispanic_White (percentage)

population_density.csv: This .csv contains the population counts and density for each county in the United States, as derived from US Census 2020 data.

Column descriptions:

- FIPS: fips number (five diget unique county ID)
- name: county name
- density: population density percentage (percentage)

svi.csv: This .csv contains social vulnerability indices (SVI) at the county level, taken from the Centers for Disease Control and Prevention (CDC).

Column descriptions:

- FIPS: fips number (five diget unique county ID)
- RPL_THEME1: Social vulnerability CDC index - Socioeconomic status (percentage)
- RPL_THEME2: Social vulnerability CDC index - Household Type (percentage)
- RPL_THEME3: Social vulnerability CDC index - Minority Status and Language (percentage)
- RPL_THEME4: Social vulnerability CDC index - Housing and Transportation (percentage)

/counties: This folder contains a shapefile and associated data for county mapping data - UScounties_conus.shp.
/states: This folder contains a shapefile and associated data for state mapping data - states.shp.

