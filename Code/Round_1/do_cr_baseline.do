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

use "$raw\NEFF baseline final.dta", clear 										
gen submission_date = dofc(submissiondate)
format submission_date %td
la var submission_date "Submission Date"
gen survey_round = 1

gen enterprise_id=sec1_q4
gen panchayat_id=sec1_q3
destring panchayat_id, replace


**Replacing panchayat and panchayat_id value of 5 incomplete survey
replace panchayat="arungurukkai" if sec1_q4=="2410"
replace panchayat_id=154 if sec1_q4=="2410"

replace panchayat="asoor" if sec1_q4=="2439"
replace panchayat_id=183 if sec1_q4=="2439"

replace panchayat="melakondai" if sec1_q4=="371"
replace panchayat_id=189 if sec1_q4=="371"

replace panchayat="karpaganatharkullam" if sec1_q4=="718"
replace panchayat_id=94 if sec1_q4=="718"


replace panchayat="thiruthiyamalai" if sec1_q4=="765"
replace panchayat_id=91 if sec1_q4=="765"

replace sec1_q7=1 if sec1_q7==.  //consent for incomplete survey

merge m:1 panchayat_id using "V:\Projects\TNRTP\Data\Administrative\Cascade\neff_village_list.dta"
replace neff_vill=0 if neff_vill==.
drop if _merge==2


//merge with main sample
merge m:1 enterprise_id using "V:\Projects\TNRTP\Data\Administrative\Cascade\enterprise_detail_final.dta", gen (_m_mis_survey)  

//V drive path

keep if(_m_mis_survey)==3

order sec1_q1 district
order sec1_q2 block
order sec1_q3 panchayat
order sec1_q4 enterprise

********************************************************************************
**********************Labelling some variable***********************************
********************************************************************************
label var cost_june2023_january2024_1 "In June 2023 to January 2024 cost of Purchase of raw materials and items for resale"
label var cost_june2023_january2024_2 "In June 2023 to January 2024 cost ofin Purchase of electricity, water, gas, and fuel"
label var cost_june2023_january2024_3 "In June 2023 to January 2024 cost of in Interest paid on loans"
la var cost_june2023_january2024_4 "In June 2023 to January 2024 cost of in Wages and salaries for employees"
la var cost_june2023_january2024_5 "In June 2023 to January 2024 cost of in Rent for land or buildings"
label var cost_june2023_january2024_6 "In June 2023 to January 2024 cost of in Taxes"
label var cost_june2023_january2024_7 "In June 2023 to January 2024 cost of in Transportation"
	

label var cost_2023_1 "In 2023 January to December cost of Purchase of raw materials and items for resale"
label var cost_2023_2 "In 2023 January to December cost ofin Purchase of electricity, water, gas, and fuel"
label var cost_2023_3 "In 2023 January to December cost of in Interest paid on loans"
la var cost_2023_4 "In 2023 January to December cost of in Wages and salaries for employees"
la var cost_2023_5 "In 2023 January to December cost of in Rent for land or buildings"
label var cost_2023_6 "In 2023 January to December cost of in Taxes"
label var cost_2023_7 "In 2023 January to December cost of in Transportation"
	

label var cost_2022_1 "In 2022 January to December cost of Purchase of raw materials and items for resale"
label var cost_2022_2 "In 2022 January to December cost ofin Purchase of electricity, water, gas, and fuel"
label var cost_2022_3 "In 2022 January to December cost of in Interest paid on loans"
la var cost_2022_4 "In 2022 January to December cost of in Wages and salaries for employees"
la var cost_2022_5 "In 2022 January to December cost of in Rent for land or buildings"
label var cost_2022_6 "In 2022 January to December cost of in Taxes"
label var cost_2022_7 "In 2022 January to December cost of in Transportation"

**household roster variable labelling:
gen tot_hh_member=sec5_q1_a+sec5_q1_b
la var tot_hh_member "total number of household member"

sum tot_hh_member
forval i=1/`r(max)' {
	la var sec5_q2_1_`i' "Name of the HH member `i'"
	la var sec5_q2_2_`i'  "Relation of member `i' with HH head"
	la var sec5_q2_3_`i' "Gender of member `i', (1=male,2=female)"
	la var sec5_q2_4_`i' "Age of member `i'"
	la var sec5_q2_5_`i' "Marital status of member `i'"
	la var sec5_q2_6_`i' "Highest education Completed by member `i'"
	la var sec5_q2_7_`i' "Whether member `i' is an earning member?"
	la var sec5_q2_8_`i' "Primary activity (Highest Earning) of member `i' in the last 12 months"
	la var sec5_q2_9_`i' "Is member `i' involved in secondary activity?"
	la var sec5_q2_9_a_`i' "Secondary activity of member `i' in the last 12 months"
	la var  sec5_q2_10_`i' "Has member `i' migrated away from village/town for 1 month or more but less than 6 months during the last 12 months for employment or in search of employment?"
	la var  sec5_q2_11_`i' "Whether member `i' SHG member or not?"
	la var  sec5_q2_12_`i' "Type of SHG"
	la var  sec5_q2_12_a_`i' "Since when member `i' is member of SHG?"
	la var  sec5_q2_13_`i' "Is member `i' the owner of the surveyed enterprise"
	la var  sec5_q2_14_`i' "Whether member `i' own any other enterprise (apart from this enterprise)?"
	la var  sec5_q2_14_`i' "Does member `i' received NEFF loan?"
	la var  sec5_q2_14_`i' "Does member `i' received CAP (Covid Assistance Package) loan? "	
}

**investment variable labelling
forval i=1/4 {
	la var sec7_q1_a_`i' "Type `i' investment (1=working capital, 2=Asset creation, 3=debt reduction, 4=Starting new enterprise) during June 2023 to January, 2024"
		
}

forval i=1/3 {
	la var sec7_q2_`i' "Amount invested in type `i' during June 2023 to January, 2024 (in Rs.)"
	la var sec7_q5_`i' "Amount invested in type `i' during 2023 (January to December) (in Rs.)"
	la var sec7_q8_`i' "Amount invested in  type `i' during 2022 (January to December) (in Rs.)
}


 *la var sec7_q3_`i' "Source of investment of type `i' during June 2023 to January, 2024- Code 24"

**asset variables labelling
forval i=1/6 {
	la var sec9_q1_`i' "Assets are you using currently?(1=site,2=machinary, 3=utensils,4=vehicle,5=furniture,6=other)"
}

forval i=1/5{
	la var sec9_q2_`i' "Do you currently own asset `i'?"
	la var sec9_q3_`i' "What is the owned value of asset `i'"
	la var sec9_q4_`i' "If you had not owned asset `i', how much you may have paid as rent per month?"
	la var sec9_q5_`i' "Monthly rental value of asset `i' that you use"
}


**digital payments labelling
la var sec17_q21_1 "Technical issues for digital payments"
la var sec17_q21_2 "Customer adoption issues for digital payments"
la var sec17_q21_3 "Security concerns issues for digital payments"
la var sec17_q21_4 "Cost-related challenges for digital payments"
la var sec17_q21_5 "No challenge faced for digital payments"
la var sec17_q21_88 "Other challenge faced for digital payments"


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

gen ent_running = (sec1_q7 == 1 & sec1_q9 == 1)					
la var ent_running "Business is running and owner provided consent (1=Yes)"


**enterpris age
gen e_age = (td(26feb2024) - sec3_q1 )/365.25
la var e_age "Age of the enterprise"
format e_age %4.2f
replace e_age = . if e_age < 0							
winsor2 e_age, replace cuts(1 99)


**age of the entrepreneur
gen age_entrepreneur = (td(08mar2024) - sec4_q1 )/365.25
la var age_entrepreneur "Age of the entrepreneur"
format age_entrepreneur %4.2f
replace age_entrepreneur = . if age_entrepreneur < 0							//6 entrepreneurs have negative values despite putting age connstraints in SurveyCTO
winsor2 age_entrepreneur, replace cuts(1 99)


**Marriage age
clonevar marriage_age=sec4_q2_a
sum marriage_age, d
replace marriage_age = `r(p50)' if marriage_age == 0


*recoding the education variable as a continuous variable
gen education_yrs = sec4_q5
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

//gender
gen f_ent = 1 if sec2_q5 == 2 & sec2_q5 != .
replace f_ent = 0 if sec2_q5 == 1
la var f_ent "Female entrepreneur"
la def f_ent_label 1 "Female" 0 "Male"
la value f_ent f_ent_label


**Registation status: sec3_q2 sec3_q2_1 sec3_q2_a
clonevar udyam_registration = sec3_q2_1
replace udyam_registration = 0 if sec3_q2 == 0
la var udyam_registration "Whether enterprise is registered with Udyam Aadhar (1 = Yes)"


**whether enteprise is sole proprietiership
gen single_owner =.
replace single_owner =1 if sec3_q2_a==1
replace single_owner =0 if sec3_q2_a==2
replace single_owner =0 if sec3_q2_a==3

lab var single_owner "Whether the enterprise is owned by a single person"

//Whether the enterprise operations are seasonal or annual in nature? : sec3_q7 

tab sec3_q7, m

/*==============================================================================
						Enterprise Location (sec3_q6)
===============================================================================*/


tab sec3_q6, gen(ent_location_)
label var ent_location_1 "Located in main marketplace"
label var ent_location_2 "Located in secondary marketplace"
label var ent_location_3 "Located on street with other businesses"
label var ent_location_4 "Located in residential area"


/*==============================================================================
								loan
===============================================================================*/


**Has the enterprise taken any loan in the last five years? (sec8_q1)
la var sec8_q1 "At least one Loan"

*gen count_loan= sec8_q3 (used clonevar instead of gen)
clonevar count_loan = sec8_q3
replace count_loan = 0 if count_loan == .
la var count_loan "Count of Loan (overall)"


**formal and informal source (sec8_q4_1 sec8_q4_2 sec8_q4_3 sec8_q4_4 sec8_q4_5 sec8_q4_6 sec8_q4_7)
gen formal_loan_source = .

replace formal_loan_source = 1 if inlist(sec8_q4_1,2,4,5,6,7,8) | inlist(sec8_q4_2,2,4,5,6,7,8) | inlist(sec8_q4_3,2,4,5,6,7,8)| inlist(sec8_q4_4,2,4,5,6,7,8)|inlist(sec8_q4_5,2,4,5,6,7,8)|inlist(sec8_q4_6,2,4,5,6,7,8)|inlist(sec8_q4_7,2,4,5,6,7,8)


replace formal_loan_source = 0 if formal_loan_source != 1
lab var formal_loan_source "whether enterprise accessed loan from formal financial institution"
la define formal_loan_source_label 0 "No" 1 "Yes"
la value formal_loan_source formal_loan_source_label
fre formal_loan_source // percentage of enterprises supported by the project that have accessed funds from financial institutions

//Whether enterprise accessed loan from bank
gen bank_loan_source = 1 if sec8_q4_1==2
replace bank_loan_source=0 if bank_loan_source==.
la var bank_loan_source "Whether enterprise accessed loan from bank"
la define bank_loan_source_label 1 "Bank" 0 "Other source"
la value bank_loan_source bank_loan_source_label

///rate of interest of bank 

// Set up a loop to label variables
sum sec8_q3
// Set up a loop to label variables
forvalues i = 1/7 {
    local var sec8_q11_`i' 
    local label "Rate of interest (in %) of `i' loan" 
    label variable `var' "`label'" 
}


sum sec8_q3
forvalue i = 1/`r(max)' {
	qui sum sec8_q11_`i', d
	gen sec8_q11_an_`i' = (sec8_q11_`i'*1) if sec8_q12_`i' == 1
	replace sec8_q11_an_`i' = (sec8_q11_`i'*12) if sec8_q12_`i' == 2
	replace sec8_q11_an_`i'= (sec8_q11_`i'*52) if sec8_q12_`i' == 3
    replace sec8_q11_an_`i' = (sec8_q11_`i'*365) if sec8_q12_`i' == 4
	*replace sec8_q11_`i' = 0 if missing(sec8_q11_`i')
	*replace sec8_q12_`i' = 0 if missing(sec8_q12_`i')
	*replace sec8_q11_an_`i' = 0 if missing(sec8_q11_an_`i')
	}

format sec8_q11_an_1 sec8_q11_an_2 sec8_q11_an_3 sec8_q11_an_4 sec8_q11_an_5 sec8_q11_an_6 sec8_q11_an_7 %15.0g

// Label each variable manually
label variable sec8_q11_an_1 "Annual interest rate of first loan"
label variable sec8_q11_an_2 "Annual interest rate of second loan"
label variable sec8_q11_an_3 "Annual interest rate of third loan"
label variable sec8_q11_an_4 "Annual interest rate of fourth loan"
label variable sec8_q11_an_5 "Annual interest rate of fifth loan"
label variable sec8_q11_an_6 "Annual interest rate of sixth loan"
label variable sec8_q11_an_7 "Annual interest rate of seventh loan"

//average interest rate variable creation

egen avg_int_rate= rowmean (sec8_q11_an_*)
la var avg_int_rate "Average interest rate of all loan"

winsor2 avg_int_rate, cuts(1 99)
rename avg_int_rate_w w1_avg_int_rate
label variable w1_avg_int_rate "Average interest rate of all loan (w1)"


*total loan recieved
ds sec8_q7_*
egen total_loan_received=rowtotal(`r(varlist)')
label variable total_loan_received "Total loan received"
*Total loan applied
ds sec8_q6_*
egen total_loan_applied=rowtotal(`r(varlist)')
la var total_loan_applied "Total loan applied"
*Taken atleast one loan
gen atleast_one_loan = 0 if sec8_q3 == .
replace atleast_one_loan = 1 if atleast_one_loan == .
label variable atleast_one_loan "Taken atleast one loan"

ds sec8_q5_*
egen active_loan=rowtotal (`r(varlist)')
label var active_loan "Number of active loans which was taken in the last 5 years"


//loan taken in last 6 months
gen loan_taken_1  = dofc(sec8_q9_1)
format loan_taken %td
la var loan_taken "When was the loan 1 taken?"

gen loan_taken_2  = dofc(sec8_q9_2)
format loan_taken_2 %td
la var loan_taken_2 "When was the loan 2 taken?"

gen loan_taken_3 = dofc(sec8_q9_3)
format loan_taken_3 %td
la var loan_taken_3 "When was the loan 3 taken?"

gen loan_taken_4 = dofc(sec8_q9_4)
format loan_taken_4 %td
la var loan_taken_4 "When was the loan 4 taken?"

gen loan_taken_5 = dofc(sec8_q9_5)
format loan_taken_5 %td
la var loan_taken_5 "When was the loan 5 taken?"

gen loan_taken_6 = dofc(sec8_q9_6)
format loan_taken_6 %td
la var loan_taken_6 "When was the loan 6 taken?"

gen loan_taken_7 = dofc(sec8_q9_7)
format loan_taken_7 %td
la var loan_taken_7 "When was the loan 7 taken?"

gen loan_times_1 = (td(08mar2024) - sec8_q9_1 )
gen loan_times_2 = (td(08mar2024) - sec8_q9_2 )
gen loan_times_3 = (td(08mar2024) - sec8_q9_3 )
gen loan_times_4 = (td(08mar2024) - sec8_q9_4 )
gen loan_times_5 = (td(08mar2024) - sec8_q9_5 )
gen loan_times_6 = (td(08mar2024) - sec8_q9_6 )
gen loan_times_7 = (td(08mar2024) - sec8_q9_7 )


gen rec_loan_taken = 0
replace rec_loan_taken = 1 if (loan_times_1<250)
replace rec_loan_taken = 1 if (loan_times_2<250)
replace rec_loan_taken = 1 if (loan_times_3<250)
replace rec_loan_taken = 1 if (loan_times_4<250)
replace rec_loan_taken = 1 if (loan_times_5<250)
replace rec_loan_taken = 1 if (loan_times_6<250)
replace rec_loan_taken = 1 if (loan_times_7<250)

la var rec_loan_taken "Count of Loan (post-NEFF)"

forval i=1/7 {
	gen rate_neff_`i'=.
	replace rate_neff_`i'= sec8_q11_an_`i' if (rec_loan_taken==1) & (loan_times_`i' <250)
}

gen rate_neff=.
forval i=1/7 {
replace rate_neff=rate_neff_`i' if rate_neff_`i' !=.
}

gen wins=rate_neff, after(rate_neff)
sum wins, d
replace wins=r(p10) if rate_neff<=r(p10)
replace wins=r(p90) if rate_neff>=r(p90)
rename wins w10_rate_neff
la var w10_rate_neff "Winsorized (at 10%) Total amount of unpaid principal across loans"

**Total amount of unpaid principal across loans
ds sec8_q14_*
egen tot_unpaid_loan=rowtotal(`r(varlist)')
la var tot_unpaid_loan "Total amount of unpaid principal across loans"

gen wins=tot_unpaid_loan, after(tot_unpaid_loan)
sum wins, d
replace wins=r(p10) if tot_unpaid_loan<=r(p10)
replace wins=r(p90) if tot_unpaid_loan>=r(p90)
rename wins w10_tot_unpaid_loan
la var w10_tot_unpaid_loan "Winsorized (at 10%) Total amount of unpaid principal across loans"

gen log_w10_tot_unpaid_loan=log(w10_tot_unpaid_loan)
la var log_w10_tot_unpaid_loan "log_w10_tot_unpaid_loan"


/*==============================================================================
                            Investment variable creation	
===============================================================================*/

/*==============================================================================
                            TOTAL INVESTMENT AMOUNTS
===============================================================================*/
**generate total amount investment variable for 3 time period described as 1=2023-2024, 2=2023, 3=2022

*Investment 2023-2024 (6 months period)
ds sec7_q2_*
egen invest_1=rowtotal (`r(varlist)')
la var invest_1 "Amount invested in June,2023 to January,2024"

*Investment in 2023
ds sec7_q5_*
egen invest_2=rowtotal(`r(varlist)')
la var invest_2 "Amount invested in 2023 (Jan-Dec)"

*Investment in 2022
ds sec7_q8_*
egen invest_3=rowtotal(`r(varlist)')
la var invest_3 "Amount invested in 2022 (Jan-Dec)"


*winsorized Investment 2023-2024 (6 months period)

gen wins=invest_1, after(invest_1)
sum wins, d
replace wins=r(p10) if invest_1<=r(p10)
replace wins=r(p90) if invest_1>=r(p90)
rename wins w10_invest_1
la var w10_invest_1 "Winsorized (at 10%) investment in June,2023 to January,2024"

*winsorized Investment in 2023
gen wins=invest_2, after(invest_2)
sum wins, d
replace wins=r(p10) if invest_2<=r(p10)
replace wins=r(p90) if invest_2>=r(p90)
rename wins w10_invest_2
la var w10_invest_2 "Winsorized (at 10%) investment in 2023 (Jan-Dec)"


*winsorized Investment in 2022
gen wins=invest_3, after(invest_3)
sum wins, d
replace wins=r(p10) if invest_3<=r(p10)
replace wins=r(p90) if invest_3>=r(p90)
rename wins w10_invest_3
la var w10_invest_3 "Winsorized (at 10%) investment in 2022 (Jan-Dec)"


/*==============================================================================
                            COUNT OF INVESTMENTS
===============================================================================*/

gen count_investment_1=0
ds sec7_q1_a_*
foreach i in `r(varlist)' {
replace count_investment_1=count_investment_1+1 if `i'!=0
}
lab var count_investment_1 "Investments (#) in June,2023 to January,2024"

gen count_investment_2=0
ds sec7_q4_a_*
foreach i in `r(varlist)' {
replace count_investment_2=count_investment_2+1 if `i'!=0
}
lab var count_investment_2 "Investments (#) in 2023 (Jan-Dec)"

gen count_investment_3=0
ds sec7_q7_a_*
foreach i in `r(varlist)' {
replace count_investment_3=count_investment_3+1 if `i'!=0
}
lab var count_investment_3 "Investments (#) in 2022 (Jan-Dec)"


/*==============================================================================
                            INVESTMENT TYPE PROPORTIONS
===============================================================================*/

**Proportion of WC/Asset creation/Debt reduction in Post-NEFF period
gen wc_invest_1=sec7_q2_1/invest_1
gen ac_invest_1=sec7_q2_2/invest_1
gen dr_invest_1=sec7_q2_3/invest_1

la var wc_invest_1 "Proportion of total invested in working capital in Post-NEFF period"
la var ac_invest_1 "Proportion of total invested in asset creation in Post-NEFF period"
la var dr_invest_1 "Proportion of total invested in debt reduction in Post-NEFF period"


*How many people invested in WC/AC/DR (Post-NEFF period)
gen count_wc_invest_1=. , after(wc_invest_1)
replace count_wc_invest_1=1 if sec7_q2_1 !=.
replace count_wc_invest_1=0 if count_wc_invest_1==.
fre count_wc_invest_1
la var count_wc_invest_1 "People(#) invested in working capital in Post-NEFF period"


gen count_ac_invest_1=. , after(ac_invest_1)
replace count_ac_invest_1=1 if sec7_q2_2 !=.
replace count_ac_invest_1=0 if count_ac_invest_1==.
fre count_ac_invest_1
la var count_ac_invest_1 "People(#) invested in asset creation in Post-NEFF period"

gen count_dr_invest_1=. , after (dr_invest_1)
replace count_dr_invest_1=1 if sec7_q2_3 !=.
replace count_dr_invest_1= 0 if count_dr_invest_1==.
fre count_dr_invest_1
la var count_dr_invest_1 "People(#) invested in debt reduction in Post-NEFF period"

  
*How many people invested in WC/AC/DR (2023)
gen wc_invest_2=sec7_q5_1/invest_2
gen ac_invest_2=sec7_q5_2/invest_2
gen dr_invest_2=sec7_q5_3/invest_2

la var wc_invest_2 "Proportion of total invested in working capital in 2023 (Jan-Dec)"
la var ac_invest_2 "Proportion of total invested in asset creation in 2023 (Jan-Dec)"
la var dr_invest_2 "Proportion of total invested in debt reduction in 2023 (Jan-Dec)"

local count_invest wc_invest_2 ac_invest_2 dr_invest_2
foreach var in `count_invest' {
	gen count_`var'=.
	replace count_`var'= 1 if (sec7_q5_1 !=.) | (sec7_q5_2 !=.)| (sec7_q5_3 !=.)
	replace count_`var'= 0 if count_`var'==.
}

la var count_wc_invest_2 "People(#) invested in working capital in 2023"
la var count_ac_invest_2 "People(#) invested in asset creation in 2023"
la var count_dr_invest_2 "People(#) invested in debt reduction in 2023"

*How many people invested in WC/AC/DR (2022)
  
gen wc_invest_3=sec7_q8_1/invest_3
gen ac_invest_3=sec7_q8_2/invest_3
gen dr_invest_3=sec7_q8_3/invest_3

la var wc_invest_3 "Proportion of total invested in working capital in 2022 (Jan-Dec)"
la var ac_invest_3 "Proportion of total invested in asset creation in 2022 (Jan-Dec)"
la var dr_invest_3 "Proportion of total invested in debt reduction in 2022 (Jan-Dec)"

local count_invest wc_invest_3 ac_invest_3 dr_invest_3
foreach var in `count_invest' {
	gen count_`var'=.
	replace count_`var'= 1 if (sec7_q8_1 !=.) | (sec7_q8_2 !=.)| (sec7_q8_3 !=.)
	replace count_`var'= 0 if count_`var'==.
}

la var count_wc_invest_3 "People(#) invested in working capital in 2022 (Jan-Dec)"
la var count_ac_invest_3 "People(#) invested in asset creation in 2022 (Jan-Dec)"
la var count_dr_invest_3 "People(#) invested in debt creation in 2022 (Jan-Dec)"


//sec7_q4 sec7_q7
gen pre_neff_invest=1 if (sec7_q7==1)
replace pre_neff_invest=0 if pre_neff_invest==.
la var pre_neff_invest "Whether any amount invested in pre-NEFF period (2022)"
la define pre_neff_invest_label 0 "No" 1 "Yes"
la value pre_neff_invest pre_neff_invest_label

tab pre_neff_invest, m

//
egen tot_pre_neff_invest=rowtotal(sec7_q8_1 sec7_q8_2 sec7_q8_3)
la var tot_pre_neff_invest "Total amount invested in pre-NEFF period"


**if need to reshape
preserve
keep enterprise_id invest_1 invest_2 invest_3	
reshape long invest_, i(enterprise_id) j(year)
reshape wide	
restore

/*==============================================================================
                            Asset vaiables
===============================================================================*/

*There asset value is sum of owned value of particular asset and rental value of the asset which enterprise is using.
ds sec9_q3_* sec9_q5_*
egen asset_value=rowtotal (`r(varlist)')
la var asset_value "Total asset value"

*winsorized asset_value
gen wins=asset_value, after(asset_value)
sum wins, d
replace wins=r(p10) if asset_value<=r(p10)
replace wins=r(p90) if asset_value>=r(p90)
rename wins w10_asset_value
la var w10_asset_value "Winsorized (at 10%) asset value "

// Display the list of variables starting with sec9_q3_
ds sec9_q3_*

// Generate the total of these variables
egen owned_asset_value = rowtotal(sec9_q3_*)

// Replace the total with missing if all specific variables are missing
replace owned_asset_value = . if missing(sec9_q3_1) & ///
                                  missing(sec9_q3_2) & ///
                                  missing(sec9_q3_3) & ///
                                  missing(sec9_q3_4) & ///
                                  missing(sec9_q3_5)

label variable owned_asset_value "Total Owned Asset Value"



// Display the list of variables starting with sec9_q4_
ds sec9_q4_*

// Generate the total of these variables
egen percieved_asset_value = rowtotal(sec9_q4_*)

// Replace the total with missing if all specific variables are missing
replace percieved_asset_value = . if missing(sec9_q4_1) & ///
                                      missing(sec9_q4_2) & ///
                                      missing(sec9_q4_3) & ///
                                      missing(sec9_q4_4) & ///
                                      missing(sec9_q4_5)

label variable percieved_asset_value "Total Perceived Asset Value"


ds sec9_q5_*
egen monthly_asset_value=rowtotal (`r(varlist)')
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
	
	
//cost variable:  enterprise_cost enterprise_cost_1 enterprise_cost_2 enterprise_cost_3 enterprise_cost_4 enterprise_cost_5 enterprise_cost_6 enterprise_cost_7 enterprise_cost_8 cost_table_count cost_index_1 cost_june2023_january2024_1 cost_2023_1 cost_2022_1 cost_index_2 cost_june2023_january2024_2 cost_2023_2 cost_2022_2 cost_index_3 cost_june2023_january2024_3 cost_2023_3 cost_2022_3 cost_index_4 cost_june2023_january2024_4 cost_2023_4 cost_2022_4 cost_index_5 cost_june2023_january2024_5 cost_2023_5 cost_2022_5 cost_index_6 cost_june2023_january2024_6 cost_2023_6 cost_2022_6 cost_index_7 cost_june2023_january2024_7 cost_2023_7 cost_2022_7

** total enterprise cost for June,2023 to january, 2024
//Cost variaoble for particular time period: cost_june2023_january2024_*
egen ecost_1 = rowtotal(cost_june2023_january2024_*)
la var ecost_1 "Enterprise cost in June 2023-January 2024"
		
*winsorized enterprise cost in June 2023-January 2024
gen wins = ecost_1, after(ecost_1)
summarize wins, detail
replace wins = r(p5) if ecost_1 <= r(p5)
replace wins = r(p95) if ecost_1 >= r(p95)
rename wins w5_ecost_1
la var w5_ecost_1 "Winsorized (at 5%) Enterprise cost in June 2023-January 2024"

**total enerprise cost for 2023 (January-December)
//Cost variaoble for particular time period: cost_2023_*
egen ecost_2 = rowtotal (cost_2023_*)
la var ecost_2 "Enterprise cost in 2023 (January-December)"

*winsorized enterprise cost in 2023 (January-December)
gen wins = ecost_2, after(ecost_2)
summarize wins, detail
replace wins = r(p5) if ecost_2 <= r(p5)
replace wins = r(p95) if ecost_2 >= r(p95)
rename wins w5_ecost_2
la var w5_ecost_2 "Winsorized (at 5%) Enterprise cost in 2023 (January-December)"
	
		
**total enterprise cost for 2022 (January-February)
//Cost variaoble for particular time period: cost_2022_*
egen ecost_3 = rowtotal (cost_2022_*)
la var ecost_3 "Enterprise cost in 2022 (January-December)"
	
*winsorized enterprise cost in 2023 (January-December)
gen wins=ecost_3, after(ecost_3)
summarize wins, detail
replace wins = r(p5) if ecost_2 <= r(p5)
replace wins = r(p95) if ecost_2 >= r(p95)
rename wins w5_ecost_3
la var w5_ecost_3 "Winsorized (at 10%) Enterprise cost in 2022 (January-December)"


**if need to reshape
preserve
keeporder enterprise_id ecost_1 ecost_2 ecost_3 w5_ecost_1 w5_ecost_2 w5_ecost_3
reshape long ecost_, i(enterprise_id) j(year)
reshape wide	
restore

/*==============================================================================
                            Enterprise Revenue		
===============================================================================*/


**taking self reported annual revenue: sec12_q3_d, sec12_q3_h, sec12_q3_i

clonevar revenue_1=sec12_q3_d
la var revenue_1 "Annual revenue in Post-NEFF period or June, 2023 to January, 2024"

clonevar revenue_2=sec12_q3_h
la var revenue_2 "Annual revenue in 2023 (January to December)"

clonevar revenue_3=sec12_q3_i
la var revenue_3 "Annual revenue in 2022 (January to December)"

*winsorized annual revenue in 2023 (January-December)
gen wins=revenue_1, after(revenue_1)
sum wins, d
replace wins=r(p5) if revenue_1<=r(p5)
replace wins=r(p95) if revenue_1>=r(p95)
rename wins w5_revenue_1
la var w5_revenue_1 "Winsorized (at 5%) Annual revenue in Post-NEFF period or June, 2023 to January, 2024"

*winsorized annual revenue in 2023 (January-December)
gen wins=revenue_2, after(revenue_2)
sum wins, d
replace wins=r(p5) if revenue_2<=r(p5)
replace wins=r(p95) if revenue_2>=r(p95)
rename wins w5_revenue_2
la var w5_revenue_2 "Winsorized (at 5%) Annual revenue in 2023 (January-December)"

*winsorized annual revenue in 2022 (January-December)
gen wins=revenue_3, after(revenue_3)
sum wins, d
replace wins=r(p5) if revenue_3<=r(p5)
replace wins=r(p95) if revenue_3>=r(p95)
rename wins w5_revenue_3
la var w5_revenue_3 "Winsorized (at 5%) Annual revenue in 2022 (January-December)"

/*==============================================================================
                            Enterprise Profit		
===============================================================================*/

gen profit_1=revenue_1-ecost_1
la var profit_1 "Profit in June, 2023 to January, 2024"

gen profit_2=revenue_2-ecost_2
la var profit_2 "Profit in 2023 (January to December)"

gen profit_3=revenue_3-ecost_3
la var profit_3 "Profit in 2022 (January to December)"


//winsorized profit
				
gen w5_profit_1 = w5_revenue_1 - w5_ecost_1		
la var w5_profit_1 "Winsorized (at 5%) Profit in June, 2023 to January, 2024"
			
gen w5_profit_2 = w5_revenue_2 - w5_ecost_2
la var w5_profit_2 "Winsorized (at 5%) Profit in 2023 (January to December)"
			
gen w5_profit_3 = w5_revenue_3 - w5_ecost_3
la var w5_profit_3 "Winsorized (at 5%) Profit in 2023 (January to December)"

/*==============================================================================
                            SELF-REPORTED PROFIT
===============================================================================*/

gen rec_profit= sec12_q6*7
la var rec_profit "self-reported profits of enterprise in last 7 months"

*winsorized self-reported profit
gen wins=rec_profit, after(rec_profit)
sum wins, d
replace wins=r(p10) if rec_profit<=r(p10)
replace wins=r(p90) if rec_profit>=r(p90)
rename wins w10_rec_profit
la var w10_rec_profit "Winsorized (at 10%) self-reported profit"




//OSF service
fre sec15_q1 sec15_q2

gen osf_utilise=sec15_q2
replace osf_utilise=0 if osf_utilise==.
la var osf_utilise "Have you utilized at least one OSF service?"
la define osf_utilise_label 0 "No" 1 "Yes"
la value osf_utilise osf_utilise_label

			
//Digital payment and CIBIL Score
fre sec17_q16 sec19_q1
				
gen cibil_purpose_1=sec19_q7 if sec19_q7 == 1
replace cibil_purpose_1=0 if (sec19_q7 != 1) & (sec19_q7 != .)
la var cibil_purpose_1 "CIBIL purpose: Monitoring my overall credit health"
 			
gen cibil_purpose_2=sec19_q7 if sec19_q7 == 2
replace cibil_purpose_2=0 if (sec19_q7 != 2) & (sec19_q7 != .)
la var cibil_purpose_2 "CIBIL purpose: Preparing loan application"
				
				
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
                            Digital payments
===============================================================================*/

gen dig_pm_start=(td(11mar2024)-sec17_q17)/365.25
la var dig_pm_start "When did you start collecting the digital payment?"

la var neff_cap_ent "0-Only CAP, 1-Only NEFF, 2-Both CAP and NEFF"


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
replace wins=r(p10) if hh_income<=r(p10)
replace wins=r(p90) if hh_income>=r(p90)
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


gen hh_profit=w10_hh_income-w10_hh_cost

**Generate variable for avergae age of HH memebr
ds sec5_q2_4_*
egen avg_hh_age=rowmean(`r(varlist)')


* List variables matching the pattern
ds sec5_q2_6_*

* Store the list of variables in a local macro
local varlist `r(varlist)'

* Loop over each variable in the list and apply the recoding
foreach var of varlist `varlist' {
    gen education_yrs_`var' = `var'
    replace education_yrs_`var' = 0 if inlist(`var', 16, 17, 18, 19)
    replace education_yrs_`var' = 17 if inlist(`var', 14, 15)
    replace education_yrs_`var' = 15 if `var' == 13
    replace education_yrs_`var' = 12 if inlist(`var', 12, 20)
    replace education_yrs_`var' = 11 if `var' == 11
    replace education_yrs_`var' = 10 if `var' == 10
    replace education_yrs_`var' = 9  if `var' == 9
    replace education_yrs_`var' = 8  if `var' == 8
    replace education_yrs_`var' = 7  if `var' == 7
    replace education_yrs_`var' = 6  if `var' == 6
    replace education_yrs_`var' = 5  if `var' == 5
    replace education_yrs_`var' = 4  if `var' == 4
    replace education_yrs_`var' = 3  if `var' == 3
    replace education_yrs_`var' = 2  if `var' == 2
    replace education_yrs_`var' = 1  if `var' == 1
}

* Calculate the average education years of all household members
egen avg_hh_education = rowmean(education_yrs_sec5_q2_6_*)
lab var avg_hh_education "Average years of education of household members"
format avg_hh_education %5.2g
drop  education_yrs_*

** Number of earning member in the HH
ds sec5_q2_7_*
egen earning_member_num=rowtotal(`r(varlist)')
la var earning_member_num "earning member (#) in the HH"



**Direct CAP effect 
gen both=1 if neff_cap_ent ==2
replace both =0 if neff_cap_ent ==1
gen t_both=neff_vill * both


**What if NEFF firms had access to CAP
**Joint effects (nc-c)-(n-c)
gen nc=1 if neff_cap_ent ==2
replace nc=0 if neff_cap_ent ==0
gen n=1 if neff_cap_ent ==1
replace n=0 if neff_cap_ent ==0
gen nc_t=nc*neff_vill
gen n_t=n*neff_vill

reg count_loan neff_vill nc_t $cov  i.sec4_q4 i.block_id
est sto m1
reg count_loan neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0

drop _merge


//estimated revenue from daily revenue
winsor2 sec12_q3_e , cuts(10 90)
areg w5_revenue_2  sec12_q3_e_w $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
predict predicted_annual_revenue_2023
areg predicted_annual_revenue_2023 neff_vill $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)


replace  district="Tiruvarur" if enterprise_id == "718"
replace  district="Tiruchirappalli" if enterprise_id == "765"
replace  district="Villupuram " if enterprise_id == "2410"
replace  district="Villupuram " if enterprise_id == "371"
replace  district="Villupuram " if enterprise_id == "2439"


replace district = trim(district)
save "$derived/NEFF_phase_1_full.dta", replace