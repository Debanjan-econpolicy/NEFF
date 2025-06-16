	
*Time period 1 defines June,2023 to january, 2024  (Post-NEFF period)
*Time period 2 defines 2023 (January-December)
*TYime period 3 defines 2022 (January-December)

*Reshape the data by keeping all relevent outcome variable
*We will create panel of time period 1 and 3 here
* We will run Panel dataregression
*outcome variable of time period 1:  loan_taken_1 loan_times_1 rate_neff_1 invest_1 w10_invest_1 count_investment_1 ecost_1 w10_ecost_1 revenue_1 w10_revenue_1 profit_1 w10_profit_1 wc_invest_1 count_wc_invest_1 ac_invest_1 count_ac_invest_1 dr_invest_1 count_dr_invest_1

*outcome variable of time period 3:  loan_taken_3 loan_times_3 rate_neff_3 invest_3 w10_invest_3 count_investment_3 ecost_3 w10_ecost_3 revenue_3 w10_revenue_3 profit_3 w10_profit_3 wc_invest_3 ac_invest_3 dr_invest_3 count_wc_invest_3 count_ac_invest_3 count_dr_invest_3

global cov "sec2_q2 f_ent e_age age_entrepreneur education_yrs"  			//Covariates 




**reshape 
preserve	
keep enterprise_id district district_id block block_id panchayat panchayat_id enterprise loan_taken_1 loan_times_1 rate_neff_1 invest_1 w10_invest_1 count_investment_1 ecost_1 w10_ecost_1 revenue_1 w10_revenue_1 profit_1 w10_profit_1 wc_invest_1 count_wc_invest_1 ac_invest_1 count_ac_invest_1 dr_invest_1 count_dr_invest_1 loan_taken_3 loan_times_3 rate_neff_3 invest_3 w10_invest_3 count_investment_3 ecost_3 w10_ecost_3 revenue_3 w10_revenue_3 profit_3 w10_profit_3 wc_invest_3 ac_invest_3 dr_invest_3 count_wc_invest_3 count_ac_invest_3 count_dr_invest_3 neff_vill neff_cap_ent treat_ent treat_exp  sec2_q2 f_ent e_age age_entrepreneur education_yrs invest_1 invest_3 marriage_age treat_ent 


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

gen np=neff_vill * year
la var np "T*year"
la var year "Year"




**Log transformation
gen l_r_revenue=log(r_revenue)
gen l_r_cost=log(r_cost)
gen l_r_profit=log(r_profit)
gen l_r_invest=log(r_invest)
gen l_r_ac=log(r_ac)
gen l_r_wc=log(r_wc)
gen l_r_dr=log(r_dr)



**observing the impact
xtreg l_r_revenue  np year,fe
xtreg l_r_cost  np year,fe
xtreg l_r_profit  np year,fe
xtreg l_r_invest  np year,fe
xtreg l_r_wc np year,fe
xtreg l_r_ac np year,fe
xtreg l_r_dr np year,fe

**Table generate

outreg2 using "$table/panel_1_3.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control enterprise fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.  Period 1:2023 (Half-yearly). Period 0:2022 (Half-yearly). ) title(Impact on Enterprise Revenue/Cost/Profit/Investment) addtext(Individual FE, YES) label

outreg2 using "$table/panel_1_3.doc", append dec(2) ctitle(Cost) addtext(Individual FE, YES) label 			//for cost
outreg2 using "$table/panel_1_3.doc", append dec(2) ctitle(Profit) addtext(Individual FE, YES) label 			//for Profit
outreg2 using "$table/panel_1_3.doc", append dec(2) ctitle(Investment) addtext(Individual FE, YES) label 			//for Investment

outreg2 using "$table/panel_1_3.doc", append dec(2) ctitle(Working Capital) addtext(Individual FE, YES) label  		//for WC
outreg2 using "$table/panel_1_3.doc", append dec(2) ctitle(Asset creation) addtext(Individual FE, YES) label  		//for AC
outreg2 using "$table/panel_1_3.doc", append dec(2) ctitle(Debt Reduction) addtext(Individual FE, YES) label  		//for DR

restore

********************************************************************************
**								Treatment effet								**
********************************************************************************

**reshape 
preserve	
keep enterprise_id district district_id block block_id panchayat panchayat_id enterprise loan_taken_1 loan_times_1 rate_neff_1 invest_1 w10_invest_1 count_investment_1 ecost_1 w10_ecost_1 revenue_1 w10_revenue_1 profit_1 w10_profit_1 wc_invest_1 count_wc_invest_1 ac_invest_1 count_ac_invest_1 dr_invest_1 count_dr_invest_1 loan_taken_3 loan_times_3 rate_neff_3 invest_3 w10_invest_3 count_investment_3 ecost_3 w10_ecost_3 revenue_3 w10_revenue_3 profit_3 w10_profit_3 wc_invest_3 ac_invest_3 dr_invest_3 count_wc_invest_3 count_ac_invest_3 count_dr_invest_3 neff_vill neff_cap_ent treat_ent treat_exp  sec2_q2 f_ent e_age age_entrepreneur education_yrs invest_1 invest_3 marriage_age treat_ent 


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

gen np=treat_ent * year
la var np "T*year"
la var year "Year"




**Log transformation
gen l_r_revenue=log(r_revenue)
gen l_r_cost=log(r_cost)
gen l_r_profit=log(r_profit)
gen l_r_invest=log(r_invest)
gen l_r_ac=log(r_ac)
gen l_r_wc=log(r_wc)
gen l_r_dr=log(r_dr)



**observing the impact
xtreg l_r_revenue  np year,fe
xtreg l_r_cost  np year,fe
xtreg l_r_profit  np year,fe
xtreg l_r_invest  np year,fe
xtreg l_r_wc np year,fe
xtreg l_r_ac np year,fe
xtreg l_r_dr np year,fe

**Table generate

outreg2 using "$tables_2_TE/panel_1_3.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control enterprise fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.  Period 1:2023 (Half-yearly). Period 0:2022 (Half-yearly). ) title(Impact on Enterprise Revenue/Cost/Profit/Investment) addtext(Individual FE, YES) label

outreg2 using "$tables_2_TE/panel_1_3.doc", append dec(2) ctitle(Cost) addtext(Individual FE, YES) label 			//for cost
outreg2 using "$tables_2_TE/panel_1_3.doc", append dec(2) ctitle(Profit) addtext(Individual FE, YES) label 			//for Profit
outreg2 using "$tables_2_TE/panel_1_3.doc", append dec(2) ctitle(Investment) addtext(Individual FE, YES) label 			//for Investment

outreg2 using "$tables_2_TE/panel_1_3.doc", append dec(2) ctitle(Working Capital) addtext(Individual FE, YES) label  		//for WC
outreg2 using "$tables_2_TE/panel_1_3.doc", append dec(2) ctitle(Asset creation) addtext(Individual FE, YES) label  		//for AC
outreg2 using "$tables_2_TE/panel_1_3.doc", append dec(2) ctitle(Debt Reduction) addtext(Individual FE, YES) label  		//for DR

restore
	

********************************************************************************
*****							Direct CAP effect 							****
********************************************************************************
global tables_3_DCE "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\tables_3_DCE"

**reshape 
preserve	
keep enterprise_id district district_id block block_id panchayat panchayat_id enterprise loan_taken_1 loan_times_1 rate_neff_1 invest_1 w10_invest_1 count_investment_1 ecost_1 w10_ecost_1 revenue_1 w10_revenue_1 profit_1 w10_profit_1 wc_invest_1 count_wc_invest_1 ac_invest_1 count_ac_invest_1 dr_invest_1 count_dr_invest_1 loan_taken_3 loan_times_3 rate_neff_3 invest_3 w10_invest_3 count_investment_3 ecost_3 w10_ecost_3 revenue_3 w10_revenue_3 profit_3 w10_profit_3 wc_invest_3 ac_invest_3 dr_invest_3 count_wc_invest_3 count_ac_invest_3 count_dr_invest_3 neff_vill neff_cap_ent treat_ent treat_exp  sec2_q2 f_ent e_age age_entrepreneur education_yrs invest_1 invest_3 marriage_age treat_ent t_both both 


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

gen np=t_both*year
la var np "T*year"
la var year "Year"




**Log transformation
gen l_r_revenue=log(r_revenue)
gen l_r_cost=log(r_cost)
gen l_r_profit=log(r_profit)
gen l_r_invest=log(r_invest)
gen l_r_ac=log(r_ac)
gen l_r_wc=log(r_wc)
gen l_r_dr=log(r_dr)



**observing the impact
xtreg l_r_revenue  np year,fe
xtreg l_r_cost  np year,fe
xtreg l_r_profit  np year,fe
xtreg l_r_invest  np year,fe
xtreg l_r_wc np year,fe
xtreg l_r_ac np year,fe
xtreg l_r_dr np year,fe

**Table generate

outreg2 using "$tables_3_DCE/panel_1_3.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control enterprise fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.  Period 1:2023 (Half-yearly). Period 0:2022 (Half-yearly). ) title(Impact on Enterprise Revenue/Cost/Profit/Investment) addtext(Individual FE, YES) label

outreg2 using "$tables_3_DCE/panel_1_3.doc", append dec(2) ctitle(Cost) addtext(Individual FE, YES) label 			//for cost
outreg2 using "$tables_3_DCE/panel_1_3.doc", append dec(2) ctitle(Profit) addtext(Individual FE, YES) label 			//for Profit
outreg2 using "$tables_3_DCE/panel_1_3.doc", append dec(2) ctitle(Investment) addtext(Individual FE, YES) label 			//for Investment

outreg2 using "$tables_3_DCE/panel_1_3.doc", append dec(2) ctitle(Working Capital) addtext(Individual FE, YES) label  		//for WC
outreg2 using "$tables_3_DCE/panel_1_3.doc", append dec(2) ctitle(Asset creation) addtext(Individual FE, YES) label  		//for AC
outreg2 using "$tables_3_DCE/panel_1_3.doc", append dec(2) ctitle(Debt Reduction) addtext(Individual FE, YES) label  		//for DR

xtset, clear
reshape wide invest_ w10_invest_ ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_ r_* np l_* _est_*, i(enterprise_id) j(year)

restore












