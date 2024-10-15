# Loading the necessary libraries
library("tidyverse")     # For data manipulation and visualization (includes dplyr, ggplot2, etc.)
library("openxlsx")      # To read and write Excel files
library("data.table")    # For high-performance data manipulation
library("readxl")        # Another package to read Excel files
library("lubridate")     # To work with date and time data
library("forecast")      # For time series forecasting
library("scales")        # For scaling functions in plots (e.g., formatting axes)
library("astsa")         # For time series analysis
library("autoTS")        # Automated time series modeling
library("stringr")       # For string manipulation



###### Reading and Manipulating Data ###### 

# Reading in the data from the Excel sheets
# Domestic flights data for the years 2017 to 2021
db2017 <- read_excel("Flights_DOM_2017-2021 New.xlsx", sheet = "2017")
db2018 <- read_excel("Flights_DOM_2017-2021 New.xlsx", sheet = "2018")
db2019 <- read_excel("Flights_DOM_2017-2021 New.xlsx", sheet = "2019")
db2020 <- read_excel("Flights_DOM_2017-2021 New.xlsx", sheet = "2020")
db2021 <- read_excel("Flights_DOM_2017-2021 New.xlsx", sheet = "2021")

# International flights data for the years 2017 to 2021
ib2017 <- read_excel("Flights_INT_2017-2021 New.xlsx", sheet = "2017")
ib2018 <- read_excel("Flights_INT_2017-2021 New.xlsx", sheet = "2018")
ib2019 <- read_excel("Flights_INT_2017-2021 New.xlsx", sheet = "2019")
ib2020 <- read_excel("Flights_INT_2017-2021 New.xlsx", sheet = "2020")
ib2021 <- read_excel("Flights_INT_2017-2021 New.xlsx", sheet = "2021")

# Merging (combining) all domestic flights data into a single dataframe (temp1)
temp1 <- rbind(db2017, db2018, db2019, db2020, db2021)

# Extracting unique airport codes (domestic) from the 'ORIG AIRPORT' column
tair <- levels(as.factor(temp1$`ORIG AIRPORT`))

# Merging all international flights data into a single dataframe (temp2)
# Filtering the data to keep only the rows where the originating airport is in the list of domestic airports (tair)
temp2 <- rbind(ib2017, ib2018, ib2019, ib2020, ib2021) %>% filter(`ORIG AIRPORT` %in% tair)

# Combining the domestic and filtered international flights data into a final dataframe (db)
db <- rbind(temp1, temp2)

# Removing the individual year-based dataframes and temporary dataframes to free up memory
rm(db2017, db2018, db2019, db2020, db2021, ib2017, ib2018, ib2019, ib2020, ib2021, temp1, temp2)

# Converting 'TIME DEPARTING' and 'TIME ARRIVING' columns to Date format
# The 'openxlsx::convertToDate' is used to handle different Excel date formats
db$time_dep2 <- as.Date(as.character(openxlsx::convertToDate(db$`TIME DEPARTING`)))
db$time_arr2 <- as.Date(as.character(openxlsx::convertToDate(db$`TIME ARRIVING`)))

# Creating new columns for fuel consumption per passenger (barrels and barrels of oil equivalent - BOE)
# Dividing total fuel consumption by the number of passengers (PAX) to get per passenger metrics
db$fuel_barrelspax <- db$`FUEL CONSUM (BARRELS)` / db$PAX 
db$fuel_boepax <- db$`FUEL CONDUM (BOE)` / db$PAX 

# Filtering out specific airports from the data
db <- db %>%
  filter(`ORIG AIRPORT` != "DHA") %>%  # Exclude rows where originating airport is "DHA"
  filter(`ORIG AIRPORT` != "NUM") %>%  # Exclude rows where originating airport is "NUM"
  filter(`ORIG AIRPORT` != "DWD") %>%  # Exclude rows where originating airport is "DWD"
  filter(`ORIG AIRPORT` != "EAM") %>%  # Exclude rows where originating airport is "EAM"
  filter(`ORIG AIRPORT` != "AHB") %>%  # Exclude rows where originating airport is "AHB"
  filter(`ORIG AIRPORT` != "EJH") %>%  # Exclude rows where originating airport is "EJH"
  filter(`ORIG AIRPORT` != "WAE") %>%  # Exclude rows where originating airport is "WAE"
  filter(`ORIG AIRPORT` != "ULH")      # Exclude rows where originating airport is "ULH"

# Grouping the data by originating airport and departure time and calculating fuel efficiency
db2 <- db %>%
  group_by(`ORIG AIRPORT`, time_dep2) %>%  # Grouping by the originating airport and departure date
  summarize(fuel_eff = sum((PAX * DISTANCE / `FUEL CONSUM (BARRELS)`)))  # Summarizing fuel efficiency (distance * passengers / fuel consumption in barrels)
  

# Counting the number of unique departure dates in the dataset
x <- nrow(db %>% 
            dplyr::select(time_dep2) %>%            # Selecting the departure date column
            mutate(time_dep2 = as.character(time_dep2)) %>%  # Converting the date to character format
            distinct()                              # Keeping only distinct values (unique dates)
)

# Counting the number of unique originating airports in the dataset
y <- length(levels(as.factor(db$`ORIG AIRPORT`)))  # Getting the number of unique levels in the originating airport factor

# Creating a base dataframe 'dbase' with all combinations of airports and dates
dbase <- data.frame(
  orig_a = rep(levels(as.factor(db$`ORIG AIRPORT`)), times = x),   # Repeating each airport code x times
  dates = as.Date(rep(levels(as.factor(db$time_dep2)), times = y))  # Repeating each unique date y times
) %>% arrange(dates)  # Sorting the dataframe by dates

# Performing a left join of 'dbase' and 'db2' by matching dates and originating airports
db3 <- left_join(dbase, db2, by = c("dates" = "time_dep2", "orig_a" = "ORIG AIRPORT")) %>% 
  dplyr::arrange(orig_a, dates)  # Arranging the resulting dataframe by airport and date

# Replacing missing values (NA) in the fuel efficiency column with 0
db3$fuel_eff[is.na(db3$fuel_eff)] <- 0

# Grouping the data by originating airport and calculating summary statistics
db3 %>% group_by(orig_a) %>% 
  summarize(
    mx = mean(fuel_eff),  # Mean fuel efficiency
    sx = sd(fuel_eff),    # Standard deviation of fuel efficiency
    maxx = max(fuel_eff), # Maximum fuel efficiency
    minx = min(fuel_eff)  # Minimum fuel efficiency
  )

# Updating the 'orig_a' column to replace airport codes with more descriptive names
db3 <- db3 %>% mutate(orig_a = case_when(
  orig_a == "ABT" ~ "ABT \n King Saud Bin Abdulaziz Airport",
  orig_a == "AJF" ~ "AJF \n Al-Jawf Airport",
  orig_a == "AQI" ~ "AQI \n Al-Qaisumah Airport",
  orig_a == "BHH" ~ "BHH \n Bisha Airport",
  orig_a == "DMM" ~ "DMM \n King Fahd International Airport",
  orig_a == "ELQ" ~ "ELQ \n Prince Naif Bin Abdulaziz Airport",
  orig_a == "GIZ" ~ "GIZ \n King Abdullah Bin Abdulaziz Airport",
  orig_a == "HAS" ~ "HAS \n King Fahd International Airport",
  orig_a == "HOF" ~ "HOF \n Al Ahsa Airport",
  orig_a == "JED" ~ "JED \n King Abdul Aziz International Airport",
  orig_a == "MED" ~ "MED \n Prince Mohammed bin Abdulaziz",
  orig_a == "RAE" ~ "RAE \n Arar Airport",
  orig_a == "RAH" ~ "RAH \n Rafha Airport",
  orig_a == "RUH" ~ "RUH \n King Khalid International Airport",
  orig_a == "SHW" ~ "SHW \n Sharurah Airport",
  orig_a == "TIF" ~ "TIF \n Taif International Airport",
  orig_a == "TUI" ~ "TUI \n Turaif Airport",
  orig_a == "TUU" ~ "TUU \n Prince Sultan-bin Abdulaziz Airport",
  orig_a == "URY" ~ "URY \n Gurayat Airport",
  orig_a == "YNB" ~ "YNB \n Prince Abdul Mohsin Bin Abdulaziz Airport",
  TRUE ~ orig_a))  # Default case: if no match, keep the original code


# Open a TIFF device to save the first figure "Figure 1.tiff".
# Width is set to 15 inches, height to 8 inches, and resolution (res) is 300 dpi for high-quality output.
tiff("Figure 1.tiff", units = "in", width = 15, height = 8, res = 300)

# Create a line plot using ggplot2:
db3 %>%
  ggplot(aes(x = dates, y = fuel_eff, group = orig_a)) +  # Define 'dates' on the x-axis, 'fuel_eff' (fuel efficiency) on the y-axis, and group the data by 'orig_a' (originating airport)
  geom_line() +                                           # Add a line for each airport to show changes in fuel efficiency over time
  facet_wrap(vars(orig_a), scales = "free") +             # Create separate panels for each airport ('orig_a'), and allow each panel to have its own y-axis scaling with 'scales = "free"'
  scale_y_continuous(labels = comma) +                    # Format the y-axis labels with commas for easier readability of large numbers
  ylab("Energy Efficiency (RPK/BOE)") +                   # Add a label to the y-axis representing fuel efficiency in terms of RPK (Revenue Passenger Kilometers) per BOE (Barrels of Oil Equivalent)
  xlab("Dates")                                           # Add a label to the x-axis representing dates (time)

dev.off()  # Close the TIFF device to save "Figure 1.tiff"

# Open a TIFF device to save the second figure "Figure 2.tiff"
tiff("Figure 2.tiff", units = "in", width = 15, height = 8, res = 300)

# Create a box plot grouped by year using ggplot2:
db3 %>%
  group_by(orig_a, yy = year(dates)) %>%                  # Group the data by originating airport ('orig_a') and extract the year from 'dates' to create the variable 'yy'
  ggplot(aes(x = yy, y = fuel_eff, group = yy)) +         # Define 'yy' (year) on the x-axis, 'fuel_eff' (fuel efficiency) on the y-axis, and group the data by 'yy' for each airport
  geom_boxplot() +                                        # Add a box plot to show the distribution of fuel efficiency for each year and airport
  facet_wrap(vars(orig_a), scales = "free") +             # Create separate panels for each airport, allowing for free scaling of the y-axis
  scale_y_continuous(labels = comma) +                    # Format the y-axis labels with commas for better readability
  ylab("Energy Efficiency (RPK/BOE)") +                   # Label the y-axis as energy efficiency in terms of RPK per BOE
  xlab("Year")                                            # Label the x-axis to show the year

dev.off()  # Close the TIFF device to save "Figure 2.tiff"


###### Time Series Model ###### 

# Create a text file to store the model report. The initial text is "Models Report".
cat("Models Report \n \n", file = "reportBest.txt")

# Initialize an empty dataframe to store training errors for different models
terror <- data.frame(prophet = double(), ets = double(), sarima = double(), tbats = double(), 
                     bats = double(), stlm = double(), bagged = double())

# Initialize an empty dataframe to store the forecasting summary results
forecastsummary <- data.frame(orig_a = character(), fuel_eff_forecast = double())

# Loop through each unique originating airport
for (i in levels(as.factor(db3$orig_a))){
  
  # Write the airport code to the "reportBest.txt" file and append a newline
  capture.output(print(paste(i, sep = "")), file = "reportBest.txt", append = TRUE)
  cat("\n", append = TRUE, file = "reportBest.txt")
  
  # Split the data into training (before March 8, 2020) and testing (after March 8, 2020)
  temp1 <- db3 %>% filter(orig_a == i) %>% filter(dates <= "2020-03-08")  # Training set
  temp2 <- db3 %>% filter(orig_a == i) %>% filter(dates > "2020-03-08")   # Testing set
  
  # Call a function 'getBestModel' to find the best forecasting model based on training data
  # Models considered: Prophet, SARIMA, TBATS, BATS, STLM, Short-term model
  tmpModel <- getBestModel(temp1$dates, temp1$fuel_eff, freq = "day", n_test = nrow(temp2),
                           algos = list("my.prophet", "my.sarima", "my.tbats", "my.bats", "my.stlm", 
                                        "my.shortterm"), graph = FALSE) 
  
  # Print the airport code to the console
  print(i)
  
  # Output the best model to the "reportBest.txt" file
  capture.output(print(tmpModel$best), file = "reportBest.txt", append = TRUE)
  
  # Store the training errors of the model into 'terror'
  ttemp <- tmpModel$train.errors
  terror <- rbind(terror, ttemp)  # Append the errors for the current airport to 'terror'
  
  
  # Remove the "my." prefix from the best model name to simplify it
  colbest <- str_remove(tmpModel$best, "my.")
  
  # Generate predictions using the best model, based on the testing set's length
  tmp.res <- tmpModel %>% my.predictions(n_pred = nrow(temp2), algos = list(tmpModel$best)) %>%
    filter(type == "mean")  # Select only the mean (average) forecast
  
  # Create a dataframe for storing the forecasted values, with the originating airport and forecasted efficiency
  ftemp <- data.frame(orig_a = rep(i, times = nrow(temp2)), fuel_eff_f = pull(tmp.res[, 4]))  # 4th column has the forecast
  
  # Append the forecast for the current airport to 'forecastsummary'
  forecastsummary <- rbind(forecastsummary, ftemp)
}

# Combine the forecast results with the original dataset (db3) by joining on 'dates' and 'orig_a'
dbtemp <- cbind(forecastsummary, dates = as.Date(rep(temp2$dates, times = y)))  # Ensure 'dates' are properly repeated and cast as Date

# Perform a left join to merge the forecasted values with the original dataset
db4 <- left_join(db3, dbtemp, by = c("dates" = "dates", "orig_a" = "orig_a")) %>%
  dplyr::arrange(orig_a, dates) %>%  # Arrange the merged data by airport and date
  mutate(fuel_eff_f = if_else(fuel_eff_f < 0, 0, fuel_eff_f))  # Replace any negative forecast values with 0



tiff("Figure 3.tiff", units = "in", width = 15, height = 8, res = 300)

# Create a plot comparing actual and forecasted energy efficiency over time for each airport
db4 %>%
  ggplot(aes(x = dates, group = orig_a)) +  # Set 'dates' on x-axis, group data by 'orig_a' (airport)
  geom_line(aes(y = fuel_eff), color = "black") +  # Plot actual energy efficiency in black
  geom_line(aes(y = fuel_eff_f), color = "blue") + # Plot forecasted energy efficiency in blue
  facet_wrap(vars(orig_a), scales = "free") +      # Create separate panels for each airport, with free y-axis scaling for each
  scale_y_continuous(labels = comma) +             # Format y-axis labels with commas
  ylab("Energy Efficiency (RPK/BOE)") +            # Label y-axis
  xlab("Dates")                                    # Label x-axis

dev.off()  # Close the TIFF device, saving the plot to "Figure 3.tiff"

# Calculate the difference between actual and forecasted energy efficiency, rounded to 1 decimal place
db4$difference <- round((db4$fuel_eff - db4$fuel_eff_f) / 1000, 1)


# Create a plot to show the percentage change in energy efficiency over time
db4 %>%
  filter(!is.na(difference)) %>%  # Filter out rows with NA values in the 'difference' column
  ggplot(aes(x = dates, group = orig_a)) +  # Set 'dates' on x-axis, group data by airport
  geom_line(aes(y = difference), color = "black") +  # Plot the percentage change in black
  geom_hline(aes(yintercept = 0), color = "blue") +  # Add a horizontal line at 0 to indicate no change
  facet_wrap(vars(orig_a), scales = "free") +        # Create separate panels for each airport
  ylab("% Change Energy Efficiency") +               # Label y-axis as percentage change
  xlab("Dates") +                                    # Label x-axis
  scale_y_continuous(labels = percent)               # Format y-axis labels as percentages


tiff("Figure 4.tiff", units = "in", width = 15, height = 8, res = 300)

# Create a plot to show the absolute change in energy efficiency over time
db4 %>%
  filter(!is.na(difference)) %>%  # Filter out rows with NA values in 'difference' column
  ggplot(aes(x = dates, group = orig_a)) +  # Set 'dates' on x-axis, group by airport
  geom_line(aes(y = difference), color = "black") +  # Plot the absolute difference in black
  geom_hline(aes(yintercept = 0), color = "blue") +  # Add a horizontal line at 0 for reference
  facet_wrap(vars(orig_a), scales = "free") +        # Create separate panels for each airport
  ylab("Change in Energy Efficiency (RPK/BOE)") +    # Label y-axis
  xlab("Dates")                                      # Label x-axis

dev.off()  # Close the TIFF device, saving the plot to "Figure 4.tiff"


# Summarize energy efficiency across all airports, grouping by 'time_dep2' (departure date)
db5 <- db4 %>%
  group_by(time_dep2) %>%  # Group data by departure date
  summarize(fuel_eff = sum((pax * distance / fuel_barrels)))  # Sum the energy efficiency (passenger-kilometers per fuel consumption)


