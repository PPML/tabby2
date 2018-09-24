About Tabby
===========


Tabby is a web application that predicts future tuberculosis (TB)
epidemiology in the United States, based on hypothetical scenarios
chosen by the user. Users can select a health outcome and population
group of interest, then select one or multiple scenarios to compare.
Results are displayed graphically, and following inputs from the user,
the graphs update automatically to reflect the new selections.
Visualizations can be downloaded in various formats, and the estimates
underlying the graphs can also be downloaded in tabular format.

For the definitions of terms and abbreviations used in this application,
see the Definitions page of the application. Additionally, common
questions about Tabby are answered in the Frequently Asked Questions
(FAQ) page. Any further questions may be directed
to [*ppml@hsph.harvard.edu*](mailto:ppml@hsph.harvard.edu).

The estimates shown by Tabby are based on a mathematical model of TB
epidemiology in the United States. The model can be used to investigate how
changes in the drivers of TB epidemiology could lead to changes in long term
epidemiology. For further details on the epidemiological factors included in the
model, detailed methods, and main results see the paper “Prospects for
tuberculosis elimination in the United States: results of a transmission dynamic
model” Menzies et al, American Journal of Epidemiology 2018 (forthcoming). While
the model itself includes a large number of factors determining TB epidemiology,
this web tool is restricted to the scenarios included in the published journal
article, and does not allow user control of individual parameters.

The findings and conclusions described in this web application and
linked journal article are those of the author(s) and do not necessarily
represent the views of the U.S. Centers for Disease Control and
Prevention. This web tool was funded by the CDC, National Center for
HIV, Viral Hepatitis, STD, and TB Prevention Epidemiologic and Economic
Modeling Agreement (NEEMA, \# 5U38PS004644-01).

### Organization of the tool

Tabby has three pages with interactive visualizations: *Estimates, Time
Trends,* and *Age Groups.* Each page can be accessed from the menu bar
at the top of the page.

The *Estimates* page visualizes predicted TB outcomes at five major time
points: 2016, 2025, 2050, 2075, and 2100.

The *Time Trends* page depicts predicted TB outcomes for each individual
year from 2016 to 2100.

The *Age Groups* page visualizes predicted TB outcomes for a specified
year subdivided into 11 age groups.

#### Estimates page

User options are shown in a column on the left. The user specifies:

*Comparison:* results can be shown as absolute values for each outcome
in each year, as a percentage of the base case scenario in the same
year, or as a percentage of the base case scenario in 2016.

*Subgroup:* results can be shown for the total population, or for a
subgroup described by nativity (U.S.-born, non-U.S.-born), and broad age
groups (0-24 years, 25-64 years, 65+ years).

*Outcome:* results can be shown for five different outcomes:

-   **Incident TB Infections** representing the annual number of
    incident *M. tb (Mycobacterium tuberculosis)* infections per million
    due to transmission within the United States (includes reinfection of
    individuals with LTBI, excludes migrants entering the United States with
    established LTBI);
-   **LTBI Prevalence** representing the percentage of individuals with
    latent TB infection in a given year;
-   **Active TB Incidence** representing the annual number of notified TB
    cases per million, including TB cases identified after death;
-   **MDR-TB in Incident TB Cases** representing the percentage of all
    incident TB cases with multidrug-resistant TB (MDR-TB); and
-   **TB-Related Deaths** representing annual TB-attributable mortality
    per million.

*Scenarios:* results can be shown for up to five scenarios selected by
the user, describing hypothetical changes to current TB prevention and
control activities (‘Modeled Scenarios'). Descriptions for
each scenario are provided below.

*Download:* clicking on a button initiates download of the visualization
itself (.png, .pdf, .pptx) or the estimates underlying the visualization
(.csv, .xlsx).


#### Time Trends page

User options are shown in a column on the left. The user specifies:

*Comparison:* results can be shown as absolute values for each outcome
in each year, as a percentage of the base case scenario in the same
year, or as a percentage of the base case scenario in 2016.

*Subgroup:* results can be shown for the total population, or for a
subgroup described by nativity (U.S.-born, non-U.S.-born), and broad age
groups (0-24 years, 25-64 years, 65+ years).

*Outcome:* results can be shown for five different outcomes:

-   **Incident TB infections** representing the annual number of
    incident *M. tb (Mycobacterium tuberculosis)* infections per million
    due to transmission within the United States (includes reinfection of
    individuals with prior infection, excludes migrants entering the
    United States with established LTBI);
-   **LTBI Prevalence** representing the percentage of individuals with
    latent TB infection in a given year;
-   **Active TB Incidence** representing the annual number of notified TB
    cases per million, including TB cases identified after death;
-   **MDR-TB in incident TB cases** representing the percentage of all
    incident TB cases with MDR-TB; and
-   **TB-Related Deaths** representing annual TB-attributable mortality
    per million.

*Scenarios:* results can be shown for up to five scenarios selected by
the user, describing different assumptions about future TB prevention
and control policy (‘Modeled Scenarios'). Descriptions for
each scenario are provided below.

*Download:* clicking on a button initiates download of the visualization
itself (.png, .pdf, .pptx) or the estimates underlying the visualization
(.csv, .xlsx).

#### Age Groups page

This page matches the format of the first two pages with the following
exceptions:

*Comparison:* results are only shown as absolute values for each outcome
in each year.

*Subgroup:* results can be shown for the total population, or for
U.S.-born and non-U.S.-born alone.

*Outcomes:* results can be shown for three major outcomes (LTBI
prevalence, TB incidence, and TB-related deaths), either as a prevalence
or incidence rate with each age group (first three selections), or in
absolute numbers (last three selections).

The following are descriptions of the intervention scenarios and
outcomes available for visualization in Tabby.

#### Scenarios

**Base case scenario**

The base case scenario projects TB health outcomes assuming steady
coverage and effectiveness of current TB prevention and treatment
activities.

Each of the other scenarios that the user can select modify this base
case scenario in some way, as described below.

**Modeled Scenarios**

-   **TLTBI for New Immigrants:** Provision of LTBI testing and treatment
    for all new legal immigrants entering the United States.
-   **Improved TLTBI in the United States:** Intensification of the
    current LTBI targeted testing and treatment policy for high-risk
    populations, doubling treatment uptake within each risk group
    compared to current levels, and increasing the fraction cured among
    individuals initiating LTBI treatment, via a 3-month
    Isoniazid-Rifapentine drug regimen.
-   **Better Case Detection:** Improved detection of active TB cases, such
    that the duration of untreated active disease (time from TB
    incidence to the initiation of treatment) is reduced by 50%.
-   **Better TB Treatment:** Improved treatment quality for active TB,
    such that treatment default, failure rates, and the fraction of
    individuals receiving an incorrect drug regimen are reduced by 50%
    from current levels.
-   **All Improvements:** The combination of all intervention scenarios
    described above.

### 508 Accessibility of This Product

Section 508 requires Federal agencies and grantees receiving Federal
funds to ensure that individuals with disabilities who are members of
the public or Federal employees have access to and use of electronic and
information technology (EIT) that is comparable to that provided to
individuals without disabilities, unless an undue burden would be
imposed on the agency.

If you need assistance with this web application, please contact
<ppml@hsph.harvard.edu>.

### 
