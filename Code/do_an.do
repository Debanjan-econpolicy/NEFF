

/*==============================================================================
                        PREPARE PHASE 1 DATA  
===============================================================================*/

clear all
cd "V:\Projects\NEFF\Analysis"
global NEFF_root "V:\Projects\NEFF\Analysis"
global code "${NEFF_root}/Code"
global raw "${NEFF_root}/Data/raw" 
global derived "${NEFF_root}/Data/derived"
global tables "${NEFF_root}/Tables"
global figures "${NEFF_root}/Figures"
global Scratch "V:\Projects\NEFF\Analysis\Scratch"



use "$derived/NEFF_phase_1_full.dta", clear

* Keep core variables needed for panel analysis
keep enterprise_id enterprise panchayat_id panchayat block_id block district district_id  	///
		neff_vill treat_ent neff_cap_ent survey_round  sec1_q4  sec1_q3  sec1_q2  sec1_q1 	///
		e_age age_entrepreneur marriage_age education_yrs f_ent  				///
		udyam_registration single_owner sec3_q6 ent_location_*	ent_running			///
     /// Financial outcomes
     w5_revenue_1 w5_revenue_2 w5_revenue_3 revenue_1 revenue_2 revenue_3 ///
     w5_ecost_1 w5_ecost_2 w5_ecost_3 ecost_1 ecost_2 ecost_3 ///
     w5_profit_1 w5_profit_2 w5_profit_3 profit_1 profit_2 profit_3 ///
     w10_rec_profit rec_profit ///
     /// Investment outcomes  
     w10_invest_1 w10_invest_2 w10_invest_3 invest_1 invest_2 invest_3 ///
     count_investment_1 count_investment_2 count_investment_3 ///
     wc_invest_1 wc_invest_2 wc_invest_3 ac_invest_1 ac_invest_2 ac_invest_3 ///
     dr_invest_1 dr_invest_2 dr_invest_3 ///
     count_wc_invest_1 count_wc_invest_2 count_wc_invest_3 ///
     count_ac_invest_1 count_ac_invest_2 count_ac_invest_3 ///
     count_dr_invest_1 count_dr_invest_2 count_dr_invest_3 ///
     /// Credit outcomes
     count_loan total_loan_received total_loan_applied active_loan ///
     w10_tot_unpaid_loan tot_unpaid_loan formal_loan_source bank_loan_source ///
     w1_avg_int_rate avg_int_rate sec8_q1 ///
     /// Business practices
     marketing_score record_keeping_score bp_score bps bps_1 ///
     supplier_relation ///
     /// Assets  
     w10_asset_value asset_value owned_asset_value percieved_asset_value monthly_asset_value ///
     /// Digital and financial inclusion
     sec17_q16 sec19_q1  ///
     /// Enterprise characteristics
     e_age f_ent education_yrs udyam_registration single_owner ///
     age_entrepreneur marriage_age sec2_q5 sec3_q2 sec3_q2_a sec4_q4 ///
     /// Household characteristics
      w10_hh_income w10_hh_cost hh_profit  ///
     /// Treatment variables
     treat_ent sec12_q6 sec12_q1 credit_mgmt_index supplier_relation

* COST VARIABLES
clonevar ecost_2022 = ecost_3 
clonevar ecost_2023 = ecost_2 
clonevar ecost_jun2023_jan2024 = ecost_1
clonevar w5_ecost_2022 = w5_ecost_3 
clonevar w5_ecost_2023 = w5_ecost_2 
clonevar w5_ecost_jun2023_jan2024 = w5_ecost_1

* REVENUE VARIABLES  
clonevar revenue_2022 = revenue_3
clonevar revenue_2023 = revenue_2
clonevar revenue_jun2023_jan2024 = revenue_1
clonevar w5_revenue_2022 = w5_revenue_3 
clonevar w5_revenue_2023 = w5_revenue_2 
clonevar w5_revenue_jun2023_jan2024 = w5_revenue_1	 
	 
* PROFIT VARIABLES
clonevar profit_2022 = profit_3
clonevar profit_2023 = profit_2
clonevar profit_jun2023_jan2024 = profit_1
clonevar w5_profit_2022 = w5_profit_3
clonevar w5_profit_2023 = w5_profit_2
clonevar w5_profit_jun2023_jan2024 = w5_profit_1

* INVESTMENT VARIABLES
clonevar invest_2022 = invest_3
clonevar invest_2023 = invest_2
clonevar invest_jun2023_jan2024 = invest_1
clonevar w10_invest_2022 = w10_invest_3
clonevar w10_invest_2023 = w10_invest_2
clonevar w10_invest_jun2023_jan2024 = w10_invest_1

* INVESTMENT COMPOSITION VARIABLES
clonevar count_investment_2022 = count_investment_3
clonevar count_investment_2023 = count_investment_2
clonevar count_investment_jun2023_jan2024 = count_investment_1

clonevar wc_invest_2022 = wc_invest_3
clonevar wc_invest_2023 = wc_invest_2
clonevar wc_invest_jun2023_jan2024 = wc_invest_1

clonevar ac_invest_2022 = ac_invest_3
clonevar ac_invest_2023 = ac_invest_2
clonevar ac_invest_jun2023_jan2024 = ac_invest_1

clonevar dr_invest_2022 = dr_invest_3
clonevar dr_invest_2023 = dr_invest_2
clonevar dr_invest_jun2023_jan2024 = dr_invest_1

clonevar count_wc_invest_2022 = count_wc_invest_3
clonevar count_wc_invest_2023 = count_wc_invest_2
clonevar count_wc_invest_jun2023_jan2024 = count_wc_invest_1

clonevar count_ac_invest_2022 = count_ac_invest_3
clonevar count_ac_invest_2023 = count_ac_invest_2
clonevar count_ac_invest_jun2023_jan2024 = count_ac_invest_1

clonevar count_dr_invest_2022 = count_dr_invest_3
clonevar count_dr_invest_2023 = count_dr_invest_2
clonevar count_dr_invest_jun2023_jan2024 = count_dr_invest_1	 
	


save  "$derived/phase1_data.dta", replace










/*==============================================================================
                        PREPARE PHASE 2 DATA  
===============================================================================*/

use "$derived/NEFF_phase_2_full.dta", clear

* Ensure exact same variable structure as Phase 1
* Create missing variables that exist in Phase 1 but not Phase 2

* Revenue variables - Phase 2 has different time structure
* Keep the existing revenue_1, revenue_2 but create revenue_3 as missing
capture gen revenue_3 = .
capture gen w5_revenue_3 = .
capture label var revenue_3 "Not applicable in Phase 2"
capture label var w5_revenue_3 "Not applicable in Phase 2"

* Cost variables
capture gen ecost_3 = .
capture gen w5_ecost_3 = .
capture label var ecost_3 "Not applicable in Phase 2"
capture label var w5_ecost_3 "Not applicable in Phase 2"

* Profit variables  
capture gen profit_3 = .
capture gen w5_profit_3 = .
capture label var profit_3 "Not applicable in Phase 2"
capture label var w5_profit_3 "Not applicable in Phase 2"

* Investment variables
capture gen invest_3 = .
capture gen w10_invest_3 = .
capture gen count_investment_3 = .
capture gen wc_invest_3 = .
capture gen ac_invest_3 = .
capture gen dr_invest_3 = .
capture gen count_wc_invest_3 = .
capture gen count_ac_invest_3 = .
capture gen count_dr_invest_3 = .

* Label the missing investment variables
capture label var invest_3 "Not applicable in Phase 2"
capture label var w10_invest_3 "Not applicable in Phase 2"
capture label var count_investment_3 "Not applicable in Phase 2"
capture label var wc_invest_3 "Not applicable in Phase 2"
capture label var ac_invest_3 "Not applicable in Phase 2"
capture label var dr_invest_3 "Not applicable in Phase 2"
capture label var count_wc_invest_3 "Not applicable in Phase 2"
capture label var count_ac_invest_3 "Not applicable in Phase 2"
capture label var count_dr_invest_3 "Not applicable in Phase 2"



* Keep same variables as Phase 1 in the EXACT same order
keep enterprise_id enterprise panchayat_id panchayat block_id block district district_id  ///
		neff_vill treat_ent neff_cap_ent survey_round  sec1_q4  sec1_q3  sec1_q2  sec1_q1 	///
		e_age age_entrepreneur marriage_age education_yrs f_ent  				///
		udyam_registration single_owner sec3_q6 ent_location_*	ent_running				///
     /// Financial outcomes
     w5_revenue_1 w5_revenue_2 w5_revenue_3 revenue_1 revenue_2 revenue_3 ///
     w5_ecost_1 w5_ecost_2 w5_ecost_3 ecost_1 ecost_2 ecost_3 ///
     w5_profit_1 w5_profit_2 w5_profit_3 profit_1 profit_2 profit_3 ///
     w10_rec_profit rec_profit ///
     /// Investment outcomes  
     w10_invest_1 w10_invest_2 w10_invest_3 invest_1 invest_2 invest_3 ///
     count_investment_1 count_investment_2 count_investment_3 ///
     wc_invest_1 wc_invest_2 wc_invest_3 ac_invest_1 ac_invest_2 ac_invest_3 ///
     dr_invest_1 dr_invest_2 dr_invest_3 ///
     count_wc_invest_1 count_wc_invest_2 count_wc_invest_3 ///
     count_ac_invest_1 count_ac_invest_2 count_ac_invest_3 ///
     count_dr_invest_1 count_dr_invest_2 count_dr_invest_3 ///
     /// Credit outcomes
     count_loan total_loan_received total_loan_applied active_loan ///
     w10_tot_unpaid_loan tot_unpaid_loan formal_loan_source bank_loan_source ///
     w1_avg_int_rate avg_int_rate sec8_q1   ///
     /// Business practices
     marketing_score record_keeping_score bp_score bps bps_1 ///
     supplier_relation ///
     /// Assets  
     w10_asset_value asset_value owned_asset_value percieved_asset_value monthly_asset_value ///
     /// Digital and financial inclusion
     sec17_q16 sec19_q1 ///
     /// Enterprise characteristics (duplicated - clean this up)
     sec2_q5 sec3_q2 sec3_q2_a sec4_q4 ///
     /// Household characteristics
      w10_hh_income w10_hh_cost hh_profit sec12_q6 sec12_q1 credit_mgmt_index ///	
	  supplier_relation
	  
	  
	  
      
* COST VARIABLES (Phase 2: _2=2024, _1=Jan-Mar 2025)
clonevar ecost_2024 = ecost_2
clonevar ecost_jan_mar2025 = ecost_1
clonevar w5_ecost_2024 = w5_ecost_2
clonevar w5_ecost_jan_mar2025 = w5_ecost_1

* REVENUE VARIABLES (Phase 2: _2=2024, _1=2025 estimation)  
clonevar revenue_2024 = revenue_2
clonevar revenue_2025_estimation = revenue_1
clonevar w5_revenue_2024 = w5_revenue_2
clonevar w5_revenue_2025_estimation = w5_revenue_1

* PROFIT VARIABLES (Phase 2: _2=2024, _1=2025 estimation)
clonevar profit_2024 = profit_2
clonevar profit_2025_estimation = profit_1
clonevar w5_profit_2024 = w5_profit_2
clonevar w5_profit_2025_estimation = w5_profit_1

* INVESTMENT VARIABLES (Phase 2: _2=2024, _1=Jan-Mar 2025)
clonevar invest_2024 = invest_2
clonevar invest_jan_mar2025 = invest_1
clonevar w10_invest_2024 = w10_invest_2
clonevar w10_invest_jan_mar2025 = w10_invest_1
* INVESTMENT COMPOSITION VARIABLES
clonevar count_investment_2024 = count_investment_2
clonevar count_investment_jan_mar2025 = count_investment_1

clonevar wc_invest_2024 = wc_invest_2
clonevar wc_invest_jan_mar2025 = wc_invest_1

clonevar ac_invest_2024 = ac_invest_2
clonevar ac_invest_jan_mar2025 = ac_invest_1

clonevar dr_invest_2024 = dr_invest_2
clonevar dr_invest_jan_mar2025 = dr_invest_1

clonevar count_wc_invest_2024 = count_wc_invest_2
clonevar count_wc_invest_jan_mar2025 = count_wc_invest_1

clonevar count_ac_invest_2024 = count_ac_invest_2
clonevar count_ac_invest_jan_mar2025 = count_ac_invest_1
clonevar count_dr_invest_2024 = count_dr_invest_2
clonevar count_dr_invest_jan_mar2025 = count_dr_invest_1



save "$derived/phase2_data.dta", replace






/*==============================================================================
                        CREATE PANEL DATASET
===============================================================================*/

use "$derived/phase1_data.dta", clear
merge 1:1 enterprise_id using "$derived/phase2_data.dta", gen(panel_merge)
/*
append using "$derived/phase2_data.dta"
sort enterprise_id survey_round
order enterprise_id survey_round
*/
keep if panel_merge == 3 

reshape long ecost_ w5_ecost_ revenue_ w5_revenue_ profit_ w5_profit_ invest_ w10_invest_ 			///
		count_investment_ wc_invest_ ac_invest_ dr_invest_ count_wc_invest_ count_ac_invest_ 		///
		count_dr_invest_, i(enterprise_id) j(year)	
keep if inlist(year, 2022, 2023, 2024)
keep if ent_running == 1
encode enterprise_id, gen(enterprise_id_num)
xtset enterprise_id_num year
	
rename 	ecost_ ecost
rename w5_ecost_ w5_ecost
rename revenue_ revenue
rename w5_revenue_ w5_revenue
rename profit_ profit
rename w5_profit_ w5_profit

rename invest_ invest
la var invest "Total Investment"

rename w10_invest_ w10_invest
la var w10_invest "Total Investment (w10)"


rename count_investment_ count_investment
la var count_investment "Number of Investment"

rename wc_invest_ wc_invest
la var wc_invest "Proportion of total invested in working capital"

rename ac_invest_ ac_invest
la var ac_invest "Proportion of total invested in asset creation"

rename dr_invest_ dr_invest
la var dr_invest "Proportion of total invested in debt reduction"

rename count_wc_invest_ count_wc_invest
la var count_wc_invest "People(#) invested in working capital"

rename count_ac_invest_ count_ac_invest
la var count_ac_invest "People(#) invested in asset creation"

rename count_dr_invest_ count_dr_invest
la var count_dr_invest "People(#) invested in debt reduction"

forval i = 2022/2024 {
		distinct enterprise_id_num if year ==	`i'
	}



* NEFF was implemented in 2023, so the post-treatment period is 2024
gen post = (year >= 2024)  // Post-treatment period
label var post "Post-NEFF Period (2024)"

gen did_neff_vill = neff_vill * post
label var did_neff_vill "DiD: NEFF Village × Post"

gen did_treat_ent = treat_ent * post
label var did_treat_ent "DiD: NEFF Enterprise × Post"

		
		
		
winsor2 profit, cuts(1 99) suffix(_w1)	
winsor2 ecost , cuts(1 99) suffix(_w1) 	
winsor2 revenue , cuts(1 99) suffix(_w1) 	

didregress (profit_w1) (did_neff_vill), group(enterprise_id_num) time(year)	
didregress (ecost_w1) (did_treat_ent), group(enterprise_id_num) time(year)	
didregress (revenue_w1) (did_treat_ent), group(enterprise_id_num) time(year)	
			
		


xtdidregress (profit_w1) (did_treat_ent), group(enterprise_id_num) time(year) 
xtdidregress (revenue_w1) (did_treat_ent), group(enterprise_id_num) time(year)		
xtdidregress (ecost_w1) (did_neff_vill), group(enterprise_id_num) time(year)		
		
		
foreach var in ecost_w1 revenue_w1 profit_w1 {
	gen log_`var' = log(`var'+1)
}		
		
zscore ecost_w1 revenue_w1 profit_w1		
		
foreach var in ecost_w1 revenue_w1 profit_w1 {
	gen ihs_`var' = asinh(`var')
}		
		
didregress (z_revenue_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
estat trendplots 
estat grangerplot 

didregress (z_ecost_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq	
didregress (z_profit_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
		
		

		

didregress (z_profit_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
eststo profit

didregress (z_ecost_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
eststo cost

didregress (z_revenue_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
eststo revenue

etable, estimates(profit cost revenue) ///
    mstat(N) ///
    stars(.10 "*" .05 "**" .01 "***") ///
    showstars showstarsnote ///
    title("Impact of NEFF Program on Enterprise Performance") ///
    note("Standard errors clustered at the enterprise level") ///
    note("All outcomes are standardized variables (mean=0, sd=1)") ///
    export("$Scratch/NEFF_RCP.docx", replace)



	
	

		

didregress (z_profit_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
eststo profit

didregress (z_ecost_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
eststo cost

didregress (z_revenue_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq
eststo revenue


// If you want to show all coefficients (like etable default)
esttab profit cost revenue using "$Scratch/reg_esttab_full.rtf", replace ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    mtitles("Profit" "Cost" "Revenue") ///
    title("Impact of NEFF Program on Enterprise Performance") ///
    addnotes("Standard errors clustered at the enterprise level" ///
             "All outcomes are standardized variables (mean=0, sd=1)") ///
    stats(N, fmt(0) labels("Observations"))
	
	

		

		
		
		
		
		
		

eststo clear

local i=1
foreach outcome in z_profit_w1 z_ecost_w1 z_revenue_w1 {
    didregress (`outcome') (did_treat_ent), group(enterprise_id_num) time(year) aeq
    
    estadd local treatment_FE "Yes"
    estadd local time_FE "Yes"
    estadd local cov "No"
    estadd local clustering "Enterprise"
    sum `outcome' if e(sample) & treat_ent==0 & year==2023
    estadd scalar mean_control_2023=r(mean)
    
    sum `outcome' if e(sample) & treat_ent==0 & year==2024
    estadd scalar mean_control_2024=r(mean)
    
    eststo did_table_`i'
    local i=`i'+1
}

#delimit ;
esttab did_table_1 did_table_2 did_table_3 using "$Scratch/NEFF_RCP.rtf", 
    replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(*did_treat_ent* *year*) ///
    order(*did_treat_ent* *year*) ///
    stats(N mean_control_2023 mean_control_2024 treatment_FE time_FE cov clustering, 
          fmt(%9.0g %9.3f %9.3f %s %s %s %s) 
          labels("Observations" "Control Mean (2023)" "Control Mean (2024)" "Treatment FE" "Time FE" "Covariates" "SE Clustering")) ///
    mtitles("Profit (z)" "Cost (z)" "Revenue (z)") ///
    title("Table X: Impact of NEFF Program on Enterprise Performance") ///
    addnotes("Standard errors clustered at the enterprise level" 
             "All outcomes are standardized variables") ;
#delimit cr


		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		


didregress (z_revenue_w1) (did_treat_ent), group(enterprise_id_num) time(year) aeq

estat trendplots, ///
    omeans(lcolor(navy) lwidth(thick) msymbol(circle) msize(large) mcolor(navy)) ///
    ltrends(lcolor(maroon) lwidth(thick) msymbol(square) msize(large) mcolor(maroon)) ///
    line1opts(lcolor(navy) lwidth(thick) lpattern(solid)) ///
    line2opts(lcolor(cranberry) lwidth(thick) lpattern(solid)) ///
    title("Parallel Trends Analysis: Revenue", size(large) color(black)) ///
    subtitle("NEFF Program Impact", size(medlarge) color(gs6)) ///
    xtitle("Year", size(medlarge)) ///
    ytitle("Standardized Revenue", size(medlarge)) ///
    xlabel(2022 "2022" 2023 "2023" 2024 "2024", labsize(medium)) ///
    ylabel(, labsize(medium) format(%9.2f)) ///
    legend(order(1 "Control Group" 2 "Treatment Group") ///
           position(6) cols(2) size(medium) ///
           region(lcolor(white) fcolor(white))) ///
    graphregion(color(white) fcolor(white)) ///
    plotregion(color(white) fcolor(white)) ///
    scheme(s1color)

graph export "$Scratch/parallel_trends_revenue.png", replace width(1200) height(800)
graph export "$Scratch/parallel_trends_revenue.eps", replace
graph save "$Scratch/parallel_trends_revenue.gph", replace

estat grangerplot, ///
    mcolor(navy) msymbol(circle) msize(large) ///
    lcolor(navy) lwidth(thick) ///
    ciopts(lcolor(gs8) lwidth(medium)) ///
    title("Dynamic Treatment Effects: Revenue", size(large) color(black)) ///
    subtitle("NEFF Program Impact Over Time", size(medlarge) color(gs6)) ///
    xtitle("Time Relative to Treatment", size(medlarge)) ///
    ytitle("Treatment Effect (Standard Deviations)", size(medlarge)) ///
    xlabel(, labsize(medium)) ///
    ylabel(, labsize(medium) format(%9.2f)) ///
    legend(off) ///
    graphregion(color(white) fcolor(white)) ///
    plotregion(color(white) fcolor(white)) ///
    scheme(s1color)

// Save the graph
graph export "$Scratch/granger_plot_revenue.png", replace width(1200) height(800)
graph export "$Scratch/granger_plot_revenue.eps", replace
graph save "$Scratch/granger_plot_revenue.gph", replace

/*==============================================================================
                    3. ALL THREE OUTCOMES - PARALLEL TRENDS
===============================================================================*/

foreach outcome in z_revenue_w1 z_ecost_w1 z_profit_w1 {
    
    local title_name ""
    if "`outcome'" == "z_revenue_w1" local title_name "Revenue"
    if "`outcome'" == "z_ecost_w1" local title_name "Cost" 
    if "`outcome'" == "z_profit_w1" local title_name "Profit"
    
    didregress (`outcome') (did_treat_ent), group(enterprise_id_num) time(year) aeq
    
    estat trendplots, ///
        omeans(lcolor(navy) lwidth(thick) msymbol(circle) msize(large) mcolor(navy)) ///
        ltrends(lcolor(maroon) lwidth(thick) msymbol(square) msize(large) mcolor(maroon)) ///
        line1opts(lcolor(navy) lwidth(thick) lpattern(solid)) ///
        line2opts(lcolor(cranberry) lwidth(thick) lpattern(solid)) ///
        title("Parallel Trends: `title_name'", size(large) color(black)) ///
        subtitle("NEFF Program Analysis", size(medlarge) color(gs6)) ///
        xtitle("Year", size(medlarge)) ///
        ytitle("Standardized `title_name'", size(medlarge)) ///
        xlabel(2022 "2022" 2023 "2023" 2024 "2024", labsize(medium)) ///
        ylabel(, labsize(medium) format(%9.2f)) ///
        legend(order(1 "Control Group" 2 "Treatment Group") ///
               position(6) cols(2) size(medium) ///
               region(lcolor(white) fcolor(white))) ///
        graphregion(color(white) fcolor(white)) ///
        plotregion(color(white) fcolor(white)) ///
        scheme(s1color)
    
    graph export "$Scratch/parallel_trends_`outcome'.png", replace width(1200) height(800)
    graph save "$Scratch/parallel_trends_`outcome'.gph", replace
}

foreach outcome in z_revenue_w1 z_ecost_w1 z_profit_w1 {
    
    local title_name ""
    if "`outcome'" == "z_revenue_w1" local title_name "Revenue"
    if "`outcome'" == "z_ecost_w1" local title_name "Cost" 
    if "`outcome'" == "z_profit_w1" local title_name "Profit"
    
    didregress (`outcome') (did_treat_ent), group(enterprise_id_num) time(year) aeq
    
    estat grangerplot, ///
        mcolor(navy) msymbol(circle) msize(large) ///
        lcolor(navy) lwidth(thick) ///
        ciopts(lcolor(gs8) lwidth(medium)) ///
        title("Dynamic Effects: `title_name'", size(medium) color(black)) ///
        xtitle("Time Relative to Treatment", size(small)) ///
        ytitle("Treatment Effect (Std. Dev.)", size(small)) ///
        xlabel(, labsize(medium)) ///
        ylabel(, labsize(medium) format(%9.2f)) ///
        legend(off) ///
        graphregion(color(white) fcolor(white)) ///
        plotregion(color(white) fcolor(white)) ///
        scheme(s1color)
    
    graph export "$Scratch/granger_plot_`outcome'.png", replace width(1200) height(800)
    graph save "$Scratch/granger_plot_`outcome'.gph", replace
}
graph combine ///
    "$Scratch/parallel_trends_z_profit_w1.gph" ///
    "$Scratch/parallel_trends_z_ecost_w1.gph" ///
    "$Scratch/parallel_trends_z_revenue_w1.gph", ///
    title("Parallel Trends Analysis: All Outcomes", size(large) color(black)) ///
    subtitle("NEFF Program Impact Assessment", size(medlarge) color(gs6)) ///
    rows(2) cols(2) ///
    iscale(0.8) ///
    graphregion(color(white) fcolor(white)) ///
    scheme(s1color)

graph export "$Scratch/parallel_trends_combined.png", replace width(1600) height(1200)
graph save "$Scratch/parallel_trends_combined.gph", replace

// Combine all Granger plots
graph combine ///
    "$Scratch/granger_plot_z_profit_w1.gph" ///
    "$Scratch/granger_plot_z_ecost_w1.gph" ///
    "$Scratch/granger_plot_z_revenue_w1.gph", ///
    rows(2) cols(2) ///
    iscale(0.8) ///
    graphregion(color(white) fcolor(white)) ///
    scheme(s1color)

graph export "$Scratch/granger_combined.png", replace width(1600) height(1200)
graph save "$Scratch/granger_combined.gph", replace




/*==============================================================================
									Investment
===============================================================================*/



winsor2 invest, cuts(1 99) suffix(_w1)
zscore invest_w1

foreach outcome in z_invest_w1 count_investment wc_invest ac_invest count_ac_invest  count_dr_invest {
    didregress (`outcome') (did_treat_ent), group(enterprise_id_num) time(year) aeq  
}


// Clear stored estimates
eststo clear

// Run regressions for all investment outcomes
local i=1
foreach outcome in z_invest_w1 count_investment wc_invest ac_invest count_ac_invest count_dr_invest {
    didregress (`outcome') (did_treat_ent), group(enterprise_id_num) time(year) aeq
    
    // Add metadata about the estimation
    estadd local Enterprise_FE "Yes"
    estadd local time_FE "Yes"
    estadd local cov "No"
    estadd local clustering "Enterprise"
    
    // Calculate control group means for 2023 and 2024
    sum `outcome' if e(sample) & treat_ent==0 & year==2023
    estadd scalar mean_control_2023=r(mean)
    
    sum `outcome' if e(sample) & treat_ent==0 & year==2024
    estadd scalar mean_control_2024=r(mean)
    
    // Store the estimate
    eststo invest_table_`i'
    local i=`i'+1
}

// Generate investment table (all outcomes)
#delimit ;
esttab invest_table_1 invest_table_2 invest_table_3 invest_table_4 invest_table_5 invest_table_6 
    using "$Scratch/neff_investment_full.rtf", 
    replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(*did_treat_ent* *year*) ///
    order(*did_treat_ent* *year*) ///
    stats(N mean_control_2023 mean_control_2024 treatment_FE time_FE cov clustering, 
          fmt(%9.0g %9.3f %9.3f %s %s %s %s) 
          labels("Observations" "Control Mean (2023)" "Control Mean (2024)" "Treatment FE" "Time FE" "Covariates" "SE Clustering")) ///
    mtitles("Investment (z)" "Count Investment" "WC Investment" "AC Investment" "Count AC Investment" "Count DR Investment") ///
    title("Table X: Impact of NEFF Program on Investment Behavior") ///
    addnotes("Standard errors clustered at the enterprise level" 
             "Investment (z) is standardized and winsorized at 1st and 99th percentiles"
             "WC = Working Capital, AC = Asset Creation, DR = Debt Reduction") ;
#delimit cr






local outcomes "z_invest_w1 count_investment wc_invest ac_invest count_ac_invest count_dr_invest"
local titles `""Investment Amount (z)" "Number of Investments" "Working Capital Share" "Asset Creation Share" "Asset Creation Count" "Debt Reduction Count""'

local i = 1
foreach outcome in `outcomes' {
    local title : word `i' of `titles'
    
    didregress (`outcome') (did_treat_ent), group(enterprise_id_num) time(year) aeq
    
    estat grangerplot, ///
        mcolor(navy) msymbol(circle) msize(large) ///
        lcolor(navy) lwidth(thick) ///
        ciopts(lcolor(gs8) lwidth(medium)) ///
        title("Dynamic Effects: `title'", size(medium) color(black)) ///
        xtitle("Time Relative to Treatment", size(small)) ///
        ytitle("Treatment Effect", size(small)) ///
        xlabel(, labsize(medium)) ///
        ylabel(, labsize(medium) format(%9.3f)) ///
        legend(off) ///
        graphregion(color(white) fcolor(white)) ///
        plotregion(color(white) fcolor(white)) ///
        scheme(s1color)
    
    graph export "$Scratch/granger_`outcome'.png", replace width(1200) height(800)
    graph save "$Scratch/granger_`outcome'.gph", replace
    
    local i = `i' + 1
}

/*==============================================================================
                    COMBINED GRANGER PLOT (ALL 6 OUTCOMES)
===============================================================================*/

// Combine all investment Granger plots
graph combine ///
    "$Scratch/granger_z_invest_w1.gph" ///
    "$Scratch/granger_count_investment.gph" ///
    "$Scratch/granger_wc_invest.gph" ///
    "$Scratch/granger_ac_invest.gph" ///
    "$Scratch/granger_count_ac_invest.gph" ///
    "$Scratch/granger_count_dr_invest.gph", ///
    rows(3) cols(2) ///
    iscale(0.7) ///
    graphregion(color(white) fcolor(white)) ///
    scheme(s1color)

graph export "$Scratch/granger_investment_combined.png", replace width(1600) height(1200)
graph save "$Scratch/granger_investment_combined.gph", replace



/*==============================================================================
                    Sales and Profit (DM Boundary paper)
===============================================================================*/
global cov "e_age marriage_age age_entrepreneur education_yrs" // Covariates 


la var sec12_q6 "Last month profit"
la var sec12_q1 "Last month sale"


* Inverse Hyperbolic sine of each
foreach var of varlist sec12_q6 sec12_q1 {
gen inv`var'=asinh(`var')
}

zscore invsec12_q6 invsec12_q1

egen salesprofindex = rowmean(z_invsec12_q6 z_invsec12_q1) 
label var salesprofindex "Sales and Profits Index"


eststo clear
local i=1
foreach var of varlist invsec12_q6 invsec12_q1 salesprofindex  {
areg `var' treat_ent if survey_round == 1, a(block_id) cluster(panchayat_id)
}

eststo clear
local i=1
foreach var of varlist invsec12_q6 invsec12_q1 salesprofindex  {
areg `var' treat_ent if survey_round == 2, a(block_id) cluster(panchayat_id)
}




eststo clear
local i=1
foreach var of varlist invsec12_q6 invsec12_q1 salesprofindex {
    
    areg `var' treat_ent $cov i.sec4_q4 if survey_round == 1, absorb(block_id) cluster(panchayat_id)
    test treat_ent == 0
    estadd scalar pval1 = r(p)
    estadd local Round "1"
    estadd local Enterprise "Yes"
    estadd local Block_FE "Yes"
    sum `var' if e(sample) & treat_ent == 0
    estadd scalar control_mean=r(mean)
    eststo round1_`i'
    
    areg `var' treat_ent $cov i.sec4_q4 if survey_round == 2, absorb(block_id) cluster(panchayat_id)
    test treat_ent == 0
    estadd scalar pval1 = r(p)
    estadd local Round "2"
    estadd local Enterprise "Yes"
    estadd local Block_FE "Yes"
    sum `var' if e(sample) & treat_ent == 0
    estadd scalar control_mean=r(mean)
    eststo round2_`i'
    local i=`i'+1
}
    
#delimit ;
esttab round1_* using "$Scratch/sales_profits_by_round.rtf", replace depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel A: Round 1 Effects") ///
    stats(control_mean N pval1 Enterprise Block_FE, fmt(%9.3f %9.0g %9.3f %s %s) labels("Control Group Mean" "Observations" "P-value" "Enterprise Controls" "Block Fixed Effects")) ///
    mtitles("IHS Last Month Profit" "IHS Last Month Sales" "Sales and Profits Index") ///
    title("Table: Impact on Sales and Profits by Survey Round") ;
#delimit cr

#delimit ;
esttab round2_* using "$Scratch/sales_profits_by_round.rtf", append depvar legend label nonumbers nogaps nonotes ///
    b(%9.3f) se star(* 0.10 ** 0.05 *** 0.01) nogaps ///
    keep(treat_ent) ///
    posthead("Panel B: Round 2 Effects") ///
    stats(control_mean N pval1 Enterprise Block_FE, fmt(%9.3f %9.0g %9.3f %s %s) labels("Control Group Mean" "Observations" "P-value" "Enterprise Controls" "Block Fixed Effects")) ///
    mtitles("IHS Last Month Profit" "IHS Last Month Sales" "Sales and Profits Index") ///
    addnotes("Standard errors clustered at the panchayat level. Standard errors in parentheses." "IHS: Inverse Hyperbolic Sine transformation" "Enterprise controls include: $cov and i.sec4_q4") ;
#delimit cr