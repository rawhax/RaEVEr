
db <- dbConnect(RPostgres::Postgres(), dbname = "rsql", user = "jat")

ET(url = "https://esi.evetech.net/latest/universe/regions/?datasource=tranquility") %>% 
  content(as = "text", encoding="UTF-8") %>% 
  POST(url = "https://esi.evetech.net/latest/universe/names/?datasource=tranquility", body = .) %>% 
  content(as = "text", encoding="UTF-8") %>% 
  tibble(fromJSON(.,flatten=TRUE)) %>% 
  rename(region_id = id) %>% 
  rename(region_name = name) %>% 
  select(-., -category)-> region_ids

tail(dbListTables(db),10) -> antiorder

anti_join

tab <- tbl (db, antiorder)

antiorder <- function (x){ 
  
}

map2(antiorder[-1], antiorder[-10], anti_join(by = order_id)) -> aj
