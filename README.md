# Time Series Analysis of Energy Efficiency in Saudi Arabia's Aviation Sector

This project analyzes energy efficiency trends in Saudi Arabia's aviation sector from 2017 to 2021, focusing on both domestic and international flights departing from the Kingdom. The research assesses energy efficiency in terms of fuel consumption per passenger-kilometer traveled, across 20 airports in Saudi Arabia. By exploring the data through time series analysis, the project aims to understand the impact of fuel consumption, air traffic patterns, and the COVID-19 pandemic on energy efficiency.

This work is based on the following sources:
- Guzman, Andres Felipe, Juan Nicolas Gonzalez, and Abdulrahman Alwosheel. “Energy Efficiency Trends in Saudi Arabian Commercial Aviation before and after COVID-19.” Transportation Research Interdisciplinary Perspectives 26, no. June (2024): 101170. https://doi.org/10.1016/j.trip.2024.101170.
- Guzman, Andres Felipe, Juan Nicolas Gonzalez, and Abdulrahman Alwosheel. “Fuel Efficiency in Saudi Arabia’s Aviation Sector: Progress and Future Implications.” Riyadh, Saudi Arabia, July 25, 2023. https://doi.org/10.30573/KS--2023-DP16.


## Key Features:
**1. Energy Efficiency Assessment:**
 - The project calculates fuel efficiency using the ratio of passenger kilometers (pax-km) to fuel consumption (barrels of oil equivalent - BOE), providing an indication of how efficiently energy is used in aviation operations.
 - The analysis delves into how the pandemic affected flight frequencies, passenger loads, aircraft utilization, and energy efficiency. Significant fluctuations in energy efficiency were observed during the pandemic, where reduced flight loads often led to lower (pax-km)/BOE values due to underutilized aircraft.

**2. Time Series Modeling:**
 - Time series models that effectively describe historical variations in energy efficiency are used to predict future trends and assess the impact of disruptions, such as the COVID-19 pandemic, on aviation energy efficiency.
 - Selected time series models for energy efficiency assessment include Prophet, SARIMA, TBATS, and STLM, among others, chosen based on their accuracy across different flights departing from selected airports during the period 2017 to 2019 (pre-COVID-19 pandemic period)
 - The forecasting period from 2020 to 2021 (COVID-19 pandemic period) was conducted using the time series models selected during the pre-COVID-19 pandemic period.
 - By applying these models to the pandemic period, the project aims to analyze how well the models capture shifts in energy efficiency under unprecedented disruptions. 

**3. Data Insights:**
 - The project evaluates the seasonality of travel demand, highlighting peaks driven by religious tourism and other seasonal travel patterns, which are reflected in varying energy efficiency values.
 - The analysis includes a comparison of the pre-pandemic and pandemic periods to determine how aviation energy efficiency was affected by management measures, such as flight restrictions, changes in passenger load factors (PLF), lockdowns and curfews, and general changes in air traffic patterns.
 - This approach provides insights into the impact of pandemic-related flight restrictions and changes in air traffic patterns on energy efficiency, highlighting the robustness of the selected models.

**4. Visualization:**
 - Visualizations of actual and forecasted energy efficiency trends are generated for each airport, showing fluctuations and identifying patterns.
 - The project also presents box plots illustrating the variability of fuel efficiency across airports during different years.

**5. Policy Implications:**
 - The findings provide insights into future policy development, particularly regarding energy conservation and environmental impact within the aviation sector.
 - The project identifies potential management practices that can improve fuel efficiency, reduce carbon emissions, and enhance sustainability within the aviation industry.

## How to use the Model
This repository will not be updated but can be cloned and can serve new research in the field. For additional requirements, please contact andres.guzman@kapsarc.org or juannicolas.gonzalez@kapsarc.org.

## How to setup the model the first time
The model was developed using R and RStudio. Install RStudio: https://www.rstudio.com/products/rstudio/. Once R and Rstudio are operationals, opens RStudio, create a new project and sets up the working directory. Download the model from this repository on your local computer and save it inside the project folder.  

Ensure all the necessary R libraries are installed. To install the necessary libraries, use the `install.packages()` function in R. You can run the following commands in your R environment:
```r
install.packages(c("tidyverse", "lubridate", "forecast", "ggplot2", "data.table", readxl", "forecast", "scales", "astsa", "autoTS", "stringr"))
```
## Data Sources
**Flight Data**: The data used for this project includes flight data from domestic and international sources (2017-2021). Due to file size limitations on GitHub, these data files are compressed (.zip). 
- Flights_DOM_New.zip
- Flights_INT_2017_2018_New.zip
- Flights_INT_2019_2021_New.zip

Unzip all files and save it in the project folder.

## Posible Use Cases
  - **Aviation Authorities:** Understanding fuel efficiency trends can help authorities set policies aimed at improving overall energy efficiency in the aviation sector.
  - **Airline Companies:** Insights into fuel consumption per route or airport can help airlines optimize their routes for better fuel efficiency and lower operational costs.
  - **Environmental Impact Assessors:** This project provides valuable information for stakeholders interested in the carbon footprint of the aviation industry, offering data-backed insights into potential reductions in fuel consumption and emissions.

## Publications
Guzman, Andres Felipe, Juan Nicolas Gonzalez, and Abdulrahman Alwosheel. “Energy Efficiency Trends in Saudi Arabian Commercial Aviation before and after COVID-19.” Transportation Research Interdisciplinary Perspectives 26, no. June (2024): 101170. https://doi.org/10.1016/j.trip.2024.101170.

Guzman, Andres Felipe, Juan Nicolas Gonzalez, and Abdulrahman Alwosheel. “Fuel Efficiency in Saudi Arabia’s Aviation Sector: Progress and Future Implications.” Riyadh, Saudi Arabia, July 25, 2023. https://doi.org/10.30573/KS--2023-DP16.
