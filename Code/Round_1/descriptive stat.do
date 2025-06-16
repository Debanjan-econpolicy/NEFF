

cd "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat"

**drop no consent and defuncted enteprises
drop if sec1_q7==0
drop if sec1_q9==2

**enterpris age

twoway kdensity e_age if  neff_vill== 0, xtitle("Age of the enterprise (in years)") ytitle(Density) ///
color(blue*.5) lcolor(blue) lwidth(medthick) ||  ///
kdensity e_age if neff_vill ==1, ///
color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
legend(order(1 "Non-NEFF" 2 "NEFF") col(1) pos(1) ring(0)) ///
saving(age_ent, replace)

**Age of ent owner
gen age_entrepreneur = (td(29feb2024) - sec4_q1 )/365.25
la var age_entrepreneur "Age of the entrepreneur"

twoway kdensity age_entrepreneur if neff_vill== 0, xtitle("Age of the enterprise owner (in years)") ytitle(Density) ///
color(blue*.5) lcolor(blue) lwidth(medthick) ||  ///
kdensity age_entrepreneur if neff_vill== 0, ///
color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
legend(order(1 "Non-NEFF" 2 "NEFF") col(1) pos(1) ring(0)) ///
saving(age_owner, replace)



*recoding the education variable as a continuous variable

**Education of the ent owner
twoway kdensity education_yrs if neff_vill == 0, bwidth(1) xtitle("Years of education of the enterprise owner") ytitle(Density) ///
color(blue*.5) lcolor(blue) lwidth(medthick) ||  ///
kdensity education_yrs if neff_vill ==1, bwidth(1) ///
color(red*.1) lcolor(red) lpattern(dash) lwidth(medthick) ///
legend(order(1 "Non-NEFF" 2 "NEFF") col(1) pos(1) ring(0)) ///
saving(educ, replace)





*combining graphs

grc1leg age_owner.gph age_ent.gph educ.gph 

graph combine age_owner.gph age_ent.gph , ///
name("firstset", replace) ycommon cols(3)
graph combine educ.gph, ///
name("secondset", replace) ycommon cols(4)
graph combine firstset secondset, ///
saving("age_edu_plot.gph", replace) ycommon cols(1)
graph export age_edu_plot.eps, replace


***Nature of enteprise
tab sec2_q2, missing


//pie chart making  (Overall village)

#delimit ;
graph pie, over( sec2_q2 )
     pie(1, color(blue)) 
     pie(2, color(orange)) 
     plabel(_all percent, format(%9.1f))       
;
#delimit cr
graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\nature_overall.gph", replace

//pie chart making  (By NEFF village)

#delimit ;
graph pie, over(sec2_q2) 
                   by(neff_vill, title("Nature of enteprise by village") note(" ")) 
     pie(1, color(blue)) 
     pie(2, color(orange)) 
     plabel(_all percent, format(%9.1f))       
;
#delimit cr
graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\Ent_nature_Graph.gph", replace	 

//sec3_q4: Where is the enterprise operated from?

#delimit ;
graph bar, over(sec3_q4)             
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(blue))
     bar(2, color(orange))
                   ytitle("Percent")
;
#delimit cr
graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\enterprise_operation.gph"



//gender

foreach var of varlist f_ent {
    ttest `var', by(neff_vill)
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using new.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay  annotate(stars) asymbol(*,**) 
}

				 
**Registation status: sec3_q2 sec3_q2_1 sec3_q2_a

//sec3_q2

tab sec3_q2  //Whether the enterprise is registered?
tab sec3_q2_1, m //Whether enterprise is registered with Udyam Aadhar?

*What is the type of registration? : sec3_q2_a 
lab var single_owner "Whether the enterprise is owned by a single person"


foreach var of varlist single_owner {
    ttest `var', by(neff_vill)
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using new.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay  annotate(stars) asymbol(*,**) 
}




//Whether the enterprise operations are seasonal or annual in nature? : sec3_q7 


tab sec3_q7, m

/*
Whether the enterprise operations are |
          seasonal or annual in nature? |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                     Seasonal( பருவகால) |        		 14        2.43        2.43
Operational throughout the year( ஆண்டு  |        		563       97.57      100.00
----------------------------------------+-----------------------------------
                                  Total |        577      100.00

*/
**owner and firm characteristics

foreach var of varlist age_entrepreneur f_ent sec4_q6 sec3_q7 sec3_q2 udyam_registration single_owner {
    ttest `var', by(neff_vill)
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using firm_ent_charcterstics.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay  annotate(stars) asymbol(*,**) 
}


***loan***

#delimit ;
graph bar, over(formal_loan_source) over(neff_vill) 
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(red) lw(thin) fi(100))
     bar(2, color(green) lw(thin) fi(100))
                   ytitle("Percent")
                   title("Access of loan from formal financial institution")
;
#delimit cr

graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\formal_loan.gph", replace


foreach var of varlist sec8_q1 count_loan formal_loan_source total_loan_received w10_avg_int_rate {
    ttest `var', by(neff_vill)
    
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using loan.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay
}



*Investment (Pre-NEFF) only takes value of 2023 and 2022.


foreach var of varlist  pre_neff_invest tot_pre_neff_invest {
	ttest `var', by(neff_vill)
	scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using invest.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay
}



		  
#delimit ;
graph bar, over(pre_neff_invest) over(neff_vill) 
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(red) lw(thin) fi(100))
     bar(2, color(green) lw(thin) fi(100))
                   ytitle("Percent")
                   title("Investment Status (pre-NEFF) by Village")
;
#delimit cr

//Type of investment
graph bar sec7_q7_a_1 sec7_q7_a_2 sec7_q7_a_3 sec7_q7_a_4, ///
     bar(1, color(blue)) bar(2, color(red)) bar(3, color(green)) bar(4, color(purple)) ///
     bar(5, color(orange)) bar(6, color(pink)) bar(7, color(yellow)) bar(8, color(brown)) ///
     blabel(bar, format(%9.1f) ) ///
     title("Percentage of 1s in Each Dummy Variable") ///
     ytitle("Percentage") ///
     legend(order(1 "Working Capital" 2 "Asset Creation" 3 "Debt Reduction" 4 "sec7_q7_a_4"))


*Enterprise cost (most recent cost), taking winsorized

foreach var of varlist w10_ecost_1 w10_revenue_1 w10_profit_1 w10_rec_profit{
    ttest `var', by(neff_vill)
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using RCP.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay  annotate(stars) asymbol(*,**) 
}


//Asset value 
foreach var of varlist owned_asset_value percieved_asset_value monthly_asset_value {
    ttest `var', by(neff_vill)
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using asset_value.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay  annotate(stars) asymbol(*,**) 
}




//OSF service
sec15_q1 sec15_q2


tab sec15_q1 if neff_vill == 1
/*
    Are you |
   aware of |
    the One |
       Stop |
   Facility |
      (OSF) |
    centre? |      Freq.     Percent        Cum.
------------+-----------------------------------
No ( இல்லை) 	|     	 322       90.45       90.45
 Yes ( ஆம்) 	|        34        9.55      100.00
------------+-----------------------------------
      Total |        356      100.00

*/


tab sec15_q1 if neff_vill == 0
/*
    Are you |
   aware of |
    the One |
       Stop |
   Facility |
      (OSF) |
    centre? |      Freq.     Percent        Cum.
------------+-----------------------------------
No ( இல்லை) 	|        213       96.38       96.38
 Yes ( ஆம்) 	|          8        3.62      100.00
------------+-----------------------------------
      Total |        221      100.00
*/


//Bargraph (Overall)
#delimit ;
graph bar, over(sec15_q1) 
                   
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(blue))
     bar(2, color(orange))
                   ytitle("Percent")
                   title("Awarness")
;
#delimit cr

graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\osf_awarness.gph", replace

//Bargraph (By village)

#delimit ;
graph bar, over(sec15_q1) 
                   over(neff_vill) 
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(blue))
     bar(2, color(orange))
                   ytitle("Percent")
                   title("Awarness")
;
#delimit cr

graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\neff_osf.gph", replace

*combining OSF Awarness

grc1leg osf_awarness.gph neff_osf.gph

**Have you utilized OSF atleast once?
tab sec15_q2, m
/*
   Have you |
utilized at |
  least one |
        OSF |
   service? |      Freq.     Percent        Cum.
------------+-----------------------------------
No ( இல்லை) 	|         35        6.07        6.07
 Yes ( ஆம்) 	|          7        1.21        7.28
          . |        535       92.72      100.00
------------+-----------------------------------
      Total |        577      100.00
*/


//Bargraph (Overall)
#delimit ;
graph bar, over(osf_utilise) 
                   
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(blue))
     bar(2, color(orange))
                   ytitle("Percent")
                   title("Utilisation")
;
#delimit cr

graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\osf_utilisation.gph", replace

//Bargraph (By village)

#delimit ;
graph bar, over(sec15_q1) 
                   over(neff_vill) 
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(blue))
     bar(2, color(orange))
                   ytitle("Percent")
                   title("utilisation")
;
#delimit cr


graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\neff_utilise.gph", replace

*combining OSF Utilisationgraphs


*combining OSF Utilisationgraphs

grc1leg osf_utilisation.gph neff_utilise.gph
graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\osf_utlisation_combine.gph", replace



//Business skills and practices  (Total 22 variables)

egen bps = rowtotal(sec17_q1_a sec17_q1_b sec17_q1_c sec17_q1_d sec17_q1_e sec17_q1_f ///
                   sec17_q2_1 sec17_q2_2 sec17_q2_3 sec17_q2_4 sec17_q2_5 				///
                   sec17_q3 sec17_q4 sec17_q5 											///
                   sec17_q7 sec17_q8 sec17_q9 sec17_q10 sec17_q11 						///
                   sec17_q14 sec17_q15 sec17_q16 ) // Corrected variable name

la var bps "Business skill and practices"

foreach var of varlist sec17_q1_a sec17_q1_b sec17_q1_c sec17_q1_d sec17_q1_e sec17_q1_f sec17_q2_1 sec17_q2_2 sec17_q2_3 sec17_q2_4 sec17_q2_5 sec17_q3 sec17_q4 sec17_q5 sec17_q7 sec17_q8 sec17_q9 sec17_q10 sec17_q11 sec17_q14 sec17_q15 sec17_q16  {
	tab `var'

}






//Digital payment and CIBIL Score

tab sec17_q16 if neff_vill==1
/*
Do you have |
  a digital |
    payment |
 collection |
   solution |
   (QR code |
etc)? (Ippo |
  Pay, Phon |      Freq.     Percent        Cum.
------------+-----------------------------------
No ( இல்லை) 	|        276       77.53       77.53
 Yes ( ஆம்) 	|         80       22.47      100.00
------------+-----------------------------------
      Total |        356      100.00
*/

tab sec17_q16 if neff_vill==0

/*
Do you have |
  a digital |
    payment |
 collection |
   solution |
   (QR code |
etc)? (Ippo |
  Pay, Phon |      Freq.     Percent        Cum.
------------+-----------------------------------
No ( இல்லை) 	|        188       85.07       85.07
 Yes ( ஆம்) 	|         33       14.93      100.00
------------+-----------------------------------
      Total |        221      100.00

.*/ 
#delimit ;
graph bar, over(sec17_q16) over(neff_vill) 
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(red) lw(thin) fi(100))
     bar(2, color(green) lw(thin) fi(100))
                   ytitle("Percent")
                   title("Digital payment collection solution status by Village")
;
#delimit cr

graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\digital_payment.gph"

//CIBIL awarness
tab sec19_q1 if neff_vill == 1
/*
    Are you |
   aware of |
CIBIL score |
    (Credit |
     bureau |
    score)? |      Freq.     Percent        Cum.
------------+-----------------------------------
No ( இல்லை) 	|        271       76.12       76.12
 Yes ( ஆம்) 	|         85       23.88      100.00
------------+-----------------------------------
      Total |        356      100.00
*/

tab sec19_q1 if neff_vill == 0
/*
    Are you |
   aware of |
CIBIL score |
    (Credit |
     bureau |
    score)? |      Freq.     Percent        Cum.
------------+-----------------------------------
No ( இல்லை) 	|        183       82.81       82.81
 Yes ( ஆம்) 	|         38       17.19      100.00
------------+-----------------------------------
      Total |        221      100.00
*/

#delimit ;
graph bar, over(sec19_q1) over(neff_vill) 
     asyvars 
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(red) lw(thin) fi(100))
     bar(2, color(green) lw(thin) fi(100))
                   ytitle("Percent")
                   title("Credit bureau score status by Village")
;
#delimit cr
graph save "Graph" "V:\Projects\TNRTP\Data\Baseline\Baseline report\analysis\descriptive stat\credit_aware.gph", replace

grc1leg credit_aware.gph digital_payment.gph

graph combine credit_aware.gph, ///
name("firstset", replace) ycommon cols(3)
graph combine digital_payment.gph, ///
name("secondset", replace) ycommon cols(4)
graph combine firstset secondset, ///
saving("digital_cibil_plot.gph", replace) ycommon cols(1)
graph export digital_cibil_plot.eps, replace

**NEFF value proposition


foreach var of varlist sec13_q11_1 sec13_q11_2 sec13_q11_3 sec13_q11_4 sec13_q11_5 sec13_q11_6 sec13_q11_7 sec13_q11_8 {
	la define `var'_label 1	"Hiring"  2 "Wage increase" 3 "Purchase of new equipments and machinery" 4 "Purchase of raw materials" 5 "Introduction of new product or service" 6 "Being able to sell in new geography" 7 "Acquire a new shop" 8 "Being able to pay rent/electricity bill, etc."
	la value `var' `var'_label
}

#delimit ;
graph bar sec13_q11_1 sec13_q11_2 sec13_q11_3 sec13_q11_4 sec13_q11_5 sec13_q11_6 sec13_q11_7 sec13_q11_8,
     blabel(bar, format(%9.1f)) 
     percentages
     bar(1, color(red) lw(thin) fi(100))
     bar(2, color(green) lw(thin) fi(100))
                   ytitle("Percent")
                   title("NEFF value proposition")
;
#delimit cr



graph bar sec13_q11_1 sec13_q11_2 sec13_q11_3 sec13_q11_4 sec13_q11_5 sec13_q11_6 sec13_q11_7 sec13_q11_8, ///
     bar(1, color(blue)) bar(2, color(red)) bar(3, color(green)) bar(4, color(purple)) ///
     bar(5, color(orange)) bar(6, color(pink)) bar(7, color(yellow)) bar(8, color(brown)) ///
     blabel(bar, format(%9.1f%%)) ///
     title("Percentage of 1s in Each Dummy Variable") ///
     ytitle("Percentage") ///
     legend(order(1 "sec13_q11_1" 2 "sec13_q11_2" 3 "sec13_q11_3" 4 "sec13_q11_4" ///
                  5 "sec13_q11_5" 6 "sec13_q11_6" 7 "sec13_q11_7" 8 "sec13_q11_8"))

	graph bar sec13_q11_1 sec13_q11_2 sec13_q11_3 sec13_q11_4 sec13_q11_5 sec13_q11_6 sec13_q11_7 sec13_q11_8, ///
     bar(1, color(blue)) bar(2, color(red)) bar(3, color(green)) bar(4, color(purple)) ///
     bar(5, color(orange)) bar(6, color(pink)) bar(7, color(yellow)) bar(8, color(brown)) ///
     blabel(bar, format(%9.1f) ) ///
     title("Percentage of 1s in Each Dummy Variable") ///
     ytitle("Percentage") ///
     legend(order(1 "sec13_q11_1" 2 "sec13_q11_2" 3 "sec13_q11_3" 4 "sec13_q11_4" ///
                  5 "sec13_q11_5" 6 "sec13_q11_6" 7 "sec13_q11_7" 8 "sec13_q11_8"))



***Growth Perception

foreach var of varlist sec18_q1 sec18_q2 sec18_q3 sec18_q4 sec18_q5 sec18_q6 sec18_q7 {
    ttest `var', by(neff_vill)
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using growth_perception.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay  annotate(stars) asymbol(*,**) 
}


***Business Practices and Skills 

foreach var of varlist marketing_score record_keeping_score bp_score {
    ttest `var', by(neff_vill)
    scalar mean_`var' = (r(mu_1)*r(N_1) + r(mu_2)*r(N_2))/(r(N_1) + r(N_2))
    scalar obs_`var' = r(N_1) + r(N_2)
    scalar mean_`var'_0 = r(mu_1)
    scalar obs_`var'_0 = r(N_1)
    scalar mean_`var'_1 = r(mu_2)
    scalar obs_`var'_1 = r(N_2)
    scalar diff_`var' = r(mu_1) - r(mu_2)
    scalar diff_se_`var' = r(se)
    scalar diff_p_l_`var' = r(p_l)
    scalar diff_p_u_`var' = r(p_u)

    mat dir_`var' = (mean_`var', obs_`var', mean_`var'_0, obs_`var'_0, ///
                     mean_`var'_1, obs_`var'_1, diff_`var', diff_se_`var', ///
                     diff_p_l_`var', diff_p_u_`var')
    mat colnames dir_`var' = Mean_all N_all Mean_NoNEFF N_0 Mean_NEFF N_1 ///
                             Mean_difference stderror_difference pvalue_l pvalue_u
    mat rownames dir_`var' = `var'

    frmttable using bps.rtf, replace statmat(dir_`var') sdec(2) varlabels append ///
        dwide nocenter hlines(1) nodisplay  annotate(stars) asymbol(*,**) 
}







