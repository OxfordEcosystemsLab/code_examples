# Author: Alexander Shenkin (al@shenkin.org, alexander.shenkin@ouce.ox.ac.uk)
# This script queries the Scopus database and returns the number of hits in
# each journal below for your query.
# See http://api.elsevier.com/documentation/search/SCOPUSSearchTips.htm and 
#   http://api.elsevier.com/content/search/fields/scopus for query syntax.

library(rscopus)

# set the journals you'll query here.  See ecology_journals.htm for other ISSNs.
journal_issn = c("Ecology" = "0012-9658",
                 "Journal of Ecology" = "1365-2745",
                 "Journal of Applied Ecology" = "0021-8901",
                 "American Naturalist" = "0003-0147",
                 "Ecology Letters" = "1461-023X",
                 "Ecological Application" = "1051-0761",
                 "Ecography" = "0906-7590")

# Get an API key here: https://dev.elsevier.com/myapikey.html.
# About Scopus API keys: https://dev.elsevier.com/sc_apis.html
set_api_key('ADD_YOUR_API_KEY_HERE') 

hits = list()

# set your own query here.  
query_substring = "TITLE-ABS-KEY(logging) and TITLE-ABS-KEY(forests) and PUBYEAR AFT 2010"

for (journal in names(journal_issn)) {
  issn = journal_issn[journal]
  query_string = paste0(query_substring," and ISSN(",issn,")")
  query = generic_elsevier_api(query = query_string, type = "search", search_type = "scopus")
  hits[[journal]] = query
}

print(paste("For the query:",query_substring))
for (i in 1:length(hits)) {
  j = names(hits)[i]
  results = hits[[i]]$content[["search-results"]][["opensearch:totalResults"]]
  print(paste(j,"has",results,"entries"))
}

