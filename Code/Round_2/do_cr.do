//Change the path in same folder structure
clear all
cd "V:\Projects\NEFF\Analysis"
global NEFF_root "V:\Projects\NEFF\Analysis"
global code "${NEFF_root}/Code"
global raw "${NEFF_root}/Data/raw" 
global derived "${NEFF_root}/Data/derived"
global tables "${NEFF_root}/Tables"
global figures "${NEFF_root}/Figures"
global Scratch "${NEFF_root}/Tables"


* Set $root
return clear
if ("${NEFF_root}"=="") do `"`c(sysdir_personal)'profile.do"'
* Document data sources
local date_run = c(current_date)
local time_run = c(current_time)
display "Data cleaning script run on `date_run' at `time_run'"

* Document system and run information
display "============================================"
display "NEFF Data Cleaning Script"
display "Date: `c(current_date)' at `c(current_time)'"
display "Computer: `c(hostname)'"
display "User: `c(username)'"
display "OS: `c(os)' (`c(osdtl)')"
display "Stata version: `c(stata_version)'"
display "Working directory: `c(pwd)'"
display "============================================"

/*==============================================================================
							Variable Creation File
===============================================================================*/



use "$raw\NEFF Phase 2.dta", clear 										
la var key "key"
gen submission_date = dofc(submissiondate)
format submission_date %td
la var submission_date "Submission Date"
gen survey_round = 2

clonevar enterprise_id = sec1_q4
clonevar panchayat_id = sec1_q3
destring panchayat_id, replace


merge m:1 panchayat_id using "$raw\neff_village_list.dta"
replace neff_vill = 0 if neff_vill == .
drop if _merge == 2


//merge with main sample
merge m:1 enterprise_id using "$raw\enterprise_detail_final.dta", gen (_m_mis_survey)  
keep if(_m_mis_survey)==3

order sec1_q1 district
order sec1_q2 block
order sec1_q3 panchayat
order sec1_q4 enterprise

gen t = neff_vill
replace t = 0 if neff_cap_ent == 0

/*==============================================================================
					Drop Invalid and Duplicate Enterprises	
===============================================================================*/
duplicates tag enterprise_id, gen(ent_dup)

drop if key == "uuid:22f7ebb2-e664-4f39-abc2-388caba1c219"
drop if key == 	"uuid:b37bab28-18ed-40b8-9058-b81e0c774e29"
drop if key == "uuid:4db1bc55-731b-4220-b227-8617e2d5993b"
drop if key == "uuid:7d2402e3-24e3-4c95-9344-021edccb7f0b"
drop if key == "uuid:8ae55e64-9663-4555-afa4-a7c2016b81a1"
drop if key == "uuid:daa26e78-16f5-4e86-81b8-63199b6640f2"
drop if key == "uuid:13f3ba7b-7022-4c49-9bec-91a1797e3424"
drop if key == "uuid:44d6d064-f97c-4bb7-9a73-5d73709e39ea"
drop if key == "uuid:a69739db-7ede-4002-b3e4-a3ee4b67c996"
drop if key == "uuid:e5c22231-2e50-4761-901e-17d07e3bc7cc"
drop if key == "uuid:b9d53bc3-6271-406e-9a55-4e0a5afd043e"
drop if key == "uuid:1d1a719b-c8f5-4c9b-b0b4-8843b13ac955"
drop if key == "uuid:9a675589-4f7e-4a01-af8b-3122279b889b"
drop if key ==  "uuid:ba7b00d1-e766-4a49-acb0-90f595a659b7"
drop if key == "uuid:2ae2545b-60d9-4478-a9f6-26443697b10d"
drop if key == "uuid:bdbf1ef0-c5db-40ac-a87c-e2e052404c1b"
drop if key == "uuid:f6646d96-a7d3-46a0-96b1-03e54f735f89"
drop if key == "uuid:a8a8ec8c-fee1-4426-9adc-3c6c017eca80"
drop if key == "uuid:39851987-ef7f-46dc-b0e3-a3ac63bfcaf4"
drop if key == "uuid:de7db214-5765-4971-ad9a-40c9c223a01b"
drop if key == "uuid:f08b445b-a4fe-4c36-9901-462dc1814bf7"
drop if key == "uuid:605b82bd-8218-4e8b-b69e-584553b61567"
drop if key == "uuid:7eeed059-52e8-4f18-b04b-066b56647b8a"
drop if key == "uuid:dcff3401-e645-4dac-863a-805834f83d57"
				
replace enterprise_id = "2528" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace sec1_q4 = "2528" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace enterprise = "Rani_Paramasivam/Small Eateries/Snacks" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace panchayat = "seettampattu" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace sec1_q3 = "37" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace sec1_q2 = "17" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace block = "kalasapakkam" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace sec1_q1 = "21" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"
replace district = "Thiruvannamalai" if key == "uuid:c857e067-ccca-4ae6-a652-2a33ca7e36c9"

drop if key =="uuid:084321de-c53c-4990-b4a4-fbae16cffd08"

/*==============================================================================
								Treatment Variable
===============================================================================*/

**labelling treatment variable
la define neff_vill_label 0 "Non-NEFF" 1 "NEFF"
la value neff_vill neff_vill_label

**NEFF & Non-NEFF enterprise
gen treat_ent=.
replace treat_ent=0 if neff_cap_ent==0
replace treat_ent=1 if (neff_cap_ent==1)|(neff_cap_ent==2)
la var treat_ent "whether enterprise is NEFF or Non-NEFF"
la define treat_ent_la 1 "NEFF enerprise" 0 "Non-NEFF enteprise"
la value treat_ent treat_ent_la

/*==============================================================================
							Business Running Insights
==============================================================================*/
fre sec1_q9

/*
sec1_q9 -- Is this enterprise still running?
---------------------------------------------------------------------------
                              |      Freq.    Percent      Valid       Cum.
------------------------------+--------------------------------------------
Valid   1 Yes, still running  |       1978      78.34      83.99      83.99
        2 No, it is defuncted |        377      14.93      16.01     100.00
        Total                 |       2355      93.27     100.00           
Missing .                     |        170       6.73                      
Total                         |       2525     100.00                      
---------------------------------------------------------------------------




*/
//1978 enterprises are running

gen ent_running = (sec1_q7 == 1 & sec1_q9 == 1)					
la var ent_running "Business is running and owner provided consent (1=Yes)"


/*==============================================================================
						Enterprise Age 						
===============================================================================*/
gen e_age = (td(26feb2024) - sec3_q1 )/365.25
la var e_age "Age of the enterprise"
format e_age %4.2f
replace e_age = . if e_age < 0							
winsor2 e_age, replace cuts(1 99)


/*==============================================================================
						Age of the Etrepreneur					
===============================================================================*/
gen age_entrepreneur = (td(07june2024) - sec4_q1 )/365.25
la var age_entrepreneur "Age of the entrepreneur"
format age_entrepreneur %4.2f

replace age_entrepreneur = . if age_entrepreneur < 0							//6 entrepreneurs have negative values despite putting age connstraints in SurveyCTO
winsor2 age_entrepreneur, replace cuts(1 99)


/*==============================================================================
						Marriage age			
===============================================================================*/
clonevar marriage_age = sec4_q2_a
sum marriage_age, d
replace marriage_age = `r(p50)' if marriage_age == 0


/*==============================================================================
		Recoding the education variable as a continuous variable
===============================================================================*/


clonevar education_yrs = sec4_q5
replace education_yrs = 0 if inlist(sec4_q5,16,17,18,19)
replace education_yrs = 17 if inlist(sec4_q5,14,15)
replace education_yrs = 15 if sec4_q5==13
replace education_yrs = 12 if inlist(sec4_q5,12,20)
replace education_yrs = 11 if sec4_q5==11
replace education_yrs = 10 if sec4_q5==10
replace education_yrs = 9  if sec4_q5==9
replace education_yrs = 8  if sec4_q5==8
replace education_yrs = 7  if sec4_q5==7
replace education_yrs = 6  if sec4_q5==6
replace education_yrs = 5  if sec4_q5==5
replace education_yrs = 4  if sec4_q5==4
replace education_yrs = 3  if sec4_q5==3
replace education_yrs = 2  if sec4_q5==2
replace education_yrs = 1  if sec4_q5==1
lab var education_yrs "Years of education of the enterprise owner"

kdensity education_yrs, bw(2) normal

/*==============================================================================
									Gender
===============================================================================*/


gen f_ent = 1 if sec2_q5 == 2 & sec2_q5 != .
replace f_ent = 0 if sec2_q5 == 1
la var f_ent "Female entrepreneur"
la def f_ent_label 1 "Female" 0 "Male"
la value f_ent f_ent_label


/*==============================================================================
				Registation status: sec3_q2 sec3_q2_1 sec3_q2_a
===============================================================================*/
clonevar whether_register = sec3_q2
la var whether_register "Whether enterprise is registered"

clonevar udyam_registration = sec3_q2_1
replace udyam_registration = 0 if sec3_q2 == 0
la var udyam_registration "Whether enterprise is registered with Udyam Aadhar (1 = Yes)"

/*==============================================================================
								Proprietiership
===============================================================================*/

**whether enteprise is sole 
gen single_owner =.
replace single_owner = 1 if sec3_q2_a==1
replace single_owner = 0 if sec3_q2_a==2
replace single_owner = 0 if sec3_q2_a==3
replace single_owner = 0 if sec3_q2 == 0



/*==============================================================================
						Enterprise Location (sec3_q6)
===============================================================================*/


tab sec3_q6, gen(ent_location_)
label var ent_location_1 "Located in main marketplace"
label var ent_location_2 "Located in secondary marketplace"
label var ent_location_3 "Located on street with other businesses"
label var ent_location_4 "Located in residential area"




/*==============================================================================
                            BASIC LOAN VARIABLES
===============================================================================*/

// Has enterprise taken any loan (Jan 2024 - Mar 2025)
label variable sec8_q1 "At least one Loan (Jan 2024 - Mar 2025)"

// Count of loans
clonevar count_loan = sec8_q3
replace count_loan = 0 if sec8_q1 == 0
label var count_loan "Count of Loans (Jan 2024 - Mar 2025)"


count if sec8_q1 == 1 & count_loan == 0
replace sec8_q1 = 0 if count_loan == 0

foreach var in sec8_q4_oth_1 sec8_q4_oth_2 sec8_q4_oth_3 {
	replace `var' = upper(`var')
}

//LOAN SOURCE CLASSIFICATION

// Formal vs Informal loan sources
// Formal sources: Banks(2), TNSRLM(4), MFI(5), NBFC(6), NEFF(7)
gen formal_loan_source = .
sum count_loan, d
forval i = 1/`r(max)' {
	replace formal_loan_source = 1 if inlist(sec8_q4_`i',2,4,5,6,7) 
}
sum count_loan, d
forval i = 1/`r(max)' {
	replace formal_loan_source = 0 if inlist(sec8_q4_`i',1,3) 
}

sum count_loan, d
forval i = 1/`r(max)' {
	replace formal_loan_source = 1 if inlist(sec8_q4_oth_`i', "CAFF", "MGP", "VILLAGE MEMBERSHIP GROUP" ) 
}

// Handle missing values properly
replace formal_loan_source = 0 if sec8_q1 == 0  // No loans = informal (0)
replace formal_loan_source = . if sec8_q1 == .   // True missing data
	
label variable formal_loan_source "whether enterprise accessed loan from formal sources (1 = Formal, 0 = Informal)"
label define formal_loan_source_label 0 "Informal" 1 "Formal"
label values formal_loan_source formal_loan_source_label


// Individual loan source variables (using dynamic approach)
// Bank loan source
gen bank_loan_source = 0
sum count_loan, d
forvalues i = 1/`r(max)' {
    replace bank_loan_source = 1 if sec8_q4_`i' == 2
}
replace bank_loan_source = . if count_loan == 0
label variable bank_loan_source "Whether enterprise accessed loan from bank"
label define bank_loan_source_label 1 "Bank" 0 "Other source"
label values bank_loan_source bank_loan_source_label


                            
// Rate of interest 
                          
sum count_loan, d
forvalues i = 1/`r(max)' {
    local var sec8_q11_`i' 
    local label "Rate of interest (in %) of `i' loan" 
    label variable `var' "`label'"  
}

// Create annualized interest rates 
sum count_loan, d
forvalues i = 1/`r(max)' {
		quietly sum sec8_q11_`i', detail
        gen sec8_q11_an_`i' = (sec8_q11_`i'*1) if sec8_q12_`i' == 1     // Annual
        replace sec8_q11_an_`i' = (sec8_q11_`i'*12) if sec8_q12_`i' == 2   // Monthly
        replace sec8_q11_an_`i' = (sec8_q11_`i'*52) if sec8_q12_`i' == 3   // Weekly
        replace sec8_q11_an_`i' = (sec8_q11_`i'*365) if sec8_q12_`i' == 4  // Daily
        
        format sec8_q11_an_`i' %15.0g
        label variable sec8_q11_an_`i' "Annual interest rate of loan `i'"
    }


// Average interest rate (EXACT SAME LOGIC AS PHASE 1)
egen avg_int_rate = rowmean(sec8_q11_an_*)
label variable avg_int_rate "Average interest rate of all loan"

// Winsorized average interest rate 
winsor2 avg_int_rate, cuts(1 99)
rename avg_int_rate_w w1_avg_int_rate
label variable w1_avg_int_rate "Average interest rate of all loan (w10)"


// Total loan received 
ds sec8_q7_*
egen total_loan_received = rowtotal(`r(varlist)')
label variable total_loan_received "Total loan received"

// Total loan applied 
ds sec8_q6_*
egen total_loan_applied = rowtotal(`r(varlist)')
label variable total_loan_applied "Total loan applied"

// Active loans 
ds sec8_q5_*
egen active_loan = rowtotal(`r(varlist)')
label variable active_loan "Number of active loans which was taken in the last 1.5 years"





// Total unpaid loan 
ds sec8_q14_*
egen tot_unpaid_loan = rowtotal(`r(varlist)')
label variable tot_unpaid_loan "Total amount of unpaid principal across loans"

winsor2 tot_unpaid_loan, cuts(1 99)
rename tot_unpaid_loan_w w10_tot_unpaid_loan
la var w10_tot_unpaid_loan "Winsorized (at 1%) Total amount of unpaid principal across loans"


gen log_w10_tot_unpaid_loan = log(w10_tot_unpaid_loan+1)
label variable log_w10_tot_unpaid_loan "Log of Total amount of unpaid principal across loans"	
	
	
/*==============================================================================
                            BASIC INVESTMENT INDICATORS
===============================================================================*/

label variable sec7_q1 "Whether any amount invested during January 2025 to March 31, 2025"
label variable sec7_q4 "Whether any amount invested during 2024 (January to December)"

label variable sec7_q10 "Do you have a bank account in the name of your business?"

label variable sec7_q1_a_1 "Invested in Working Capital during January 2025 to March 2025"
label variable sec7_q1_a_2 "Invested in Asset creation during January 2025 to March 2025"
label variable sec7_q1_a_3 "Invested in Debt reduction during January 2025 to March 2025"
label variable sec7_q1_a_4 "Invested in new enterprise during January 2025 to March 2025"

label variable sec7_q4_a_1 "Invested in Working Capital during 2024"
label variable sec7_q4_a_2 "Invested in Asset creation during 2024"
label variable sec7_q4_a_3 "Invested in Debt reduction during 2024"
label variable sec7_q4_a_4 "Invested in new enterprise during 2024"


/*==============================================================================
                            TOTAL INVESTMENT AMOUNTS
===============================================================================*/

// Investment Period 1: Jan-Mar 2025 (corresponds to invest_1 in Phase 1)
ds sec7_q2*
egen invest_1 = rowtotal(`r(varlist)')
replace invest_1 = 0 if sec7_q1 == 0  // No investment = 0 amount
label variable invest_1 "Amount invested in January-March 2025"

// Investment Period 2: 2024 (corresponds to invest_2 in Phase 1)  
ds sec7_q5*
egen invest_2 = rowtotal(`r(varlist)')
replace invest_2 = 0 if sec7_q4 == 0  // No investment = 0 amount
label variable invest_2 "Amount invested in 2024 (Jan-Dec)"



// Winsorized Investment Jan-Mar 2025
gen wins = invest_1, after(invest_1)
summarize wins, detail
replace wins = r(p10) if invest_1 <= r(p10)
replace wins = r(p90) if invest_1 >= r(p90)
rename wins w10_invest_1
label variable w10_invest_1 "Winsorized (at 10%) investment in January-March 2025"

// Winsorized Investment 2024
gen wins = invest_2, after(invest_2)
summarize wins, detail
replace wins = r(p10) if invest_2 <= r(p10)
replace wins = r(p90) if invest_2 >= r(p90)
rename wins w10_invest_2
label variable w10_invest_2 "Winsorized (at 10%) investment in 2024 (Jan-Dec)"

/*==============================================================================
                            COUNT OF INVESTMENTS
===============================================================================*/

// Count investments in Jan-Mar 2025 
gen count_investment_1 = 0
replace count_investment_1 = sec7_q1_a_1 + sec7_q1_a_2 + sec7_q1_a_3 + sec7_q1_a_4
replace count_investment_1 = 0 if sec7_q1 == 0
label variable count_investment_1 "Investments (#) in January-March 2025"

// Count investments in 2024 
gen count_investment_2 = 0
replace count_investment_2 = sec7_q4_a_1 + sec7_q4_a_2 + sec7_q4_a_3 + sec7_q4_a_4
replace count_investment_2 = 0 if sec7_q4 == 0
label variable count_investment_2 "Investments (#) in 2024 (Jan-Dec)"

/*==============================================================================
                            INVESTMENT TYPE AMOUNTS
===============================================================================*/

// Create investment type amounts for Jan-Mar 2025
gen wc_amount_1 = 0	   // Working capital
gen ac_amount_1 = 0   // Asset creation
gen dr_amount_1 = 0   // Debt reduction
gen ne_amount_1 = 0   // New enterprise

ds sec7_q2*
local investment_vars `r(varlist)'
local i = 1
foreach var in `investment_vars' {
    replace wc_amount_1 = wc_amount_1 + `var' if sec7_q1_a_`i' == 1 & sec7_q1_a_1 == 1
    replace ac_amount_1 = ac_amount_1 + `var' if sec7_q1_a_`i' == 1 & sec7_q1_a_2 == 1
    replace dr_amount_1 = dr_amount_1 + `var' if sec7_q1_a_`i' == 1 & sec7_q1_a_3 == 1
    replace ne_amount_1 = ne_amount_1 + `var' if sec7_q1_a_`i' == 1 & sec7_q1_a_4 == 1
    local i = `i' + 1
}

// Create investment type amounts for 2024
gen wc_amount_2 = 0   // Working capital
gen ac_amount_2 = 0   // Asset creation
gen dr_amount_2 = 0   // Debt reduction
gen ne_amount_2 = 0   // New enterprise

ds sec7_q5*
local investment_vars `r(varlist)'
local i = 1
foreach var in `investment_vars' {
    replace wc_amount_2 = wc_amount_2 + `var' if sec7_q4_a_`i' == 1 & sec7_q4_a_1 == 1
    replace ac_amount_2 = ac_amount_2 + `var' if sec7_q4_a_`i' == 1 & sec7_q4_a_2 == 1
    replace dr_amount_2 = dr_amount_2 + `var' if sec7_q4_a_`i' == 1 & sec7_q4_a_3 == 1
    replace ne_amount_2 = ne_amount_2 + `var' if sec7_q4_a_`i' == 1 & sec7_q4_a_4 == 1
    local i = `i' + 1
}

/*==============================================================================
                            INVESTMENT TYPE PROPORTIONS
===============================================================================*/

// Proportions for Jan-Mar 2025 (Period 1)
gen wc_invest_1 = wc_amount_1 / invest_1 if invest_1 > 0
replace wc_invest_1 = 0 if invest_1 == 0
gen ac_invest_1 = ac_amount_1 / invest_1 if invest_1 > 0
replace ac_invest_1 = 0 if invest_1 == 0
gen dr_invest_1 = dr_amount_1 / invest_1 if invest_1 > 0
replace dr_invest_1 = 0 if invest_1 == 0
gen ne_invest_1 = ne_amount_1 / invest_1 if invest_1 > 0  // New variable for Phase 2
replace ne_invest_1 = 0 if invest_1 == 0

label variable wc_invest_1 "Proportion of total invested in working capital in Jan-Mar 2025"
label variable ac_invest_1 "Proportion of total invested in asset creation in Jan-Mar 2025"
label variable dr_invest_1 "Proportion of total invested in debt reduction in Jan-Mar 2025"
label variable ne_invest_1 "Proportion of total invested in new enterprise in Jan-Mar 2025"

// Proportions for 2024 (Period 2)
gen wc_invest_2 = wc_amount_2 / invest_2 if invest_2 > 0
replace wc_invest_2 = 0 if invest_2 == 0
gen ac_invest_2 = ac_amount_2 / invest_2 if invest_2 > 0
replace ac_invest_2 = 0 if invest_2 == 0
gen dr_invest_2 = dr_amount_2 / invest_2 if invest_2 > 0
replace dr_invest_2 = 0 if invest_2 == 0
gen ne_invest_2 = ne_amount_2 / invest_2 if invest_2 > 0
replace ne_invest_2 = 0 if invest_2 == 0

label variable wc_invest_2 "Proportion of total invested in working capital in 2024"
label variable ac_invest_2 "Proportion of total invested in asset creation in 2024"
label variable dr_invest_2 "Proportion of total invested in debt reduction in 2024"
label variable ne_invest_2 "Proportion of total invested in new enterprise in 2024"


gen count_wc_invest_1 = sec7_q1_a_1
replace count_wc_invest_1 = . if sec7_q1 == .
label variable count_wc_invest_1 "People(#) invested in working capital in Jan-Mar 2025"

gen count_ac_invest_1 = sec7_q1_a_2
replace count_ac_invest_1 = . if sec7_q1 == .
label variable count_ac_invest_1 "People(#) invested in asset creation in Jan-Mar 2025"

gen count_dr_invest_1 = sec7_q1_a_3
replace count_dr_invest_1 = . if sec7_q1 == .
label variable count_dr_invest_1 "People(#) invested in debt reduction in Jan-Mar 2025"

gen count_ne_invest_1 = sec7_q1_a_4
replace count_ne_invest_1 = . if sec7_q1 == .
label variable count_ne_invest_1 "People(#) invested in new enterprise in Jan-Mar 2025"

gen count_wc_invest_2 = sec7_q4_a_1
replace count_wc_invest_2 = . if sec7_q4 == .
label variable count_wc_invest_2 "People(#) invested in working capital in 2024"

gen count_ac_invest_2 = sec7_q4_a_2
replace count_ac_invest_2 = . if sec7_q4 == .
label variable count_ac_invest_2 "People(#) invested in asset creation in 2024"

gen count_dr_invest_2 = sec7_q4_a_3
replace count_dr_invest_2 = . if sec7_q4 == .
label variable count_dr_invest_2 "People(#) invested in debt reduction in 2024"

gen count_ne_invest_2 = sec7_q4_a_4
replace count_ne_invest_2 = . if sec7_q4 == .
label variable count_ne_invest_2 "People(#) invested in new enterprise in 2024"


	
	
	

/*==============================================================================
                            BASIC ASSET INDICATORS
===============================================================================*/

label variable sec9_q1 "Out of the following what assets are you using currently?"

// Create individual asset type indicators based on sec9_q1
gen uses_site = 0
gen uses_machinery = 0  
gen uses_utensils = 0
gen uses_vehicles = 0
gen uses_furniture = 0
gen uses_other_assets = 0

// Parse the multi-response sec9_q1 variable
replace uses_site = 1 if strpos(sec9_q1, "1") 
replace uses_machinery = 1 if strpos(sec9_q1, "2")
replace uses_utensils = 1 if strpos(sec9_q1, "3") 
replace uses_vehicles = 1 if strpos(sec9_q1, "4") 
replace uses_furniture = 1 if strpos(sec9_q1, "5") 
replace uses_other_assets = 1 if strpos(sec9_q1, "1") 

label variable uses_site "Uses site assets (land, building, shop, etc.)"
label variable uses_machinery "Uses machinery and equipment"
label variable uses_utensils "Uses utensils"
label variable uses_vehicles "Uses vehicles and transportation"
label variable uses_furniture "Uses furniture"
label variable uses_other_assets "Uses other physical assets"


// Total asset value = owned value + rental value 
ds sec9_q3_* sec9_q5_*
egen asset_value = rowtotal(`r(varlist)')
label variable asset_value "Total asset value"



// Winsorized asset_value 
gen wins = asset_value, after(asset_value)
summarize wins, detail
replace wins = r(p10) if asset_value <= r(p10)
replace wins = r(p90) if asset_value >= r(p90)
rename wins w10_asset_value
label variable w10_asset_value "Winsorized (at 10%) asset value"


// Total owned asset value 
ds sec9_q3_*
egen owned_asset_value = rowtotal(`r(varlist)')

// Replace the total with missing if all specific variables are missing
replace owned_asset_value = . if missing(sec9_q3_1) & ///
                                  missing(sec9_q3_2) & ///
                                  missing(sec9_q3_3) & ///
                                  missing(sec9_q3_4) & ///
                                  missing(sec9_q3_5)

label variable owned_asset_value "Total Owned Asset Value"


// Total perceived asset value 
ds sec9_q4_*
egen percieved_asset_value = rowtotal(`r(varlist)')

// Replace the total with missing if all specific variables are missing
replace percieved_asset_value = . if missing(sec9_q4_1) & ///
                                      missing(sec9_q4_2) & ///
                                      missing(sec9_q4_3) & ///
                                      missing(sec9_q4_4) & ///
                                      missing(sec9_q4_5)

label variable percieved_asset_value "Total Perceived Asset Value"



// Monthly rental asset value 
ds sec9_q5_*
egen monthly_asset_value = rowtotal(`r(varlist)')
replace monthly_asset_value = . if missing(sec9_q5_1) & ///
                                  missing(sec9_q5_2) & ///
                                  missing(sec9_q5_3) & ///
                                  missing(sec9_q5_4) & ///
                                  missing(sec9_q5_5)


label variable monthly_asset_value "Monthly Asset Rent Total"

	
/*==============================================================================
                            profit margin
===============================================================================*/

local pm sec12_q2_a sec12_q2_b sec12_q2_c

foreach var in `pm'  {
gen profit_margin_`var' = ((`var'-1000)/1000)*100 if `var' !=.  
local label : variable label `var'
la var profit_margin_`var' "Profit margin : '`label''"
}	

gen profit_margin = .	
replace profit_margin = profit_margin_sec12_q2_a 
replace profit_margin = profit_margin_sec12_q2_b if profit_margin == .	
replace profit_margin = profit_margin_sec12_q2_c if profit_margin == .		 	
	
// Winsorized asset_value 
gen wins = profit_margin, after(profit_margin)
summarize wins, detail
replace wins = r(p10) if profit_margin <= r(p10)
replace wins = r(p90) if profit_margin >= r(p90)
rename wins w10_profit_margin
label variable w10_profit_margin "Winsorized (at 10%) Profit Margin"
	
	
/*==============================================================================
                            Enterprise cost 		
===============================================================================*/
	

label var enterprise_cost "Cost categories incurred in 2024-2025"

label var enterprise_cost_1 "Purchase of raw materials and items for resale"
label var enterprise_cost_2 "Purchase of electricity, water, gas, and fuel"
label var enterprise_cost_3 "Interest paid on loans"
label var enterprise_cost_4 "Wages and salaries for employees"
label var enterprise_cost_5 "Rent for land or buildings"
label var enterprise_cost_6 "Taxes"
label var enterprise_cost_7 "Transportation"
label var enterprise_cost_8 "Other expenses (equipment rental, telephone, etc.)"

label variable cost_table_count "Number of cost categories reported"


// Enterprise cost for Jan-Mar 2025 
// Phase 2: Uses monthly amounts for Jan-Mar 2025, so sum all cost_2025_* variables
ds cost_2025_* cost_table_count
destring `r(varlist)', replace
ds cost_2025_*
egen ecost_1 = rowtotal(`r(varlist)')
label variable ecost_1 "Enterprise cost in January-March 2025"

// Enterprise cost for 2024 
ds cost_2024_* 
destring `r(varlist)', replace

// Phase 2: Uses monthly amounts for 2024, so sum all cost_2024_* variables
ds cost_2024_*
egen ecost_2 = rowtotal(`r(varlist)')
label variable ecost_2 "Enterprise cost in 2024 (January-December)"



// Winsorized enterprise cost Jan-Mar 2025 (exact same method as Phase 1)
gen wins = ecost_1, after(ecost_1)
summarize wins, detail
replace wins = r(p5) if ecost_1 <= r(p5)
replace wins = r(p95) if ecost_1 >= r(p95)
rename wins w5_ecost_1
label variable w5_ecost_1 "Winsorized (at 5%) Enterprise cost in January-March 2025"

// Winsorized enterprise cost 2024 (exact same method as Phase 1)
gen wins = ecost_2, after(ecost_2)
summarize wins, detail
replace wins = r(p5) if ecost_2 <= r(p5)
replace wins = r(p95) if ecost_2 >= r(p95)
rename wins w5_ecost_2
label variable w5_ecost_2 "Winsorized (at 5%) Enterprise cost in 2024 (January-December)"



/*==============================================================================
                            Enterprise Revenue		
===============================================================================*/
	
	
label variable sec12_q1 "Total monthly sales in March 2025 (last month)"
label variable sec12_q3_a "Daily revenue in 2024 (Jan-Dec)"
label variable sec12_q3_b "Weekly revenue in 2024 (Jan-Dec)"
label variable sec12_q3_c "Monthly revenue in 2024 (Jan-Dec)"
label variable sec12_q3_d "Annual revenue in 2024 (Jan-Dec)"
label variable sec12_q3_e "Daily revenue in Jan-Mar 2025"
label variable sec12_q3_f "Weekly revenue in Jan-Mar 2025"
label variable sec12_q3_g "Monthly revenue in Jan-Mar 2025"
label variable sec12_q3_h "Annual estimation for 2025"

// Return percentages
label variable sec12_q4_a "Return from main item (%) in 2024"
label variable sec12_q4_b "Return from main item (%) in Jan-Mar 2025"

// Monthly profit
label variable sec12_q6 "Profits during last month"


// Revenue 1: Recent period revenue (Jan-Mar 2025)
clonevar revenue_1 = sec12_q3_h  // Using annual estimation for 2025 as primary measure
label variable revenue_1 "Annual revenue estimation for 2025 (recent period)"

// Alternative: Use quarterly calculation for better comparability
gen revenue_1_quarterly = sec12_q3_g * 4  // Monthly * 4 quarters
label variable revenue_1_quarterly "Quarterly-based annual revenue for 2025"

// Revenue 2: Annual revenue for 2024 (exact match with Phase 1 structure)
clonevar revenue_2 = sec12_q3_d
label variable revenue_2 "Annual revenue in 2024 (January to December)"



// Winsorized annual revenue for 2025 estimation (exact same method as Phase 1)
gen wins = revenue_1, after(revenue_1)
summarize wins, detail
replace wins = r(p5) if revenue_1 <= r(p5)
replace wins = r(p95) if revenue_1 >= r(p95)
rename wins w5_revenue_1
label variable w5_revenue_1 "Winsorized (at 5%) Annual revenue estimation for 2025"

// Winsorized annual revenue for 2024 (exact same method as Phase 1)
gen wins = revenue_2, after(revenue_2)
summarize wins, detail
replace wins = r(p5) if revenue_2 <= r(p5)
replace wins = r(p95) if revenue_2 >= r(p95)
rename wins w5_revenue_2
label variable w5_revenue_2 "Winsorized (at 5%) Annual revenue in 2024 (January-December)"


// Winsorized annual revenue for 2024 (exact same method as Phase 1)
gen wins = revenue_1_quarterly, after(revenue_1_quarterly)
summarize wins, detail
replace wins = r(p5) if revenue_2 <= r(p5)
replace wins = r(p95) if revenue_2 >= r(p95)
rename wins w5_revenue_1_quarterly
label variable w5_revenue_1_quarterly "Winsorized (at 5%) Annual revenue in 2024 (January-December)"

/*==============================================================================
                            ENTERPRISE PROFIT CALCULATION
===============================================================================*/

// Profit 1: Recent period profit (2025 estimation minus recent costs)
gen profit_1 = revenue_1 - ecost_1
label variable profit_1 "Profit for 2025 (estimated annual revenue minus recent costs)"

// Alternative profit calculation using quarterly approach
gen profit_1_alt = revenue_1_quarterly - (ecost_1 * 3)  // Annualize quarterly costs
label variable profit_1_alt "Alternative profit calculation (Jan-March, 2025)"

// Profit 2: Annual profit for 2024 
gen profit_2 = revenue_2 - ecost_2
label variable profit_2 "Profit in 2024 (January to December)"

//winsorized profit

// Winsorized profit for 2025 (exact same logic as Phase 1)
gen w5_profit_1 = w5_revenue_1 - w5_ecost_1
label variable w5_profit_1 "Winsorized (at 5%) Profit for 2025"

// Winsorized profit for 2024 (exact same logic as Phase 1)
gen w5_profit_2 = w5_revenue_2 - w5_ecost_2
label variable w5_profit_2 "Winsorized (at 5%) Profit in 2024 (January to December)"


/*==============================================================================
                            SELF-REPORTED PROFIT
===============================================================================*/

// Self-reported profit 
// Phase 1: sec12_q6 * 7 (last 7 months)
// Phase 2: sec12_q6 is "profits during last month", so different calculation
gen rec_profit = sec12_q6 * 12  // Monthly profit * 12 for annual estimate
label variable rec_profit "Self-reported annual profit estimate (last month * 12)"


// Winsorized self-reported profit (exact same method as Phase 1)
gen wins = rec_profit, after(rec_profit)
summarize wins, detail
replace wins = r(p10) if rec_profit <= r(p10)
replace wins = r(p90) if rec_profit >= r(p90)
rename wins w10_rec_profit
label variable w10_rec_profit "Winsorized (at 10%) self-reported annual profit estimate"

	
	

/*==============================================================================
                            Business skills and practices  
===============================================================================*/

				

local bps sec17_q1_a sec17_q1_b sec17_q1_c sec17_q1_d sec17_q1_e sec17_q1_f sec17_q3 sec17_q4 sec17_q5 sec17_q7 sec17_q8 sec17_q9 sec17_q10 sec17_q11 sec17_q14 sec17_q15 sec17_q16 
egen bps = rowtotal(`bps')
la var bps "Business practices and skills"	

**Based on sir's identified variable
egen bps_1=rowtotal (sec17_q1_a sec17_q1_c sec17_q1_d sec17_q1_e sec17_q1_f sec17_q5 sec17_q5_a sec17_q5_b sec17_q6 sec17_q8 sec17_q9 sec17_q10 sec17_q11)

** Create Indices of Business Practices
egen marketing_score=rowtotal(sec17_q1_a sec17_q1_c sec17_q1_d sec17_q1_e sec17_q1_f)
label var marketing_score "Proportion of marketing practices used"

egen  record_keeping_score=rowtotal(sec17_q5 sec17_q5_a sec17_q5_b sec17_q6 sec17_q8 sec17_q9 sec17_q10 sec17_q11)
label var record_keeping_score "Proportion of record-keeping practices used"

// Sales on Credit
zscore sec17_q12 sec17_q13
egen  credit_mgmt_index = rowtotal(z_sec17_q12 z_sec17_q13 sec17_q14 sec17_q15)
label var credit_mgmt_index "Credit management index"



local bpscore "sec17_q1_a sec17_q1_c sec17_q1_d sec17_q1_e sec17_q1_f sec17_q5 sec17_q5_a sec17_q5_b sec17_q6 sec17_q8 sec17_q9 sec17_q10 sec17_q11 z_sec17_q12 z_sec17_q13 sec17_q14 sec17_q15"
egen bp_score=rmean(`bpscore')
label var bp_score "Business Practices Score"


/*==============================================================================
                            Supplier relation (section 16)
===============================================================================*/


egen supplier_relation=rowtotal(sec16_q1 sec16_q2 sec16_q3 sec16_q4 sec16_q8 sec16_q11 sec16_q12 sec16_q13 sec16_q14 sec16_q15 sec16_q16 sec16_q17)
label var supplier_relation "Supplier Relation Score"



/*==============================================================================
                            HH Income
===============================================================================*/

egen hh_income = rowtotal(sec6_q1 sec6_q2 sec6_q6 sec6_q9 sec6_q12 sec6_q15 sec6_q24 sec6_q25 sec6_q26)
egen missings = rowmiss(sec6_q1 sec6_q2 sec6_q6 sec6_q9 sec6_q12 sec6_q15 sec6_q24 sec6_q25 sec6_q26)
replace hh_income = . if missings > 0
drop missings
la var hh_income "Total HH Income (In last 12 months)"

* Winsorize the new variable at the 10th and 90th percentiles
gen wins=hh_income, after(hh_income)
sum wins, d
replace wins = r(p10) if avg_int_rate <= r(p10)
replace wins =r(p90) if avg_int_rate >= r(p90)
rename wins w10_hh_income
la var w10_hh_income "Winsorized (at 10%) Total HH Income (In last 12 months)"

* Generate total household cost
egen hh_cost = rowtotal(sec6_q3 sec6_q5 sec6_q17 sec6_q19 sec6_q21 sec6_q23)

* Set total household cost to missing if all component variables are missing
egen all_missing = rowmiss(sec6_q3 sec6_q5 sec6_q17 sec6_q19 sec6_q21 sec6_q23) 

replace hh_cost = . if all_missing==6
		
la var hh_cost "Total HH Cost (In last 12 months)"


* Winsorize the new variable at the 10th and 90th percentiles
gen wins=hh_cost, after(hh_cost)
sum wins, d
replace wins=r(p10) if avg_int_rate<=r(p10)
replace wins=r(p90) if avg_int_rate>=r(p90)
rename wins w10_hh_cost
la var w10_hh_cost "Winsorized (at 10%) Total HH Cost (In last 12 months)"


gen hh_profit = w10_hh_income-w10_hh_cost
 
save "$derived/NEFF_phase_2_full.dta", replace