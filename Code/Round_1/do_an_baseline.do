global cov "i.sec2_q2 f_ent e_age age_entrepreneur education_yrs"  			//Covariates 
global cov "i.sec2_q2 e_age marriage_age  age_entrepreneur education_yrs"  			//Covariates 

mkdir tables
global table "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\tables"


**loans and indebtedness
areg sec8_q1 neff_vill $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )

areg sec8_q3 neff_vill $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )
areg count_loan neff_vill $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )			//Number of loan taken

areg rec_loan_taken neff_vill $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )		//Loans(#) taken in Post-NEFF period

areg avg_int_rate neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id ) 	//average annual interest rate
areg w10_avg_int_rate neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id ) 	//Winsorized average annual interest rate


areg rate_neff neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id )		//annual interest rate for loan in Post-NEFF period
areg w10_rate_neff neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id )		//annual interest rate for loan in Post-NEFF period


areg tot_unpaid_loan neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//Total unpaid loans
areg w10_tot_unpaid_loan neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//Total unpaid loans

* table generate
outreg2 using "$table/loan.doc", replace dec(3) ctitle(Loan access) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on loans and indebtedness)

outreg2 using "$table/loan.doc", append dec(2) ctitle(Loan number) 
outreg2 using "$table/loan.doc", append dec(2) ctitle(Loans(#) in Post-NEFF period) 
outreg2 using "$table/loan.doc", append dec(2) ctitle(Average interest rate) 				//Winsorized average annual interest rate
outreg2 using "$table/loan.doc", append dec(2) ctitle(Interest rate in Post-NEFF period)  //annual interest rate for loan in Post-NEFF period
outreg2 using "$table/loan.doc", append dec(2) ctitle(Total unpaid loans)  				//Total unpaid loans

**reveue/cost/profit/investment in Post-NEFF period
areg w10_revenue_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg w10_ecost_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg w10_profit_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)			//doesnot follow mid way analysis
areg w10_invest_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

outreg2 using "$table/ent_outcome_post_neff.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Enterprise Revenue/Cost/Profit/Investment in Post-NEFF period)

outreg2 using  "$table/ent_outcome_post_neff.doc", append dec(3) ctitle(Cost) 
outreg2 using  "$table/ent_outcome_post_neff.doc", append dec(3) ctitle(Profit) 
outreg2 using  "$table/ent_outcome_post_neff.doc", append dec(3) ctitle(Investment) 

***Proportions of investment in Post-NEFF period
areg wc_invest_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg ac_invest_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //Proportion of investment in asset creation
areg dr_invest_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //Proportion of investment in asset creation

outreg2 using "$table/invest_proportion_post_neff.doc", replace dec(3) ctitle(Working capital) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Proportions of investment in Post-NEFF period)

outreg2 using  "$table/invest_proportion_post_neff.doc", append dec(3) ctitle(Asset Creation) 
outreg2 using  "$table/invest_proportion_post_neff.doc", append dec(3) ctitle(Debt Reduction) 


**Business practice and skills 
areg bps neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg bps_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

** Business practice and skills (Sir)
areg sec17_q1_a neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q1_c neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q1_d neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q1_e neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q1_f neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q5 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q5_a neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

ologit sec17_q5_b neff_vill $cov  i.sec4_q4 i.block_id, cluster(panchayat_id)

areg sec17_q6 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q8 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q9 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q10 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec17_q11 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)


*table generate
outreg2 using "$table/busines_practice_score.doc", replace dec(3) ctitle(Business Skills and Practices) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Business Skills and Practices)


outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Business Skills and Practices 1) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Visited competitor's business) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Product Preferences) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Inquired customer) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Attract customer) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Advertisement) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Written business records) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Update frequency) 

outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Digital record) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Regular use of record) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Most profitable product) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Written budget) 
outreg2 using  "$table/busines_practice_score.doc", append dec(3) ctitle(Sell on credit) 

**Supplier relation
areg sec16_q1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q2 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q3 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q4 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q5 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q6 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
logit sec16_q8 neff_vill $cov  i.sec4_q4 i.block_id, cluster(panchayat_id)
areg sec16_q9 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q11 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q12 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q13 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q14 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
logit sec16_q15 neff_vill $cov  i.sec4_q4 i.block_id, cluster(panchayat_id)

areg sec16_q16 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg sec16_q17 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

**Supplier relation
outreg2 using "$table/suppliers_relation.doc", replace dec(3) ctitle(Negotiation) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Supplier Relation)
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Obtain lower price) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(raw material payment) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Grace period) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(payment at purchase time) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Grace period time) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Advance payment) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(% Pay in advance) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Product suggestion) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Product discount) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Flexible payment) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Long term contract) 
outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Supplier priority) 

outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Price/quality compare) 

outreg2 using  "$table/suppliers_relation.doc", append dec(3) ctitle(Most selling product) 


**registration
areg sec3_q2 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg udyam_registration neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

outreg2 using "$table/registration.doc", replace dec(3) ctitle(Registration) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Enterprise Registration Status)

outreg2 using  "$table/registration.doc", append dec(3) ctitle(Udyam-Aadhar registration) 

*Digital Payments System
areg sec17_q16 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

outreg2 using "$table/digital_payments.doc", replace dec(3) ctitle(Digital payment use) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Digital Payments)

areg sec17_q20 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
outreg2 using  "$table/digital_payments.doc", append dec(3) ctitle(Monthly sales (%)) 

areg dig_pm_start neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id) 	//Digital payments collection starting date
outreg2 using  "$table/digital_payments.doc", append dec(3) ctitle(Years of use) 

ologit sec17_q18 neff_vill $cov  i.sec4_q4 i.block_id, cluster(panchayat_id)      //service provider
outreg2 using  "$table/digital_payments.doc", append dec(3) ctitle(service provider) 

areg sec17_q21_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //technical challenge
outreg2 using  "$table/digital_payments.doc", append dec(3) ctitle(technical challenge) 

areg sec17_q22_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id) //Initial setup cost
outreg2 using  "$table/digital_payments.doc", append dec(3) ctitle(Initial setup cost) 

areg sec17_q23_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //Increase revenue due to digital payments
outreg2 using  "$table/digital_payments.doc", append dec(3) ctitle(Increase revenue) 


areg sec17_q23_2 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id) 		// Streamlined financial processes due to digital payments
outreg2 using  "$table/digital_payments.doc", append dec(3) ctitle(Streamlined financial processes) 

*CIBIL
areg sec19_q1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
outreg2 using "$table/cibil.doc", replace dec(3) ctitle(CIBIL awareness) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on CIBIL score)

areg sec19_q3 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)		//Have you ever checked your own CIBIL score (Credit bureau score)?
outreg2 using  "$table/cibil.doc", append dec(3) ctitle(CIBIL score check) 					


areg sec19_q3_a neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//CIBIL score
outreg2 using  "$table/cibil.doc", append dec(3) ctitle(CIBIL score) 					

ologit sec19_q4 neff_vill $cov  i.sec4_q4, cluster(panchayat_id)					//Frequency of checking
outreg2 using  "$table/cibil.doc", append dec(3) ctitle(Frequency of checking) 				


areg sec19_q5  neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//Action taken to improve CIBIL score
outreg2 using  "$table/cibil.doc", append dec(3) ctitle(Action taken to improve CIBIL score) 				

ologit sec19_q8 neff_vill $cov  i.sec4_q4 i.block_id, cluster(panchayat_id)  		//level of familiarity
outreg2 using  "$table/cibil.doc", append dec(3) ctitle(level of familiarity) 				

areg cibil_purpose_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)   //Monitor credit health
outreg2 using  "$table/cibil.doc", append dec(3) ctitle(Purpose: Monitor credit health) 				


areg cibil_purpose_1 neff_vill $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)   //Preparing for a loan application
outreg2 using  "$table/cibil.doc", append dec(3) ctitle(Purpose: Preparation of loan application) 				



********************************************************************************
*****							Treatment effect 							*****
********************************************************************************
global tables_2_TE "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\tables_2_TE"



**loans and indebtedness
areg sec8_q1 treat_ent $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )

areg sec8_q3 treat_ent $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )
areg count_loan treat_ent $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )			//Number of loan taken

areg rec_loan_taken treat_ent $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )		//Loans(#) taken in Post-NEFF period

areg avg_int_rate treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id ) 	//average annual interest rate
areg w10_avg_int_rate treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id ) 	//Winsorized average annual interest rate


areg rate_neff treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id )		//annual interest rate for loan in Post-NEFF period
areg w10_rate_neff treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id )		//annual interest rate for loan in Post-NEFF period


areg tot_unpaid_loan treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//Total unpaid loans
areg w10_tot_unpaid_loan treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//Total unpaid loans

* table generate
outreg2 using "$tables_2_TE/loan.doc", replace dec(3) ctitle(Loan access) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on loans and indebtedness)

outreg2 using "$tables_2_TE/loan.doc", append dec(2) ctitle(Loan number) 
outreg2 using "$tables_2_TE/loan.doc", append dec(2) ctitle(Loans(#) in Post-NEFF period) 
outreg2 using "$tables_2_TE/loan.doc", append dec(2) ctitle(Average interest rate) 				//Winsorized average annual interest rate
outreg2 using "$tables_2_TE/loan.doc", append dec(2) ctitle(Interest rate in Post-NEFF period)  //annual interest rate for loan in Post-NEFF period
outreg2 using "$tables_2_TE/loan.doc", append dec(2) ctitle(Total unpaid loans)  				//Total unpaid loans

**reveue/cost/profit/investment in Post-NEFF period
areg w10_revenue_1 treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg w10_ecost_1 treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg w10_profit_1 treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)			//doesnot follow mid way analysis
areg w10_invest_1 treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

outreg2 using "$tables_2_TE/ent_outcome_post_neff.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Enterprise Revenue/Cost/Profit/Investment in Post-NEFF period)

outreg2 using  "$tables_2_TE/ent_outcome_post_neff.doc", append dec(3) ctitle(Cost) 
outreg2 using  "$tables_2_TE/ent_outcome_post_neff.doc", append dec(3) ctitle(Profit) 
outreg2 using  "$tables_2_TE/ent_outcome_post_neff.doc", append dec(3) ctitle(Investment) 

***Proportions of investment in Post-NEFF period
areg wc_invest_1 treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg ac_invest_1 treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //Proportion of investment in asset creation
areg dr_invest_1 treat_ent $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //Proportion of investment in asset creation

outreg2 using "$tables_2_TE/invest_proportion_post_neff.doc", replace dec(3) ctitle(Working capital) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Proportions of investment in Post-NEFF period)

outreg2 using  "$tables_2_TE/invest_proportion_post_neff.doc", append dec(3) ctitle(Asset Creation) 
outreg2 using  "$tables_2_TE/invest_proportion_post_neff.doc", append dec(3) ctitle(Debt Reduction) 


********************************************************************************
*****							Direct CAP effect 							****
********************************************************************************
global tables_3_DCE "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\tables_3_DCE"



**loans and indebtedness
areg sec8_q1 t_both $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )

areg sec8_q3 t_both $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )
areg count_loan t_both $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )			//Number of loan taken

areg rec_loan_taken t_both $cov  i.sec4_q4 , absorb(block_id) cluster(panchayat_id )		//Loans(#) taken in Post-NEFF period

areg avg_int_rate t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id ) 	//average annual interest rate
areg w10_avg_int_rate t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id ) 	//Winsorized average annual interest rate


areg rate_neff t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id )		//annual interest rate for loan in Post-NEFF period
areg w10_rate_neff t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id )		//annual interest rate for loan in Post-NEFF period


areg tot_unpaid_loan t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//Total unpaid loans
areg w10_tot_unpaid_loan t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)	//Total unpaid loans

* table generate
outreg2 using "$tables_3_DCE/loan.doc", replace dec(3) ctitle(Loan access) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on loans and indebtedness)

outreg2 using "$tables_3_DCE/loan.doc", append dec(2) ctitle(Loan number) 
outreg2 using "$tables_3_DCE/loan.doc", append dec(2) ctitle(Loans(#) in Post-NEFF period) 
outreg2 using "$tables_3_DCE/loan.doc", append dec(2) ctitle(Average interest rate) 				//Winsorized average annual interest rate
outreg2 using "$tables_3_DCE/loan.doc", append dec(2) ctitle(Interest rate in Post-NEFF period)  //annual interest rate for loan in Post-NEFF period
outreg2 using "$tables_3_DCE/loan.doc", append dec(2) ctitle(Total unpaid loans)  				//Total unpaid loans

**reveue/cost/profit/investment in Post-NEFF period
areg w10_revenue_1 t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg w10_ecost_1 t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg w10_profit_1 t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)			//doesnot follow mid way analysis
areg w10_invest_1 t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)

outreg2 using "$tables_3_DCE/ent_outcome_post_neff.doc", replace dec(3) ctitle(Revenue) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Enterprise Revenue/Cost/Profit/Investment in Post-NEFF period)

outreg2 using  "$tables_3_DCE/ent_outcome_post_neff.doc", append dec(3) ctitle(Cost) 
outreg2 using  "$tables_3_DCE/ent_outcome_post_neff.doc", append dec(3) ctitle(Profit) 
outreg2 using  "$tables_3_DCE/ent_outcome_post_neff.doc", append dec(3) ctitle(Investment) 

***Proportions of investment in Post-NEFF period
areg wc_invest_1 t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)
areg ac_invest_1 t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //Proportion of investment in asset creation
areg dr_invest_1 t_both $cov  i.sec4_q4, absorb(block_id) cluster(panchayat_id)  //Proportion of investment in asset creation

outreg2 using "$tables_3_DCE/invest_proportion_post_neff.doc", replace dec(3) ctitle(Working capital) addnote(Standard errors clustered at the panchayat level. Regressions control for block fixed effects. Standard errors in parentheses. *, **, *** denote significance at the 10, 5, and 1 percent levels.) title(Impact on Proportions of investment in Post-NEFF period)

outreg2 using  "$tables_3_DCE/invest_proportion_post_neff.doc", append dec(3) ctitle(Asset Creation) 
outreg2 using  "$tables_3_DCE/invest_proportion_post_neff.doc", append dec(3) ctitle(Debt Reduction) 


********************************************************************************
*****							Joint effect 								****
********************************************************************************


global tables_3_DCE "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\tables_JE"

**loans and indebtedness
reg sec8_q1 neff_vill nc_t $cov  i.sec4_q4 i.block_id
est sto m1
reg sec8_q1 neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0

reg count_loan neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Number of loan taken
est sto m1
reg count_loan neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0


reg rec_loan_taken neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Loans(#) taken in Post-NEFF period
est sto m1
reg rec_loan_taken neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0



reg w10_avg_int_rate neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Winsorized average annual interest rate
est sto m1
reg w10_avg_int_rate neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0


reg w10_rate_neff neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//annual interest rate for loan in Post-NEFF period
est sto m1
reg w10_rate_neff neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0


reg w10_tot_unpaid_loan neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Total unpaid loans
est sto m1
reg w10_tot_unpaid_loan neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0



**reveue/cost/profit/investment in Post-NEFF period

reg w10_revenue_1 neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//revenue
est sto m1
reg w10_revenue_1 neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0



reg w10_ecost_1 neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Cost
est sto m1
reg w10_ecost_1 neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0



reg w10_profit_1 neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Profit
est sto m1
reg w10_profit_1 neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0
		
reg w10_invest_1 neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Investment
est sto m1
reg w10_invest_1 neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0



***Proportions of investment in Post-NEFF period

reg wc_invest_1 neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Proportion of working capital
est sto m1
reg wc_invest_1 neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0

reg ac_invest_1 neff_vill nc_t $cov  i.sec4_q4 i.block_id 		//Proportion of investment in asset creation
est sto m1
reg ac_invest_1 neff_vill n_t $cov  i.sec4_q4 i.block_id
est sto m2
suest m1 m2, noomitted  vce(cluster panchayat_id)
test [m1_mean]nc_t - [m2_mean]n_t = 0









