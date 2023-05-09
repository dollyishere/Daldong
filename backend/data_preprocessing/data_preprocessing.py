import pandas as pd
import numpy as np
import pprint
import requests
import json

ex_data = pd.read_csv('first_data_preprocessing.csv')
a = []
# count = 0
print(ex_data)

# video_url 비어있는 셀, 빈 내용 찾기 (일일이 찾아서 수작업..)

for i in range(len(ex_data)):
    # print(type(ex_data['video_url'][i]))
    if type(ex_data['video_url'][i]) == float:
        a.append(ex_data['ex_recommend'][i])
    #     print(i)

print(len(set(ex_data['ex_recommend'])))
print(len(a))
print(len(set(a)))
print(list(set(a)))
