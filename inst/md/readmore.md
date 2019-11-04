Definitions and Abbreviations
-----------------------------

**Base Case**

The base case is the default scenario, assuming no change in current TB
prevention and control activities. This scenario is automatically
included in all visualizations, and other scenarios are defined and
analyzed with reference to this scenario.

**Dynamic Transmission Model**

Dynamic transmission models are systems of mathematical equations
designed to reproduce the epidemiology of communicable diseases. These
analyses assume that improvements in disease control (such as more rapid
diagnosis and treatment of infectious individuals) will reduce the risk
that uninfected individuals will be exposed to infection. In this
manner, individuals not directly reached by an intervention may still
benefit by experiencing a lower risk of infection.

**IGRA – Interferon-Gamma Release Assays**

IGRAs are blood tests that can aid in the diagnosis of tuberculosis
infection.

**Incident Cases**

Incident cases are new disease cases. Incidence refers to the number of
new cases that develop in a particular population in a given period of
time.

**Isoniazid (INH)**

A medicine used to prevent TB disease in people who have latent TB
infection. INH is also one of the four medicines often used to treat TB
disease.

**LTBI – Latent tuberculosis infection**

A condition in which individuals are infected with TB bacteria, but this
infection is controlled by the individual's immune system. People with
latent TB infection have no symptoms, don't feel sick, and can't spread
TB to others. Individuals with LTBI usually have a positive TB skin test
or positive TB blood test reaction. Individuals with LTBI may develop TB
disease in the future if they do not receive treatment.

**Prevalence**

The number of cases of a disease present in a population at a given
time.

**Rifapentine (RPT)**

A medication used to treat latent TB infection.

**TST – Tuberculin Skin Test**

TSTs determine if someone has developed an immune response to the
bacterium that causes tuberculosis, Mycobacterium tuberculosis.

**TB – Tuberculosis**

A disease caused by bacteria that are spread from person to person
through the air. TB usually affects the lungs, but it can also affect
other parts of the body, such as the brain, the kidneys, or the spine.
In most cases, TB is treatable and curable; however, people with TB can
die if they do not get proper treatment.


Organization of the Tool
------------------------

<!-- ![](img/figure1.png =250x){width="1.8284722222222223in"
height="4.097222222222222in"} --> 


Users of Tabby2 progress through a sequence
of pages that provide a brief introduction to the tool, allow them to
specify scenarios and choose outcomes of interest, and ultimately to
view and download graphs of their chosen outcomes. The tool's sidebar
(Figure 1) serves as the primary navigational aid for the user.

<table>
<tr>
<td>
<ul>
  <li>   Introduction </li>
  <li>   Scenarios </li>
      <ul>
      <li>   Predefined Scenarios </li>
      <li>   Custom Scenarios </li>
          <ul>
          <li>   Targeted Testing and Treatment </li>
          <li>   Care Cascade Changes </li>
          <li>   Combination Scenarios </li>
          </ul>
      </ul>
  <li>   Modelled Outcomes </li>
      <ul> 
      <li>   Estimates </li>
      <li>   Time Trends </li>
      <li>   Age Groups </li>
      <li>   Comparison to Recent Data </li>
      </ul>
  <li>   Further Description </li>
  <li>   Feedback </li>
</ul>
  
</td>
<td width='33%'>

<figure>
  <img src='img/figure1.png' alt="Figure 1: Sidebar Showing the Sections of the Tabby2 Application" width="175px"/>
  <figcaption>Figure 1: Sidebar Showing the Sections of the Tabby2 Application</figcaption>
</figure>
</td>
</tr>
</table>


### Introduction

On the introduction page of Tabby2 (Figure 2), the user is shown the
*About Tabby2* text and is prompted to select a location. After
specifying a location, Tabby2 will load figures showing historical data
and model estimates calibrated to that location.

<center>
<figure>
  <img src='img/figure2.png' alt="Figure 2: The Introduction Page of the Tabby2 Web Application" height="275px"/>
  <figcaption>
    Figure 2: The Introduction Page of the Tabby2 Web Application
  </figcaption>
</figure>
</center>
<!--![](img/figure3.png){width="6.026842738407699in"
height="4.070539151356081in"}

Figure 2: The Introduction Page of the Tabby2 Web Application
-->

### Scenarios

#### Predefined Scenarios

Tabby2 provides estimates of future TB outcomes for a small number of
predefined scenarios, in addition to a base case scenario that assumes no
change in current TB prevention and control activities. The tool's predefined
scenarios include five hypothetical scenarios that reflect a range of
changes to latent TB and TB disease testing and treatment, described below.

-   **LTBI treatment for new migrants**: Provision of LTBI testing and
    treatment for all new legal migrants entering the US.

-   **Improved LTBI treatment in the United States**: Intensification of the
    current LTBI targeted testing and treatment efforts for high-risk
    populations, doubling treatment uptake within each risk group
    compared to current levels, and increasing the percentage cured among
    individuals initiating LTBI treatment, via a 3-month
    Isoniazid-Rifapentine drug regimen.

-   **Enhanced case detection**: Improved detection of TB disease cases,
    such that the duration of untreated disease (time from TB
    incidence to the initiation of treatment) is reduced by 50%.

-   **Enhanced TB treatment**: Improved treatment quality for TB disease,
    such that treatment default, failure rates, and the percentage of
    individuals receiving an incorrect drug regimen are reduced by 50%
    from current levels.

-   **All improvements**: The combination of all intervention scenarios
    described above.

Each of these scenarios is automatically available when the user chooses
scenarios to plot.

After the user reviews the descriptions of the predefined scenarios,
they can either proceed to one of the *Modelled Outcomes* pages to view the
results corresponding to these predefined scenarios, or choose to define
a new scenario by navigating to the *Custom Scenarios* page.

#### Custom Scenarios

Custom Model Scenarios allow users to generate a new scenario by selecting
different options for Targeted Testing and Treatment of LTBI ("Targeted Testing
and Treatment") or TB disease and latent infection treatment ("Care Cascade
Changes"). Users can also create scenarios as a combination of changes in both
of these areas, specified on the "Combination Scenarios" page.


After specifying a Targeted Testing and Treatment scenario, Program
Change scenario, or Combination scenario, the user clicks the "Run
Model" button to simulate the scenario they have specified. Upon
navigating to one of the *Modelled Outcomes* pages, their scenario will appear as
an option for visualization or download in the *Estimates, Time Trends,*
and *Age Groups* pages of the application.

#### Custom Scenarios – Targeted Testing and Treatment

<!--![](media/image3.png){width="4.64in" height="2.75in"}-->
<center>
<figure>
  <img src='img/figure3.png' alt="Figure 3: User Interface for Building Targeted Testing and Treatment Interventions" height="275px"/>
  <figcaption>
    Figure 3: User Interface for Building Targeted Testing and Treatment
    Interventions
  </figcaption>
</figure>
</center>

The *Targeted Testing and Treatment* (TTT) input page (Figure 3) is used
to create scenarios that simulate additional screening of specific risk
groups over a specified number of years. Within the TTT scenario
builder, a user can either select from a list of high-risk groups (such
as people living with HIV), or choose to define a custom risk group. To
do so, the user must define the new group in terms of their rate ratios
of LTBI prevalence, progression, and mortality, as compared to the
general population in the same age and nativity group. Additionally, a
user must provide an age range, nativity group, and total targeted
population size.

#### Custom Scenarios – Care Cascade Changes

<!--![](media/image4.png){width="4.66in" height="2.75in"}

Figure 4: User Interface for Building Care Cascade Changes -->

<center>
<figure>
  <img src='img/figure4.png' alt="Figure 4: User Interface for Building Program Change Scenarios" height="275px"/>
  <figcaption>
    Figure 4: User Interface for Building Care Cascade Change Scenarios
  </figcaption>
</figure>
</center>

The *Care Cascade Changes* page (Figure 4) allows users to change assumptions
related to the LTBI treatment and TB treatment care cascades.
These changes do not change any historical projections the model has
made and will only be active in the years following the user-inputted
start year.


#### Custom Scenarios – Combination Scenarios

The <i>Combination Scenarios</i> page (Figure 5) allows users to simulate
combinations of targeted testing and treatment for LTBI, and changes to the 
care cascade.

<table>
<tr>
<td>
<center>
<figure>
  <img src='img/figure5.png' alt="Figure 5: User Interface for Building Combination Scenarios" height="200px"/>
  <figcaption>
    Figure 5: User Interface for Building Combination Scenarios 
  </figcaption>
</figure>
</center>
</td>
</tr>
</table>

### Modelled Outcomes

<center>
<figure>
  <img src='img/figure6.png' alt="Figure 6: The Time Trends page of Tabby2 Depicting the Incident M. tuberculosis Infections Outcome for the 5 Predefined Scenarios" height="300px"/>
  <figcaption>
    Figure 6: The Time Trends page of Tabby2 Depicting the Incident M. tuberculosis
    Infections Outcome for the 5 Predefined Scenarios
  </figcaption>
</figure>
</center>

Model outcomes are presented as four interactive pages with
visualizations: *Estimates*, *Time Trends*, *Age Groups*, and
*Comparison to Recent Data*.

The *Estimates* page provides graphs of modelled results at five major
time points: 2018, 2020, 2025, 2035, and 2050.

The *Time Trends* page (Figure 6) provides graphs of modelled results
for each individual year from 2018 to 2050.

The *Age Groups* page provides graphs of modelled results for a specific
year chosen by the user, subdivided into 11 age groups.

The *Comparison to Recent Data* page shows model results compared to
recent empirical data and estimates.

A detailed description of each of these pages is provided below.

#### Modelled Outcomes – Estimates 

User options are shown in a column on the left. The user specifies:

*Comparison:* results can be shown as absolute values for each outcome
in each year, as a percentage of the base case scenario in the same
year, or as a percentage of the base case scenario in 2018.

*Subgroup:* results can be shown for the total population, or for a
subgroup described by nativity (U.S.-born, non-U.S.-born), and broad age
groups (0-24 years, 25-64 years, 65+ years).

*Outcome:* results can be shown for five different outcomes:

-   **Incident TB infections** representing the annual number of
    incident *M. tuberculosis (Mycobacterium tuberculosis)* infections per 100,000
    due to transmission within the United States (includes reinfection
    of individuals with prior LTBI, excludes migrants entering the United
    States with established LTBI);

-   **LTBI Prevalence** representing the percentage of individuals with
    latent TB infection in a given year;

-   **TB Incidence** representing the annual number of notified
    TB cases per 100,000, including TB cases identified after death;

-   **TB-Related Deaths** representing annual TB-attributable mortality
    per 100,000.

*Scenarios:* results can be shown for up to five scenarios selected by
the user, describing hypothetical changes to current TB prevention and
control activities ("Modeled Scenarios").

*Download:* clicking on a button initiates download of the visualization
itself (.png, .pdf, .pptx) or the estimates underlying the visualization
(.csv, .xlsx).

#### Modelled Outcomes – Time Trends 

User options are shown in a column on the left. The user specifies:

*Comparison:* results can be shown as absolute values for each outcome
in each year, as a percentage of the base case scenario in the same
year, or as a percentage of the base case scenario in 2018.

*Subgroup:* results can be shown for the total population, or for a
subgroup described by nativity (U.S.-born, non-U.S.-born), and broad age
groups (0-24 years, 25-64 years, 65+ years).

*Outcome:* results can be shown for five different outcomes:

-   **Incident TB infections** representing the annual number of
    incident *M. tuberculosis (Mycobacterium tuberculosis)* infections per 100,000
    due to transmission within the United States (includes reinfection
    of individuals with prior LTBI, excludes migrants entering the
    United States with established LTBI);

-   **LTBI Prevalence** representing the percentage of individuals with
    latent TB infection in a given year;

-   **TB Incidence** representing the annual number of notified
    TB cases per 100,000, including TB cases identified after death;

-   **TB-Related Deaths** representing annual TB-attributable mortality
    per 100,000.

*Scenarios:* results can be shown for up to five scenarios selected by
the user, describing hypothetical changes to current TB prevention and 
control activities ("Modeled Scenarios").

*Download:* clicking on a button initiates download of the visualization
itself (.png, .pdf, .pptx) or the estimates underlying the visualization
(.csv, .xlsx).

#### Modelled Outcomes – Age Groups 

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

#### Modelled Outcomes – Comparison to Recent Data 

<!--![](media/image9.png){width="4.87in" height="2.75in"}
Figure 7: The selected plot depicts model outcomes compared to the
reported Total Population in 2016 in the US by Age and Nativity. -->

The Comparison to Recent Data Page

<center>
<figure>
  <img src='img/figure7.png' alt="Figure 7: The selected plot depicts model outcomes compared to the
reported Total Population in 2016 in the US by Age and Nativity." height="300px"/>
  <figcaption>
    Figure 7: The selected plot depicts model outcomes compared to the
    reported Total Population in 2016 in the US by Age and Nativity.
  </figcaption>
</figure>
</center>

In the *Comparison to Recent Data* page (Figure 7), users can compare
the model's output to reported data on the demography and TB
epidemiology for their selected geography.

### Further Description 

In this Further Description page of the Tabby2 web application,
documentation detailing the *Organization of the tool, Definitions and
Abbreviations,* *Frequently Asked Questions,* and a notice about the
*508 Accessibility of This Product* are provided.

### Feedback

The Feedback page in the Tabby2 web application prompts users of the
application with feedback to either email <ppml@hsph.harvard.edu> with
their questions, comments, or feedback, or to submit it directly to us
through the web application.

Frequently Asked Questions 
---------------------------

**How do I export data from Tabby2?**

Tabby2 users are able to download the data visualizations that they have
created using the "Estimates", "Time Trends", or "Age Groups" tabs and
the underlying estimates that were used to generate their
visualizations.

To download a data visualization:

1.  Navigate to the last heading on the "Estimates," "Time Trends," or
    "Age Groups" tab, which reads "Download" (this can be found on the
    bottom left-hand corner of a typical web browser)

2.  Select PNG or PDF or PPTX depending on desired format

To download underlying data estimates:

1.  Navigate to the last heading on the "Estimates," "Time Trends," or
    "Age Groups" tab, which reads "Download" (this can be found on the
    bottom left-hand corner of a typical web browser)

2.  Select CSV or XLSX depending on desired format

Downloads should begin immediately after selection. If not, contact
<ppml@hsph.harvard.edu> for assistance.

#### **Where can I find more information about TB / TB modelling?**

General information and resources on tuberculosis can be found on the
Centers for Disease Control and Prevention's Tuberculosis webpage:
<https://www.cdc.gov/tb/default.htm>

### 508 Accessibility of This Product

Section 508 requires Federal agencies and grantees receiving Federal
funds to ensure that individuals with disabilities who are members of
the public or Federal employees have access to and use of electronic and
information technology (EIT) that is comparable to that provided to
individuals without disabilities, unless an undue burden would be
imposed on the agency.

If you need assistance with this web application, please contact
<ppml@hsph.harvard.edu>.

