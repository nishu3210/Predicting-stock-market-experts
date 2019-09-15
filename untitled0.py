# -*- coding: utf-8 -*-
"""
Created on Mon Nov 19 18:28:32 2018

@author: Nishant Jain
"""

from bs4 import BeautifulSoup
import requests
import re

# extract data from page
def extract_data(soup):
    tables = soup.find_all("div", {"class":"race-card"})[0].find_all("tbody")

    item_list = [
        (
            t[0].text.strip(), #date
            t[1].text.strip(), #dist
            t[2].text.strip(), #TP
            t[3].text.strip(), #StmHCP
            t[4].text.strip(), #Fin
            t[5].text.strip(), #By
            t[6].text.strip(), #WinnerOr2nd
            t[7].text.strip(), #Venue
            t[8].text.strip(), #Remarks
            t[9].text.strip(), #WinTime
            t[10].text.strip(), #Going
            t[11].text.strip(), #SP
            t[12].text.strip(), #Class
            t[13].text.strip()  #CalcTm
        )
        for t in (t.find_all('td') for t in tables[1].find_all('tr'))
        if t
    ]
    print(item_list)

session = requests.Session()

url = 'http://www.gbgb.org.uk/RaceCard.aspx?dogName=Hardwick%20Serena'

response = session.get(url)
soup = BeautifulSoup(res.content, "html.parser")

# get view state value
view_state = soup.find_all("input", {"id":"__VIEWSTATE"})[0]["value"]

# get all event target values
event_target = soup.find_all("div", {"class":"rgNumPart"})[0]
event_target_list = [
    re.search('__doPostBack\(\'(.*)\',', t["href"]).group(1)
    for t in event_target.find_all('a')
]

# extract data for the 1st page
extract_data(soup)

# extract data for each page except the first
for link in event_target_list[1:]:
    print("get page {0}".format(link))
    post_data = {
        '__EVENTTARGET': link,
        '__VIEWSTATE': view_state
    }
    response = session.post(url, data=post_data)
    soup = BeautifulSoup(response.content, "html.parser")
    extract_data(soup)
