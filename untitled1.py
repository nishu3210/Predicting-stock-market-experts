# -*- coding: utf-8 -*-
"""
Created on Mon Nov 19 18:38:54 2018

@author: Nishant Jain
"""

import pandas as pd
import requests
from bs4 import BeautifulSoup
from tabulate import tabulate

res = requests.get("https://www.gurufocus.com/guru/warren+buffett/stock-picks")
soup = BeautifulSoup(res.content,'lxml')
table = soup.find_all('table')[2] 
df = pd.read_html(str(table))
print( tabulate(df[0], headers='keys', tablefmt='psql') )
