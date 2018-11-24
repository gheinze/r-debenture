load_pdf <- function() {
  
  # Setup Project workspace
  #setwd(paste(getwd(), "CODE/r-debenture", sep="/"))
  
  # Libraries
  library(pdftools)
  
  txt <- pdf_text("data/DebtInstruments.pdf")
  lines_by_page = strsplit(txt, "\\r?\\n")
  lines = trimws(unlist(lines_by_page))
  
  # Skip initial two lines which contains the date and headers
  start_index = 3
  
  # Skip the section marked as "Notes" and onward
  end_index = match("Notes", lines) - 1
  
  # The list of instruments to process
  instruments <- lines[start_index:end_index]
  
  # Specialized one-off cleanups
  # "Invesque Inc." does not have a space between description and percent
  instruments <- gsub("Invesque Inc.", "Invesque Inc. ", instruments)
    
  # First column is the symbol
  symbol_end_index <- regexpr(" ", instruments) - 1
  symbol_vector <- substring(instruments, 1, symbol_end_index)
  
  # Remainder is description, but strip off the last 5 chars: " 1000"
  start_index = symbol_end_index + 2
  end_index = nchar(instruments) - 5
  description_vector <- trimws(substring(instruments, start_index, end_index))
  
  # Try to extract the percentage out of the description if it exists
  # e.g. extract "5.5%" out of "Aecon Broup Inc 5.5% Debenture"
  # "invert=NA" will split into 3 pieces if possible: before match, match, after match
  description_split <- regmatches(description_vector, regexpr("[0-9,.]+%", description_vector), invert=NA)
  rate_string <- sapply(description_split, function(x) {if (length(x) == 1) "" else x[2]})
  rate_vector <- as.double(gsub("%", "", rate_string))
  
  null_numeric_col   <- rep(as.numeric(NA), length(symbol_vector))
  null_character_col <- rep(as.character(NA), length(symbol_vector))
  
  debentures <- data.frame(
    Symbol = symbol_vector,
    Description = description_vector,
    Rate = rate_vector,
    Issued = null_character_col,
    Maturity = null_character_col,
    UnderlyingSymbol = null_character_col,
    ConversionPrice = null_numeric_col,
    ConversionRate = null_numeric_col,
    ProspectusUrl = null_character_col,
    stringsAsFactors = FALSE
    )

  return (debentures)

}
