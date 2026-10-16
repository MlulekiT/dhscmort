{smcl}
{* *! version 0.0.5  08may2026}{...}
{hline}
help for {hi:dhscmort}
{hline}

{title:Title}

{p 4 4 2}
{bf:dhscmort} {hline 2} DHS Childhood Mortality Indicators, Tables, and Graphical Visualisations

{p 4 4 2}
Synthetic cohort estimation of neonatal, infant, child, and under-five mortality using DHS birth histories.

{title:Table of contents}

    {help dhscmort##syn:Syntax}
    {help dhscmort##des:Description}
    {help dhscmort##data:Data requirements}
    {help dhscmort##gen:Generated variables}
    {help dhscmort##opt:Options}
    {help dhscmort##exa:Examples}
    {help dhscmort##sto:Stored results}
    {help dhscmort##met:Methodological notes}
    {help dhscmort##cit:How to cite}
    {help dhscmort##ref:References}
    {help dhscmort##aut:Author}


{marker syn}
{title:Syntax}

{p 8 17 2}
{cmd:dhscmort} {it:indicator} [{cmd:if}] [{cmd:in}] [{cmd:,} {it:options}]

{pstd}
where {it:indicator} is one of:

{phang2}{bf:indicators} {hline 2} produces all mortality indicators simultaneously{p_end}
{phang2}{bf:NNMR} {hline 2} neonatal mortality rate{p_end}
{phang2}{bf:PNNMR} {hline 2} post-neonatal mortality rate{p_end}
{phang2}{bf:IMR} {hline 2} infant mortality rate{p_end}
{phang2}{bf:CMR} {hline 2} child mortality rate (12–59 months){p_end}
{phang2}{bf:U5MR} {hline 2} under-five mortality rate{p_end}

{p 8 8 2}
{cmd:if} and {cmd:in} qualifiers are supported.


{marker des}
{title:Description}

{pstd}
{cmd:dhscmort} estimates childhood mortality indicators using the DHS synthetic cohort life table approach applied to birth histories.

{pstd}
The command computes weighted mortality estimates from DHS Birth Recode ({bf:BR}) datasets and supports:

{phang2}o National-level mortality estimation{p_end}
{phang2}o Stratified estimation using {cmd:by()}{p_end}
{phang2}o Multiple reference periods (5, 10, or 15 years){p_end}
{phang2}o Publication-quality bar and horizontal bar charts{p_end}
{phang2}o Automatic scaling of graph axes{p_end}
{phang2}o Generation of binary mortality indicators for further analysis{p_end}

{pstd}
All estimates are weighted using DHS sampling weights ({cmd:v005}) and constructed using Century Month Code (CMC) alignment.

{pstd}
The implementation follows DHS synthetic cohort principles as documented in the DHS Guide to Statistics and DHS indicator programming code.


{marker data}
{title:Data requirements}

{pstd}
This command requires a DHS Birth Recode ({bf:BR}) dataset.

{pstd}
Required variables:

{phang2}{bf:v005} {hline 2} sampling weight{p_end}
{phang2}{bf:v008} {hline 2} date of interview (CMC){p_end}
{phang2}{bf:b3} {hline 2} date of birth of child (CMC){p_end}
{phang2}{bf:b5} {hline 2} survival status of child{p_end}
{phang2}{bf:b7} {hline 2} age at death (months){p_end}

{pstd}
The command supports both labelled categorical variables and numeric variables without value labels when used with {cmd:by()}.

{pstd}
If additional covariates are required, BR files may be merged with IR or HR datasets prior to estimation.


{marker gen}
{title:Generated variables}

{pstd}
{cmd:dhscmort} generates the following binary mortality indicators in the active dataset:

{synoptset 20 tabbed}{...}
{synopthdr:Variable}
{synoptline}
{synopt:{cmd:mrt_nnmr}}Neonatal mortality (0 months){p_end}
{synopt:{cmd:mrt_pnnmr}}Post-neonatal mortality (1–11 months){p_end}
{synopt:{cmd:mrt_imr}}Infant mortality (0–11 months){p_end}
{synopt:{cmd:mrt_cmr}}Child mortality (12–59 months){p_end}
{synopt:{cmd:mrt_u5mr}}Under-five mortality (0–59 months){p_end}
{synoptline}

{pstd}
These variables remain in memory and can be used for:

{phang2}o Regression analysis{p_end}
{phang2}o Survival and event history models{p_end}
{phang2}o Multilevel modelling{p_end}
{phang2}o Inequality and decomposition analysis{p_end}
{phang2}o Survey-weighted estimation{p_end}

{pstd}
Example usage:

{phang2}{cmd:. svy: logistic mrt_u5mr i.v013 i.v106 i.v190 i.v025}{p_end}
{phang2}{cmd:. tab mrt_nnmr, m}{p_end}


{marker opt}
{title:Options}

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}

{synopt:{opt by(varname)}}Stratifies mortality estimates by categorical or numeric grouping variable{p_end}

{synopt:{opt period(integer)}}Reference period (5, 10, or 15 years; default 5){p_end}

{synopt:{opt graph(string)}}Graph type: {cmd:bar} | {cmd:hbar}{p_end}

{synopt:{opt angle(integer)}}Category label rotation for bar charts (default 0). Other options are 45 and 90{p_end}

{synopt:{opt legplace(string)}}Legend placement: {cmd:bottom} or {cmd:inside}{p_end}

{synopt:{opt title(string)}}Graph title{p_end}

{synopt:{opt name(string)}}Graph name identifier{p_end}

{synopt:{opt export(filename)}}Export graph (.png, .pdf, .svg, .emf, .jpg){p_end}

{synopt:{opt scheme(string)}}Graph scheme (e.g., s2color, scientific, 538w){p_end}

{synoptline}


{marker exa}
{title:Examples}

{pstd}{bf:1. National estimates}{p_end}

{phang2}{cmd:. dhscmort indicators}{p_end}
{phang2}{cmd:. dhscmort indicators, period(10)}{p_end}
{phang2}{cmd:. dhscmort indicators, period(15)}{p_end}


{pstd}{bf:2. Stratified analysis}{p_end}

{phang2}{cmd:. dhscmort indicators, by(v025)}{p_end}
{phang2}{cmd:. dhscmort indicators, by(v024)}{p_end}
{phang2}{cmd:. dhscmort indicators, by(v106) period(10)}{p_end}


{pstd}{bf:3. Single indicators}{p_end}

{phang2}{cmd:. dhscmort NNMR, by(v025)}{p_end}
{phang2}{cmd:. dhscmort IMR, by(v024)}{p_end}
{phang2}{cmd:. dhscmort U5MR, by(v106)}{p_end}


{pstd}{bf:4. Horizontal bar charts}{p_end}

{phang2}{cmd:. dhscmort indicators, by(v024) graph(hbar)}{p_end}
{phang2}{cmd:. dhscmort U5MR, by(v025) graph(hbar) scheme(scientific)}{p_end}


{pstd}{bf:5. Publication-ready graphs}{p_end}

{phang2}{cmd:. dhscmort indicators, by(v024) graph(bar) angle(45) title("Mortality by province")}{p_end}
{phang2}{cmd:. dhscmort indicators, by(v024) graph(bar) export(mortality.png)}{p_end}


{marker sto}
{title:Stored results}

{pstd}
{cmd:dhscmort} does not return scalars in {cmd:r()} or {cmd:e()}.

{pstd}
All mortality indicators are stored directly in the dataset as variables.

{pstd}
These variables remain available until overwritten or dropped.


{marker met}
{title:Methodological notes}

{pstd}
The command implements the DHS synthetic cohort life table approach.

{pstd}
Mortality is estimated across discrete age intervals and combined into survivorship probabilities.

{pstd}
Age segments include:

{phang2}0 months{p_end}
{phang2}1–2 months{p_end}
{phang2}3–5 months{p_end}
{phang2}6–11 months{p_end}
{phang2}12–23 months{p_end}
{phang2}24–35 months{p_end}
{phang2}36–47 months{p_end}
{phang2}48–59 months{p_end}

{pstd}
All mortality rates are expressed per 1,000 live births.

{pstd}
Graphs use dynamically scaled y-axes based on observed maxima.


{marker cit}
{title:How to cite}

{pstd}
Tsawe, M. (2026). {bf:dhscmort}: A Stata command for DHS childhood mortality estimation and visualisation (Version 0.0.5).


{marker ref}
{title:References}

{pstd}
Croft, Trevor N. 2018. DHS User Forum discussions on childhood mortality estimation. {browse "https://userforum.dhsprogram.com/index.php?t=msg&goto=18592&&srch=infant+mortality+rate#msg_18592"}

{pstd}
Croft, Trevor N., Allen, Courtney K., Zachary, Blake W., et al. 2023. {it:Guide to DHS Statistics}. DHS-8. Rockville, Maryland, USA: ICF. {browse "https://www.dhsprogram.com/pubs/pdf/DHSG1/Guide_to_DHS_Statistics_DHS-8.pdf"}

{pstd}
Croft, Trevor N., Marshall, Aileen M. J., Allen, Courtney K., et al. 2018. {it:Guide to DHS Statistics}. DHS-7. Rockville, Maryland, USA: ICF. {browse "https://www.dhsprogram.com/pubs/pdf/DHSG1/Guide_to_DHS_Statistics_DHS-7_v2.pdf"}

{pstd}
DHS Program. 2024. {it:DHS-Indicators-Stata (Chap08_CM)}. GitHub Repository. {browse "https://github.com/DHSProgram/DHS-Indicators-Stata/tree/master/Chap08_CM"}


{marker aut}
{title:Author}

{pstd}{bf:Mluleki Tsawe}{p_end}
{pstd}Population Dynamics Sub-programme{p_end}
{pstd}Population and Health Research Entity{p_end}
{pstd}North-West University, Mahikeng Campus{p_end}
{pstd}South Africa{p_end}