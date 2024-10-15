# KSA-Aviation-Energy-Efficiency-TimeSeries
This repository contains the input data, R codes and results of the model developed in the paper "A dynamic fleet model of U.S light-duty vehicle lightweighting and associated greenhouse gas emissions from 2016-2050" submitted to Environmental Science and Technology (vol. X issue. X year. X) by Alexandre Milovanoffa, Hyung Chul Kimb, Robert De Kleineb, Timothy J. Wallingtonb, I. Daniel Posena, Heather L. MacLeana,c.
a Department of Civil & Mineral Engineering, University of Toronto, 35 St. George Street, Toronto, Ontario, M5S 1A4 Canada
b Materials & Manufacturing R&A Department, Ford Motor Company, Dearborn, Michigan 48121-2053, United States
c Department of Chemical Engineering & Applied Chemistry, University of Toronto, 200 College Street, Toronto, Ontario, M5S 3E5 Canada

# Overview
The repository comprises 5 folders.

architecture: Contains some codes to create the model architecture. Compiles the list of inputs files, of interdependencies between the functions (i.e., how are the functions linked?) and define the set of attribute inputs to the functions.
functions: Contains the R scripts of the different functions of the model. Each function has a specific goal (e.g., compute the stock of light-duty vehicles by model year and vehicle type, or compute the flow of materials going in and ouf of the light-duty fleet stock). Outputs of a functions can be inputs of another function. The "architecture" folder contains the decription of the functions flow (i.e., interdependcies between functions).
inputs: Contains the external inputs of the functions and some R scripts to obtain formatted inputs data from raw inputs data.
outputs: Contains the intermediate or final outputs of the model functions. Most of the outputs are in .Rdata format and contains default results or results from simulations and sensitivity analysis. The folder also contains some plots.
reports: Contains some RMarkedown reports generated directly from the functions outputs. In this folder, the codes to generate the plots included in the paper are available as well as the full supporting information in RMarkedown format.

# How to use the Model
This repository will not be updated but can be cloned and can serve new researches in the field. Feel free me to contact if you have any questions via email (alexandre.milovanoff@mail.utoronto.ca) or by GitHub @amilovanoff.

# How to setup the model the first time
The model was developed using R and RStudio. Install RStudio: https://www.rstudio.com/products/rstudio/. I use the RStudio Desktop Open Source License (free).
Once R and Rstudio are operationals, open the repository on your computer and open the file 'model_setup.RProj' in the main folder. It opens RStudio and sets up the working directory to the repository folder.
Download the model from this repository on your local computer.
Open and run "architecture/library_dependencies.R". It installs all the packages used at some point in the model (i.e., in the functions or to create the plots). The model is operational.

# How to run the R code
to run the code , you simply have to open "model_setup.RProj" in the main folder. It opens RStudio and sets up the working directory.
once the model is set up

# Extracting and Interpretating Results
In reports, open "supporting_information.Rmd".
Make sure to run the first R chunk entitled "setup". This chunk defines some necessary elements to simulate the other chunks.
Simulate the chunk of interests by clicking on the play button at the right of the chunk. This simulates the code inside the chunk and creates the data frames and plots. If you have an error such as "cannot open the connection", try to simulate the "setup" chunk once again before resimulating the chunk of interests.


# Publications
Guzman, Andres Felipe, Juan Nicolas Gonzalez, and Abdulrahman Alwosheel. “Energy Efficiency Trends in Saudi Arabian Commercial Aviation before and after COVID-19.” Transportation Research Interdisciplinary Perspectives 26, no. June (2024): 101170. https://doi.org/10.1016/j.trip.2024.101170.

Guzman, Andres Felipe, Juan Nicolas Gonzalez, and Abdulrahman Alwosheel. “Fuel Efficiency in Saudi Arabia’s Aviation Sector: Progress and Future Implications.” Riyadh, Saudi Arabia, July 25, 2023. https://doi.org/10.30573/KS--2023-DP16.

