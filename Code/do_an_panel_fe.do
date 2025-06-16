clear all
cd "V:\Projects\NEFF\Analysis"
global NEFF_root "V:\Projects\NEFF\Analysis"
global code "${NEFF_root}/Code"
global raw "${NEFF_root}/Data/raw" 
global derived "${NEFF_root}/Data/derived"
global tables "${NEFF_root}/Tables"
global figures "${NEFF_root}/Figures"
global Scratch "V:\Projects\NEFF\Analysis\Scratch"


/*==============================================================================
							CREATE PANEL 
===============================================================================*/

use "$derived/phase1_data.dta", clear
append using "$derived/phase2_data.dta"
encode enterprise_id, gen(enterprise_id_num)
sort enterprise_id_num survey_round
xtset enterprise_id_num survey_round

xtdes

gen treat_ent_r1 = (treat_ent == 1) * (survey_round == 1)
gen treat_ent_r2 = (treat_ent == 1) * (survey_round == 2)

gen treat_vill_r1 = (neff_vill == 1) * (survey_round == 1)
gen treat_vill_r2 = (neff_vill == 1) * (survey_round == 2)

label var treat_ent_r1 "Enterprise treatment effect in Round 1"
label var treat_ent_r2 "Enterprise treatment effect in Round 2"
label var treat_vill_r1 "Village treatment effect in Round 1"
label var treat_vill_r2 "Village treatment effect in Round 2"


xtreg marketing_score treat_ent_r1 treat_ent_r2 i.survey_round, fe 
zscore marketing_score record_keeping_score 





foreach var in z_marketing_score z_record_keeping_score bp_score {
    xtreg `var' treat_ent_r1 treat_ent_r2 , fe vce(cluster enterprise_id_num)
}

foreach var in marketing_score z_record_keeping_score bp_score {
    xtreg `var' treat_ent i.survey_round, fe vce(cluster enterprise_id_num)
}


foreach var in sec17_q1_a sec17_q1_c sec17_q1_d sec17_q1_e sec17_q1_f {
    xtreg `var' treat_ent i.survey_round, fe vce(cluster enterprise_id_num)
}





eststo clear
local i=1
foreach var in z_marketing_score z_record_keeping_score credit_mgmt_index bp_score {
    xtreg `var' treat_ent_r1 treat_ent_r2 i.survey_round, fe vce(cluster enterprise_id_num)
    
    test treat_ent_r1 treat_ent_r2
    estadd scalar pval_joint=r(p)
    
    test treat_ent_r2 = treat_ent_r1
    estadd scalar pval_diff=r(p)
    
    estadd local enterprise_fe "YES"
    estadd local round_fe "YES"
    estadd local clustering "Enterprise"
    
    sum `var' if e(sample) & treat_ent==0
    estadd scalar mean_control=r(mean)
    
    eststo panelA_`i'
    local i=`i'+1
}
local i=1
foreach var in z_marketing_score z_record_keeping_score credit_mgmt_index bp_score {
    xtreg `var' treat_vill_r1 treat_vill_r2 i.survey_round, fe vce(cluster enterprise_id_num)
    
    test treat_vill_r1 treat_vill_r2
    estadd scalar pval_joint=r(p)
    
    test treat_vill_r2 = treat_vill_r1
    estadd scalar pval_diff=r(p)
    
    estadd local enterprise_fe "YES"
    estadd local round_fe "YES"
    estadd local clustering "Enterprise"
    
    sum `var' if e(sample) & neff_vill==0
    estadd scalar mean_control=r(mean)
    
    eststo panelB_`i'
    local i=`i'+1
}

// Panel A: Enterprise Treatment Effects
#delimit ;
esttab panelA_1 panelA_2 panelA_3 panelA_4 using "$Scratch/business_practices_four_panel.rtf", 
    replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent_r1 treat_ent_r2 2.survey_round) ///
    order(treat_ent_r1 treat_ent_r2 2.survey_round) ///
    posthead("Panel A: Enterprise Treatment Effects") ///
    stats(N mean_control pval_joint pval_diff enterprise_fe round_fe clustering, 
          fmt(%9.0g %9.3f %9.3f %9.3f %s %s %s) 
          labels("Observations" "Control Mean" "Joint P-value" "ST vs LT P-value" "Enterprise FE" "Round FE" "SE Clustering")) ///
    mtitles("Marketing (z)" "Record Keeping (z)" "Credit Management Index" "Business Practices") ///
    title("Table X: Short-term and Long-term Effects of NEFF Program on Business Practices") ///
    addnotes("Standard errors clustered at the enterprise level" 
             "treat_ent_r1: Short-term effects (Round 1 post-treatment)"
             "treat_ent_r2: Long-term effects (Round 2 post-treatment)"
             "Credit Management Index = sum of standardized credit %, credit terms + written records + creditworthiness assessment") ;
#delimit cr

// Panel B: Village Treatment Effects 
#delimit ;
esttab panelB_1 panelB_2 panelB_3 panelB_4 using "$Scratch/business_practices_four_panel.rtf", 
    append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_vill_r1 treat_vill_r2 2.survey_round) ///
    order(treat_vill_r1 treat_vill_r2 2.survey_round) ///
    posthead("Panel B: Village Treatment Effects") ///
    stats(N mean_control pval_joint pval_diff enterprise_fe round_fe clustering, 
          fmt(%9.0g %9.3f %9.3f %9.3f %s %s %s) 
          labels("Observations" "Control Mean" "Joint P-value" "ST vs LT P-value" "Enterprise FE" "Round FE" "SE Clustering")) ///
    mtitles("Marketing (z)" "Record Keeping (z)" "Credit Management Index" "Business Practices") ///
    addnotes("Standard errors clustered at the enterprise level"
             "treat_vill_r1: Short-term village effects (Round 1 post-treatment)"
             "treat_vill_r2: Long-term village effects (Round 2 post-treatment)"
             "ST vs LT P-value tests if long-term effects differ from short-term effects"
             "Z-score variables are standardized with mean 0 and standard deviation 1"
             "Credit Management Index includes: credit sales %, credit terms, written debt records, creditworthiness assessment") ;
#delimit cr




//sec8_q1 count_loan w10_tot_unpaid_loan avg_int_rate  
/*==============================================================================
									Loan
===============================================================================*/

gen log_w10_tot_unpaid_loan = (w10_tot_unpaid_loan) 
gen log_w1_avg_int_rate = (w1_avg_int_rate) 

local loan_vars "sec8_q1 count_loan log_w10_tot_unpaid_loan log_w1_avg_int_rate"

foreach var in `loan_vars' {
    xtreg `var' treat_ent_r1 treat_ent_r2 i.survey_round, fe vce(cluster panchayat_id)
    xtreg `var' treat_vill_r1 treat_vill_r2 i.survey_round, fe vce(cluster panchayat_id)
}



eststo clear
local i=1

// Panel A: Enterprise Treatment Effects
foreach var in sec8_q1 count_loan log_w10_tot_unpaid_loan log_w1_avg_int_rate {
    xtreg `var' treat_ent_r1 treat_ent_r2 i.survey_round, fe 
    
    test treat_ent_r1 treat_ent_r2
    estadd scalar pval_joint=r(p)
    
    test treat_ent_r2 = treat_ent_r1
    estadd scalar pval_diff=r(p)
    
    estadd local enterprise_fe "YES"
    estadd local round_fe "YES"
    
    sum `var' if e(sample) & treat_ent==0
    estadd scalar mean_control=r(mean)
    
    eststo credit_ent_`i'
    local i=`i'+1
}


// Panel B: Village Treatment Effects
local i=1
foreach var in sec8_q1 count_loan log_w10_tot_unpaid_loan log_w1_avg_int_rate {
    xtreg `var' treat_vill_r1 treat_vill_r2 i.survey_round, fe 
    
    test treat_vill_r1 treat_vill_r2
    estadd scalar pval_joint=r(p)
    
    test treat_vill_r2 = treat_vill_r1
    estadd scalar pval_diff=r(p)
    
    estadd local enterprise_fe "YES"
    estadd local round_fe "YES"
    
    sum `var' if e(sample) & neff_vill==0
    estadd scalar mean_control=r(mean)
    
    eststo credit_vill_`i'
    local i=`i'+1
}

// Panel A: Enterprise Treatment Effects
#delimit ;
esttab credit_ent_1 credit_ent_2 credit_ent_3 credit_ent_4 using "$Scratch/credit_analysis.rtf", 
    replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent_r1 treat_ent_r2 2.survey_round) ///
    order(treat_ent_r1 treat_ent_r2 2.survey_round) ///
    posthead("Panel A: Enterprise Treatment Effects") ///
    stats(N mean_control pval_joint pval_diff enterprise_fe round_fe clustering, 
          fmt(%9.0g %9.3f %9.3f %9.3f %s %s %s) 
          labels("Observations" "Control Mean" "Joint P-value" "ST vs LT P-value" "Enterprise FE" "Round FE" )) ///
    mtitles("Any Loan" "Loan Count" "Indebtedness" "Interest Rate") ///
    title("Table X: NEFF Effects on Credit Access and Loan Management") ///
    addnotes("Unpaid loan amounts winsorized at 10th percentile") ;
#delimit cr

// Panel B: Village Treatment Effects (append)
#delimit ;
esttab credit_vill_1 credit_vill_2 credit_vill_3 credit_vill_4 using "$Scratch/credit_analysis.rtf", 
    append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_vill_r1 treat_vill_r2 2.survey_round) ///
    order(treat_vill_r1 treat_vill_r2 2.survey_round) ///
    posthead("Panel B: Village Treatment Effects") ///
    stats(N mean_control pval_joint pval_diff enterprise_fe round_fe clustering, 
          fmt(%9.0g %9.3f %9.3f %9.3f %s %s %s) 
          labels("Observations" "Control Mean" "Joint P-value" "ST vs LT P-value" "Enterprise FE" "Round FE" )) ///
    mtitles("Any Loan" "Loan Count" "Indebtedness" "Interest Rate") ///
    addnotes("treat_vill_r1: Short-term village effects (Round 1 post-treatment)"
             "treat_vill_r2: Long-term village effects (Round 2 post-treatment)") ;
#delimit cr



/*==============================================================================
									Suppliers Relation
===============================================================================*/




eststo clear
local i=1
foreach var in supplier_relation {
xtreg `var' treat_ent_r1 treat_ent_r2 i.survey_round, fe vce(cluster enterprise_id_num)
    
    test treat_ent_r1 treat_ent_r2
    estadd scalar pval_joint=r(p)
    
    test treat_ent_r2 = treat_ent_r1
    estadd scalar pval_diff=r(p)
    
    estadd local enterprise_fe "YES"
    estadd local round_fe "YES"
    estadd local clustering "Enterprise"
    
    sum `var' if e(sample) & treat_ent==0
    estadd scalar mean_control=r(mean)
    
    eststo panelA_`i'
    local i=`i'+1
}
local i=1
foreach var in supplier_relation {
    xtreg `var' treat_vill_r1 treat_vill_r2 i.survey_round, fe vce(cluster enterprise_id_num)
    
    test treat_vill_r1 treat_vill_r2
    estadd scalar pval_joint=r(p)
    
    test treat_vill_r2 = treat_vill_r1
    estadd scalar pval_diff=r(p)
    
    estadd local enterprise_fe "YES"
    estadd local round_fe "YES"
    estadd local clustering "Enterprise"
    
    sum `var' if e(sample) & neff_vill==0
    estadd scalar mean_control=r(mean)
    
    eststo panelB_`i'
    local i=`i'+1
}

// Panel A: Enterprise Treatment Effects
#delimit ;
esttab panelA_1 using "$Scratch/supplier_relation.rtf", 
    replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent_r1 treat_ent_r2 2.survey_round) ///
    order(treat_ent_r1 treat_ent_r2 2.survey_round) ///
    posthead("Panel A: Enterprise Treatment Effects") ///
    stats(N mean_control pval_joint pval_diff enterprise_fe round_fe clustering, 
          fmt(%9.0g %9.3f %9.3f %9.3f %s %s %s) 
          labels("Observations" "Control Mean" "Joint P-value" "ST vs LT P-value" "Enterprise FE" "Round FE" "SE Clustering")) ///
    mtitles("Supplier Relation") ///
    title("Table X: Short-term and Long-term Effects of NEFF Program on Suppliers Relation") ///
    addnotes("Standard errors clustered at the enterprise level" 
             "treat_ent_r1: Short-term effects (Round 1 post-treatment)"
             "treat_ent_r2: Long-term effects (Round 2 post-treatment)") ;
#delimit cr

// Panel B: Village Treatment Effects 
#delimit ;
esttab panelB_1 using "$Scratch/supplier_relation.rtf", 
    append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_vill_r1 treat_vill_r2 2.survey_round) ///
    order(treat_vill_r1 treat_vill_r2 2.survey_round) ///
    posthead("Panel B: Village Treatment Effects") ///
    stats(N mean_control pval_joint pval_diff enterprise_fe round_fe clustering, 
          fmt(%9.0g %9.3f %9.3f %9.3f %s %s %s) 
          labels("Observations" "Control Mean" "Joint P-value" "ST vs LT P-value" "Enterprise FE" "Round FE" "SE Clustering")) ///
    mtitles("Supplier Relation") ///
    addnotes("Standard errors clustered at the enterprise level"
             "treat_vill_r1: Short-term village effects (Round 1 post-treatment)"
             "treat_vill_r2: Long-term village effects (Round 2 post-treatment)") ;
#delimit cr






