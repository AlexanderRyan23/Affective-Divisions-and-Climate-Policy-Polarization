clear 

/***********************************************************

The cumulative GLES panel data set (waves 1–21) was structured so that the first nine waves consisted of one data file and were then added separately for each addition wave. We therefore use wave 10 as the master data set and then append the individual data sets (waves 11–29 and 1-9) before data cleaning. 

All data sets are downloaded from the German Longitudinal Election Study and the GLES Panel: https://www.gesis.org/en/gles/data-and-documentation

Waves 1-9 constitute one data set, whereas waves 10-29 are separate data sets. However, we reshaped the data set for waves 1-9 to long a format before appending it below. 

************************************************************/

global data "C:\path\to\your\data"

use "$data/Germany_W10.dta" 

append using "$data/Germany_W11.dta"
append using "$data/Germany_W12.dta"
append using "$data/Germany_W13.dta"
append using "$data/Germany_W14.dta"
append using "$data/Germany_W15.dta"
append using "$data/Germany_W16.dta"
append using "$data/Germany_W17.dta"
append using "$data/Germany_W18.dta"
append using "$data/Germany_W19.dta"
append using "$data/Germany_W20.dta"
append using "$data/Germany_W22.dta"
append using "$data/Germany_W23.dta"
append using "$data/Germany_W24.dta"
append using "$data/Germany_W25.dta"
append using "$data/Germany_W26.dta"
append using "$data/Germany_W27.dta"
append using "$data/Germany_W28.dta"
append using "$data/Germany_W29.dta"

* This is to add the wave indicator in the appended waves. They were already generated for waves 1–9 when reshaping to a long format (see the do-file for waves 1–9)
gen Wave = .

foreach w in 10 11 12 13 14 15 16 17 18 19 20 22 23 24 25 26 27 28 29 {
    replace Wave = `w' if !missing(kp`w'_430a)
}

* Appending the data set for waves 1–9

append using "$data/GLES_W1_W9_Long"

/****************************************************************

generating the variables in the appended data frame with all waves

****************************************************************/

* Party like-dislike. We perform two sections of code since the prefixes are different in waves 1-9 and 10-29. 

local parties  "CDU CSU SPD FDP Green Linke AFD"

foreach p of local parties {
    gen Like_`p' = .
}

local letters  "a b c d e f i"

local i = 1

foreach p of local parties {
    local l : word `i' of `letters' 
	replace Like_`p' = kp_430`l' - 1 if inrange(kp_430`l', 1, 11)
    local ++i
}

local parties  "CDU CSU SPD FDP Green Linke AFD"
local letters  "a b c d e f i"

forvalues w = 10/29 {
    local i = 1
    foreach p of local parties {
        local l : word `i' of `letters'
        capture confirm variable kp`w'_430`l'
        if !_rc {
            replace Like_`p' = kp`w'_430`l' - 1 ///
                if inrange(kp`w'_430`l', 1, 11)
        }
        local ++i
    }
}


* Left-right self-placement. Once again, first for waves 1-9 and then for waves 10-29 where the variable name has a separate prefix in each wave: kp10_1500, kp11_1500, and so forth. We rocde it from 1-11 to 0-10. 

gen LR_Self = kp_1500 - 1 ///
    if inrange(kp_1500, 1, 11)
	
forvalues w = 10/29 {
    capture replace LR_Self = kp`w'_1500 - 1 if inrange(kp`w'_1500, 1, 11)
}

* Vote choice. The ba suffix indicates that it refers to the second party vote (b) and the version without all other parties (a)

gen Vote =.

forvalues w = 10/29 {
    capture replace Vote = kp`w'_190ba if kp`w'_190ba !=.
}

replace Vote = kp_190ba if inrange(Wave,1,9)

* Party identification

gen PID =.

forvalues w = 10/29 {
    capture replace PID = kp`w'_2090a if kp`w'_2090a !=.
}

replace PID = kp_2090a if inrange(Wave,1,9)

* Political interest

gen Interest =.

forvalues w = 10/29 {
    capture replace Interest = 6 - kp`w'_010 if inrange(kp`w'_010, 1, 5)
}

replace Interest = 6-kp_010 if inrange(kp_010,1,5) & inrange(Wave,1,9)

* Satisfaction with democracy 

gen Sat_Democracy =.

forvalues w = 10/29 {
    capture replace Sat_Democracy = 6 - kp`w'_020 if inrange(kp`w'_020, 1, 5)
}

replace Sat_Democracy = 6-kp_020 if inrange(kp_020,1,5) & inrange(Wave,1,9)

* Saliency on the climate change question (different from position on the item, which we use)

gen Climate_Saliency =.

forvalues w = 10/29 {
    capture replace Climate_Saliency = 6 - kp`w'_1300 if inrange(kp`w'_1300, 1, 5)
}

replace Climate_Saliency = 6-kp_1300 if inrange(kp_1300,1,5) & inrange(Wave,1,9)

* Evaluation of Pt:s own current economic circumstances 

gen Economy_Self =.

forvalues w = 10/29 {
    capture replace Economy_Self = 6 - kp`w'_780 if inrange(kp`w'_780, 1, 5)
}

replace Economy_Self = 6-kp_780 if inrange(kp_780,1,5) & inrange(Wave,1,9)

* Evaluation of economic circumstances for the country

gen Eco_Country =.

forvalues w = 10/29 {
    capture replace Eco_Country = 6 - kp`w'_820 if inrange(kp`w'_820, 1, 5)
}

replace Eco_Country = 6-kp_820 if inrange(kp_820,1,5) & inrange(Wave,1,9)

* Attitudes about economic redistribution and social services 

gen Taxes =.

forvalues w = 10/29 {
    capture replace Taxes = kp`w'_1090 if inrange(kp`w'_1090, 1, 7)
}

replace Taxes = kp_1090 if inrange(kp_1090,1,7) & inrange(Wave,1,9)

* Pt:s placement on the immigration dimension

gen Imm_Self =.

forvalues w = 10/29 {
    capture replace Imm_Self = 8 - kp`w'_1130 if inrange(kp`w'_1130, 1, 7)
}

replace Imm_Self = 8-kp_1130 if inrange(kp_1130,1,7) & inrange(Wave,1,9)

* Placement of parties on climate dimension 

local parties  "CDU CSU SPD FDP Green Linke AFD"

foreach p of local parties {
    gen Env_`p' = .
}

local letters  "a b c d e f i"

local i = 1

foreach p of local parties {
    local l : word `i' of `letters'
    replace Env_`p' = 8-kp_1270`l' ///
        if inrange(kp_1270`l', 1, 7)
    local ++i
}

local parties  "CDU CSU SPD FDP Green Linke AFD"
local letters  "a b c d e f i"

forvalues w = 10/29 {
    local i = 1
    foreach p of local parties {
        local l : word `i' of `letters'
        capture confirm variable kp`w'_1270`l'

        if !_rc {

            replace Env_`p' = 8-kp`w'_1270`l' ///
                if inrange(kp`w'_1270`l', 1, 7)
        }
        local ++i
    }
}

* Self-placement on climate dimension 

gen Env_Growth =.

forvalues w = 10/29 {
    capture replace Env_Growth = 8-kp`w'_1290 if inrange(kp`w'_1290, 1, 7)
}

replace Env_Growth = 8-kp_1290 if inrange(kp_1290,1,7) & inrange(Wave,1,9)

* Region of residence. We assign values from wave 15 to observations during waves 16 to 19 when it is missing. 

gen Region =.

forvalues w = 1/29 {
    capture replace Region = kp`w'_2601 if kp`w'_2601 !=.
}

gen Region_15_A = Region if Wave == 15
bysort lfdn: egen region_15 = mean(Region_15_A) 

* Date variable for the start of the fieldwork in each wave. It is only used for a few graphs 

gen Date = .    

replace Date = date("2016-10-06", "YMD") if Wave == 1
replace Date = date("2017-02-16", "YMD") if Wave == 2
replace Date = date("2017-05-11", "YMD") if Wave == 3
replace Date = date("2017-07-06", "YMD") if Wave == 4
replace Date = date("2017-08-17", "YMD") if Wave == 5
replace Date = date("2017-09-04", "YMD") if Wave == 6
replace Date = date("2017-09-18", "YMD") if Wave == 7
replace Date = date("2017-09-27", "YMD") if Wave == 8
replace Date = date("2018-03-15", "YMD") if Wave == 9
replace Date = date("2018-11-06", "YMD") if Wave == 10
replace Date = date("2019-05-28", "YMD") if Wave == 11
replace Date = date("2019-11-05", "YMD") if Wave == 12
replace Date = date("2020-04-21", "YMD") if Wave == 13
replace Date = date("2020-11-03", "YMD") if Wave == 14
replace Date = date("2021-02-25", "YMD") if Wave == 15
replace Date = date("2021-05-06", "YMD") if Wave == 16
replace Date = date("2021-07-07", "YMD") if Wave == 17
replace Date = date("2021-08-11", "YMD") if Wave == 18
replace Date = date("2021-09-15", "YMD") if Wave == 19
replace Date = date("2021-09-29", "YMD") if Wave == 20
replace Date = date("2022-05-18", "YMD") if Wave == 22
replace Date = date("2022-10-12", "YMD") if Wave == 23
replace Date = date("2023-05-03", "YMD") if Wave == 24
replace Date = date("2023-10-11", "YMD") if Wave == 25
replace Date = date("2024-06-12", "YMD") if Wave == 26
replace Date = date("2024-09-24", "YMD") if Wave == 27
replace Date = date("2024-12-11", "YMD") if Wave == 28
replace Date = date("2025-01-16", "YMD") if Wave == 29

format Date %td



/**************************************************************************
                        Main analyses
**************************************************************************/

* Count number of waves for each unit
bysort lfdn: gen nwaves = _N

* Affective distance (polarization)
gen AP_Distance = Like_Green-Like_AFD

* Differences in position of parties on climate dimension 
gen Elite_Pol = Env_Green-Env_AFD

* All waves that include distance, climate attitudes, and elite polarization 

gen Full_Sample_A = 1 if inlist(Wave,2,4,7,11,13,14,15,18,19,24,27)


* These are the results for Table 1 in manuscript. Declare the dataset as time series cross-sectional and then the four regression models 

xtset lfdn Wave
est clear 

eststo: xtreg Env_Growth AP_Distance, fe vce(cluster lfdn)

eststo: xtreg Env_Growth AP_Distance Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.AP_Distance##c.Elite_Pol, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.AP_Distance##c.Elite_Pol Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

esttab, stats(N N_g r2_w, labels("Observations" "Units" "R2 (within)")) drop(*.Wave)

esttab using Table_1.rtf, se(3) b(3) sfmt(2) ///
    stats(N N_g r2_w, labels("Observations" "Units" "R-squared (within)") fmt(%9.0fc %9.0fc %9.3f)) ///
	varlabels(AP_Distance "Affective distance (AD)" Interest "Political interest" Taxes "Taxes/social services" Imm_Self "Immigration" ///
	Economy_Self "Egotropic economy" Eco_Country "Sociotropic economy" ///
	Elite_Pol "Perceived divergence (PD)" c.AP_Distance#c.Elite_Pol ///
	"AD*PD") varwidth(20) modelwidth(10) drop(*.Wave) replace


/***********************************************
Lenz test - affective distance as predictor
***********************************************/

/************************************************
           	   
		   2017 campaign */
		   	   
************************************************/

* The predictor variables are coded so that they are measured during the first wave (wave 1) for both observations. They are then used as predictors of climate change attitudes during waves 1 and 7. 
 
gen AD_1 = AP_Distance if Wave == 1
bysort lfdn: egen AD_L1 = mean(AD_1) 

* Indictor for whether the obs. refer to wave 1 or 7
gen Post_Dummy = 1 if Wave == 7 
replace Post_Dummy = 0 if Wave == 1

* Env_Growth = self-placement on climate change vs. growth
gen Env1A = Env_Growth if Wave == 1
gen Env7A = Env_Growth if Wave == 7
bysort lfdn: egen Env1 = mean(Env1A) 
bysort lfdn: egen Env7 = mean(Env7A)

* control variables measured during wave 1

gen Interest1A = Interest if Wave == 1
bysort lfdn: egen Interest1 = mean(Interest1A) 

gen Eco1A = Eco_Country if Wave == 1
bysort lfdn: egen Eco1 = mean(Eco1A)

gen Eco_Self1A = Economy_Self if Wave == 1
bysort lfdn: egen Eco_Self1 = mean(Eco_Self1A)

gen Taxes_1A = Taxes if Wave == 1
bysort lfdn: egen Taxes_1 = mean(Taxes_1A)

gen Imm_Self_1A = Imm_Self if Wave == 1
bysort lfdn: egen Imm_Self_1 = mean(Imm_Self_1A)

* Restricting analysis to Ps with values on the DV in both the pre- and postcampaign waves
egen Climate_Miss_1 = rownonmiss(Env1 Env7)

* Changes in elite polarization waves 2-7 

gen Elite_Pol_2A = Elite_Pol if Wave == 2
bysort lfdn: egen Elite_Pol_2 = mean(Elite_Pol_2A) 

gen Elite_Pol_7A = Elite_Pol if Wave == 7
bysort lfdn: egen Elite_Pol_7 = mean(Elite_Pol_7A) 

gen Change_1A = Elite_Pol_7-Elite_Pol_2
gen Change = 1 if inrange(Change_1A,1,12)
replace Change = 0 if inrange(Change_1A,-12,0)


/***********************************************
             2021 campaign */

************************************************

* Models 4-6. Predictors measured during wave 15. 

gen AD_15A = AP_Distance if Wave == 15
bysort lfdn: egen AD_L15 = mean(AD_15A)

gen Post_Dummy19 = 0 if Wave == 15 
replace Post_Dummy19 = 1 if Wave == 19

gen Env15A = Env_Growth if Wave == 15
bysort lfdn: egen Env15 = mean(Env15A) 

gen Env_19A = Env_Growth if Wave == 19
bysort lfdn: egen Env_19 = mean(Env_19A)

gen Interest15A = Interest if Wave == 15
bysort lfdn: egen Interest15 = mean(Interest15A) 

gen Eco_Self15A = Economy_Self if Wave == 15
bysort lfdn: egen Eco_Self15 = mean(Eco_Self15A)

gen Eco15A = Eco_Country if Wave == 15
bysort lfdn: egen Eco15 = mean(Eco15A)

gen Taxes_15A = Taxes if Wave == 15
bysort lfdn: egen Taxes_15 = mean(Taxes_15A)

gen Imm_Self_15A = Imm_Self if Wave == 15
bysort lfdn: egen Imm_Self_15 = mean(Imm_Self_15A)

egen Climate_Miss_2 = rownonmiss(Env15 Env_19)

* Changes in elite polarization waves 15 and 19 

gen Elite_Pol_15A = Elite_Pol if Wave == 15
bysort lfdn: egen Elite_Pol_15 = mean(Elite_Pol_15A) 

gen Elite_Pol_19A = Elite_Pol if Wave == 19
bysort lfdn: egen Elite_Pol_19 = mean(Elite_Pol_19A) 

gen Change_19A = Elite_Pol_19-Elite_Pol_15
gen Change_19 = 1 if inrange(Change_19A,1,12)
replace Change_19 = 0 if inrange(Change_19A,-12,0)

* Regression analyses 
est clear

* Model 1
eststo: regress Env_Growth c.AD_L1##b0.Post_Dummy if Climate_Miss_1 == 2, vce(cluster lfdn)

* Summary statistics of AD for the analytical sample. 
summarize AD_L1 if e(sample)

* Model 2
eststo: regress Env_Growth c.AD_L1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Climate_Miss_1 == 2, vce(cluster lfdn)

* Model 3. The analysis is subset for those who experienced a divergence in party positions of one scale step or more
eststo: regress Env_Growth c.AD_L1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Climate_Miss_1 == 2 & Change == 1, vce(cluster lfdn)


* Summary statistics of AD for the analytical sample
summarize AD_L1 if e(sample)

		   
* Models 4-6 (2021 campaign). The if statement restricts the analytical sample to those who answered the climate change (DV) measure in both waves 

* Model 4
eststo: regress Env_Growth c.AD_L15##b0.Post_Dummy19 if Climate_Miss_2 == 2, vce(cluster lfdn)

* Model 5
eststo: regress Env_Growth c.AD_L15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Climate_Miss_2 == 2, vce(cluster lfdn)

* Model 6
eststo: regress Env_Growth c.AD_L15##b0.Post_Dummy19  c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Climate_Miss_2 == 2 & Change_19 == 1, vce(cluster lfdn)

* Table 2 

esttab, stats(N N_clust r2 r2_a, labels("Observations" "Units" "R2" "adj. R2")) drop(Imm_Self_1 Taxes_1 Interest1 Eco1 Eco_Self1 0.Post_Dummy 0.Post_Dummy#c.AD_L1 0.Post_Dummy#c.Imm_Self_1 0.Post_Dummy#c.Taxes_1 0.Post_Dummy#c.Interest1 0.Post_Dummy#c.Eco1 0.Post_Dummy#c.Eco_Self1) 

esttab using Table_1.rtf, se(3) b(3) sfmt(2) ///
    stats(N N_clust r2 r2_a, labels("Observations" "Units" "R-squared" "Adj. R-squared") fmt(%9.0fc %9.0fc %9.3f)) varwidth(20) modelwidth(10) drop(Imm_Self_1 Taxes_1 Interest1 Eco1 Eco_Self1 0.Post_Dummy 0.Post_Dummy#c.AD_L1 0.Post_Dummy#c.Imm_Self_1 0.Post_Dummy#c.Taxes_1 0.Post_Dummy#c.Interest1 0.Post_Dummy#c.Eco1 0.Post_Dummy#c.Eco_Self1 0.Post_Dummy19 0.Post_Dummy19#c.AD_L15 0.Post_Dummy19#c.Imm_Self_15 0.Post_Dummy19#c.Taxes_15 0.Post_Dummy19#c.Interest15 0.Post_Dummy19#c.Eco15 0.Post_Dummy19#c.Eco_Self15) replace

	
	
eststo: regress Env_Growth c.AD_L1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Climate_Miss_1 == 2 & Change == 1, vce(cluster lfdn)

* Left-hand panel of Figure 3 
margins, at(AD_L1=(-10(2) 10) Post=(0 1))
marginsplot, scheme(white_hue) recast(line) ciopt(color(%20)) recastci(rarea) ///
legend(order(1 "AD Wave 1 -> Climate wave 1" 2 "AD Wave 1 -> Climate wave 7") ///
           position(6) ring(1) rows(2)) ///
		   title("2017 (Model 3)") ytitle("Climate change vs. growth") ///
		   xtitle("Affective distance")

graph save "Fig_3_Left.gph", replace

* Producing the right-hand panel to Figure 3. 

eststo: regress Env_Growth c.AD_L15##b0.Post_Dummy19  c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Climate_Miss_2 == 2 & Change_19 == 1, vce(cluster lfdn)
		   
margins, at(AD_L15=(-10(2) 10) Post=(0 1))
marginsplot, scheme(white_hue) recast(line) ciopt(color(%20)) recastci(rarea) ///
legend(order(1 "AD Wave 15 -> Climate wave 15" 2 "AD Wave 15 -> Climate wave 19") ///
           position(6) ring(1) rows(2)) ///
		   title("2021 (Model 6)") ytitle("Climate change vs. growth") ///
		   xtitle("Affective distance")
		   
graph save "Fig_3_Right.gph", replace

gr combine Fig_3_Left.gph Fig_3_Right.gph, ycommon

		   
/***********************************************

Lenz test - climate change as predictor

Below are analyses for Table 3, where climate change attitudes are the focal predictor and affective distance is the outcome

***********************************************/

* 2017 campaign. As before, the analytical sample is restricted to those answering the DV in both waves		   

gen AD_7 = AP_Distance if Wave == 7
bysort lfdn: egen AD_L7 = mean(AD_7) 

egen AD_Miss_1 = rownonmiss(AD_L1 AD_L7)

* 2021 campaign 

gen AD_19A = AP_Distance if Wave == 19
bysort lfdn: egen AD_L19 = mean(AD_19A)	

egen AD_Miss_2 = rownonmiss(AD_L15 AD_L19)

* Regression analyses 

est clear

eststo: regress AP_Distance c.Env1##b0.Post_Dummy if AD_Miss_1 == 2, vce(cluster lfdn)

eststo: regress AP_Distance c.Env1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if AD_Miss_1 == 2, vce(cluster lfdn)

eststo: regress AP_Distance c.Env1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if AD_Miss_1 == 2 & Change == 1, vce(cluster lfdn)

* 2021

eststo: regress AP_Distance c.Env15##b0.Post_Dummy19 if AD_Miss_2 == 2, vce(cluster lfdn)

eststo: regress AP_Distance c.Env15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if AD_Miss_2 == 2, vce(cluster lfdn)

eststo: regress AP_Distance c.Env15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if AD_Miss_2 == 2 & Change_19 == 1, vce(cluster lfdn)

* Table 3 

esttab, stats(N N_clust r2 r2_a, labels("Observations" "Units" "R2" "adj. R2")) drop(Imm_Self_1 Taxes_1 Interest1 Eco1 Eco_Self1 0.Post_Dummy 0.Post_Dummy#c.Env1 0.Post_Dummy19#c.Env15 0.Post_Dummy#c.Imm_Self_1 0.Post_Dummy#c.Taxes_1 0.Post_Dummy#c.Interest1 0.Post_Dummy#c.Eco1 0.Post_Dummy#c.Eco_Self1 0.Post_Dummy19 0.Post_Dummy19#c.Imm_Self_15 0.Post_Dummy19#c.Taxes_15 0.Post_Dummy19#c.Interest15 0.Post_Dummy19#c.Eco15 0.Post_Dummy19#c.Eco_Self15) 

esttab using Table_1.rtf, se(3) b(3) sfmt(2) ///
    stats(N N_clust r2 r2_a, labels("Observations" "Units" "R-squared" "Adj. R-squared") fmt(%9.0fc %9.0fc %9.3f)) varwidth(20) modelwidth(10) drop(Imm_Self_1 Taxes_1 Interest1 Eco1 Eco_Self1 0.Post_Dummy 0.Post_Dummy#c.Env1 0.Post_Dummy19#c.Env15 0.Post_Dummy#c.Imm_Self_1 0.Post_Dummy#c.Taxes_1 0.Post_Dummy#c.Interest1 0.Post_Dummy#c.Eco1 0.Post_Dummy#c.Eco_Self1 0.Post_Dummy19 0.Post_Dummy19#c.Imm_Self_15 0.Post_Dummy19#c.Taxes_15 0.Post_Dummy19#c.Interest15 0.Post_Dummy19#c.Eco15 0.Post_Dummy19#c.Eco_Self15) replace


/**************************************************************************
                        Descriptive figures 1 and 2
**************************************************************************/

* Graph for trends in party positions (Figure 1)

bysort Wave: egen Mean_Green = mean(Env_Green)
bysort Wave: egen Mean_AfD = mean(Env_AFD)
bysort Wave: egen Mean_Distance = mean(Elite_Pol)

sort Date

twoway ///
    (line Mean_Green Date, lcolor(green)) ///
    (line Mean_AfD Date, lcolor(blue)) ///
    (line Mean_Distance Date, lcolor(gold)), ///
    legend(order(1 "Green" 2 "AfD" 3 "Distance") ///
           position(6) ring(1) rows(1)) ///
    xlabel(, format(%tdCCYY)) ///
    xtitle("") ///
    ytitle("Mean placement and distance") ///
    scheme(white_hue)
	
* Correlations across waves (Figure 2)
sort Wave
egen Corr_Env = corr(AP_Distance Env_Growth), by(Wave)

summ Date if Wave==7, meanonly
local d7 = r(mean)

summ Date if Wave==15, meanonly
local d15 = r(mean)

summ Date if Wave==19, meanonly
local d19 = r(mean)

twoway ///
    (line Corr_Env Date if inrange(Date, td(01oct2016), td(16jan2025)), ///
        lcolor(black) lpattern(solid)), ///
    xline(`d7' `d15' `d19', lpattern(dash) lwidth(medthin)) ///
    xlabel(, format(%tdCCYY)) ///
    xtitle("Year") ///
    ytitle("Mean Value") ///
    scheme(white_hue)
	
	
/**************************************************************************
                        
						
						Appendix analyses

The first part performs robustness tests pertaining to the fixed effects analysis, and the second part focuses on the campaign analyses
						
**************************************************************************/


/********************************************************************
* Fixed effects analyses - from Table A7
**************************************************************************/

* Vote choice. BSW (392) in waves 25-29 are excluded
* Comparing effects for party ID 

label define Party_Lab 1 "CDU/CSU" 2 "SPD" 3 "FDP" 4 "Greens" 5 "Linke" 6 "AfD" 7 "None or other"

recode PID(1=1)(4=2)(5=3)(6=4)(7=5)(322=6)(801 808=7)(392 -99 -95 -93=.), gen(PID_Re)

label values PID_Re Party_Lab

gen East_West = 0 if inrange(Region,1,10)
replace East_West = 1 if inrange(Region,12,16)
replace East_West = 2 if Region == 11

label define Region_Lab 0 "West" 1 "East" 2 "Berlin"
label values East_West Region_Lab


* Figure A5

est clear 
eststo: xtreg Env_Growth c.AP_Distance##b7.PID_Re Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

margins PID_Re, dydx(AP_Distance)
marginsplot, recast(scatter) ciopts(recast(rcap)) scheme(white_hue) ytitle("Predicted effects of AD") title("") xtitle("") xscale(range(1 7.3))

graph save "Party.gph", replace

eststo: xtreg Env_Growth c.AP_Distance##b0.East_West Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

margins East_West, dydx(AP_Distance)
marginsplot, recast(scatter) ciopts(recast(rcap)) scheme(white_hue) ytitle("Predicted effects of AD") title("") xtitle("")

graph save "Region.gph", replace

gr combine Party.gph Region.gph, ycommon

* Analysis with PID as the control variable (Table A14)

xtset lfdn Wave
est clear 

eststo: xtreg Env_Growth AP_Distance b7.PID_Re, fe vce(cluster lfdn)

eststo: xtreg Env_Growth AP_Distance Interest Taxes Imm_Self Economy_Self Eco_Country b7.PID_Re i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.AP_Distance##c.Elite_Pol b7.PID_Re, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.AP_Distance##c.Elite_Pol Interest Taxes Imm_Self Economy_Self Eco_Country b7.PID_Re i.Wave, fe vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_A1_.rtf, se(3) b(3) sfmt(2) ar2 r2 replace 

* Lagged variables (Table A11)
xtset lfdn Wave
est clear 

eststo: xtreg Env_Growth L.AP_Distance, fe vce(cluster lfdn)

eststo: xtreg Env_Growth L.AP_Distance L.Interest L.Taxes L.Imm_Self L.Economy_Self L.Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth L.c.AP_Distance##L.c.Elite_Pol, fe vce(cluster lfdn)

eststo: xtreg Env_Growth L.c.AP_Distance##L.c.Elite_Pol L.Interest L.Taxes L.Imm_Self L.Economy_Self L.Eco_Country i.Wave, fe vce(cluster lfdn)

* Double demean (Table A12)

* Within respondent variation in AP distance, climate change attitudes and differences in party placements 

bysort lfdn: egen mean_AP = mean(AP_Distance) 
gen AP_within = AP_Distance - mean_AP 

bysort lfdn: egen mean_Env = mean(Env_Growth) 
gen Env_within = Env_Growth - mean_Env 

bysort lfdn: egen mean_Elite = mean(Elite_Pol) 
gen Elite_within = Elite_Pol - mean_Elite 

gen Demean_Product = AP_within*Elite_within

est clear 
eststo: xtreg Env_Growth c.AP_within##c.Elite_within, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.AP_within##c.Elite_within Interest LR_Self Economy_Self Eco_Country Wave, fe vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_A1_.rtf, se(3) b(3) sfmt(2) ar2 r2 replace 

* Restricted to samples A1 and A2 (Table A13)

est clear 

eststo: xtreg Env_Growth AP_Distance if inrange(sample,2,3), fe vce(cluster lfdn)

eststo: xtreg Env_Growth AP_Distance Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave if inrange(sample,2,3), fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.AP_Distance##c.Elite_Pol if inrange(sample,2,3), fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.AP_Distance##c.Elite_Pol Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave if inrange(sample,2,3), fe vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_A_1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace 

* Separate analyses for Green and AfD (Table A15)

est clear 
eststo: xtreg Env_Growth Like_Green Like_AFD Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.Like_Green##c.Env_Green c.Like_AFD##c.Env_AFD Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

margins, at(Env_AFD=(1 3 5 7) Like_AFD=(0(5)10))
marginsplot 

esttab, ar2 r2
esttab using Table_A1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace 


* Changes in effects of like-dislike of Greens and AfD over time (Figure A6)

regress Env_Growth Like_Green Like_AFD Interest Taxes Imm_Self Economy_Self Eco_Country c.Like_Green##i.Wave c.Like_AFD##i.Wave, vce(cluster lfdn)

margins, dydx(Like_Green) over(Wave) 
marginsplot, ///
    recast(connected) ///
    ciopts(recast(rarea) fcolor(%20)) ///
    xlabel(, noticks nolabels nogrid) ///
    graphregion(color(white)) ///
    scheme(white_hue) title("Effect of like-dislike (Greens)") ///
	xtitle("Waves 1-29") ytitle("Predicted effect")

graph save "Party_Green.gph", replace

regress Env_Growth Like_Green Like_AFD Interest Taxes Imm_Self Economy_Self Eco_Country c.Like_Green##i.Wave c.Like_AFD##i.Wave, vce(cluster lfdn)

margins, dydx(Like_AFD) over(Wave) 
marginsplot, ///
    recast(connected) ///
    ciopts(recast(rarea) fcolor(%20)) ///
    xlabel(, noticks nolabels nogrid) ///
    graphregion(color(white)) ///
    scheme(white_hue) title("Effect of like-dislike (AfD)") ///
	xtitle("Waves 1-29") ytitle("Predicted effect")

graph save "Party_AFD.gph", replace

gr combine Party_Green.gph Party_AFD.gph, ycommon

* Alternative affective distance measures (Tables A16 and A17)

gen Mainstream_A = Like_SPD-Like_CDU

gen Left_Bloc = (Like_SPD+Like_Linke)/2
gen Right_Bloc = (Like_CDU+Like_CSU+Like_FDP)/3

gen Mainstream_B = Left_Bloc-Right_Bloc

* Perceptions of party polarization 
gen LR_Per_1 = Env_SPD-Env_CDU

gen Left_Mean = (Env_SPD+Env_Linke)/2
gen Right_Mean = (Env_CDU+Env_CSU+Env_FDP)/3
gen LR_Diff = Left_Mean-Right_Mean


xtset lfdn Wave

est clear 
eststo: xtreg Env_Growth c.Mainstream_A Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.Mainstream_A AP_Distance Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.Mainstream_B Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.Mainstream_B AP_Distance Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_A1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace


xtset lfdn Wave

est clear 
eststo: xtreg Env_Growth c.Mainstream_A##c.LR_Per_1 Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.Mainstream_A##c.LR_Per_1 c.AP_Distance##c.Elite_Pol Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.Mainstream_B##c.LR_Diff Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)

eststo: xtreg Env_Growth c.Mainstream_B##c.LR_Diff c.AP_Distance##c.Elite_Pol Interest Taxes Imm_Self Economy_Self Eco_Country i.Wave, fe vce(cluster lfdn)


esttab, ar2 r2
esttab using Table_A1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace



/********************************************************************

* Lenz analyses. Tables A3-A10
 
**************************************************************************/

* Waves 1, 2 and 24. Three-wave test

gen Post24 = 0 if Wave == 2
replace Post24 = 1 if Wave == 24

gen AD_2A = AP_Distance if Wave == 2
bysort lfdn: egen AD_L2 = mean(AD_2A)

* AD_L1 is affective distance during wave 1
gen AD_Lag = AD_L1 if Wave == 2
replace AD_Lag = AD_L2 if Wave == 24

gen Env_2A = Env_Growth if Wave == 2
bysort lfdn: egen Env_2 = mean(Env_2A)

* Env1 is climate change position in wave 1
gen Env_Lag = Env1 if Wave == 2
replace Env_Lag = Env_2 if Wave == 24

gen Env_24A = Env_Growth if Wave == 24
bysort lfdn: egen Env_24 = mean(Env_24A)

* Control variables 

gen Taxes_2A = Taxes if Wave == 2
bysort lfdn: egen Taxes_2 = mean(Taxes_2A)
gen Taxes_Lag = Taxes_1 if Wave == 2
replace Taxes_Lag = Taxes_2 if Wave == 24

gen Imm_2A = Imm_Self if Wave == 2
bysort lfdn: egen Imm_2 = mean(Imm_2A)
gen Imm_Lag = Imm_Self_1 if Wave == 2
replace Imm_Lag = Imm_2 if Wave == 24

gen Interest2A = Interest if Wave == 2
bysort lfdn: egen Interest2 = mean(Interest2A) 

gen Interest_Lag = Interest1 if Wave == 2
replace Interest_Lag = Interest2 if Wave == 24

* Changes in party placements between waves 2-24

gen Elite_Pol_24A = Elite_Pol if Wave == 24
bysort lfdn: egen Elite_Pol_24 = mean(Elite_Pol_24A) 

gen Change_24A = Elite_Pol_24-Elite_Pol_2
gen Change_24 = 1 if inrange(Change_24A,1,12)
replace Change_24 = 0 if inrange(Change_24A,-12,0)

gen Change_24_Re = 1 if inrange(Change_24A,-12,-1)
replace Change_24_Re = 2 if Change_24A == 0
replace Change_24_Re = 3 if Change_24A == 1
replace Change_24_Re = 4 if inrange(Change_24A,2,3)
replace Change_24_Re = 5 if inrange(Change_24A,4,12)

* Analytical sample restricted to those answering the key variables in both waves

egen Climate_Miss_Test = rownonmiss(Env_2 Env_24 AD_L1 AD_L2)

* Post indicator for two-wave test (Models 4-6): Waves 1 and 24

gen Post_24A = 1 if Wave == 24
replace Post_24A = 0 if Wave == 1

* Restricting the analytical sample for the two-wave test
egen Climate_Miss_24 = rownonmiss(Env1 Env_24)


* Below is for Table A3

est clear 

eststo: regress Env_Growth c.AD_Lag##b0.Post24 c.Env_Lag##b0.Post24 if Climate_Miss_Test == 4, vce(cluster lfdn)

eststo: regress Env_Growth c.AD_Lag##b0.Post24 c.Env_Lag##b0.Post24 c.Taxes_Lag##b0.Post24 c.Imm_Lag##b0.Post24 c.Interest_Lag##b0.Post24 c.Eco1##b0.Post24 c.Eco_Self1##b0.Post24  if Climate_Miss_Test == 4, vce(cluster lfdn)

eststo: regress Env_Growth c.AD_Lag##b0.Post24 c.Env_Lag##b0.Post24 c.Taxes_Lag##b0.Post24 c.Imm_Lag##b0.Post24 c.Interest_Lag##b0.Post24 c.Eco1##b0.Post24 c.Eco_Self1##b0.Post24  if Climate_Miss_Test == 4 & Change_24 == 1, vce(cluster lfdn)
		   
eststo: regress Env_Growth c.AD_L1##b0.Post_24A if Climate_Miss_24 == 2, vce(cluster lfdn)

eststo: regress Env_Growth c.AD_L1##b0.Post_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2, vce(cluster lfdn)

eststo: regress Env_Growth c.AD_L1##b0.Post_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2 & Change_24 == 1, vce(cluster lfdn)
				   
esttab, ar2 r2
esttab using Table_A1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace 

* This is for the left-hand panel in Figure A4. 

est clear 
regress Env_Growth c.AD_L1##b0.Post_24A if Climate_Miss_24 == 2 & Change_24_Re == 1, vce(cluster lfdn) 
estimate store A 

regress Env_Growth c.AD_L1##b0.Post_24A if Climate_Miss_24 == 2 & Change_24_Re == 2, vce(cluster lfdn)
estimate store B

regress Env_Growth c.AD_L1##b0.Post_24A if Climate_Miss_24 == 2 & Change_24_Re == 3, vce(cluster lfdn)
estimate store C

regress Env_Growth c.AD_L1##b0.Post_24A if Climate_Miss_24 == 2 & Change_24_Re == 4, vce(cluster lfdn)
estimate store D

regress Env_Growth c.AD_L1##b0.Post_24A if Climate_Miss_24 == 2 & Change_24_Re == 5, vce(cluster lfdn)
estimate store E

coefplot ///
    (A, keep(1.Post_24A#c.AD_L1) label("Q1")) ///
    (B, keep(1.Post_24A#c.AD_L1) label("Q2")) ///
    (C, keep(1.Post_24A#c.AD_L1) label("Q3")) ///
    (D, keep(1.Post_24A#c.AD_L1) label("Q4")) ///
    (E, keep(1.Post_24A#c.AD_L1) label("Q5")), ///
    vertical ///
    yline(0) ///
    ciopts(recast(rcap)) scheme(white_hue) /// 
	coeflabels(1.Post_24A#c.AD_L1 = "") ///
	legend(position(6) title(Quintiles elite polarization, size(medium)) ring(1) rows(1)) xtitle("") ytitle("") /// 
	ylabel(-.05(0.05).20)

	
* This is for the right-hand panel in Figure A4.

est clear 
regress Env_Growth c.AD_L1##b0.Post_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2 & Change_24_Re == 1, vce(cluster lfdn)
estimate store A

regress Env_Growth c.AD_L1##b0.Post_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2  & Change_24_Re == 2, vce(cluster lfdn)
estimate store B

regress Env_Growth c.AD_L1##b0.Post_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2  & Change_24_Re == 3, vce(cluster lfdn)
estimate store C

regress Env_Growth c.AD_L1##b0.Post_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2  & Change_24_Re == 4, vce(cluster lfdn)
estimate store D

regress Env_Growth c.AD_L1##b0.Post_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2  & Change_24_Re == 5, vce(cluster lfdn)
estimate store E

coefplot ///
    (A, keep(1.Post_24A#c.AD_L1) label("Q1")) ///
    (B, keep(1.Post_24A#c.AD_L1) label("Q2")) ///
    (C, keep(1.Post_24A#c.AD_L1) label("Q3")) ///
    (D, keep(1.Post_24A#c.AD_L1) label("Q4")) ///
    (E, keep(1.Post_24A#c.AD_L1) label("Q5")), ///
    vertical ///
    yline(0) ///
    ciopts(recast(rcap)) scheme(white_hue) /// 
	coeflabels(1.Post_24A#c.AD_L1 = "") ///
	legend(position(6) title(Quintiles elite polarization, size(medium)) ring(1) rows(1)) xtitle("") ytitle("") /// 
	ylabel(-.05(0.05).20)

* Table A4. Three-way interaction 

est clear 

eststo: regress Env_Growth c.AD_L1##b0.Post_24A##c.Change_24A if Climate_Miss_24 == 2, vce(cluster lfdn)

eststo: regress Env_Growth c.AD_L1##b0.Post_24A##c.Change_24A c.Imm_Self_1##b0.Post_24A c.Taxes_1##b0.Post_24A c.Interest1##b0.Post_24A c.Eco1##b0.Post_24A c.Eco_Self1##b0.Post_24A if Climate_Miss_24 == 2, vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_A1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace


/*******************************************************

Alternative analyses. Tables A7-A9 

*******************************************************/

gen Green_1A = Like_Green if Wave == 1
bysort lfdn: egen Green_1 = mean(Green_1A) 

gen AFD_1A = Like_AFD if Wave == 1
bysort lfdn: egen AFD_1 = mean(AFD_1A)

gen AFD_15A = Like_AFD if Wave == 15
bysort lfdn: egen AFD_15 = mean(AFD_15A) 

gen Green_15A = Like_Green if Wave == 15
bysort lfdn: egen Green_15 = mean(Green_15A) 

est clear

eststo: regress Env_Growth c.Green_1##b0.Post_Dummy c.AFD_1##b0.Post_Dummy if Climate_Miss_1 == 2, vce(cluster lfdn)

eststo: regress Env_Growth c.Green_1##b0.Post_Dummy c.AFD_1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Climate_Miss_1 == 2, vce(cluster lfdn)

eststo: regress Env_Growth c.Green_1##b0.Post_Dummy c.AFD_1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Climate_Miss_1 == 2 & Change == 1, vce(cluster lfdn)

		   
* Models 4-6 (2021 campaign)

eststo: regress Env_Growth c.Green_15##b0.Post_Dummy19 c.AFD_15##b0.Post_Dummy19 if Climate_Miss_2 == 2, vce(cluster lfdn)

eststo: regress Env_Growth c.Green_15##b0.Post_Dummy19 c.AFD_15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Climate_Miss_2 == 2, vce(cluster lfdn)

eststo: regress Env_Growth c.Green_15##b0.Post_Dummy19 c.AFD_15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Climate_Miss_2 == 2 & Change_19 == 1, vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_A1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace 

* Reverse causal direction - we test both Like_Green and Like_AFD as dependent variables 

gen AFD_7A = Like_AFD if Wave == 7
bysort lfdn: egen AFD_7 = mean(AFD_7A)

gen Green_7A = Like_Green if Wave == 7
bysort lfdn: egen Green_7 = mean(Green_7A)

egen AfD_Miss_1 = rownonmiss(AFD_1 AFD_7)

egen Green_Miss_1 = rownonmiss(Green_1 Green_7)

* Like-dislike toward Green instead of affective distance as the outcome. Change the DV to Like_AFD for the alternative analysis, with affect toward the AfD as the outcome (Table A9)

est clear

eststo: regress Like_Green c.Env1##b0.Post_Dummy if Green_Miss_1 == 2, vce(cluster lfdn)

eststo: regress Like_Green c.Env1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Green_Miss_1 == 2, vce(cluster lfdn)

eststo: regress Like_Green c.Env1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Green_Miss_1 == 2 & Change == 1, vce(cluster lfdn)

		   
* Models 4-6 (2021 campaign)

gen AFD_19A = Like_AFD if Wave == 19
bysort lfdn: egen AFD_19 = mean(AFD_19A)

egen AfD_Miss_2 = rownonmiss(AFD_15 AFD_19)

gen Green_19A = Like_Green if Wave == 19
bysort lfdn: egen Green_19 = mean(Green_19A)

egen Green_Miss_2 = rownonmiss(Green_15 Green_19)

eststo: regress Like_Green c.Env15##b0.Post_Dummy19 if Green_Miss_2 == 2, vce(cluster lfdn)

eststo: regress Like_Green c.Env15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Green_Miss_2 == 2, vce(cluster lfdn)

eststo: regress Like_Green c.Env15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Green_Miss_2 == 2 & Change_19 == 1, vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_A1.rtf, se(3) b(3) sfmt(2) ar2 r2 replace

* Party ID as predictor 

gen PID_1A = PID_Re if Wave == 1
bysort lfdn: egen PID_1 = mean(PID_1A)

est clear

eststo: regress Env_Growth b7.PID_1##b0.Post_Dummy b7.PID_1##b0.Post_Dummy if Climate_Miss_1 == 2, vce(cluster lfdn)

eststo: regress Env_Growth b7.PID_1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1A##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Climate_Miss_1 == 2, vce(cluster lfdn)

eststo: regress Env_Growth b7.PID_1##b0.Post_Dummy c.Imm_Self_1##b0.Post_Dummy c.Taxes_1##b0.Post_Dummy c.Interest1A##b0.Post_Dummy c.Eco1##b0.Post_Dummy c.Eco_Self1##b0.Post_Dummy if Climate_Miss_1 == 2 & Change == 1, vce(cluster lfdn)

		   
* Models 4-6 (2021 campaign)

eststo: regress Env_Growth b7.PID_15##b0.Post_Dummy19 if Climate_Miss_2 == 2, vce(cluster lfdn)

eststo: regress Env_Growth b7.PID_15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Climate_Miss_2 == 2, vce(cluster lfdn)

eststo: regress Env_Growth b7.PID_15##b0.Post_Dummy19 c.Imm_Self_15##b0.Post_Dummy19 c.Taxes_15##b0.Post_Dummy19 c.Interest15##b0.Post_Dummy19 c.Eco15##b0.Post_Dummy19 c.Eco_Self15##b0.Post_Dummy19 if Climate_Miss_2 == 2 & Change_19 == 1, vce(cluster lfdn)

esttab, ar2 r2
esttab using Table_2_A.rtf, se(3) b(3) sfmt(2) ar2 r2


/*************************************************************

                  Appendix graphs 

*************************************************************/

* Share of don't know responses in relation to substantive responses (1-7)

foreach v in 10 11 13 14 15 18 19 24 27 {
    gen Know_Green_`v' = .
    replace Know_Green_`v' = 1 if kp`v'_1270e == -98
    replace Know_Green_`v' = 0 if inrange(kp`v'_1270e, 1, 7)
}

gen Know_Green =.

foreach w in 10 11 13 14 15 18 19 24 27 {
    replace Know_Green = Know_Green_`w' if Wave == `w'
}

replace Know_Green = 1 if kp_1270e == -98 & inrange(Wave,1,9)
replace Know_Green = 0 if inrange(kp_1270e,1,7) & inrange(Wave,1,9)



foreach v in 10 11 13 14 15 18 19 24 27 {
    gen Know_AfD_`v' = .
    replace Know_AfD_`v' = 1 if kp`v'_1270i == -98
    replace Know_AfD_`v' = 0 if inrange(kp`v'_1270i, 1, 7)
}


gen Know_AfD =.

foreach w in 10 11 13 14 15 18 19 24 27 {
    replace Know_AfD = Know_AfD_`w' if Wave == `w'
}

replace Know_AfD = 1 if kp_1270i == -98 & inrange(Wave,1,9)
replace Know_AfD = 0 if inrange(kp_1270i,1,7) & inrange(Wave,1,9)

bysort Wave: egen Green_Know = mean(Know_Green)
bysort Wave: egen AfD_Know = mean(Know_AfD)

* Figure A1

twoway ///
    (line Green_Know Date) ///
    (line AfD_Know Date), ///
    legend(order(1 "Greens" 2 "AfD") ///
           position(6) ring(1) rows(1)) ///
    xlabel(, format(%tdCCYY)) ///
    xtitle("Year") ///
    ytitle("% Don't know") ///
    scheme(white_hue)
	
* Histograms of key variables (Figure A2)

histogram AP_Distance, percent scheme(white_hue) xtitle("Affective distance") ytitle("Percent")
graph save AP_Distance.gph, replace

histogram Elite_Pol, percent scheme(white_hue) xtitle("Perceived divergence") ytitle("Percent")
graph save Divergence.gph, replace

histogram Env_Growth, percent scheme(white_hue) xtitle("Climate change vs. growth") ytitle("Percent")
graph save Climate_Attitudes.gph, replace

gr combine AP_Distance.gph Divergence.gph Climate_Attitudes.gph, ycommon

* Correlations between party affect and climate attitudes across waves (Figure A3)

sort Wave
bysort Wave: egen Main_Env = corr(Mainstream_B Env_Growth)

summ Date if Wave==7, meanonly
local d7 = r(mean)

summ Date if Wave==15, meanonly
local d15 = r(mean)

summ Date if Wave==19, meanonly
local d19 = r(mean)

twoway ///
    (line Corr_Env Date if inrange(Date, td(01oct2016), td(16jan2025))) ///
    (line Main_Env Date if inrange(Date, td(01oct2016), td(16jan2025)), ///
        lcolor(black) lpattern(solid)) ///
    , ///
    xline(`d7' `d15' `d19', lpattern(dash) lwidth(medthin)) ///
    xlabel(, format(%tdCCYY)) ///
    xtitle("Year") ///
    ytitle("Mean Value") ///
    scheme(white_hue) legend(order(1 "Greens vs. AFD" 2 "Left vs. Right") ///
           position(6) ring(1) rows(1)) xtitle("") ytitle("Correlation coefficient")
		   


	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

