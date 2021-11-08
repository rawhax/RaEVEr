library(tidyverse)
library(RPostgres)
library(R.utils)



db <- dbConnect(RPostgres::Postgres(), dbname = "rsql", user = "jat")



cratetable  <- function(x){dbExecute(db, paste("CREATE TABLE ", x," 
(duration double precision,
is_buy_order boolean, 
issued timestamp with time zone, 
location_id double precision, 
min_volume double precision,
order_id double precision,
price double precision,
range text,
system_id double precision,
type_id double precision,
volume_remain double precision,
volume_total double precision,
region_id double precision,
http_last_modified timestamp with time zone,
station_id double precision,
constellation_id double precision,
universe_id text);"))}

boofer <- function(x){
  bunzip2(x) -> unz
  sub("E:/RaEVE/csv/","", x) %>% 
    sub(".v3.csv.bz2","", .) %>% 
      sub("_", "x", .) %>% 
        gsub("-","_", .) -> tablename
  cratetable(tablename)
  dbExecute(db, paste0("COPY ",tablename," FROM '",unz[1],"' DELIMITER ','  CSV HEADER;"))
}

as.character(fs::dir_ls("E:/RaEVE/csv", regexp = "\\.csv.bz2$")) -> csv.list
map(csv.list, boofer)

#unlink(paste0(normalizePath(tempdir()), "/", dir(tempdir())), recursive = TRUE)


