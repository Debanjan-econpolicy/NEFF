	
global cov "i.sec2_q2 e_age marriage_age age_entrepreneur education_yrs" // Covariates 
global hh_cov "tot_hh_member avg_hh_age avg_hh_education earning_member_num" // Covariates 


	reg sec8_q1 neff_vill nc_t $cov $hh_cov i.sec4_q4 i.block_id
	est sto m1
	reg sec8_q1 neff_vill n_t $cov $hh_cov  i.sec4_q4 i.block_id
	est sto m2
	suest m1 m2, noomitted  vce(cluster panchayat_id)
	test [m1_mean]nc_t - [m2_mean]n_t = 0



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
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 using "$tables/joint_effect.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
	title("Impact on loans and indebtedness") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Loan access" "Loan number" "Loans(#) in Post-NEFF period" "Average interest rate" "Interest rate in Post-NEFF period" "Total unpaid loans") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 joint_4 joint_5 joint_6 using "$tables/joint_effect.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("Loan access" "Loan number" "Loans(#) in Post-NEFF period" "Average interest rate" "Interest rate in Post-NEFF period" "Total unpaid loans") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr





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
esttab tableB3_1 tableB3_2 tableB3_3 tableB3_4 tableB3_5 tableB3_6 using "$tables/joint_effect.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(t_both) ///
    posthead("Panel A: CAP effect in NEFF villages") ///
    title("Impact on Revenue, Cost and Profit") ///
    stats(N pval1 HH Enterprise Block_FE, fmt(%9.0g %9.3f %s %s %s) labels("Observations" "P-value" "Covariate: HH" "Covariate: Enterprise" "Block FE")) ///
    mtitles("Revenue" "Cost" "Profit") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "(#): Numbers") ;
#delimit cr

#delimit ;
esttab joint_1 joint_2 joint_3 joint_4 joint_5 joint_6 using "$tables/joint_effect.rtf", append depvar legend label nonumbers nogaps nonotes keep(neff_vill nc_t n_t) ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    posthead("Panel B: Joint effect") ///
    stats(N joint_chi2 joint_pval, fmt(%9.0g %9.2f %9.3f) labels("Observations" "Chi2 Value" "P-value")) ///
    mtitles("Revenue" "Cost" "Profit") ///
addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses.") ;
#delimit cr
