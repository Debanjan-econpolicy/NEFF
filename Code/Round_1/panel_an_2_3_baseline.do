*Time period 1 defines June,2023 to january, 2024  (Post-NEFF period)
*Time period 2 defines 2023 (January-December)
*TYime period 3 defines 2022 (January-December)

*Reshape the data by keeping all relevent outcome variable
*We will create panel of time period 2 and 3 here
*We will run Panel dataregression

*outcome variable of time period 2:  loan_taken_2 loan_times_2 rate_neff_2 invest_2 w10_invest_2 count_investment_2 ecost_2 w10_ecost_2 revenue_2 w10_revenue_2 profit_2 w10_profit_2 wc_invest_2 ac_invest_2 dr_invest_2 count_wc_invest_2 count_ac_invest_2 count_dr_invest_2
*outcome variable of time period 3:  l loan_taken_3 loan_times_3 rate_neff_3 invest_3 w10_invest_3 count_investment_3 ecost_3 w10_ecost_3 revenue_3 w10_revenue_3 profit_3 w10_profit_3 wc_invest_3 ac_invest_3 dr_invest_3 count_wc_invest_3 count_ac_invest_3 count_dr_invest_3



global cov "sec2_q2 f_ent e_age age_entrepreneur education_yrs"  			//Covariates 
global cov "i.sec2_q2 e_age marriage_age  age_entrepreneur education_yrs"  			//Covariates 

preserve
reshape long  invest_ w10_invest_  ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_, i(enterprise_id) j(year)

keep if (year==2) | (year==3)

replace year=0 if year==3
replace year=1 if year==2
**Comparing full 2023 with full 2022

destring enterprise_id, generate(enterprise_id_num) 
sort enterprise_id_num year


xtset enterprise_id_num year
gen np=neff_vill * year
la var np "T*year"
la var year "Year"


***Final for the reporting
gen l_profit=log(profit_)
gen l_cost=log(ecost_)
gen l_revenue=log(revenue_)
gen l_invest=log(invest_)
gen l_ac=log(ac_invest_)
gen l_wc=log(wc_invest_)
gen l_dr=log(dr_invest_)

**Observing the impact of treatment 
xtreg l_revenue np year,fe
xtreg l_cost np year,fe
xtreg l_profit np year,fe
xtreg l_invest np year,fe

xtreg l_wc np year,fe
xtreg l_ac np year,fe
xtreg l_dr np year,fe



**Table generate

outreg2 using "$table/panel_2_3.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control enterprise fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels. Period 0:2022. Year 1:2023. ) title(Impact on Enterprise Revenue/Cost/Profit/Investment) addtext(Individual FE, YES) label
outreg2 using "$table/panel_2_3.doc", append dec(2) ctitle(Cost) addtext(Individual FE, YES) label 			//for cost
outreg2 using "$table/panel_2_3.doc", append dec(2) ctitle(Profit) addtext(Individual FE, YES) label  		//for profit
outreg2 using "$table/panel_2_3.doc", append dec(2) ctitle(Investment) addtext(Individual FE, YES) label  		//for investment

outreg2 using "$table/panel_2_3.doc", append dec(2) ctitle(Working Capital) addtext(Individual FE, YES) label  		//for WC
outreg2 using "$table/panel_2_3.doc", append dec(2) ctitle(Asset creation) addtext(Individual FE, YES) label  		//for AC

restore
***************************



********************************************************************************
**								Treatment effet								**
********************************************************************************

preserve
global tables_2_TE "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\tables_2_TE"

reshape long  invest_ w10_invest_  ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_, i(enterprise_id) j(year)

keep if (year==2) | (year==3)

replace year=0 if year==3
replace year=1 if year==2
**Comparing full 2023 with full 2022

destring enterprise_id, generate(enterprise_id_num) 
sort enterprise_id_num year


xtset enterprise_id_num year
gen np=treat_ent * year
la var np "T*year"
la var year "Year"


***Final for the reporting
gen l_profit=log(profit_)
gen l_cost=log(ecost_)
gen l_revenue=log(revenue_)
gen l_invest=log(invest_)
gen l_ac=log(ac_invest_)
gen l_wc=log(wc_invest_)
gen l_dr=log(dr_invest_)

**Observing the impact of treatment 
xtreg l_revenue np year,fe
xtreg l_cost np year,fe
xtreg l_profit np year,fe
xtreg l_invest np year,fe

xtreg l_wc np year,fe
xtreg l_ac np year,fe
xtreg l_dr np year,fe



**Table generate

outreg2 using "$tables_2_TE/panel_2_3.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control enterprise fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels. Period 0:2022. Year 1:2023. ) title(Impact on Enterprise Revenue/Cost/Profit/Investment) addtext(Individual FE, YES) label
outreg2 using "$tables_2_TE/panel_2_3.doc", append dec(2) ctitle(Cost) addtext(Individual FE, YES) label 			//for cost
outreg2 using "$tables_2_TE/panel_2_3.doc", append dec(2) ctitle(Profit) addtext(Individual FE, YES) label  		//for profit
outreg2 using "$tables_2_TE/panel_2_3.doc", append dec(2) ctitle(Investment) addtext(Individual FE, YES) label  		//for investment

outreg2 using "$tables_2_TE/panel_2_3.doc", append dec(2) ctitle(Working Capital) addtext(Individual FE, YES) label  		//for WC
outreg2 using "$tables_2_TE/panel_2_3.doc", append dec(2) ctitle(Asset creation) addtext(Individual FE, YES) label  		//for AC

restore

********************************************************************************
*****							Direct CAP effect 							****
********************************************************************************

preserve
global tables_3_DCE "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\tables_3_DCE"

reshape long  invest_ w10_invest_  ecost_ w10_ecost_ revenue_ w10_revenue_ profit_ w10_profit_ wc_invest_ count_wc_invest_ ac_invest_ count_ac_invest_ dr_invest_ count_dr_invest_, i(enterprise_id) j(year)

keep if (year==2) | (year==3)

replace year=0 if year==3
replace year=1 if year==2
**Comparing full 2023 with full 2022

destring enterprise_id, generate(enterprise_id_num) 
sort enterprise_id_num year


xtset enterprise_id_num year
gen np=t_both * year
la var np "T*year"
la var year "Year"


***Final for the reporting
gen l_profit=log(profit_)
gen l_cost=log(ecost_)
gen l_revenue=log(revenue_)
gen l_invest=log(invest_)
gen l_ac=log(ac_invest_)
gen l_wc=log(wc_invest_)
gen l_dr=log(dr_invest_)

**Observing the impact of treatment 
xtreg l_revenue np year,fe
xtreg l_cost np year,fe
xtreg l_profit np year,fe
xtreg l_invest np year,fe

xtreg l_wc np year,fe
xtreg l_ac np year,fe
xtreg l_dr np year,fe



**Table generate

outreg2 using "$tables_3_DCE/panel_2_3.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control enterprise fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels. Period 0:2022. Year 1:2023. ) title(Impact on Enterprise Revenue/Cost/Profit/Investment) addtext(Individual FE, YES) label
outreg2 using "$tables_3_DCE/panel_2_3.doc", append dec(2) ctitle(Cost) addtext(Individual FE, YES) label 			//for cost
outreg2 using "$tables_3_DCE/panel_2_3.doc", append dec(2) ctitle(Profit) addtext(Individual FE, YES) label  		//for profit
outreg2 using "$tables_3_DCE/panel_2_3.doc", append dec(2) ctitle(Investment) addtext(Individual FE, YES) label  		//for investment

outreg2 using "$tables_3_DCE/panel_2_3.doc", append dec(2) ctitle(Working Capital) addtext(Individual FE, YES) label  		//for WC
outreg2 using "$tables_3_DCE/panel_2_3.doc", append dec(2) ctitle(Asset creation) addtext(Individual FE, YES) label  		//for AC

restore


