Tabby2 Economic Analysis Methods 
-----------------------------

This document describes detailed, technical assumptions and approaches used to calculate summary measures of health impact, costs, and cost effectiveness, as part of the Tabby2 webtool. 

Definitions and Abbreviations
-----------------------------

**Analytical horizon**

The analytical horizon of an economic evaluation determines for which years to accrue cost and benefits included in the analysis. 

**Analytical or costing perspective**

The analytical perspective of an economic evaluation determines which costs and health benefits are included in the analysis. 

**CMS – Centers for Medicare & Medicaid Services**

A federal agency within the United States Department of Health and Human Services which administers the Medicare program and assists states in administration of Medicaid. 

**CPT—Current Procedural Terminology**

Current procedural terminology codes are numeric keys assigned to services that a physician provides for a patient. These codes facilitate insurance reimbursements.

**Discount rate**

Potential costs and benefits occur in at different times; in order to account for these differences, a discount rate is applied to convert these to present-day values. Discounting is separate from the adjustment for inflation and is applied after adjustment for inflation. 

**Disutility**

The decrement in utility (valued quality of life) due to a particular symptom or complication.

**Dominated**

When a strategy is cost-increasing and benefit reducing relative to other strategies it is considered dominated by other strategies. 

**ICER – Incremental Cost Effectiveness Ratio** 

The ICER compares the incremental cost and benefit of an intervention strategy relative to the next least beneficial scenario. The ICER does not compare dominated or weakly dominated strategies. 

**MDR-TB – Multidrug-resistant tuberculosis**

Multidrug-resistant tuberculosis includes strains of TB that are resistant to at least isoniazid and rifampin, two common and potent TB drugs.

**PCE Price Index -Personal Consumption Expenditure Price Index**

A United States-wide measure of prices paid for goods and services.  The measure is used for describing and adjusting for inflation. 

**QALY – Quality Adjusted Life Year**

A summary measure of health attainment, which considers both the quality and the quantity of life lived. One QALY is equivalent to a year of life lived in full health.

**Weakly Dominated**

Also known as extended dominance. A strategy is said to be weakly dominated if it is dominated by a linear combination of two other strategy.

**XDR-TB – Extensively drug-resistant tuberculosis**

Extensively drug-resistant tuberculosis includes rare strains of TB that are resistant to isoniazid and rifampin, plus any fluoroquinolone and at least one of three injectable second-line drugs (i.e., amikacin, capreomycin, or kanamycin).

**3HP – 3 months of weekly doses of 900 mg. of isoniazid and 900 mg. of rifapentine**

A preferred treatment regimen for LTBI. 

**3HR – 3 months of daily doses of 300 mg. of isoniazid and 600 mg. of rifampin**

A preferred treatment regimen for LTBI. 

**4R – 4 months of daily doses of 600 mg. of rifampin**

A preferred treatment regimen for LTBI.


### Health Impacts

For each scenario Tabby2 quantifies health impact as TB cases averted, TB deaths averted, life-years saved, and quality adjusted life-years (QALYs) saved. These are calculated from incremental differences in health outcomes estimated by a transmission dynamic model cumulated over an analytic horizon chosen by the user. This model expands on an earlier model of future TB epidemiology in the United States (Menzies et al 2018. “Prospects for tuberculosis elimination in the United States: results of a transmission dynamic model” American Journal of Epidemiology 187(9):2011-2020) (https://academic.oup.com/aje/article/187/9/2011/4995883)).  
Details on the calculation of each outcome are shown below. These outcomes are shown on the Economic Analysis section of Tabby2, in the ‘Health Effects’ table.

**TB cases averted**
Total TB cases for a given scenario are calculated by summing annual TB cases from 2020 through to the end of the analytic horizon, as estimated from the transmission model. TB cases averted are calculated by subtracting the total cases in a given scenario from the total cases under a counterfactual scenario (e.g., the base-case).

**TB deaths averted**
Total TB deaths and TB deaths averted are calculated in the same way as for TB cases.

**Life-years saved**
We first calculate the total life-years lost from TB for each scenario. We do so by taking the cumulative number of TB deaths in each age group from the transmission model (between 2020 and the analytic horizon) and multiplying it by a life expectancy estimate for that age group. We then sum these totals across all age groups. Life expectancy inputs for each age group are shown in Table 1. Estimates of life-years saved are calculated by subtracting the total life-years lost to TB in a given scenario from the total life-years lost to TB under a counterfactual scenario (e.g., the base-case).

**TABLE 1: Remaining life expectancy by age<sup>†</sup>, for calculation of life-years and QALYs saved.**
 
 
| Age Group |	Life expectancy[^fn1] |
|:-------------|:--------------|
| 0–4 years |	78.7 |
| 5–14 years | 72.0 |
| 15–24 years |	62.2 |
| 25–34 years | 52.7 |
| 35–44 years |	43.4 |
| 45–54 years |	34.2 |
| 55–64 years | 25.7 |
| 65–74 years |	18.0 |
| 75–84 years |	11.3 |
| 85–94 years |	6.19 |
| 95 years+ |	3.18 |

† The age-weighted average of life expectancies by 5-year age groups in 2018 was calculated to produce the 10-year age bands presented above.

**QALYs saved**

We first calculate the total QALYs lost to TB for each scenario. These are calculated as the sum of:

(i)	QALYs lost due to TB death: these are equal to the total life-years lost from TB, as described above.

(ii) QALYs lost during TB disease and TB treatment: these are calculated as the product of total life-years lived with TB disease, including time spent on TB treatment (estimated from the MITUS model), and the disutility of TB disease.

(iii)	QALYs lost during LTBI treatment: this is calculated as the product of total individuals initiating LTBI treatment (estimated from the transmission model), probability of hepatoxicity for this group, and the estimated QALYs lost per episode of hepatoxicity.

Values and sources for QALY inputs are shown in Table 2. Estimates of QALYs saved are calculated by subtracting the total QALYs lost to TB in a given scenario from the total QALYs lost to TB under a counterfactual scenario (e.g., the base case).

**TABLE 2: Additional inputs for QALY calculation**

| Input	| Value |
|-------------------------------------------|-------------------------------------|
| Life expectancy at the time of TB death1 | See Table 1|
| **Utility weights** |
| LTBI treatment with no toxicity	| 1 |
| LTBI treatment with toxicity[^fn2] 	| 0.75 |
| TB disease and treatment[^fn3] 	| 0.76 |
| **Other parameters** |
| Duration of TB disease prior to TB treatment	| 2.87–5.88 months (from transmission model) |
| Duration of TB treatment	| 9 months |
| Probability of toxicity during LTBI treatment[^fn4] | 0.003 |

### Health services costs 
For each scenario Tabby2 estimates health services costs related to treatment of LTBI and TB disease. These are calculated from incremental differences in health service provision estimated by the MITUS transmission dynamic model cumulated over an analytic horizon chosen by the user, and unit costs estimated for each of these services. Details on the calculation of each cost outcomes are shown below. Total cost estimates are shown on the economic evaluation section of Tabby2, in the ‘Costs’ table.

**Health service costs of LTBI testing and treatment**

LTBI testing and treatment costs are calculated as the sum of the costs associated with:

(i)	Identifying individuals for testing: total individuals offered testing (estimated by the MITUS model) multiplied by a unit cost per person offered testing.

(ii) LTBI testing: total individuals tested (estimated by the MITUS model) multiplied by a unit cost of diagnosis. Unit costs are estimated as a weighted average of TST and IGRA costs.

(iii)	Ruling out TB disease: total individuals testing positive for LTBI (estimated by the MITUS model), multiplied by the costs of TB disease screening (estimated as the cost of two chest x-rays).

(iv) LTBI treatment: total individuals initiating LTBI treatment (estimated by the MITUS model) multiplied by a unit cost of LTBI treatment. This unit cost was calculated as the average cost of 3HP, 4R, and 3HR regimens, weighted by the distribution of regimens chosen by the user.

Values for these inputs are shown in Table 3. Several of these values represent defaults that can by adjusted by users of the webtool. All health cost estimates taken from published sources were updated to 2020 US dollar values using Bureau of Economic Analysis Personal Consumption Expenditures (PCE) separate indices for hospital and outpatient healthcare services.

**TABLE 3: Inputs for LTBI testing and treatment costs in USD 2020**

| Input |	Value | Can be edited by user? |	Comment/source |
|-----------|-----|-------------------|---------------|
| Cost to identify an individual for LTBI testing 	| $0 	| Yes 	| Default to zero |
| Cost of TST	| $9.35 | Yes 	| CMS 2020, Physician Fee CPT 86580 |
| Cost of IGRA	| $61.98 	| Yes 	| CMS 2020, Limit (Q4) CPT 86480 |
| Fraction of LTBI tests with IGRA	| 0.50	| Yes	| Default, to be updated by user |
| **Cost of ruling out TB disease before treatment initiation** |	$33.20 	| Yes 	 | |
| Chest x-ray (2 view) 	| $33.20	| No	| CMS 2020, Physician’s Fee CPT 71046 | 
| **Total cost of treatment with 3HP (self-administered)**	| $411.87 	| Yes 	 | |
| Medication costs[^fn5]  	| $133 	| No	 | |
| Cost of clinic visits[^fn6] 	| $244.77 | No	| See note below<sup>†, ††</sup> |
| Adverse events of 3HP (medical)\(^6\)	| $33.59	| No	| See note below<sup>††</sup> |
| **Total cost of treatment with 3HR**	| $354.87	| Yes	 | |
| Medication costs\(^5\)	| $76	| No	 | |
| Cost of clinic visits\(^6\)	| $244.77	| No	| See note below<sup>†, ††</sup>  |
| Adverse events of 3HR (medical)\(^6\)	| $34.10	| No	| See note below<sup>†††</sup>  |
| **Total cost of treatment with 4R**	| $353.61	| Yes 	 | |
| Medication costs\(^5\)	| $78 | No| 	
| Cost of clinic visits\(^6\)	| $275.61	| No	| See note below<sup>†, ††</sup>  |
| **Distribution of treatment of LTBI regimens** | 	
| Fraction treated receiving 3HP	| 0.33	| Yes	| Default, to be updated by user | 
| Fraction treated receiving 3HR	| 0.33	| Yes	| Default, to be updated by user |
| Fraction treated receiving 4R	| 0.33	| Yes	| Default, to be updated by user |

† Values were converted from 2010 to 2020 dollars using the ratio of PCE separate indices for outpatient services for each of these years (1.10). 

†† Cost of clinic visit is inclusive of supplies for the associated visits.

††† We assume a common cost of adverse effects for both isoniazid-containing regimens (3HP and 3HR). This cost is based on hepatoxicity. We assume no toxicity from the 4R regimen. 

**Health service cost of TB disease treatment**
TB treatment costs are calculated as the number of individuals receiving TB treatment multiplied by a fixed unit cost. Inputs used in these calculations are shown in Table 4. Of note, the transmission model does not stratify cases by drug resistance and therefore assumes a single unit cost for TB treatment. For this reason, the cost-savings associated with TB cases averted by LTBI treatment may be overestimated by 10–15%. This is because the averted cases will not include MDR-TB, even though the unit cost is calculated as a weighted average that includes MDR-TB. The average cost of TB treatment includes the cost of diagnosing TB disease.

**TABLE 4: Inputs for TB testing and treatment costs in USD 2020.**

| Input |	Value | Can be edited by user? |	Comment/source |
|------------------------------------|-----|-------------------|---------------|
| Cost to identify an individual for TB testing 	| $0	| Yes 	| Default to zero |
| Average cost of TB treatment	| $22,049.75	| Yes	| Weighted average by drug-susceptibility (shown below) |
| Direct treatment costs non-MDR TB[^fn7] 	| $21,325	| No	| See note below<sup>†</sup> |
| Direct treatment costs MDR TB\(^7\)	| $182,186	| No	| See note below<sup>††</sup> |
| Direct treatment costs XDR TB\(^7\)	| $567,708	| No	| See note below<sup>††</sup> |
| **Distribution of drug strains**[^fn8] |  |  |  |
| Non-MDR TB	| 0.9921	| No | |
| MDR TB	| 0.0078	| No | |
| XDR TB	| 0.0001	| No | |
 

† Direct costs of non-MDR TB are calculated as the product of the probability of hospitalization, average duration of hospitalization[^fn9]  and cost per day of hospitalization estimates.[^fn10]   An average outpatient cost is also added for the total value.  The values were converted to 2020 USD from 2014 USD using the ratio of PCE outpatient indices for each of these years, 1.06.

†† Converted from 2010 to 2020 dollars using the ratio of PCE inpatient and outpatient indices for each of these years, 1.21 and 1.10, respectively.

### Productivity costs

In addition to health services costs, Tabby2 calculates the loss in economic productivity associated with receipt of TB treatment and TB disease morbidity and mortality. These are calculated from incremental differences in health outcomes and health services estimated by the MITUS transmission dynamic model accumulated over an analytic horizon chosen by the user, and age-stratified estimates of economic productivity loss. Details on the calculation of these outcomes are shown below. Estimates of total productivity losses are shown on the economic evaluation section of Tabby2, in the ‘Costs’ table.

**Productivity costs of LTBI treatment**
For each scenario, the productivity costs associated with LTBI treatment are calculated from the cost inputs shown in Table 5. The adverse event costs are estimated according to the user-selected distribution of drug regimens.

**TABLE 5: Inputs for productivity costs associated with LTBI treatment in USD 2020.**

| Input	| Value (2020 USD)	| Comment |
|----------------------------------------------|----------------|-----------------|
| Initial clinic visit\(^6\)	| $48.01	| See note below<sup>†</sup> |
| Follow-up clinic visit\(^6\)	| $28.16	| See note below<sup>†</sup> |
| Adverse events of LTBI treatment with 3HP or 3HR\(^6\)	| $5.27	| See notes below<sup>†,††</sup> |
| Adverse events of LTBI treatment with 4R	| $0	| See note below<sup>†††</sup> |
 
† These values were converted from 2010 dollars to 2020 dollars using the ratio of Bureau of Labor Statistics Average Hourly Earnings of Production and Nonsupervisory Employees index for patient productivity (1.30).

†† We assume the patient productivity per day is $220 (2016 USD) and average hospitalization stay is 7 days.[^fn11] The average cost of adverse events with 3HP can be calculated as the product of these values and the probability of hospitalization with 3HP toxicity. This value was then converted to 2020 dollars using the ratio of Bureau of Labor Statistics Average Hourly Earnings of Production and Nonsupervisory Employees index for patient productivity for each of these years (1.14).

††† While we allow for differential LTBI treatment regimens, which have different probabilities of adverse events, we assume a common cost of these adverse effects across 3HP and 3HR as they both include isoniazid. We assume no toxicity from the 4R regimen. The costs of adverse events for 3HP and 3HR have been weighted by the probability of adverse events (Table 2).

**Productivity costs of TB disease**

The productivity costs of TB disease are calculated as the sum of productivity losses from mortality and morbidity. Mortality costs for each scenario are calculated as loss of productivity given the age-specific life expectancy at TB death and the remaining age-specific annual productivity estimates. Morbidity costs are calculated as the average time loss due to outpatient TB services and the average hospitalization cost, derived as the product of the probability of hospitalization, average duration of hospitalization, and age-specific productivity estimate. Morbidity costs are only incurred in the time leading to TB death. The total productivity costs of TB disease are the sum of both of these values. Values used in these calculations are shown in Table 6. 

**TABLE 6: Inputs for productivity costs associated with TB disease**

| Input | Value |
|------------------------------------------------------------|--------------------|
| Probability of hospitalization with TB\(^6\)	| 0.49 |
| Average duration of hospitalization with TB\(^6\)	| 24 days |
| Time losses due to outpatient services\(^6\)	| 6.8 days |
| **Annual productivity by age**\(^{11}\) | |  	
| 15–24 years old	| $20,166 |
| 25–34 years old 	| $64,686 |
| 35–44 years old	| $87,023 |
| 45–54 years old 	| $83,354 |
| 55–64 years old	| $67,990 |
| 65–74 years old 	| $38,504 |
| 75+ years old	| $16,017 |
| **Lifetime productivity by age**\(^{11}\)	 | |
| 0–4 years old	| $1,117,558 |
| 5–14 years old	| $1,399,870 |
| 15–24 years old	| $1,757,978 |
| 25–34 years old 	| $1,856,808 |
| 35–44 years old	| $1,582,474 |
| 45–54 years old 	| $1,142,626 |
| 55–64 years old	| $675,070 |
| 65–74 years old 	| $315,914 |
| 75–84 years old	| $150,406 |
| 85–94 years old	| $88,059 |
| 95+ years old	| $30,805 |

† Note: annual and lifetime labor productivity estimates for future years are adjusted for a projected real income growth of (.5% or 1%).

### Total cost estimates

Two estimates of total costs are reported:

•	The **total health services cost**, which sums the costs of LTBI and TB treatment cost over the analytical time horizon chosen by the user, and

•	The **total cost**, which sums health services costs and productivity costs over the analytical time horizon chosen by the user.

### Cost-effectiveness analysis

Tabby2 presents the user with several options for changing parameters of the cost-effectiveness analysis:

•	**Analytic horizon**: the time period of the analysis. This is specified on the ‘Input Costs’ page. Costs and health benefits are summed over this period for the cost-effectiveness analysis, and other tables on the page.

•	**Health outcome**: the user can select one of four health outcomes (TB cases, TB deaths, QALYs, and life-years) to be used in the cost-effectiveness analysis. The details of these measures are described under the health impact section.

•	**Analytical/costing perspective**: healthcare system or healthcare system plus productivity losses. The user can select whether to include or exclude productivity costs from the cost-effectiveness analysis.

•	**Discount rate**: the user can select whether to conduct the cost-effectiveness analysis with undiscounted costs and health outcomes, or to discount both costs and health outcomes at a fixed annual rate of 3%.[^fn12]

•	**Counterfactual**: the user can select one of two approaches for calculating cost-effectiveness ratios. In the first approach, all ACERs are calculated with respect to the base-case scenario (e.g., for a given intervention (IntA), the cost-effectiveness ratio is calculated as [Costs(IntA) − Costs(base case)] ÷ [HealthBenefit(IntA) − HealthBenefit(base case)]). In the second approach, a traditional incremental cost-effectiveness analysis is conducted, with dominated strategies excluded, strategies ordered by increasing health impact, and ICERs then calculated from the incremental costs and health benefits of each strategy compared to the next least effective.

The choice of health outcome, costing perspective, discount rate, and counterfactual are selected using radio buttons on the left panel of the tool. Results of the cost-effectiveness analysis are shown in the ‘Cost-Effectiveness Table’. Cost-effectiveness results are not shown for dominated strategies (strategies that have positive costs and negative health benefits compared to their counterfactual), and these are instead labeled as ‘dominated’.

Citations 
----------------------

[^fn1]: United States Mortality DataBase. Berkeley, CA (USA): University of California, Berkeley; 2020 [https://usa.mortality.org/, last accessed May 24 2021]. 

[^fn2]: Holland DP, Sanders GD, Hamilton CD, Stout JE. Costs and cost-effectiveness of four treatment regimens for latent tuberculosis infection. Am J Respir Crit Care Med. 2009 Jun 1;179(11):1055-60. doi: 10.1164/rccm.200901-0153OC. Epub 2009 Mar 19. PMID: 19299495; PMCID: PMC2689913.

[^fn3]:Guo N, Marra CA, Marra F, Moadebi S, Elwood RK, Fitzgerald JM. Health state utilities in latent and active TB. Value Health 2008; 11: 1154-1161.

[^fn4]: Sterling TR, Villarino ME, Borisov AS, et al. Three months of rifapentine and isoniazid for latent tuberculosis infection. N Engl J Med. 2011; 365:2155–2166. [PubMed: 22150035]

[^fn5]: US Department of Veterans Affairs. National Acquisition Center. https://www.vendorportal.ecms.va.gov/nac/Pharma/List  Accessed February 2021.

[^fn6]: Shepardson D, Marks SM, Chesson H, Kerrigan A, Holland DP, Scott N, et al. Cost-effectiveness of a 12-dose regimen for treating latent tuberculous infection in the United States. Int J Tuberc Lung Dis 2013;17(12):1531-7.

[^fn7]: Centers for Disease Control and Prevention. “CDC Estimates for TB Treatment Costs.” Atlanta, GA: Centers for Disease Control and Prevention, National Center for HIV/AIDS, Viral Hepatitis, STD, and TB Prevention, Division of Tuberculosis Elimination; 2021. https://www.cdc.gov/tb/publications/infographic/appendix.htm, last accessed February 16, 2022. 

[^fn8]: Centers for Disease Control and Prevention. “Reported Tuberculosis in the United States, 2020.” Atlanta, GA: Centers for Disease Control and Prevention, National Center for HIV/AIDS, Viral Hepatitis, STD, and TB Prevention, Division of Tuberculosis Elimination; 2021. Table 9 and the Executive Summary https://www.cdc.gov/tb/statistics/reports/2020/table9.htm 
https://www.cdc.gov/tb/statistics/reports/2020/Exec_Commentary.html, last accessed February 16, 2022. 

[^fn9]: Taylor, Z., et al. "Causes and costs of hospitalization of tuberculosis patients in the United States." The International Journal of Tuberculosis and Lung Disease 4.10 (2000): 931-939.

[^fn10]: Aslam MV, Owusu-Edusei K, Marks SM, Asay GRB, Miramontes R, Kolasa M, Winston CA, Dietz PM. Number and cost of hospitalizations with principal and secondary diagnoses of tuberculosis, United States. Int J Tuberc Lung Dis. 2018; 22(12):1495-1504.

[^fn11]: Grosse, Scott D., Kurt V. Krueger, and Jamison Pike. "Estimated annual and lifetime labor productivity in the United States, 2016: implications for economic evaluations." Journal of medical economics 22.6 (2020): 501-508.

[^fn12]: Neumann PJ, Sanders GD, Russell LB, Siegel JE, Ganiats TG, editors. Cost-effectiveness in health and medicine. Oxford University Press; 2016. 
