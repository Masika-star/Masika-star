# Data

## Kenya maize yield, 1961–2024

`kenya_maize_yield.csv` contains 64 annual observations of Kenya's maize yield for **Maize (corn)**, measured in **kg/ha**.

| Field | Definition |
|---|---|
| `year` | Calendar year |
| `maize_yield_kg_ha` | FAOSTAT maize yield in kilograms per harvested hectare |

**Source:** FAOSTAT, Crops and livestock products (QCL), Area = Kenya, Item = Maize (corn), Element = Yield. The latest available reference year in the QCL annual dataset is 2024. The crop-production catalogue reports 1961–2024 coverage and a 15 December 2025 data revision; FAO's 31 December 2025 release confirms agricultural production coverage through 2024.

**Units:** The FAOSTAT bulk file reports crop yield in hectograms per hectare (`hg/ha`). The project snapshot is expressed in kilograms per hectare (`kg/ha`), using `kg/ha = hg/ha ÷ 10`.

**Snapshot note:** The CSV is a compact, analysis-ready national time-series extract. It omits the full QCL file's other countries, commodities, elements and source-flag fields. The original full FAOSTAT archive can be downloaded using the optional refresh setting in `R/01_load_real_data.R`.

**Licence:** FAOSTAT statistical data are made available under CC BY 4.0. Attribute the source to the Food and Agriculture Organization of the United Nations (FAO).

Official source: https://www.fao.org/faostat/en/#data/QCL  
Dataset catalogue: https://data.fao.org/catalog/iso/d24a448b-3b62-4c09-8c1d-4a39bb599876  
Release note: https://www.fao.org/statistics/highlights-archive/highlights-detail/agricultural-production-statistics-2010-2024/en
