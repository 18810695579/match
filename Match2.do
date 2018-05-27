

*******************************Apple Midterm Report****************************
*							Original data from He Jing's emal on April 10, 2018

*		DATASET 			"Apple_B_M_ALL.dta"
*		do file				Apple_MidtermReport_RCT.do


capture	clear
clear 	matrix
clear	mata
set		maxvar	20000
set		memo 10g
set		more off
/*
global	dtadir	"D:\Health\Apple-Migrant-Female-Health\Midterm survey\Data\CleanData\"
global	workdir		"D:\Health\Apple-Migrant-Female-Health\Report\Midline Report\workdir\"	
global	rdir	"D:\Health\Apple-Migrant-Female-Health\Report\Midline Report\Results\"
*/
global	dtadir	"C:\Users\TOMORROW\Desktop\match"	
global	workdir		"C:\Users\TOMORROW\Desktop\match"	
global	rdir	"C:\Users\TOMORROW\Desktop\match"	

/////////////////////////////////////////////////////////////////////////////////////////
use		"$workdir\Apple_B_M_ALL_BTest_Matched.dta",clear

//Step 1 define outcome variables
//Knowledge
*Correct rate of all items in Module 1 and module 2
gen 	correctrate_B = (wm_071_sum_B+wm_072_sum_B)/10 *100
gen 	correctrate_M = wm_072_sum_M/20*100
label	var correctrate_B "Correct rate of all items at baseline,%"
label	var correctrate_M"Correct rate of all items at midline,%"

*Correct rate of common items in baseline survey and endline survey
tab1	wm_0701_B wm_0702_B wm_0704_B wm_0705_B wm_0706_B wm_0707_B wm_0709_B
gen 	correctrate1_B = 0
foreach 	var of varlist wm_0701_B wm_0702_B wm_0705_B wm_0707_B wm_0709_B {
			replace	correctrate1_B=correctrate1_B + 1 if `var' == 0|`var' == 2
			}
foreach var of varlist wm_0704_B wm_0706_B {
			replace	correctrate1_B=correctrate1_B + 1 if `var' == 1
			}
label	var correctrate1_B "Correct rate of common items at baseline, %"
tab1	wm_07201_M wm_07202_M wm_07206_M wm_07210_M wm_07211_M wm_07213_M wm_07217_M
gen 	correctrate1_M = 0
foreach 	var of varlist  wm_07202_M wm_07206_M wm_07213_M wm_07217_M {
		replace	correctrate1_M=correctrate1_M + 1 if `var' == 0|`var' == 2
		}
foreach var of varlist wm_07201_M wm_07210_M wm_07211_M {
		replace	correctrate1_M=correctrate1_M + 1 if `var' == 1
		}
replace		correctrate1_B = correctrate1_B /7 *100
replace		correctrate1_M = correctrate1_M /7 *100

label	var correctrate1_M "Correct rate of common items at midline, %"
tabstat	correctrate_B correctrate_M correctrate1_B correctrate1_M,by(treatment) stats(mean sd)

global	K_B 	correctrate_B  correctrate1_B
global	K_M   	correctrate_M  correctrate1_M

//Attitude toward gynecological diseases
tab1	wm_052_sum_B wm_052_sum_M
tabstat	wm_052_sum_M,by(treatment) stats(mean sd n)

//Incidence of gynecological disease and health care utilization
global	INCI_B wm_0310101_B  wm_0310201_B  wm_0310301_B ///
		 wm_0310401_B wm_0310501_B  wm_0310601_B ///
		 wm_0310701_B  wm_0320101_B  wm_0320201_B ///
		 wm_0320301_B  wm_0320401_B 
global	USE_B wm_0310102_B  wm_0310202_B wm_0310302_B  ///
		wm_0310402_B wm_0310502_B wm_0310602_B ///
		wm_0310702_B  wm_0320102_B  wm_0320202_B ///
		wm_0320302_B wm_0320402_B


global	INCI1_M wm_0310101_M  wm_0310201_M  wm_0310301_M ///
		 wm_0310401_M wm_0310501_M  wm_0310601_M ///
		 wm_0310701_M  
		 
global	USE1_M wm_0310102_M  wm_0310202_M wm_0310302_M  ///
		wm_0310402_M wm_0310502_M wm_0310602_M ///
		wm_0310702_M  
global	INCI2_M wm_0320101_M  wm_0320201_M ///
		 wm_0320301_M  wm_0320401_M 
global	USE2_M wm_0320102_M  wm_0320202_M ///
		wm_0320302_M wm_0320402_M	
		
sum		$INCI_M  $USE_M
tabstat	$INCI1_M $INCI2_M,by(treatment) stats(mean) format(%9.2f)
tabstat	$USE1_M $USE2_M,by(treatment) stats(mean) format(%9.2f)

tab1	wm_03301_M wm_03302_M,mi nolabel
	

//Gallop top answer
foreach a in  "B" "M" {
	gen wm_10_sum_top_`a' = 0
	gen  wm_10basic_sum_top_`a'=0
	gen  wm_10personal_sum_top_`a'=0
	gen  wm_10group_sum_top_`a'=0
	gen  wm_10long_sum_top_`a'=0
}
foreach a in  "B" "M" {	
	foreach 	num of numlist 1(1)9 {
			destring wm_100`num'_`a',replace force
			gen 	wm_100`num'_t_`a' = (wm_100`num'_`a' == 4|wm_100`num'_`a' == 5)
			replace	wm_100`num'_t_`a' = . if  wm_100`num'_`a' <1 |  wm_100`num'_`a' > 5
			}
	}
	
foreach a in  "B" "M" {				
	foreach 	num of numlist 10(1)12 {
			destring wm_10`num'_`a',replace force
			gen 	wm_10`num'_t_`a' = (wm_10`num'_`a' == 4|wm_10`num'_`a' == 5)
			replace	wm_10`num'_t_`a' = . if  wm_10`num'_`a' <1 |  wm_10`num'_`a' > 5
			}
	}
	

foreach a in  "B" "M" {	
	gen 	wm_10_sum_t_`a'	= 0
	foreach 	num of numlist 1(1)9 {
		replace	wm_10_sum_t_`a' = wm_10_sum_t_`a'+wm_100`num'_t_`a'
		replace	wm_10_sum_t_`a' = . if wm_100`num'_t_`a' == .
		}
	replace		wm_10_sum_t_`a' =wm_10_sum_t_`a'/12
	gen 	wm_10_basic_sum_t_`a'=(wm_1001_t_`a'+wm_1002_t_`a')/2
	gen 	wm_10_personal_sum_t_`a'= (wm_1003_t_`a'+wm_1004_t_`a'+wm_1005_t_`a'+wm_1006_t_`a')/4
	gen 	wm_10_group_sum_t_`a'= (wm_1007_t_`a'+wm_1008_t_`a'+wm_1009_t_`a'+wm_1010_t_`a')/4
	gen 	wm_10_long_sum_t_`a'=(wm_1011_t_`a'+wm_1012_t_`a')/2
}
	

foreach a in  "B" "M" {	
	global	TOP_`a' wm_10_basic_sum_t_`a'  wm_10_personal_sum_t_`a' wm_10_group_sum_t_`a'  wm_10_long_sum_t_`a'
	}
	

//Willingness to stay on
global	STAY_B	wm_01107_B wm_01108_B wm_01109_B
global	STAY_M 	wm_01107_M wm_01108_M wm_01109_M
sum		$STAY_B $STAY_M
tab1	$STAY_M
replace	wm_01108_M = 0 if wm_01107_M == 0
replace	wm_01109_M = 0 if wm_01107_M == 0|wm_01108_M == 0 
replace	wm_01108_M = . if wm_01108_M == 3
tabstat	$STAY_M, by(treatment) stats(mean) format(%9.2f)


//Step 2 Compliance
replace		wm_120201_M = . if wm_120201_M == 5
tab			wm_120101_M wm_120201_M,mi
gen 		treated = 0
replace 		treated = 1 if wm_120101_M == 1 | wm_120201_M == 1					// trained by any PHE at any time
replace		treated = . if wm_120101_M == . & wm_120201_M == .
//Figure 1	Compliance of Random Assignment of HERhealth program 
tab 		treatment treated,row												
bysort	factory: tab 		treatment treated,row												


//Step 3 impact of HERhealth program-regression with covariates that were unbalanced at baseline survey
*define common covariates 
global	COVARIATES age married hs college homeprovince expmths dl morethan5 insured asset boarding renting factory2 factory3
save "$workdir\Apple_B_M_ALL_BTest_Matched1.dta",replace
*Table 1 Impact of HERhealth Program on Women Workers' Knowledge about Reproductive System and Gynocological Diseases
*Panel A
eststo	clear
foreach name in  "correctrate" "correctrate1" {
	xi: reg	`name'_M treatment $COVARIATES   i.factory,cluster(department_k)
	est store `name'_M
	}
esttab  $K_M  ///
		using "$rdir/T11.csv", ///
		nolabel b(3) p(3) r2(3)   star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace	
 
*Panel B
eststo	clear
foreach  name in  "correctrate" "correctrate1"  {
	xi: ivregress 2sls	`name'_M  $COVARIATES  i.factory (treated=treatment),cluster(department_k) 
	est store `name'_M
	}
esttab  $K_M  ///
		using "$rdir/T1.csv", ///
		nolabel b(3) p(3) r2(3)   star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append

	
*Table 2 Impact of HERhealth Program on Incidences of Symptoms of Possible Gynocological Diseases among Women Workers
*Panel A
eststo	clear
foreach name in  wm_0310101  wm_0310201  wm_0310301 wm_0310401 wm_0310501  wm_0310601  wm_0310701  {
	xi: reg	`name'_M treatment $COVARIATES   i.factory,cluster(department_k)
	est store `name'_M
	}
esttab  $INCI1_M  ///
		using "$rdir/T2.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace	
 
*Panel B
eststo	clear
foreach  name in  wm_0310101  wm_0310201  wm_0310301 wm_0310401 wm_0310501  wm_0310601  wm_0310701   {
	xi: ivregress 2sls	`name'_M  $COVARIATES  i.factory (treated=treatment),cluster(department_k)
	est store `name'_M
	}
esttab  $INCI1_M  ///
		using "$rdir/T2.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append


*Table 3 Impact of HERhealth Program on Incidences of Symptoms of Abnormal Menstruation among Women Workers
*Panel A
eststo	clear
foreach name in  wm_0320101  wm_0320201  wm_0320301  wm_0320401 {
	xi: reg	`name'_M treatment $COVARIATES   i.factory,cluster(department_k)
	est store `name'_M
	}
esttab  $INCI2_M  ///
		using "$rdir/T3.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace	
 
*Panel B
eststo	clear
foreach  name in  wm_0320101  wm_0320201  wm_0320301  wm_0320401  {
	xi: ivregress 2sls	`name'_M  $COVARIATES  i.factory (treated=treatment),cluster(department_k)
	est store `name'_M
	}
esttab  $INCI2_M  ///
		using "$rdir/T3.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append
		
		
		
*Table 4 Impact of HERhealth Program on Possibility of Seeking Medical due to Symptoms of Possible Gynecological Diseases
*Panel A
eststo	clear
xi: reg		wm_03302_M treatment $COVARIATES wm_01120_B i.factory ,cluster(department_k)
est	store	wm_03302_M
foreach name in  wm_0310102  wm_0310202 wm_0310302  wm_0310402 wm_0310502 wm_0310602 wm_0310702  {
	xi: reg	`name'_M treatment   i.factory,cluster(department_k)
	est store `name'_M
	}

esttab  wm_03302_M $USE1_M  ///
		using "$rdir/T4.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace	
 
*Panel B
eststo	clear
xi: ivregress 2sls		wm_03302_M $COVARIATES wm_01120_B i.factory   (treated=treatment),cluster(department_k)
est	store	wm_03302_M
foreach  name in  wm_0310102  wm_0310202 wm_0310302  wm_0310402 wm_0310502 wm_0310602 wm_0310702   {
	xi: ivregress 2sls	`name'_M  $COVARIATES  i.factory  (treated=treatment),cluster(department_k)
	est store `name'_M
	}

esttab  wm_03302_M $USE1_M   ///
		using "$rdir/T4.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append
		
		

*Table 5 Impact of HERhealth Program on Possibility of Seeking Medical due to Abnormal Menstruation
*Panel A
eststo	clear
foreach name in  wm_0320102  wm_0320202 	wm_0320302 wm_0320402 {
	xi: reg	`name'_M treatment   i.factory,cluster(department_k)
	est store `name'_M
	}

esttab  $USE2_M  ///
		using "$rdir/T5.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace	
 
*Panel B
eststo	clear
foreach  name in  wm_0320102  wm_0320202 	wm_0320302 wm_0320402   {
	xi: ivregress 2sls	`name'_M  $COVARIATES  i.factory  (treated=treatment),cluster(department_k)
	est store `name'_M
	}

esttab $USE2_M   ///
		using "$rdir/T5.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append
	
	
*Table 6 Impact of HERhealth Program on Women Workers' Attitude toward the Incidence of Gynecological Diseases
*Panel A
eststo	clear
xi: reg		wm_052_sum_M treatment $COVARIATES i.factory ,cluster(department_k)
est	store	wm_052_sum_M_OLS
 
esttab  wm_052_sum_M_OLS   ///
		using "$rdir/T6.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace
		
*Panel B
eststo	clear
xi: ivregress 2sls		wm_052_sum_M $COVARIATES i.factory   (treated=treatment),cluster(department_k)
est	store	wm_052_sum_M_IV

esttab  wm_052_sum_M_IV  ///
		using "$rdir/T6.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append

		
*Table 7 Impact of HERhealth Program on Women Workers' Work Engagement
*Panel A
eststo	clear
foreach name in  wm_10_basic_sum_t  wm_10_personal_sum_t wm_10_group_sum_t  wm_10_long_sum_t  {
	xi: reg	`name'_M treatment $COVARIATES   i.factory,cluster(department_k)
	est store `name'_M
	}
esttab  $TOP_M  ///
		using "$rdir/T7.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace	
 
*Panel B
eststo	clear
foreach  name in   wm_10_basic_sum_t  wm_10_personal_sum_t wm_10_group_sum_t  wm_10_long_sum_t   {
	xi: ivregress 2sls	`name'_M  $COVARIATES  i.factory (treated=treatment),cluster(department_k)
	est store `name'_M
	}
esttab  $TOP_M  ///
		using "$rdir/T7.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append

		
*Table 8 Impact of HERhealth Program on Women Workers' Willingness to Stay On
eststo	clear
foreach name in  wm_01107 wm_01108 wm_01109  {
	xi: reg	`name'_M treatment $COVARIATES   i.factory,cluster(department_k)
	est store `name'_M
	}
esttab  $STAY_M  ///
		using "$rdir/T8.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treatment)  ///
		replace	
 
*Panel B
eststo	clear
foreach  name in  wm_01107 wm_01108 wm_01109  {
	xi: ivregress 2sls	`name'_M  $COVARIATES  i.factory (treated=treatment),cluster(department_k)
	est store `name'_M
	}
esttab  $STAY_M  ///
		using "$rdir/T8.csv", ///
		nolabel b(3) p(3) r2(3)    star(* 0.10 ** 0.05 *** 0.01) obslast ///
		nogap noeqlines nonote nolines keep(treated)  ///
		append

***************************************************************************************
***********************2018-05-25********************
******************Heterogeneous Effect***************
********************STARTS FORM HERE*****************

************************IMPACT OF Outcome Variables
**************************************************************************************
//Table 1. Heterogeneous effect of age on Outcome Variables 

use "$workdir\Apple_B_M_ALL_BTest_Matched1.dta" ,clear
tabstat wm_07_sum_B , stats(p25)  //后25%分位数是15
gen back25_wm_07_sum_B=.   //生成基线知识测试题的后25%变量
replace back25_wm_07_sum_B=1 if  wm_07_sum_B<=15
replace back25_wm_07_sum_B=0 if  wm_07_sum_B>15&wm_07_sum_B<25


global outcomes_B wm_051_sum_B wm_052_sum_B  wm_09_sum_B wm_10_sum_B    //关注的部分结果变量（基线）
global outcomes_M wm_052_sum_M_raw  wm_10_sum_M_raw                       //关注的部分结果变量（中线）
global heter age married hs college  dl back25_wm_07_sum_B                 //需要做交叉项的关键变量
global	COVARIATES  homeprovince expmths  morethan5 insured asset boarding renting factory2 factory3   //其他需要控制的变量
save "$workdir\Apple_B_M_ALL_BTest_Matched2.dta" ,replace
*Intention to Treat (just baseline)
use "$workdir\Apple_B_M_ALL_BTest_Matched2.dta" ,clear
eststo	clear
foreach var1 of varlist $heter  {
	gen inter_`var1' = _treated *`var1'
	foreach var of varlist  $outcomes_B $STAY_B  {
		qui	regress	`var' inter_`var1' _treated `var1' $COVARIATES   ,cluster(department_k)
		eststo
	}
	}
esttab	using T1.csv, 	///
		b(%10.2f) p(%10.4f) r2(%10.4f)  star(* 0.10 ** 0.05 *** 0.01) ///
		nogap noeqlines nonote nolines	 replace

*Intention to Treat	(just middleline)	
use "$workdir\Apple_B_M_ALL_BTest_Matched2.dta" ,clear		
eststo	clear
foreach var1 of varlist $heter  {
	gen inter_`var1' = _treated *`var1'
	foreach var of varlist  $outcomes_M $STAY_M {
		qui	regress	`var' inter_`var1' _treated `var1' $COVARIATES   ,cluster(department_k)
		eststo
	}
	}
esttab	using T2.csv, 	///
		b(%10.2f) p(%10.4f) r2(%10.4f)  star(* 0.10 ** 0.05 *** 0.01) ///
		nogap noeqlines nonote nolines	 replace
