urltest<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=Pamb0,UV_B&table=HYY_META&from=2016-02-11%2000:00:00.989&to=2016-02-12%2009:06:07.989&quality=ANY&averaging=30MIN&type=ARITHMETIC"
urltest2<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=T168,T672&table=HYY_META&from=2020-03-02%2016:23:52&to=2020-03-02%2017:23:52&quality=ANY&averaging=30MIN&type=ARITHMETIC"
#urltest2<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=T168,T672&table=HYY_META&from=2016-02-11%2000:00:00&to=2016-02-12%2009:06:07&quality=ANY&averaging=30MIN&type=ARITHMETIC"

urlstring<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=Pamb0,UV_B&table=HYY_META&from=2016-02-11%2000:00:00&to=2016-02-11%2000:10:00&quality=ANY&averaging=NONE&type=NONE"

urlstring2<-"https://avaa.tdata.fi/smear-services/smeardata.jsp?variables=Pamb0,UV_B&table=HYY_META&from=2016-02-11%2000:11:00&to=2016-02-11%2000:20:00&quality=ANY&averaging=NONE&type=NONE"

urlstring
urlstring2



d<-read.csv(urlstring2)
head(d)

