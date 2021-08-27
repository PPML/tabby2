About Tabby2 Economic Analysis 
-----------------------------

Public health officials are often tasked with allocating limited resources with the goal of maximizing health impact. Estimating the long-term costs and health benefits of proposed TB interventions can aid in the choice of TB prevention strategy, and help justify budget allocations. We developed Tabby2 Economics to allow users to explore the potential costs and health benefits of different intervention options. It uses a web interface connected to a mathematical model to forecast disease outcomes. For intervention scenarios selected or entered by users, Tabby2 Economics reports intervention costs and estimated health benefits, as well as calculations of their cost-effectiveness. 

Below is a brief introduction to the economic analysis of the health interventions, default cost values, and the concepts of cost effectiveness analysis. To review our detailed costing methodology, please visit [Tabby2 Economic Analysis Methods](https://github.com/PPML/tabby2/blob/master/utilities/inst/md/Tabby2EconomicAnalysisMethods.md). Navigating to the “Further Description” page of this tool provides a walkthrough of all options available in Tabby2 Economics. 


### Unit Cost Inputs 

Tabby2 Economics allows users to specify unit costs for various LTBI and TB care cascade health services. Default unit costs are averages (e.g., treatment of TB disease), based on national average allowable Medicare reimbursements reported by The Centers for Medicare and Medicaid Services and on cost analyses estimated by CDC. If users have access to other unit costs they want to use, these can be entered in the tool before the economic analysis is conducted. In the tool, all cost inputs are assumed to represent 2019 price levels.

### Cost-Effectiveness Analysis

Cost-effectiveness analysis compares the costs and health outcomes of two or more intervention scenarios. The results of these analyses are reported as ‘cost-effectiveness ratios,’ which represent the cost per additional health outcome achieved (e.g., the cost per additional TB case prevented) in using that scenario compared with an alternative scenario.  

Tabby2 Economics allows for the comparison of pre-defined and user-defined TB intervention scenarios. This functionality allows various options for the user to select: 

**Analytic horizon** defines the period over which the effects of an intervention scenario (costs and health benefits) are calculated when estimating cost-effectiveness ratios. A longer analytic horizon will consider outcomes over a longer period, and potentially capture more of the prevention impact of TB interventions. The analytic horizon is defined in the 'Input Costs' page.  

**Health outcomes** for the cost-effectiveness analysis, including TB cases averted, TB deaths averted, quality-adjusted life-years (QALYs) saved, or life-years saved. This will be the unit of health benefit for comparing different intervention scenarios. All health outcomes are displayed in the tool’s ‘Effectiveness’ table for review.

**Costing/Analytical perspective** determines which costs are included in the comparison. The ‘healthcare services perspective’ includes the costs associated with providing health services, such as LTBI testing and treatment, which includes costs incurred by TB clinics as well as out-of-pocket costs borne by patients (such as spending on transportation or for day care for their children during clinic visits). Alternatively, users can choose to use the ‘societal perspective,’ which includes healthcare services costs and the costs of patient lost productivity or earnings through time spent ill with TB disease or time spent attending clinic visits.

**Discounting** of future costs and outcomes accounts for the preference for dollars now versus in the future. Discounting reduces the values of costs and health benefits that occur in the future, as compared to costs and health benefits that happen this year. The user can choose to discount both costs and health outcomes at an annual discount rate of 3% (a conventional value for cost-effectiveness analyses in the United States) or conduct the analysis without discounting. 

**Comparison scenario** determines the scenario to which all other scenarios are compared. In the first approach, all cost-effectiveness ratios are calculated by comparing each new intervention scenario to the base-case scenario, resulting in an ‘average cost effectiveness ratio’ (ACER). In the second approach, a traditional incremental cost-effectiveness analysis is conducted. Strategies are ordered by increasing health impact, and ‘incremental cost-effectiveness ratios’ (ICERs) are calculated by dividing the incremental costs by the incremental health benefits of each scenario compared to the next least effective scenario. In this incremental cost-effectiveness analysis, intervention scenarios that produce both worse health outcomes and higher costs than its comparison scenario are automatically omitted (dominated strategies) before calculating results. 

For additional information, please refer to [Tabby2 Economic Analysis Methods](https://github.com/PPML/tabby2/blob/master/utilities/inst/md/Tabby2EconomicAnalysisMethods.md) and 'Further Description' section of Tabby2, or contact us through the 'Feedback' page. 