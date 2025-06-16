

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
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second regression with treat_ent
    areg `var' treat_ent $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    sum `var' if e(sample)
    eststo tableB2_`i'

    * Third regression with t_both
    areg `var' t_both $cov $hh_cov i.sec4_q4, absorb(block_id) cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    sum `var' if e(sample)
    eststo tableB3_`i'

    local i=`i'+1
}

foreach var of varlist sec19_q8 {
    * First ordered logit with neff_vill
    ologit `var' neff_vill $cov $hh_cov i.sec4_q4 i.block_id, cluster(panchayat_id)
    test neff_vill==0
    estadd scalar pval1=r(p)
    sum `var' if e(sample)
    eststo tableB1_`i'

    * Second ordered logit with treat_ent
    ologit `var' treat_ent $cov $hh_cov i.sec4_q4 i.block_id, cluster(panchayat_id)
    test treat_ent==0
    estadd scalar pval1=r(p)
    sum `var' if e(sample)
    eststo tableB2_`i'

    * Third ordered logit with t_both
    ologit `var' t_both $cov $hh_cov i.sec4_q4 i.block_id, cluster(panchayat_id)
    test t_both==0
    estadd scalar pval1=r(p)
    sum `var' if e(sample)
    eststo tableB3_`i'

    local i=`i'+1
}

* New regression analyses for Panel D
foreach var of varlist sec19_q1 sec19_q3 sec19_q3_a sec19_q5 cibil_purpose_1 {
    reg `var' neff_vill nc_t $cov i.sec4_q4 i.block_id
    eststo m1_`var'
    
    reg `var' neff_vill n_t $cov i.sec4_q4 i.block_id
    eststo m2_`var'
    
    suest m1_`var' m2_`var', noomitted vce(cluster panchayat_id)
    test [m1_`var'_mean]nc_t - [m2_`var'_mean]n_t = 0
    estadd scalar test_diff_pval_`var' = r(p)
}

#delimit ;
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6 using "$tables/cibil.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(neff_vill) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1, fmt(%9.0g %9.3f) labels("Sample Size" "Pval1")) ///
    mtitles("CIBIL awareness" "CIBIL score check" "CIBIL score" "Action taken to improve CIBIL score" "Purpose: Monitor credit health" "Level of familiarity") ///
    title("Table 6: Impact on CIBIL Score") ///
    addnotes("Control variables: HH: Yes, Enterprise: Yes");
#delimit cr

#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6  using "$tables/cibil.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1, fmt(%9.0g %9.3f) labels("Sample Size" "Pval1")) ///
    mtitles("CIBIL awareness" "CIBIL score check" "CIBIL score" "Action taken to improve CIBIL score" "Purpose: Monitor credit health" "Level of familiarity") ///
    addnotes("Control variables: HH: Yes, Enterprise: Yes");
#delimit cr

#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 using "$tables/cibil.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel C: CAP effect in NEFF villages") ///
    stats(N pval1, fmt(%9.0g %9.3f) labels("Sample Size" "Pval1")) ///
    mtitles("CIBIL awareness" "CIBIL score check" "CIBIL score" "Action taken to improve CIBIL score" "Purpose: Monitor credit health" "Level of familiarity") ///
    addnotes("Control variables: HH: Yes, Enterprise: Yes");
#delimit cr

#delimit ;
esttab m1_sec19_q1 m2_sec19_q1 m1_sec19_q3 m2_sec19_q3 m1_sec19_q3_a m2_sec19_q3_a m1_sec19_q5 m2_sec19_q5 m1_cibil_purpose_1 m2_cibil_purpose_1 using "$tables/cibil.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
	    keep(nc_t n_t) ///

    stats(N test_diff_pval_sec19_q1 test_diff_pval_sec19_q3 test_diff_pval_sec19_q3_a test_diff_pval_sec19_q5 test_diff_pval_cibil_purpose_1, fmt(%9.0g %9.3f) labels("Sample Size" "Pval")) ///
    mtitles("CIBIL awareness - NC" "CIBIL awareness - N" "CIBIL score check - NC" "CIBIL score check - N" "CIBIL score - NC" "CIBIL score - N" "Action taken to improve CIBIL score - NC" "Action taken to improve CIBIL score - N" "Purpose: Monitor credit health - NC" "Purpose: Monitor credit health - N") ///
    posthead("Panel D: Difference in Coefficients") ///
    addnotes("Control variables: HH: Yes, Enterprise: Yes, NC: Non-NEFF Control, N: NEFF");
#delimit cr










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
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6 tableB1_7 using "$tables/panel_2_3_2022_2023.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np year) ///
    posthead("Panel A: Exposure effect") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
    title("Table 2A: Impact on Enterprise Revenue/Cost/Profit/Investment") addnotes("Standard errors in parentheses" "Period 0:2022" "Period 1:2023" "Dependent variables are log-transformed") ;
#delimit cr

* Generate esttab tables for Panel B: Treatment effect
#delimit ;
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6 tableB2_7 using "$tables/panel_2_3_2022_2023.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np_treat year) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
    addnotes("Standard errors in parentheses" "Period 0:2022" "Period 1:2023" "Dependent variables are log-transformed") ;
#delimit cr

* Generate esttab tables for Panel C: CAP effect in NEFF villages
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 tableB3_7 using "$tables/panel_2_3_2022_2023.rtf", append depvar legend label nonumbers nogaps nonotes ///
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





***************************************************************************************************************************************************
*										 RESULT TABLE 2A: Impact on Revenue, Cost, Profit (PANEL: 2022-2023, Half-Yearly)
***************************************************************************************************************************************************

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
esttab tableB1_1 tableB1_2 tableB1_3 tableB1_4 tableB1_5 tableB1_6 tableB1_7 using "$tables/panel_1_3_2022_2023_half_yearly.rtf", replace depvar legend label nonumbers nogaps nonotes ///
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
esttab tableB2_1 tableB2_2 tableB2_3 tableB2_4 tableB2_5 tableB2_6 tableB2_7 using "$tables/panel_1_3_2022_2023_half_yearly.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(np_treat year) ///
    posthead("Panel B: Treatment effect") ///
    stats(N pval1 fixed_effects, fmt(%9.0g %9.3f %s) labels("Observations" "P-value" "Enterprise FE")) ///
    mtitles("Revenue" "Cost" "Profit" "Investment" "Working Capital" "Asset Creation" "Debt Reduction") ///
	addnotes("Standard errors in parentheses" "Period 0:2022 (Half-yearly)" "Period 1:2023 (Half-yearly)" "Dependent variables are log-transformed") ;
#delimit cr

* Generate esttab tables for Panel C: CAP effect in NEFF villages
#delimit ;
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 tableB3_7 using "$tables/panel_1_3_2022_2023_half_yearly.rtf", append depvar legend label nonumbers nogaps nonotes ///
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


