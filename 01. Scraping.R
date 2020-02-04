# install.packages("rvest")
# library(rvest)
# url = 'https://www.gurufocus.com/guru/warren+buffett/stock-picks'
# 
# tb = url %>%  read_html() %>% html_nodes(xpath='/html/body/div[1]/div[2]/div/div/section/section/main/div/div[3]/div/div/div[3]/table')
#      %>%  html_table(header = T) 
# 
# tb1 = tb[[1]]
# tb2 = tb1 %>% html_table(header = T)

# install.packages("RSelenium")
library(RSelenium)
library(XML)

#### Settings for connecting to the web through R and accessing the website
# rsDriver(port = 4567L, browser = c("internet explorer"), version = "latest", chromever = "latest", geckover = "latest", iedrver = NULL, phantomver = "2.1.1", verbose = TRUE, check = TRUE)
rD <- rsDriver(port = 4443L)
remDr <- rD[["client"]]
remDr$open()
url = 'https://www.gurufocus.com/stock/AAPL' #webpage to be scraped (Historical stock price for Apple)
remDr$navigate(url)
table2 = data.frame()

#### Used a for loop to get all the values from the table as only limited number of results were displayed on one page
#### Hence, a new webpage has to be visited by clicking on next through the script below
for(i in 1:57)
{
  webelem = remDr$findElement(using = "css selector",'#guruTradesTb')
  result = webelem$getElementAttribute("outerHTML")
  table1 <- readHTMLTable(result[[1]], header=TRUE, as.data.frame=TRUE)[[1]]
  remDr$findElement("css", "#guruTradesTb_next")$clickElement()
  # Sys.sleep(2)
  table1[,4] = as.numeric(as.numeric(gsub('%', '', table1[,4])))
  table3 = table1
  
  #To make sure the next webpage has been loaded, I check whether the data in the table has been changed or not
  while(sum(table1[,4]==table3[,4],na.rm = T)==sum(!is.na(table1[,4]))){
    webelem = remDr$findElement(using = "css selector",'#guruTradesTb')
    result = webelem$getElementAttribute("outerHTML")
    table3 = readHTMLTable(result[[1]], as.data.frame=TRUE)[[1]]
    table3[,4] = as.numeric(as.numeric(gsub('%', '', table3[,4])))
  }
  
  #After the above step, the scraped data is appended to the final table
  table2 = rbind.data.frame(table2,table1)
}
sum(duplicated(table2))
colnames(table2) = trimws(colnames(table2))
write.csv(table2,"Apple.csv",row.names = F)

#### Same thing for different page on the same website

remDr <- rD[["client"]]
remDr$open()
url2 = "https://www.gurufocus.com/guru/carl+icahn/stock-picks"
remDr$navigate(url2)
table2 = data.frame()
for(i in 1:7)
{
  webelem = remDr$findElement(using = "class",'normal-table')
  result = webelem$getElementAttribute("outerHTML")
  table1 <- readHTMLTable(result[[1]], as.data.frame=TRUE)[[1]]
  remDr$findElement("css", ".btn-next")$clickElement()
  # Sys.sleep(2)
  table1[,8] = as.numeric(as.numeric(gsub('%', '', table1[,8])))
  table3 = table1
  while(sum(table1[,8]==table3[,8],na.rm = T)==sum(!is.na(table1[,8]))){
    webelem = remDr$findElement(using = "class",'normal-table')
    result = webelem$getElementAttribute("outerHTML")
    table3 = readHTMLTable(result[[1]], as.data.frame=TRUE)[[1]]
    table3[,8] = as.numeric(as.numeric(gsub('%', '', table3[,8])))
  }
  table2 = rbind.data.frame(table2,table1)
}

sum(duplicated(table2))
colnames(table2) = trimws(colnames(table2))
table2 = unique(table2)

write.csv(table2,"Investors/CI.csv",row.names = F)

remDr$closeall()
