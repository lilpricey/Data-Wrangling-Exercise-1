install.packages("tidyr")
install.packages("dplyr")
install.packages("rio")
library(tidyr)
library(dplyr)
library("rio")
library(readr)
library(utils)

toys <- import("refine.xlsx")
export(toys, "refine_original.csv")

toys <- read_csv("refine_original.csv")
View(toys)

#change to lowercase
toys$company <- tolower(toys$company)

#change company variations to be the same
idx <- agrep(pattern = "philips", x = toys$company, max.distance = 3)
toys$company[idx] <- "philips"
idx <- agrep(pattern = "akzo", x = toys$company)
toys$company[idx] <- "akzo"
idx <- agrep(pattern = "van houten", x = toys$company)
toys$company[idx] <- "van houten"
idx <- agrep(pattern = "unilever", x = toys$company)
toys$company[idx] <- "unilever"

#seperate product code / number
toys <- separate(toys, `Product code / number`, into = c("product_code", "product_number") )

#add product categories
toys <- mutate(toys, product_categories = replace(product_code, 
          product_code == "p", "Smartphone"))
toys$product_categories[which(toys$product_categories=="v")] <- "TV"
toys$product_categories[which(toys$product_categories=="x")] <- "Laptop"
toys$product_categories[which(toys$product_categories=="q")] <- "Tablet"

#Add full address for geocoding
toys$full_address = paste(toys$address, ",", toys$city, ",", toys$country)

#Create dummy variables for company and product category
toys <- mutate(toys, company_philips = ifelse(company == "philips", 1, 0))
toys <- mutate(toys, company_akzo = ifelse(company == "akzo", 1, 0))  
toys <- mutate(toys, company_van_houten = ifelse(company == "van houten", 1, 0))
toys <- mutate(toys, company_unilever = ifelse(company == "unilever", 1, 0))
toys <- mutate(toys, product_smartphone = ifelse(product_code == "p", 1, 0))
toys <- mutate(toys, product_tv = ifelse(product_code == "v", 1, 0))
toys <- mutate(toys, product_laptop = ifelse(product_code == "x", 1, 0))
toys <- mutate(toys, product_tablet = ifelse(product_code == "q", 1, 0))

#save new csv file
export(toys, "refine_clean.csv")
