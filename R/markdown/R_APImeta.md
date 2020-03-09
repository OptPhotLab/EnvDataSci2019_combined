Getting metadata is simple but read.csv cannot parse the returned json-formatted text.
You can however force csv output.

Metadata are UTF-8 encoded, sub/superscripts etc. might not show correctly here.


```R
url<-"https://avaa.tdata.fi/smart-smear-portlet/variablemeta.jsp?tablevariables=HYY_META.Glob"

meta<-read.csv(url)

meta

url<-"https://avaa.tdata.fi/smart-smear-portlet/variablemeta.jsp?tablevariables=HYY_META.Glob&format=csv"

meta<-read.csv(url)

meta
```

There are libraries like jsonlite that help converting json metadata into data frame. 


```R
library(jsonlite)

url<-"https://avaa.tdata.fi/smart-smear-portlet/variablemeta.jsp?variable=PAR"

meta<-fromJSON(txt=url)

class(meta)
meta

```

Some APIs return data in more complicated format...
This is FMI open data service:


```R

url<-"http://opendata.fmi.fi/wfs?request=getFeature&storedquery_id=fmi::observations::weather::timevaluepair&fmisid=101317&starttime=2020-01-01&endtime=2020-01-02"

res<-scan(url,what=character())

res

```


```R

```
