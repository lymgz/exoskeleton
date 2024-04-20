***************************************
******Exoskeleton meta analysis*********
***************************************

**Step 1  Import the Data**
pwd

use exoskeleton_meta.dta , clear


**Meta-analysis setting**
meta query
meta esize t_n1 t_mean t_sd c_n2 c_mean c_sd, esize(cohend) studylabel(author)   //**meta 设置**//
meta galbraith, random(ebayes)  //*异质性检验*//
meta regress _cons   //*meta 回归*//


*Frequentist meta-analysis*
***Step 2 Subgroups analysis*********
*Heterogeneity summary*
asdoc meta summarize, sort(_meta_es, ascending) save(meta-analysis.doc) title(Overall meta-analysis)  //*整体看*//
asdoc meta summarize, subgroup(sample_sz_cat) sort(_meta_es, ascending) save(meta-analysis.doc) title(sample sized subgroups)  //*sample sized subgroups*//
asdoc meta summarize, subgroup(year_rag) sort(_meta_es, ascending) save(meta-analysis.doc) title(year subgroups)  //*year subgroups*//
asdoc meta summarize, subgroup(continent) sort(_meta_es, ascending) save(meta-analysis.doc) title(Continent subgroups)  //*Continent subgroups*//
asdoc meta summarize, subgroup(equipment_cat) sort(_meta_es, ascending) save(meta-analysis.doc) title(equipment categories subgroups)  //*equipment categories subgroups*//
asdoc meta summarize, subgroup(body_part) sort(_meta_es, ascending) save(meta-analysis.doc) title(Body parts subgroups) //*Body parts subgroups*//
asdoc meta summarize, subgroup(devices_cat) sort(_meta_es, ascending) save(meta-analysis.doc) title(exoskeleton devices subgroups) //*exoskeleton devices subgroups*//

*Forest plot*
meta forestplot, sort(_meta_es, ascending) insidemarker esrefline(lpattern(dash)) nullrefline(lcolor(black) lwidth(medthin) lpattern(solid))    //**整体森林图**//
meta forestplot, subgroup(sample_sz_cat) sort(_meta_es, ascending) esrefline nullrefline  //*sample sized subgroups*//
meta forestplot, subgroup(year_rag) sort(_meta_es, ascending) esrefline nullrefline  //*year subgroups*//
meta forestplot, subgroup(continent) sort(_meta_es, ascending) esrefline nullrefline  //*Continent subgroups*//
meta forestplot, subgroup(equipment_cat) sort(_meta_es, ascending) esrefline nullrefline //*equipment categories subgroups*//
meta forestplot, subgroup(body_part) sort(_meta_es, ascending) esrefline nullrefline //*Body parts subgroups*//
meta forestplot, subgroup(devices_cat) sort(_meta_es, ascending) esrefline nullrefline //*exoskeleton devices subgroups*//


*****Step 3 Publication bias*********** 
// meta funnelplot, contours(1, lines)   //*发表偏倚*//
meta trimfill, funnel itermethod(ebayes) poolmethod(hedges)
meta bias, egger //*egger*//


**********step 4 meta regression*********

capture gen y = . 
replace y = 1 if sample_sz_cat == "Medium sized"
replace y = 2  if sample_sz_cat == "Small sized"
replace y = 3 if sample_sz_cat == "Very small sized"
eststo Sample_size: meta regress y

replace y = 1 if year_rag == "Year<=2020"
replace y = 2  if year_rag == "Year>2020"
eststo Year_range: meta regress y

replace y = 1 if continent == "Asia"
replace y = 2 if continent == "Europe"
replace y = 3 if continent == "North America"
replace y = 4 if continent == "Sourth America"
eststo continental_reg: meta regress y

replace y = 1 if equipment_cat == "Electromyography (EMG) involved"
replace y = 2 if equipment_cat == "Electromyography (EMG) not involved"
eststo equipment_cat_reg: meta regress y

replace y = 1 if body_part == "Upper limb exoskeleton"
replace y = 2 if body_part == "Back support exoskeleton"
replace y = 3 if body_part == "Lower limb exoskeleton"
eststo body_part_reg: meta regress y

replace y = 1 if devices_cat == "Conceptualized"
replace y = 2 if devices_cat == "Invented"
replace y = 3 if devices_cat == "Not available"
eststo devices_cat_reg: meta regress y

asdoc esttab Sample_size Year_range continental_reg equipment_cat_reg body_part_reg devices_cat_reg,  se star(* 0.1 ** 0.05 *** 0.01) save(meta-analysis.doc)
