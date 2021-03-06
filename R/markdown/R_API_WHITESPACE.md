Example SmartSMEAR API calls, see https://avaa.tdata.fi/web/smart/smear/api


```R
urlstring<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=Pamb0,UV_B&table=HYY_META&from=2016-04-11%2000:00:00&to=2016-04-11%2000:10:00&quality=ANY&averaging=NONE&type=NONE"

urlstring2<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=Pamb0,UV_B&table=HYY_META&from=2016-04-11%2000:11:00&to=2016-04-11%2000:20:00&quality=ANY&averaging=NONE&type=NONE"



```


The most simple way for retrieving data via SmartSMEAR API is using read.csv which converts the data stream into data frame. It works in base R without additional libraries:



```R
data<-read.csv(urlstring)

data2<-read.csv(urlstring2)

class(data)
data
data2
data
```


Convert datetime columns to more convenient data type:



```R
data$datetim<-with(data,ISOdatetime(Year,Month,Day,Hour,Minute,Second))

data$datetim

data$datetim+86400
```

API makes your life easier when doing dynamic data retrievals within data processing/analysis scripts.

Construct times in POSIX time (seconds):


```R
time2<-Sys.time()
format(time2,"%Y-%m-%d %H:%M:%S")

time2<-as.POSIXct("2018-10-29 12:00:00")
format(time2,"%Y-%m-%d %H:%M:%S")

time1<-time2-3600
format(time1,"%Y-%m-%d %H:%M:%S")
```

Paste the times into API call for retrieving piece of data collected 24 h ago: 


```R
time2<-Sys.time()-86400
timestr2<-format(time2,"%Y-%m-%d%%20%H:%M:%S")
time1<-time2-3600
timestr1<-format(time1,"%Y-%m-%d%%20%H:%M:%S")

urlstring<-paste("https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=T168,T672&table=HYY_META&from=",
    timestr1,"&to=",timestr2,
    "&quality=ANY&averaging=30MIN&type=ARITHMETIC",sep="")

urlstring

data<-read.csv(urlstring)

head(data,1)
tail(data,1)

```


Below simple function for constructing API call from given parameters and downloading data.
Named parameters are used so the user can give table and variables separately or use table.variable notation, give parameters in any order and skip irrelevant parameters.
The function employs read.csv which ignores any http return codes or error messages. 
Therefore, additional parsing of returned data frame is needed. 

Different types of error affect the returned data in different ways. Be careful and take note of the column names of the returned data frame!



```R

getSmearData<-function(time1,time2,...,dbtable="",dbvariables=list(),dbtablevariables=list(),
  quality="ANY",averaging="NONE",avgtype="NONE") {

# Simple function for retrieving data from SMEAR database
# No input check, error handling etc.
# time1 and time2 are start and end times as POSIX time.
# Downloaded variables are given as list of table.variable strings (parameter "dbtablevariables").
# or giving table (string "dbtable") and variables (list "dbvariables") separately.
# Results of the query are returned as data frame (also in case of error).

timestr1=as.character(time1,"%Y-%m-%d%%20%H:%M:%S")
timestr2=as.character(time2,"%Y-%m-%d%%20%H:%M:%S")

if(length(dbtablevariables)<1) {
  urlstring<-paste("https://avaa.tdata.fi/smear-services/smeardata.jsp?",
    "variables=",paste(dbvariables,collapse=","),
    "&table=",dbtable,
    "&from=",timestr1,
    "&to=",timestr2,
    "&quality=",quality,"&averaging=",averaging,"&type=",avgtype,sep="")
}
else {
  urlstring<-paste("https://avaa.tdata.fi/smear-services/smeardata.jsp?",
    "tablevariables=",paste(dbtablevariables,collapse=","),
    "&from=",timestr1,
    "&to=",timestr2,
    "&quality=",quality,"&averaging=",averaging,"&type=",avgtype,sep="")
}
    
writeLines(urlstring)
    
return(read.csv(urlstring))
}

```

Two examples of using the function:


```R

time2<-as.POSIXct("2018-10-27 12:00:00")
time1<-time2-86400
tablename<-"HYY_META"
variables_list<-c("Pamb336","Tmm672")
avg_time="60MIN"
avg_type="Arithmetic"

data1<-getSmearData(time1,time2,dbtable=tablename,dbvariables=variables_list,
    averaging=avg_time,avgtype=avg_type)

head(data1)

time1<-Sys.Date()
time2<-time1+3600
tablevariables_list=c("HYY_META.Pamb336")

data2<-getSmearData(time1,time2,dbtablevariables=tablevariables_list)

head(data2)
```


SmartSMEAR API gives http return codes and in most cases also meaningful error messages. Read.csv cannot handle the http codes and also tries to convert the error messages to data frame. Below some examples.

Some dedicated http libraries, for instance RCurl, can handle error messages better. 



```R

time2<-Sys.time()-86400
time1<-time2-180

writeLines("Error 1:")
data<-getSmearData(time1,time2,dbtable="HYY_META",dbvariables=c("xxxx"))
if(names(data)[1]!="Year" | dim(data)[1]<1) {
  print(data)
}

writeLines("Error 2:")
data<-getSmearData(time1,time2,dbtable="HYY_XXXX",dbvariables=c("Glob"))
if(names(data)[1]!="Year" | dim(data)[1]<1) {
  print(data)
}

```

Specific notes for AVAA API:

When using tablevariables parameter, if any variable does not exist in given table, no data from that table are returned.


```R

time2<-Sys.time()-86400
time1<-time2-180

# All variables exist
data<-getSmearData(time1,time2,dbtablevariables=c("HYY_META.Glob","HYY_META.Glob67","SII1_META.Glob"))
head(data)

# Glob127 does not exist in HYY_META, only data from SII1_META are returned
data<-getSmearData(time1,time2,dbtablevariables=c("HYY_META.Glob","HYY_META.Glob127","SII1_META.Glob"))
data


```

Specific notes for AVAA API:

Sometimes there are missing rows in the database, align the rows with merge.

Example: Hyytiälä and Siikaneva 1 meteo data in 2004/2005


```R
urlstring<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=T168&table=HYY_META&from=2004-12-31%2023:00:00&to=2005-01-01%2001:00:00&quality=ANY&averaging=30min&type=arithmetic"

urlstring2<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=T_a&table=SII1_META&from=2004-12-31%2023:00:00&to=2005-01-01%2001:00:00&quality=ANY&averaging=30min&type=arithmetic"

data<-read.csv(urlstring)
data

data2<-read.csv(urlstring2)
data2

merge(data,data2,all=TRUE)
```
