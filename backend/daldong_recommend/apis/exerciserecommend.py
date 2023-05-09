from crud import read
import random

def read_users(db):
    users = read.get_users(db)
    return users

# 운동 추천 코드
def ex_get(db, user_id: int, whether: str, template: float):
    # user아이디 확인해서 유저 정보 받아옴
    user = read.get_user(db, user_id)
    # 정보 전처리 과정
    age_range = user.age // 10
    if age_range < 1:
        age_range = 1
    elif age_range >= 7:
        age_range = 7

    bmi = user.weight / (user.height/100)**2
    if bmi <= 18.5:
        bmi_grade = 0
    elif bmi < 23:
        bmi_grade = 1
    elif bmi < 25:
        bmi_grade = 2
    elif bmi < 30:
        bmi_grade = 3
    elif bmi < 35:
        bmi_grade = 4
    else:
        bmi_grade = 5

    if whether in ["Clear", "Clouds"] and 15 <= template <= 30:
        space = ["0", "1"]
    else:
        space = ["0"]

    pre_ex_rec = read.get_pre_ex(db, age_range, bmi_grade, user, space)
    main_ex_rec = read.get_main_ex(db, age_range, bmi_grade, user, space)
    end_ex_rec = read.get_end_ex(db, age_range, bmi_grade, user, space)

    # # 날씨 좋으면 야외활동을 우선으로 정렬
    # if space == ["0", "1"]:
    #     pre_ex_rec = sorted(pre_ex_rec, key=lambda ex_rec: ex_rec.space, reverse=True)
    #     main_ex_rec = sorted(main_ex_rec, key=lambda ex_rec: ex_rec.space, reverse=True)
    #     end_ex_rec = sorted(end_ex_rec, key=lambda ex_rec: ex_rec.space, reverse=True)


    # 추천할 운동, 영상 1개씩 고르기
    daily_pre_ex_recommend = pre_ex_rec[random.randint(0, len(pre_ex_rec) - 1)].rec_ex
    daily_pre_ex_video = pre_ex_rec[random.randint(0, len(pre_ex_rec) - 1)].rec_video_url
    daily_main_ex_recommend = main_ex_rec[random.randint(0, len(main_ex_rec) - 1)].rec_ex
    daily_main_ex_video = main_ex_rec[random.randint(0, len(main_ex_rec) - 1)].rec_video_url
    daily_end_ex_recommend = end_ex_rec[random.randint(0, len(end_ex_rec) - 1)].rec_ex
    daily_end_ex_video = end_ex_rec[random.randint(0, len(end_ex_rec) - 1)].rec_video_url


    Exercise = [daily_pre_ex_recommend, daily_pre_ex_video, daily_main_ex_recommend, daily_main_ex_video, daily_end_ex_recommend, daily_end_ex_video]

    return {"Exercise": Exercise}
