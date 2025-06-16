
*********************************************************************************************************************
*										 RESULT TABLE B: Impact on loans and indebtedness
*********************************************************************************************************************

**Exposure and Treatment effect
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist sec8_q1 count_loan rec_loan_taken w10_avg_int_rate w10_rate_neff w10_tot_unpaid_loan log_w10_tot_unpaid_loan {
    * First regression with neff_vill
    areg `var' neff_vill $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
    estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second regression with treat_ent
    areg `var' treat_ent $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
    estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB2_`i'

    local i=`i'+1
}

#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6 tableB1_7 using "$tables/loan_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(neff_vill) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("At least one Loan" "Count of Loan (overall)" "Count of Loan (post-NEFF)" "Rate of Interest" "Rate of Interest (post-NEFF)" "Size of indebtedness (Value of Unpaid Loans)" "Log of Indebtedness") ///
    title("Table 1: Impact on loans and indebtedness") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6 tableB2_7 using "$tables/loan_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("At least one Loan" "Count of Loan (overall)" "Count of Loan (post-NEFF)" "Rate of Interest" "Rate of Interest (post-NEFF)" "Size of indebtedness (Value of Unpaid Loans)" "Log of Indebtedness") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr




**CAP and Joint effects 
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist sec8_q1 count_loan rec_loan_taken w10_avg_int_rate w10_rate_neff w10_tot_unpaid_loan {
    * First regression with t_both (CAP effect)
    areg `var' t_both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'

    * First regression with nc_t (Joint effect)
    reg `var' neff_vill nc_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m1

    * Second regression with n_t (Joint effect)
    reg `var' neff_vill n_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m2

    * Joint effect using suest
    suest m1 m2, noomitted vce(cluster panchayat_id)

    * Perform a Wald test on the joint hypothesis
    test [m1_mean]nc_t - [m2_mean]n_t = 0

    * Store the chi-square value and the p-value
    scalar chi2_val = round(r(chi2), 0.01)
    scalar p_val = r(p)
    
    * Create a local macro to store the formatted chi-square value with stars
    local chi2_star = chi2_val
    if p_val < 0.01 {
        local chi2_star = "`chi2_star'***"
    }
    else if p_val < 0.05 {
        local chi2_star = "`chi2_star'**"
    }
    else if p_val < 0.10 {
        local chi2_star = "`chi2_star'*"
    }

    * Add the formatted chi-square value as a local macro
    estadd local joint_chi2 "`chi2_star'"
    estadd scalar joint_pval = p_val
    eststo joint_`i'

    local i = `i' + 1
}

* Generate esttab tables for both sets of results
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 using "$tables/loan_JE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
	title("Impact on loans and indebtedness") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Loan access" "Loan number" "Loans(#) in Post-NEFF period" "Average interest rate" "Interest rate in Post-NEFF period" "Total unpaid loans") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 joint_4 joint_5 joint_6 using "$tables/loan_je.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("Loan access" "Loan number" "Loans(#) in Post-NEFF period" "Average interest rate" "Interest rate in Post-NEFF period" "Total unpaid loans") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr

****CAP effects
eststo clear
local i=1

foreach var of varlist sec8_q1 count_loan rec_loan_taken w10_avg_int_rate w10_rate_neff w10_tot_unpaid_loan {
    * First regression with t_both (CAP effect)
    areg `var' both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'
    local i = `i' + 1
}

#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 using "V:\Projects\TNRTP\Data\Baseline\Baseline report/loan_JE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
	title("Impact on loans and indebtedness") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Loan access" "Loan number" "Loans(#) in Post-NEFF period" "Average interest rate" "Interest rate in Post-NEFF period" "Total unpaid loans") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr




****************************************************************************************
**										Loan complete
****************************************************************************************


***********************************************************************************************************************************
*										 RESULT TABLE B: Impact on Revenue, Cost, Profit
***********************************************************************************************************************************

**Exposure and Treatment effect
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1
foreach var of varlist w10_revenue_1 w10_ecost_1 w10_profit_1 {
    * First regression with neff_vill
    areg `var' neff_vill $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second regression with treat_ent
    areg `var' treat_ent $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB2_`i'

    local i=`i'+1
}


#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 using "$tables/RCP_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(neff_vill) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Revenue" "Cost" "Profit") ///
    title("Table 2: Impact on Revenue, Cost and Profit") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr

#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 using "$tables/RCP_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Revenue" "Cost" "Profit") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr


**CAP and Joint effect
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist w10_revenue_1 w10_ecost_1 w10_profit_1 {
    * First regression with t_both (CAP effect)
    areg `var' t_both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'

    * First regression with nc_t (Joint effect)
    reg `var' neff_vill nc_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m1

    * Second regression with n_t (Joint effect)
    reg `var' neff_vill n_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m2

    * Joint effect using suest
    suest m1 m2, noomitted vce(cluster panchayat_id)

    * Perform a Wald test on the joint hypothesis
    test [m1_mean]nc_t - [m2_mean]n_t = 0

    * Store the chi-square value and the p-value
    scalar chi2_val = round(r(chi2), 0.01)
    scalar p_val = r(p)
    
    * Create a local macro to store the formatted chi-square value with stars
    local chi2_star = chi2_val
    if p_val < 0.01 {
        local chi2_star = "`chi2_star'***"
    }
    else if p_val < 0.05 {
        local chi2_star = "`chi2_star'**"
    }
    else if p_val < 0.10 {
        local chi2_star = "`chi2_star'*"
    }

    * Add the formatted chi-square value as a local macro
    estadd local joint_chi2 "`chi2_star'"
    estadd scalar joint_pval = p_val
    eststo joint_`i'

    local i = `i' + 1
}

* Generate esttab tables for both sets of results
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 using "$tables/RCP_JE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
    title("Impact on Revenue, Cost and Profit") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Revenue" "Cost" "Profit") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 using "$tables/RCP_JE.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("Revenue" "Cost" "Profit") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr



****************************************************************************************
**										RCP complete
****************************************************************************************

***************************************************************************************************************************************
*										 RESULT TABLE 2A: Impact on Revenue, Cost, Profit (PANEL: 2022-2023, Yearly)
***************************************************************************************************************************************
preserve
**Comparing full 2023 with full 2022
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"

reshape long  invest_ w10_invest_  ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_, i(enterprise_id) j(year)

keep if (year==2) | (year==3)

replace year=0 if year==3
replace year=1 if year==2
**Comparing full 2023 with full 2022

destring enterprise_id, generate(enterprise_id_num) 
sort enterprise_id_num year


xtset enterprise_id_num year

** (Exposure effect)
gen np=neff_vill * year
la var np "NEFF*POST"
la var year "POST"

**  (Direct treatment effect)
gen np_treat=treat_ent * year
la var np_treat "NEFF*POST"
la var year "POST"

** (CAP effect in NEFF villages)
gen np_both=t_both * year
la var np_both "NEFF*POST"
la var year "POST"



***Final for the reporting
gen l_profit=log(profit_)
gen l_cost=log(ecost_)
gen l_revenue=log(revenue_)
gen l_invest=log(invest_)
gen l_ac=log(ac_invest_)
gen l_wc=log(wc_invest_)
gen l_dr=log(dr_invest_)

* Run regressions and store results
eststo clear
local i=1

foreach var in l_revenue l_cost l_profit l_invest l_wc l_ac l_dr {
    xtreg `var' np year, fe
    test np=0
    estadd scalar pval1=r(p)
    local fixed_effects "YES"
    estadd local fixed_effects `"`fixed_effects'"'
    sum `var' if e(sample)
    eststo tableB1_`i'

    xtreg `var' np_treat year, fe
    test np_treat=0
    estadd scalar pval1=r(p)
    estadd local fixed_effects `"`fixed_effects'"'
    sum `var' if e(sample)
    eststo tableB2_`i'

    xtreg `var' np_both year, fe
    test np_both=0
    estadd scalar pval1=r(p)
    estadd local fixed_effects `"`fixed_effects'"'
    sum `var' if e(sample)
    eststo tableB3_`i'

    local i=`i'+1
}

* Generate esttab tables for Panel A: Exposure effect
#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6 tableB1_7 using "$tables/panel_2_3_2022_2023_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np year) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
    title("Table 2A: Impact on Enterprise Revenue/Cost/Profit/Investment") addnotes("Standard errors in parentheses" "Period 0:2022" "Period 1:2023" "Dependent variables are log-transformed") ;
#delimit cr

* Generate esttab tables for Panel B: Treatment effect
#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6 tableB2_7 using "$tables/panel_2_3_2022_2023_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np_treat year) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
    addnotes("Standard errors in parentheses" "Period 0:2022" "Period 1:2023" "Dependent variables are log-transformed") ;
#delimit cr

* Generate esttab tables for Panel C: CAP effect in NEFF villages
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 tableB3_7 using "$tables/panel_2_3_2022_2023_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np_both year) ///
    posthead("Panel C: CAP effect in NEFF villages") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
    addnotes("Standard errors in parentheses" "Period 0:2022" "Period 1:2023" "Dependent variables are log-transformed") ;
#delimit cr

* Drop only the variables created by eststo before reshaping back to wide
drop _est_tableB1_* _est_tableB2_* _est_tableB3_*

* Reshape back to wide format, including the interaction and log variables
reshape wide invest_ w10_invest_ ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_ np np_treat np_both l_*, i(enterprise_id) j(year)

xtset, clear
restore

***********************************************************************************
*Complete: Revenue, Cost, Profit, Investment, WC, AC, DR (PANEL: 2022-2023, Yearly)
***********************************************************************************



******************************************************************************************************************************************
*								 RESULT TABLE 2A: Impact on Revenue, Cost, Profit (PANEL: 2022-2023, Half-Yearly)
******************************************************************************************************************************************

preserve
**Comparing 2023 with 2022 (Half-Yearly)
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"

reshape long  invest_ w10_invest_  ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_, i(enterprise_id) j(year)


**setting panel
destring enterprise_id, generate(enterprise_id_num) 

xtset enterprise_id_num year

keep if (year==1) | (year==3)
replace year=0 if year==3
sort enterprise_id_num year



gen r_profit=profit_
replace r_profit=profit_/2 if year==0

gen r_cost=ecost_
replace r_cost=ecost_/2 if year==0

gen r_revenue=revenue_
replace r_revenue=revenue_/2 if year==0

gen r_invest=invest_
replace r_invest=invest_/2 if year==0

gen r_ac=ac_invest_
replace r_ac=ac_invest_/2 if year==0

gen r_wc=wc_invest_
replace r_wc=wc_invest_/2 if year==0

gen r_dr=dr_invest_
replace r_dr=wc_invest_/2 if year==0
** (Exposure effect)
gen np=neff_vill * year
la var np "NEFF*POST"
la var year "POST"

**  (Direct treatment effect)
gen np_treat=treat_ent * year
la var np_treat "NEFF*POST"
la var year "POST"

** (CAP effect in NEFF villages)
gen np_both=t_both * year
la var np_both "NEFF*POST"
la var year "POST"


**Log transformation
gen l_r_revenue=log(r_revenue)
gen l_r_cost=log(r_cost)
gen l_r_profit=log(r_profit)
gen l_r_invest=log(r_invest)
gen l_r_ac=log(r_ac)
gen l_r_wc=log(r_wc)
gen l_r_dr=log(r_dr)


* Run regressions and store results
eststo clear
local i=1

foreach var in l_r_revenue l_r_cost l_r_profit l_r_invest l_r_wc l_r_ac l_r_dr {
    xtreg `var' np year, fe
    test np=0
    estadd scalar pval1=r(p)
    local fixed_effects "YES"
    estadd local fixed_effects `"`fixed_effects'"'
    sum `var' if e(sample)
    eststo tableB1_`i'

    xtreg `var' np_treat year, fe
    test np_treat=0
    estadd scalar pval1=r(p)
    estadd local fixed_effects `"`fixed_effects'"'
    sum `var' if e(sample)
    eststo tableB2_`i'

    xtreg `var' np_both year, fe
    test np_both=0
    estadd scalar pval1=r(p)
    estadd local fixed_effects `"`fixed_effects'"'
    sum `var' if e(sample)
    eststo tableB3_`i'

    local i=`i'+1
}


* Generate esttab tables for Panel A: Exposure effect
#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6 tableB1_7 using "$tables/panel_1_3_2022_2023_half_yearly_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np year) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
    title("Table 2B: Impact on Enterprise Revenue/Cost/Profit/Investment") ///
	addnotes("Standard errors in parentheses" "Period 0:2022 (Half-yearly)" "Period 1:2023 (Half-yearly)" "Dependent variables are log-transformed") ;
#delimit cr

* Generate esttab tables for Panel B: Treatment effect
#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6 tableB2_7 using "$tables/panel_1_3_2022_2023_half_yearly_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np_treat year) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
	addnotes("Standard errors in parentheses" "Period 0:2022 (Half-yearly)" "Period 1:2023 (Half-yearly)" "Dependent variables are log-transformed") ;
#delimit cr

* Generate esttab tables for Panel C: CAP effect in NEFF villages
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 tableB3_7 using "$tables/panel_1_3_2022_2023_half_yearly_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np_both year) ///
    posthead("Panel C: CAP effect in NEFF villages") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
	addnotes("Standard errors in parentheses" "Period 0:2022 (Half-yearly)" "Period 1:2023 (Half-yearly)" "Dependent variables are log-transformed") ;
#delimit cr

* Drop only the variables created by eststo before reshaping back to wide
drop _est_tableB1_* _est_tableB2_* _est_tableB3_*

* Reshape back to wide format, including the interaction and log variables
reshape wide invest_ w10_invest_ ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_ np np_treat np_both l_* r_*, i(enterprise_id) j(year)

xtset, clear
restore

****************************************************************************************
*Complete: Revenue, Cost, Profit, Investment, WC, AC, DR (PANEL: 2022-2023, Half-Yearly)
****************************************************************************************

*******************************************************************************************************************************************
*										 RESULT TABLE B: Impact on investment in Post-NEFF period
*******************************************************************************************************************************************


global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"

global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist count_investment_1 w10_invest_1 wc_invest_1 ac_invest_1 dr_invest_1 count_wc_invest_1 count_ac_invest_1 count_dr_invest_1 {
    * First regression with neff_vill
    areg `var' neff_vill $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second regression with treat_ent
    areg `var' treat_ent $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
    estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB2_`i'

    local i=`i'+1
}

#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6 tableB1_7 tableB1_8 using "$tables/investmets_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(neff_vill) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Investments (#)" "Total investment" "Proportion of total invested in WC" "Proportion of total invested in AC" "Proportion of total invested in DR" "People(#) invested in WC" "People(#) invested in AC" "People(#) invested in DR") ///
    title("Table 3: Impact on investment in Post-NEFF period") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "WC: Working Capital, AC: Asset Creation, DR: Debt Reduction, (#): Numbers");
#delimit cr

#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6 tableB2_7 tableB2_8 using "$tables/investmets_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Investments (#)" "Total investment" "Proportion of total invested in WC" "Proportion of total invested in AC" "Proportion of total invested in DR" "People(#) invested in WC" "People(#) invested in AC" "People(#) invested in DR") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "WC: Working Capital, AC: Asset Creation, DR: Debt Reduction, (#): Numbers");

#delimit cr



**CAP and Joint effects
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist count_investment_1 w10_invest_1 wc_invest_1 ac_invest_1  count_wc_invest_1 count_ac_invest_1 count_dr_invest_1 {
    * First regression with t_both (CAP effect)
    areg `var' t_both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'

    * First regression with nc_t (Joint effect)
    reg `var' neff_vill nc_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m1

    * Second regression with n_t (Joint effect)
    reg `var' neff_vill n_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m2

    * Joint effect using suest
    suest m1 m2, noomitted vce(cluster panchayat_id)

    * Perform a Wald test on the joint hypothesis
    test [m1_mean]nc_t - [m2_mean]n_t = 0

    * Store the chi-square value and the p-value
    scalar chi2_val = round(r(chi2), 0.01)
    scalar p_val = r(p)
    
    * Create a local macro to store the formatted chi-square value with stars
    local chi2_star = chi2_val
    if p_val < 0.01 {
        local chi2_star = "`chi2_star'***"
    }
    else if p_val < 0.05 {
        local chi2_star = "`chi2_star'**"
    }
    else if p_val < 0.10 {
        local chi2_star = "`chi2_star'*"
    }

    * Add the formatted chi-square value as a local macro
    estadd local joint_chi2 "`chi2_star'"
    estadd scalar joint_pval = p_val
    eststo joint_`i'

    local i = `i' + 1
}

* Generate esttab tables for both sets of results
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 tableB3_7 using "$tables/investmets_JE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
    title("Impact on investment in Post-NEFF period") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Investments (#)" "Total investment" "Proportion of total invested in WC" "Proportion of total invested in AC" "Proportion of total invested in DR" "People(#) invested in WC" "People(#) invested in AC" "People(#) invested in DR") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 joint_4 joint_5 joint_6 joint_7 using "$tables/investmets_JE.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("Investments (#)" "Total investment" "Proportion of total invested in WC" "Proportion of total invested in AC" "People(#) invested in WC" "People(#) invested in AC" "People(#) invested in DR") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr



********************************************************************************
**									Investment complete
********************************************************************************



**************************************************************************************************************************************
*										 RESULT TABLE B: Impact on Business practice and skills
**************************************************************************************************************************************
**Treatment and Exposure effect
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist marketing_score record_keeping_score bp_score {
    * First regression with neff_vill
    areg `var' neff_vill $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second regression with treat_ent
    areg `var' treat_ent $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB2_`i'

    local i=`i'+1
}

#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 using "$tables/bps_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(neff_vill) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Marketing Practices" "Record Keeping Practices" "Business Practices and Skills") ///
    title("Table 4: Impact on Business practice and skills") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr

#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 using "$tables/bps_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Marketing Practices" "Record Keeping Practices" "Business Practices and Skills") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr


**CAP and Joint effects
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist marketing_score record_keeping_score bp_score {
    * First regression with t_both (CAP effect)
    areg `var' t_both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'

    * First regression with nc_t (Joint effect)
    reg `var' neff_vill nc_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m1

    * Second regression with n_t (Joint effect)
    reg `var' neff_vill n_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m2

    * Joint effect using suest
    suest m1 m2, noomitted vce(cluster panchayat_id)

    * Perform a Wald test on the joint hypothesis
    test [m1_mean]nc_t - [m2_mean]n_t = 0

    * Store the chi-square value and the p-value
    scalar chi2_val = round(r(chi2), 0.01)
    scalar p_val = r(p)
    
    * Create a local macro to store the formatted chi-square value with stars
    local chi2_star = chi2_val
    if p_val < 0.01 {
        local chi2_star = "`chi2_star'***"
    }
    else if p_val < 0.05 {
        local chi2_star = "`chi2_star'**"
    }
    else if p_val < 0.10 {
        local chi2_star = "`chi2_star'*"
    }

    * Add the formatted chi-square value as a local macro
    estadd local joint_chi2 "`chi2_star'"
    estadd scalar joint_pval = p_val
    eststo joint_`i'

    local i = `i' + 1
}

* Generate esttab tables for both sets of results
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 using "$tables/bps_JE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
    title("Impact on Business practice and skills") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Marketing Practices" "Record Keeping Practices" "Business Practices and Skills") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 using "$tables/bps_JE.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("Marketing Practices" "Record Keeping Practices" "Business Practices and Skills") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr



********************************************************************************
**								Business practice and skills complete
********************************************************************************





***************************************************************************************************************************************************
*										 RESULT TABLE B: Impact on Digital Payments
***************************************************************************************************************************************************

global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"

global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist sec17_q16 sec17_q20 dig_pm_start sec17_q23_1 sec17_q23_2 {
    * First regression with neff_vill
    areg `var' neff_vill $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second regression with treat_ent
    areg `var' treat_ent $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB2_`i'

    local i=`i'+1
}

#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 using "$tables/digital_payments_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(neff_vill) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Digital Payments access" "Monthly sales (%)" "Years of use" "Increased revenue" "Streamlined financial processes") ///
    title("Table 5: Impact on Digital Payments") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." ) ;
#delimit cr

#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 using "$tables/digital_payments_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Digital Payments access" "Monthly sales (%)" "Years of use" "Increased revenue" "Streamlined financial processes") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr

**CAP and Joint effects
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist sec17_q16 sec17_q20 dig_pm_start sec17_q23_1 sec17_q23_2 {
    * First regression with t_both (CAP effect)
    areg `var' t_both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'

    * First regression with nc_t (Joint effect)
    reg `var' neff_vill nc_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m1

    * Second regression with n_t (Joint effect)
    reg `var' neff_vill n_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m2

    * Joint effect using suest
    suest m1 m2, noomitted vce(cluster panchayat_id)

    * Perform a Wald test on the joint hypothesis
    test [m1_mean]nc_t - [m2_mean]n_t = 0

    * Store the chi-square value and the p-value
    scalar chi2_val = round(r(chi2), 0.01)
    scalar p_val = r(p)
    
    * Create a local macro to store the formatted chi-square value with stars
    local chi2_star = chi2_val
    if p_val < 0.01 {
        local chi2_star = "`chi2_star'***"
    }
    else if p_val < 0.05 {
        local chi2_star = "`chi2_star'**"
    }
    else if p_val < 0.10 {
        local chi2_star = "`chi2_star'*"
    }

    * Add the formatted chi-square value as a local macro
    estadd local joint_chi2 "`chi2_star'"
    estadd scalar joint_pval = p_val
    eststo joint_`i'

    local i = `i' + 1
}

* Generate esttab tables for both sets of results
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 using "$tables/digital_payments_JE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
    title("Impact on Digital Payments") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Digital Payments access" "Monthly sales (%)" "Years of use" "Increased revenue" "Streamlined financial processes") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 joint_4 joint_5 using "$tables/digital_payments_JE.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("Digital Payments access" "Monthly sales (%)" "Years of use" "Increased revenue" "Streamlined financial processes") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr





********************************************************************************
**						Digital payments complete
********************************************************************************


*************************************************************************************************************************************
*										 RESULT TABLE B: Impact on CIBIL Score
*************************************************************************************************************************************

global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist sec19_q1 sec19_q3 sec19_q3_a sec19_q5 cibil_purpose_1 {
    * First regression with neff_vill
    areg `var' neff_vill $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second regression with treat_ent
    areg `var' treat_ent $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB2_`i'

    local i=`i'+1
}

foreach var of varlist sec19_q8 {
    * First ordered logit with neff_vill
    ologit `var' neff_vill $cov $hh_cov i.sec4_q4 i.block_id, cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second ordered logit with treat_ent
    ologit `var' treat_ent $cov $hh_cov i.sec4_q4 i.block_id, cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
    sum `var' if e(sample)
    eststo tableB2_`i'

    local i=`i'+1
}

#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6  using "$tables/cibil_TE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(neff_vill) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("CIBIL awareness" "CIBIL score check" "CIBIL score" "Action taken to improve CIBIL score" "Purpose: Monitor credit health" "Level of familiarity") ///
    title("Table 6: Impact on CIBIL Score") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr

#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6  using "$tables/cibil_TE.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("CIBIL awareness" "CIBIL score check" "CIBIL score" "Action taken to improve CIBIL score" "Purpose: Monitor credit health" "Level of familiarity") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr


**CAP and Joint effects
global tables "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\final_tables"
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 

eststo clear
local i=1

foreach var of varlist sec19_q1 sec19_q3 sec19_q3_a sec19_q5 cibil_purpose_1  {
    * First regression with t_both (CAP effect)
    areg `var' t_both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
	estadd local Block_FE "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'

    * First regression with nc_t (Joint effect)
    reg `var' neff_vill nc_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m1

    * Second regression with n_t (Joint effect)
    reg `var' neff_vill n_t $cov $hh_cov i.sec4_q4 i.block_id
    eststo m2

    * Joint effect using suest
    suest m1 m2, noomitted vce(cluster panchayat_id)

    * Perform a Wald test on the joint hypothesis
    test [m1_mean]nc_t - [m2_mean]n_t = 0

    * Store the chi-square value and the p-value
    scalar chi2_val = round(r(chi2), 0.01)
    scalar p_val = r(p)
    
    * Create a local macro to store the formatted chi-square value with stars
    local chi2_star = chi2_val
    if p_val < 0.01 {
        local chi2_star = "`chi2_star'***"
    }
    else if p_val < 0.05 {
        local chi2_star = "`chi2_star'**"
    }
    else if p_val < 0.10 {
        local chi2_star = "`chi2_star'*"
    }

    * Add the formatted chi-square value as a local macro
    estadd local joint_chi2 "`chi2_star'"
    estadd scalar joint_pval = p_val
    eststo joint_`i'

    local i = `i' + 1
}


foreach var of varlist sec19_q8 {
    * First ordered logit with neff_vill
    ologit `var' t_both $cov $hh_cov i.sec4_q4 i.block_id, cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    estadd local HH "Yes"
    estadd local Enterprise "Yes"
    sum `var' if e(sample)
    eststo tableB3_`i'

}


* Generate esttab tables for both sets of results
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 using "$tables/cibil_JE.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
    title("Impact on CIBIL Score") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("CIBIL awareness" "CIBIL score check" "CIBIL score" "Action taken to improve CIBIL score" "Purpose: Monitor credit health" "Level of familiarity") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 joint_4 joint_5  using "$tables/cibil_JE.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("CIBIL awareness" "CIBIL score check" "CIBIL score" "Action taken to improve CIBIL score" "Purpose: Monitor credit health" "Level of familiarity") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr






*******************************************************************************************************************************************************
**																	CIBIL Score complete
*******************************************************************************************************************************************************











