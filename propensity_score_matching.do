clear 
set more off 
cd "/Users/christiancarrillo/Documents/ACA_Opioid_research"
use "/Users/christiancarrillo/Documents/ACA_Opioid_research/NSDUH_beta.dta", clear

* Define treatment, outcome and independent vatiables 

global treatment treat22_25yr 
global ylist painreleiver_misuse_12m
global xlist female black hispanic other_race metropolitan_area
global breps 100 

describe $treatment $ylist $xlist 
summarize $treatment $ylist $xlist 

bysort $treatment: sum $ylist $xlist 

reg $ylist $treatment $xlist 

* Propensity Score Matching with common support
pscore $treatment $xlist, pscore(myscore) blockid(myblock) comsup  

* Look at different matching methods 
* Average Treatment Effect; nearest neighbor matching 

attnd $ylist $treatment $xlist, pscore(myscore) comsup boot reps($breps) dots 

* Radius Matching 

attr $ylist $treatment $xlist, pscore(myscore) comsup boot reps($breps) dots radius(0.1) 

* Kernel Matching 

attk $ylist $treatment $xlist, pscore(myscore) comsup boot reps($breps) dots 

* Stratification matching 

atts $ylist $treatment $xlist, pscore(myscore) blockid(myblock) comsup boot reps($breps) 
