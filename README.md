<!--
Profile README for Masika-star.
All experience, education, training and project claims below are based on the portfolio and CV information available as of November 2026.
-->

<div align="center">
  <img src="https://raw.githubusercontent.com/Masika-star/Masika-star/main/assets/profile-banner.svg" alt="Agricultural research, data analysis and food systems banner" width="100%">
</div>

<h1 align="center">Masika M. Joshua</h1>

<h3 align="center">Agricultural Research · Agricultural Economics · Data Analytics</h3>

<p align="center">
  <strong>📍 Nairobi, Kenya</strong> &nbsp;·&nbsp;
  <a href="mailto:joshuamasika@hotmail.com">joshuamasika@hotmail.com</a>
</p>

<p align="center">
  <a href="mailto:joshuamasika@hotmail.com"><img src="https://img.shields.io/badge/Email-Contact%20me-1f6feb?style=for-the-badge&logo=gmail&logoColor=white" alt="Email"></a>
  <a href="https://github.com/Masika-star"><img src="https://img.shields.io/badge/GitHub-Masika--star-24292f?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"></a>
  <img src="https://komarev.com/ghpvc/?username=Masika-star&style=for-the-badge&color=2e8b57" alt="Profile views">
</p>

<p align="center">
  <strong>Interested in how evidence can strengthen smallholder agriculture, food security and rural livelihoods.</strong>
</p>

---

## About me

I am an agricultural economics professional and postgraduate researcher based in **Nairobi, Kenya**, with more than four years of experience across agricultural research and monitoring, household surveys, farmer engagement, field coordination and agricultural operations.

I hold a **BSc in Agricultural Economics and Resource Management from Maasai Mara University** and am currently pursuing an **MSc in Agricultural Economics at Chuka University**.

My work brings together agricultural research, field experience and data analysis. I am interested in understanding how farming practices, production decisions and institutional support influence smallholder livelihoods and household food security. I use tools such as Stata, Excel and KoboToolbox in research and fieldwork, and I am building my R programming and reproducible research skills through practical, documented projects.

**Current research focus:** Effects of Agroecological Practice Bundles on Household Food Security among Smallholder Maize Farmers in Kimilili Sub-County, Bungoma County, Kenya.

## Featured projects

These projects show different stages of my work: a completed empirical analysis, an ongoing R exploration, and postgraduate research in development. I distinguish completed findings from proposed research so that the status of each project is clear.

<table>
  <tr>
    <td width="100%" valign="top">
      <h3>01 · Kenya maize-yield analysis</h3>
      <p><a href="https://github.com/Masika-star/Masika-star/tree/main/projects/agricultural-data-analysis"><img src="https://raw.githubusercontent.com/Masika-star/Masika-star/main/projects/agricultural-data-analysis/outputs/figures/maize_yield_trend.svg" alt="Kenya maize yield historical trend chart" width="100%"></a></p>
      <p><strong>Additional views of the same 51 annual observations:</strong></p>
      <p><img src="https://raw.githubusercontent.com/Masika-star/Masika-star/main/projects/agricultural-data-analysis/outputs/figures/maize_yield_annual_column.svg" alt="Annual column chart of Kenya maize yield from 1960 to 2010" width="100%"></p>
      <p><img src="https://raw.githubusercontent.com/Masika-star/Masika-star/main/projects/agricultural-data-analysis/outputs/figures/maize_yield_annual_line.svg" alt="Annual line graph of Kenya maize yield from 1960 to 2010" width="100%"></p>
      <p><strong>Completed empirical analysis</strong></p>
      <p>Explores Kenya's annual maize-yield series from 1960 to 2010 using a reproducible R workflow.</p>
      <ul>
        <li>51 annual observations from a public FAOSTAT-derived series.</li>
        <li>Data validation, descriptive statistics and trend visualisation.</li>
        <li>Linear time-trend model with heteroskedasticity-robust inference.</li>
      </ul>
      <p><strong>Modelled trend:</strong> approximately 10.26 kg/ha per year. This is a historical association with time, not a causal estimate.</p>
      <p><a href="https://github.com/Masika-star/Masika-star/tree/main/projects/agricultural-data-analysis">Project details and code →</a></p>
    </td>
  </tr>
  <tr>
    <td width="100%" valign="top">
      <h3>02 · Agroecological practice adoption</h3>
      <p><a href="https://github.com/Masika-star/agroecological-practice-adoption"><img src="https://img.shields.io/badge/R%20project-Exploratory%20analysis-276DC3?style=for-the-badge&logo=r&logoColor=white" alt="R exploratory project"></a></p>
      <p><strong>Ongoing exploratory analysis · Agroecological Practice Adoption among Smallholder Farmers</strong></p>
      <p>An R learning and research project, <em>Agroecological Practice Adoption among Smallholder Farmers: An Exploratory Analysis in R</em>, using the Viability of Agroecological Practices in Africa dataset. Recent work has moved from data auditing into correlation and simple linear regression using 98 farm observations.</p>
      <ul>
        <li><strong>Data preparation:</strong> removed 18 entirely empty columns from a working copy, retaining 98 farms and 28 variables; the original dataset remains unchanged.</li>
        <li><strong>Correlation:</strong> Pearson's r = -0.0423 (p = 0.679), showing negligible and statistically insignificant linear association between organic matter produced per cultivated hectare and the proportion of cultivated area fertilised with organic manure.</li>
        <li><strong>Rank-based comparison:</strong> Spearman's rho = 0.2997 (p = 0.002718), indicating a positive, statistically significant monotonic association.</li>
        <li><strong>Sensitivity check:</strong> Pearson's r changed to 0.228 (p = 0.0249) when farm 23 was excluded for this check. The observation is retained in the cleaned data and the main regression.</li>
        <li><strong>Regression:</strong> the slope was not statistically significant (p = 0.679); R-squared = 0.00179 and adjusted R-squared = -0.00861. The one-predictor model explained very little variation in the outcome.</li>
      </ul>
      <p><strong>What I learned:</strong> Pearson and Spearman answer different questions; influential observations can affect a linear correlation; and statistical significance must be considered alongside explanatory power. These are exploratory associations, not causal effects.</p>
      <p><strong>Reproducible work:</strong> <a href="https://github.com/Masika-star/agroecological-practice-adoption/blob/main/R/03_correlation_regression.R">analysis script</a> · <a href="https://github.com/Masika-star/agroecological-practice-adoption/blob/main/reports/correlation-regression-analysis.md">findings and interpretation</a>.</p>
      <p><a href="https://github.com/Masika-star/agroecological-practice-adoption">Project repository →</a></p>
    </td>
  </tr>
  <tr>
    <td width="100%" valign="top">
      <h3>03 · MSc research: practice bundles and food security</h3>
      <p><img src="https://img.shields.io/badge/MSc%20research-In%20development-8a6d3b?style=for-the-badge" alt="MSc research in development"></p>
      <p><strong>Postgraduate research project · Kimilili, Kenya</strong></p>
      <p>Examines the effects of agroecological practice bundles on household food security among smallholder maize farmers in Kimilili Sub-County, Bungoma County.</p>
      <ul>
        <li>Characterises combinations of agroecological practices.</li>
        <li>Examines their relationship with household food security.</li>
        <li>Investigates production diversity as a pathway linking practice bundles and food security.</li>
      </ul>
      <p><em>Research framework and analytical plan under development; no empirical results are claimed here.</em></p>
      <p><a href="https://github.com/Masika-star/Masika-star/tree/main/projects/agroecology-food-security">Research framework →</a></p>
    </td>
  </tr>
</table>

<p>Additional research frameworks are documented separately in the <a href="projects/">Projects folder</a>.</p>

## Research interests

<p>
  <img src="https://img.shields.io/badge/Agroecology-2e7d32?style=flat-square" alt="Agroecology">
  <img src="https://img.shields.io/badge/Smallholder%20Farming-558b2f?style=flat-square" alt="Smallholder farming">
  <img src="https://img.shields.io/badge/Food%20Security-00796b?style=flat-square" alt="Food security">
  <img src="https://img.shields.io/badge/Agricultural%20Policy-546e7a?style=flat-square" alt="Agricultural policy">
  <img src="https://img.shields.io/badge/Applied%20Econometrics-1565c0?style=flat-square" alt="Applied econometrics">
  <img src="https://img.shields.io/badge/Rural%20Development-6d4c41?style=flat-square" alt="Rural development">
</p>

- Agricultural and food systems research
- Agroecological practices and sustainable farming systems
- Smallholder production, livelihoods and agricultural markets
- Household food security and production diversity
- Agricultural extension and technology adoption
- Applied statistics, econometrics and impact evaluation

## Technical toolkit

My current toolkit combines statistical software, field data-collection platforms and research workflow tools. R and Git/GitHub are areas of active development.

| Area | Tools and capabilities |
|---|---|
| Statistical analysis | Stata 15; R (foundational programming and tidyverse data workflows) |
| Data management | Microsoft Excel; data cleaning, validation and organisation |
| Data collection | KoboToolbox / KoboCollect; ODK; structured household surveys |
| Research methods | Quantitative and qualitative data; household surveys; key-informant interviews; focus group discussions |
| Research workflow | RStudio Projects; organised data, code and output folders; Git and GitHub |
| Literature and reporting | Zotero; Google Scholar; ResearchGate; Microsoft Word and PowerPoint |
| Other statistical tools | IBM SPSS |

<p align="center">
  <img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white" alt="R">
  <img src="https://img.shields.io/badge/Stata-1A5F91?style=for-the-badge" alt="Stata">
  <img src="https://img.shields.io/badge/Excel-217346?style=for-the-badge&logo=microsoftexcel&logoColor=white" alt="Excel">
  <img src="https://img.shields.io/badge/KoboToolbox-5A9A3B?style=for-the-badge" alt="KoboToolbox">
  <img src="https://img.shields.io/badge/ODK-3F7F6F?style=for-the-badge" alt="ODK">
  <img src="https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white" alt="Git">
  <img src="https://img.shields.io/badge/GitHub-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  <img src="https://img.shields.io/badge/Zotero-CC2936?style=for-the-badge&logo=zotero&logoColor=white" alt="Zotero">
</p>


## Professional Experience

For my roles in agricultural research and M&E, farm management, agricultural extension and household enumeration, [view my professional experience](experience/).

## Education and professional development

**Academic qualifications**

- **MSc Agricultural Economics** — Chuka University, Kenya | 2025–Present
- **BSc Agricultural Economics and Resource Management** — Maasai Mara University, Kenya | 2016–2020

**Selected training**

- Managing Successful Field Research — World Bank Group, Institute for Economic Development | 2025
- Google Data Analytics Professional Certificate — Grow with Google / Coursera | 2023–2024
- Google IT Support Professional Certificate — Grow with Google / Coursera | 2023–2024
- Data Analysis in Excel — Digital Opportunity Trust | 2022–2023
- Computer Applications Certificate — Sang’alo Institute of Science & Technology | 2020–2021

## How I approach research

I begin by defining the research question and understanding the data before selecting an analytical method. My workflow is built around:

1. **Organised projects:** separate folders for data, code and outputs.
2. **Data quality:** inspect structure, missing values, duplicates, variable definitions and unusual observations before analysis.
3. **Appropriate methods:** match the research question and data structure to the method, then examine assumptions and diagnostics.
4. **Reproducibility:** document code, data-processing decisions and analytical steps.
5. **Careful interpretation:** distinguish description, association and causal evidence, and report limitations clearly.

Restricted or confidential farmer-level data are not published in this portfolio.

## GitHub activity

<p align="center">
  <img height="165" src="https://github-readme-stats.vercel.app/api?username=Masika-star&show_icons=true&hide_border=true&theme=transparent&rank_icon=github" alt="GitHub statistics">
  <img height="165" src="https://streak-stats.demolab.com?user=Masika-star&hide_border=true&theme=transparent" alt="GitHub contribution streak">
</p>

## Connect With Me

I welcome opportunities for research collaboration, agricultural data analysis, field research, monitoring and evaluation, and evidence-based work on food systems and rural development.

<p align="center">
  📍 Nairobi, Kenya
</p>

<p align="center">
  <a href="https://www.linkedin.com/in/joshua-masika-47b793215/" target="_blank"><img src="https://img.shields.io/badge/LINKEDIN-0A66C2?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn"></a>
  <a href="mailto:joshuamasika@hotmail.com"><img src="https://img.shields.io/badge/EMAIL-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Email"></a>
  <a href="https://github.com/Masika-star"><img src="https://img.shields.io/badge/GITHUB-181717?style=for-the-badge&logo=github&logoColor=white" alt="GitHub"></a>
</p>

<p align="center">
  <em>Research carefully. Analyse clearly. Contribute to better agricultural and food systems.</em>
</p>

