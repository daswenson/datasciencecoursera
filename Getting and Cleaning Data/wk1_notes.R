## Week1 Testing

  ## file.exists()
    # tells whether a file with the specified name exists in the 
    # specified directory
    # returns boolean

# this checks if a directory exists or otherwise creates it
if(!file.exists("data")){
  dir.create("data")
}

  ## download.file()
    # parameters: url,destfile, method
    # helps with reproducability
    # useful fortab-delimited, csv and others
# example with Balitmore speed cameras
fileUrl <- "https://opendata.baltimorecity.gov/egis/rest/services/Hosted/
Fixed_Speed_Cameras/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
download.file(fileUrl, destfile = "./data/cameras.csv", method = )
dateDownLoaded <- date() # always specify when you get the data

  ## reading local files 