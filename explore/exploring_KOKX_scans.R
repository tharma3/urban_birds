#### R Script to Explore Specific Nexrad Scans 
#### Scans are downloaded from https://s3.amazonaws.com/noaa-nexrad-level2/index.html
#### using the staging/download_nexrad_scans.py
####
#### Load Packages ============================================================
# load the bioRad package
library(bioRad)

# check the package version
packageVersion("bioRad")

#### Set UP ===================================================================
HOME <- "/Users/mguan/Desktop/MG/urban_birds/explore"
file.exists(HOME)
setwd(HOME)
# Finally, we set the local time zone to UTC, so all plotted time axes will be in UTC
Sys.setenv(TZ = "UTC")

# start your local Docker installation and check docker
check_docker()

# data folder
files <- list.files(path=paste0(HOME, "/nexrad_downloads/May17"))

zoom15 <- list()

for (f in files){
  print(f)
  my_pvol <- read_pvolfile(paste0(HOME, "/nexrad_downloads/May17/",f))
  minangle <-which.min(get_elevation_angles(my_pvol)) # get the lowest angle
  my_scan <- my_pvol$scans[[minangle]]
  my_ppi <- project_as_ppi(my_scan, ylim = c(40.725, 40.740), 
                           xlim = c(-74.017, -73.992)) # for zoom level 15
  basemap <- download_basemap(my_ppi, maptype = "toner-lite", alpha = 0.75)
  wsp <- map(my_ppi, map = basemap, param = "DBZH")
  zoom15[[f]] <- wsp
  ggplot2::ggsave(paste0(HOME, "/nexrad_downloads/May17/plots/", f, ".png"))
  }

