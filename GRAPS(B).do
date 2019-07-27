clear 

set more off 
cap log close
cd "/Users/christiancarrillo/Documents/ACA_Opioid_research"
use "/Users/christiancarrillo/Documents/ACA_Opioid_research/NSDUH_beta.dta", clear

local xlist female black hispanic other_race metropolitan_area
global xlist female black hispanic other_race metropolitan_area

/// INSURANCE STATUS 

preserve 
collapse (mean) any_insurance private_insurance uninsured, by(treat22_25yr YEAR) 
graph twoway (line private_insurance YEAR if treat22_25yr == 1 & YEAR<= 2009,lcolor(red)) ///
(line private_insurance YEAR if treat22_25yr ==0 & YEAR <= 2009, lcolor(blue)) ///
(line private_insurance YEAR if treat22_25yr == 1 & YEAR >= 2011,lcolor(red)) ///
(line private_insurance YEAR if treat22_25yr == 0 & YEAR >= 2011, lcolor(blue)), legend (order (1 2) label(1 "Ages 22-25") ///
label(2 "Ages 25-29")) ytitle(Percent with Private Health Insurance) name(private_insurance,replace) scheme(plottig) 

graph export private_graph.pdf, replace 

graph twoway (line any_insurance YEAR if treat22_25yr == 1 & YEAR<= 2009,lcolor(red)) ///
(line any_insurance YEAR if treat22_25yr ==0 & YEAR <= 2009, lcolor(blue)) ///
(line any_insurance YEAR if treat22_25yr == 1 & YEAR >= 2011,lcolor(red)) ///
(line any_insurance YEAR if treat22_25yr == 0 & YEAR >= 2011, lcolor(blue)), legend (order (1 2) label(1 "Ages 22-25") ///
label(2 "Ages 25-29")) ytitle(Percent with Any Type of Health Insurance) name(any_insurance,replace) scheme(plottig)

graph export any_ins_graph.pdf, replace  

graph twoway (line uninsured YEAR if treat22_25yr == 1 & YEAR<= 2009,lcolor(red)) ///
(line uninsured YEAR if treat22_25yr ==0 & YEAR <= 2009, lcolor(blue)) ///
(line uninsured YEAR if treat22_25yr == 1 & YEAR >= 2011,lcolor(red)) ///
(line uninsured YEAR if treat22_25yr == 0 & YEAR >= 2011, lcolor(blue)), legend (order (1 2) label(1 "Ages 22-25") ///
label(2 "Ages 25-29")) ytitle(Percent of Uninsured individuals) name(uninsured,replace) scheme(plottig)

graph export uninsured_graph.pdf, replace 

restore 

/// Opioid Use Disorders 
preserve 
collapse (mean) painreleiver_misuse_12m  painreleiver_30d anl_abuse_dependence , by( treat22_25yr YEAR)

graph twoway (line painreleiver_misuse_12m YEAR if treat22_25yr == 1 & YEAR<= 2009,lcolor(red) lwidth(thick)) ///
(line painreleiver_misuse_12m YEAR if treat22_25yr ==0 & YEAR <= 2009, lcolor(blue) lwidth(thick)) ///
(line painreleiver_misuse_12m YEAR if treat22_25yr == 1 & YEAR >= 2011,lcolor(red) lwidth(thick)) ///
(line painreleiver_misuse_12m YEAR if treat22_25yr == 0 & YEAR >= 2011, lcolor(blue) lwidth(thick)), legend (order (1 2) label(1 "Ages 22-25") ///
label(2 "Ages 26-29")) title("Opioid Misuse - Past Year") ytitle(Percent) name( misuse_12m,replace) scheme(plottig)

graph twoway (line painreleiver_30d YEAR if treat22_25yr == 1 & YEAR<= 2009,lcolor(red) lwidth(thick)) ///
(line painreleiver_30d YEAR if treat22_25yr ==0 & YEAR <= 2009, lcolor(blue) lwidth(thick)) ///
(line painreleiver_30d YEAR if treat22_25yr == 1 & YEAR >= 2011,lcolor(red) lwidth(thick)) ///
(line painreleiver_30d YEAR if treat22_25yr == 0 & YEAR >= 2011, lcolor(blue) lwidth(thick)), legend (order (1 2) label(1 "Ages 22-25") ///
label(2 "Ages 26-29")) title("Opioid MIsuse - Past Month") ytitle(Percent) name( misuse_30d,replace) scheme(plottig)

graph twoway (line anl_abuse_dependence YEAR if treat22_25yr == 1 & YEAR<= 2009,lcolor(red) lwidth(thick)) ///
(line anl_abuse_dependence YEAR if treat22_25yr ==0 & YEAR <= 2009, lcolor(blue) lwidth(thick)) ///
(line anl_abuse_dependence YEAR if treat22_25yr == 1 & YEAR >= 2011,lcolor(red) lwidth(thick)) ///
(line anl_abuse_dependence YEAR if treat22_25yr == 0 & YEAR >= 2011, lcolor(blue) lwidth(thick)), legend (order (1 2) label(1 "Ages 22-25") ///
label(2 "Ages 26-29")) title("Opioid Dependence & Abuse") ytitle(Percent) name( abuse_dependence,replace) scheme(plottig)

restore 

**=============================== BAR GRAPHS *=================================*
/// Opioid Use Disorders- Summary Statistics 
graph bar painreleiver_misuse_12m painreleiver_30d anl_abuse_dependence, ///
over(treat22_25yr) title("Summary Statistics - Opioid Use Disorders Outcomes", span) ytitle("Percent") name(opioid_bae, replace)  scheme(plottig)

/// Treatment for Substance Use Disorders 

graph bar inpatient_drug_treat outpatient_drug_treat emergency_room opioid_treatment, ///
over(treat22_25yr) title("Summary Statistics - Settings for Drug Treatment", span) ytitle("Percent") name(Treatment_bar, replace)  scheme(plottig)

/// Treatment for Subs
** graph combine expan_any private_insurance uninsured opioid_12m opioid_dependence opioid_dependence opioid_ABUSE  opioid_ABUSE_DEPEN inpatient outpatient ERv_visits , cols(3) altshrink iscale(.9)
** above took from another page, does not belong here 

*** Margins Plot *** 

/// Opioid Use Disorders
qui: logit painreleiver_misuse_12m DD i.AGE2 i.YEAR $xlist, vce(cluster clustvar) 
eststo: margins, dydx(DD $xlist) post 
marginsplot, recast(scatter) horizontal plotopts (fintensity(* 0.10 ** 0.05)) xline(0)


qui: logit painreleiver_30d DD i.AGE2 i.YEAR $xlist, vce(cluster clustvar) 
eststo: margins, dydx(DD $xlist) post 
marginsplot, recast(scatter) horizontal plotopts (fintensity(* 0.10 ** 0.05)) xline(0)

qui: logit painreliever_dependence DD i.AGE2 i.YEAR $xlist, vce(cluster clustvar)
eststo: margins, dydx(DD $xlist) post
marginsplot, recast(scatter) horizontal plotopts (fintensity(* 0.10 ** 0.05)) xline(0)

/// Treatment for Substance Use Disorders

qui: logit inpatient_drug_treat DD i.AGE2 i.YEAR $xlist, vce(cluster clustvar) 
eststo: margins, dydx(DD $xlist) post 
marginsplot, recast(scatter) horizontal plotopts (fintensity(* 0.10 ** 0.05)) xline(0)

qui: logit outpatient_drug_treat DD i.AGE2 i.YEAR $xlist, vce(cluster clustvar) 
eststo: margins, dydx(DD $xlist) post 
marginsplot, recast(scatter) horizontal plotopts (fintensity(* 0.10 ** 0.05)) xline(0)

qui: logit emergency_room DD i.AGE2 i.YEAR $xlist, vce(cluster clustvar) 
eststo: margins, dydx(DD $xlist) post 

qui: logit opioid_treatment DD i.AGE2 i.YEAR $xlist, vce(cluster clustvar) 
eststo: margins, dydx(DD $xlist) post 



