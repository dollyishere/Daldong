import pandas as pd
import pprint
import requests
import json

ex_data = pd.read_csv('recommend_data.csv', encoding="euc-kr")

age_range = []
bmi_grade = []
gender = []
ability = []
sports_step = []
# pd.set_option('display.max_rows', None)
# rec_ex = ex_data['ex_recommend']

for i in range(len(ex_data)):
    # 나이 그룹화
    age_range.append(int(ex_data['age_range'][i][0]))

    # bmi 변환
    if ex_data['bmi_grade'][i] == '저체중':
        bmi_grade.append(0)
    elif ex_data['bmi_grade'][i] == '정상':
        bmi_grade.append(1)
    elif ex_data['bmi_grade'][i] == '비만전단계비만':
        bmi_grade.append(2)
    elif ex_data['bmi_grade'][i] == '1단계비만':
        bmi_grade.append(3)
    elif ex_data['bmi_grade'][i] == '2단계비만':
        bmi_grade.append(4)
    elif ex_data['bmi_grade'][i] == '3단계비만':
        bmi_grade.append(5)


    # 성별 변환
    if ex_data['gender'][i] == 'M':
        gender.append(0)
    elif ex_data['gender'][i] == 'F':
        gender.append(1)

    # 운동 능력 변환
    if ex_data['ability'][i] == '참가증':
        ability.append(0)
    elif ex_data['ability'][i] == '1등급':
        ability.append(1)
    elif ex_data['ability'][i] == '2등급':
        ability.append(2)
    elif ex_data['ability'][i] == '3등급':
        ability.append(3)

    # 운동 단계 변환
    if ex_data['sports_step'][i] == '준비운동':
        sports_step.append(0)
    elif ex_data['sports_step'][i] == '본운동':
        sports_step.append(1)
    elif ex_data['sports_step'][i] == '마무리운동':
        sports_step.append(2)


ex_data['age_range'] = age_range
ex_data['bmi_grade'] = bmi_grade
ex_data['gender'] = gender
ex_data['ability'] = ability
ex_data['sports_step'] = sports_step
# print(ex_data)

ex_data['video_url'] = ''
# print(ex_data)


# video url 가져오기
video_list = []
ex_video = dict()
ex_rec = list(set(ex_data['ex_recommend']))
# print(ex_rec)

for i in range(len(ex_rec)):
    ex_name = ex_rec[i]

    url = f"https://apis.data.go.kr/B551014/SRVC_TODZ_VDO_PKG/TODZ_VDO_VIEW_ALL_LIST_I?serviceKey=O8BO9%2FNR%2BcVS1oZ7pj9m7gUneFi%2BSQlOZWSWGbayQfsDJX7b3EfUTboS0Gvq2V2O1weKoPl%2FbPewkoCgMBxpzA%3D%3D&pageNo=1&numOfRows=50&resultType=Json&trng_nm={ex_name}"

    # print(url)
    response = requests.get(url)

    contents = response.text

    pp = pprint.PrettyPrinter(indent=4)
    # print(pp.pprint(contents))

    result = json.loads(contents)

    if result['response']['body']['items']['item'] != []:
        video_url = result['response']['body']['items']['item'][0]['file_url'] + result['response']['body']['items']['item'][0]['file_nm']
        # ex_data['video_url'][i] = video_url
        # print(ex_data['video_url'][i])
        # print(ex_data['video_url'])
    else:
        video_url = ""
    # video_list.append(video_url)
    ex_video[ex_name] = video_url
    print(i)
    # print(ex_video)
    # print(ex_data)
    # print(ex_data['video_url'][0])

    # print(video_url)
    #
    #
    # print(result)
    # print(type(result))

for i in range(len(ex_data)):
    video_list.append(ex_video[ex_data['ex_recommend'][i]])

ex_data['video_url'] = video_list
print(ex_data)

# ex_data['video_url'] = video_list
# print(ex_data)

ex_data.to_csv('./Data Preprocessing.csv')