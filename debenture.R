setwd(paste(getwd(), "CODE/r-debenture", sep="/"))

source("loadPdf.R")
tsx_debentures <- load_pdf()

known_debentures <- read.csv("data/debenture_details.csv", header = TRUE, sep = "~", stringsAsFactors = FALSE)

# Combine the tsx_debentures to the end of the known_debentures; then eliminate duplicates based on "Symbol" from the end
combined_debentures <- rbind(known_debentures, tsx_debentures)
combined_debentures <- combined_debentures[!duplicated(combined_debentures["Symbol"]), ]

# Get quotes

# install.packages("alphavantager")
library(alphavantager)

alphavantage_key <- Sys.getenv("ALPHAVANTAGE_KEY")
av_api_key(alphavantage_key)

by(combined_debentures[1, ], 1:nrow(combined_debentures[1, ]), function(row) {
  symbol <- row["Symbol"]
})

combined_debentures["Symbol"]
av_get(symbol = "ARE-DBB.TO", av_fun = "GLOBAL_QUOTE")
Sys.sleep(20)


# Computed Columns

# Plots
