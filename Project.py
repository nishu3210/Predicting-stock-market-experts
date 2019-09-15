# -*- coding: utf-8 -*-
"""
Created on Tue Dec  4 01:10:48 2018

@author: Nishant Jain
"""
import os
path = "C:/Users/Nishant Jain/Documents/01. Projects/01. MLSP/"
os.chdir(path)
import pandas as pd

A1 = pd.read_csv("A1.csv")
A1 = A1.drop(A1.columns[-1],axis=1)
SP = pd.read_csv("SP500.csv")
GDP = pd.read_csv("GDP.csv")
hsp = pd.read_csv("historical_stock_prices.csv")
hsp.head(2)
hsp2 = pd.read_csv("fundamentals_dataset.csv",thousands=',')
hsp2 = hsp2.pivot_table(index = ("company","period"),columns = "indicator",values = "amount")
