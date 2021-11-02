library(rvest)
library(polite)


days_out <- 7

Fetch <- function(x){
     bow(x, user_agent = "sorry - https://github.com//RaEVEr",
     delay = 5,
     force = TRUE)%>%
     scrape(content="text/html; charset=UTF-8") %>%
     html_table
  }

Tear <- function(x){
      bow(x, user_agent = "sorry - https://github.com//RaEVEr",
      delay = 5,
      force = TRUE)%>%
      rip(path = "E:/RaEVE/csv")
}

date_list    <- tibble("date" = as.character(seq.Date(Sys.Date(), by = "-1 day", length.out = days_out)), 
                       "year" = as.character(seq.Date(Sys.Date(), by = "-1 day", length.out = days_out), format = "%Y"))

csv_uri <- tibble("uri" = paste0("https://data.everef.net/market-orders/history/", date_list$year ,"/", date_list$date, "/"),
                  "date" = date_list$date)

csv_files   <- tibble(csv = as.character(dir_ls(path = "E:/RaEVE/csv", regexp = "\\.csv.bz2$")))


#this is where downloadin happens
#scrape directory listing
 map(csv_uri$uri,Fetch)%>%
 bind_rows() ->  bound_urls 
  tibble(csv = bound_urls$X1, date = bound_urls$X4)  %>% 
  anti_join(csv_files) -> csv_missing
  csv_missing$date <- sub("T.........","",csv_missing$date)
  csv_master <- full_join(csv_missing, csv_uri, by = "date")
  url_master <- paste0(csv_master$uri,csv_master$csv)
  #do the downloadin
map(url_master,Tear) 
