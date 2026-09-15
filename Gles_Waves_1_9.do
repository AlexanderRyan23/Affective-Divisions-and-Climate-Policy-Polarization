clear 

/***********************************************************

We downloaded the data set for Waves 1-9 in a wide format and then reshaped it into a long format, as shown below. The data set for waves 1-9 was part of the panel data cumulation GLES Panel waves 1-29: https://www.gesis.org/en/gles/data-and-documentation

We reshaped it to a long format and append it to the full data set in the GLES_Panel_1_29 do-file

***********************************************************/

global data "C:\path\to\your\data"

use "$data/Wave_1_9_wide.dta" 

reshape long kp@_430a kp@_430b kp@_430c kp@_430d kp@_430e kp@_430f kp@_430i kp@_1290 kp@_1270a kp@_1270b kp@_1270c kp@_1270d kp@_1270e kp@_1270f kp@_1270i kp@_190ba kp@_1070a kp@_1070b kp@_1070c kp@_1070d kp@_1070e kp@_1070f kp@_1070i kp@_010 kp@_020 kp@_1500 kp@_1300 kp@_1110a kp@_1110b kp@_1110c kp@_1110d kp@_1110e kp@_1110f kp@_1110i kp@_780 kp@_820 kp@_2090a kp@_1130 kp@_1090, i(lfdn) j(Wave)

keep kp_430a kp_430b kp_430c kp_430d kp_430e kp_430f kp_430i kp_1290 kp_1270a kp_1270b kp_1270c kp_1270d kp_1270e kp_1270f kp_1270i kp_190ba kp_1070a kp_1070b kp_1070c kp_1070d kp_1070e kp_1070f kp_1070i kp_010 kp_020 kp_1500 kp_1300 kp_1110a kp_1110b kp_1110c kp_1110d kp_1110e kp_1110f kp_1110i kp_780 kp_820 kp_2090a kp_1130 kp_1090 lfdn kpx_2280 kpx_2290s kp1_2601 Wave sample


save "$data/GLES_W1_W9_Long.dta", replace















