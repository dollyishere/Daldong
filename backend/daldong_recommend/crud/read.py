from sqlalchemy.orm import Session
from db.models.models import User, ExerciseRecommendDatum, Friend, FriendRequest, ExerciseLog, Asset
from sqlalchemy import and_, not_, or_

# 모든 유저 불러오기
def get_users(db: Session):
    return db.query(User).all()

# 선택한 유저 불러오기
def get_user(db: Session, user_id: int):
    return db.query(User).filter(User.user_id == user_id).first()

# 준비운동 추천 리스트
def get_pre_ex(db: Session, age_range: int, bmi_grade: int, user: list, space: list):
    return db.query(ExerciseRecommendDatum). \
        filter(and_(ExerciseRecommendDatum.rec_age_range == age_range, ExerciseRecommendDatum.rec_bmi_grade == bmi_grade,
             ExerciseRecommendDatum.rec_gender == user.gender,
             ExerciseRecommendDatum.rec_ability == user.ability,
             ExerciseRecommendDatum.space.in_(space), ExerciseRecommendDatum.rec_sports_step == 0)).limit(5).all()

# 본운동 추천 리스트
def get_main_ex(db: Session, age_range: int, bmi_grade: int, user: list, space: list):
    return db.query(ExerciseRecommendDatum). \
        filter(
        and_(ExerciseRecommendDatum.rec_age_range == age_range, ExerciseRecommendDatum.rec_bmi_grade == bmi_grade,
             ExerciseRecommendDatum.rec_gender == user.gender,
             ExerciseRecommendDatum.rec_ability == user.ability,
             ExerciseRecommendDatum.space.in_(space), ExerciseRecommendDatum.rec_sports_step == 1)).limit(5).all()

# 마무리운동 추천리스트
def get_end_ex(db: Session, age_range: int, bmi_grade: int, user: list, space: list):
    return db.query(ExerciseRecommendDatum). \
        filter(and_(ExerciseRecommendDatum.rec_age_range == age_range, ExerciseRecommendDatum.rec_bmi_grade == bmi_grade,
         ExerciseRecommendDatum.rec_gender == user.gender,
         ExerciseRecommendDatum.rec_ability == user.ability,
         ExerciseRecommendDatum.space.in_(space), ExerciseRecommendDatum.rec_sports_step == 2)).limit(5).all()

# 친구인 유저 불러오기
def get_friends(db: Session, user_id: int):
    return db.query(Friend).filter(Friend.user_id == user_id).all()

# 친구 요청 or 요청받은 유저 리스트
def get_request_friends(db: Session, user_id: int):
    return db.query(FriendRequest).filter(or_(FriendRequest.sender_id == user_id, FriendRequest.receiver_id == user_id)).all()

# 친구가 아닌 유저 리스트 불러오기
def get_strangers(db: Session, user_id: int):
    friend_list = [user_id]
    friends = get_friends(db, user_id)
    friends_request = get_request_friends(db, user_id)
    for i in range(len(friends)):
        friend_list.append(friends[i].friend_id)
    for i in range(len(friends_request)):
        if friends_request[i].sender_id == user_id:
            friend_list.append(friends_request[i].receiver_id)
        else:
            friend_list.append(friends_request[i].sender_id)
    res = db.query(User).filter(not_(User.user_id.in_(friend_list))).all()

    return res

# 메인 펫 에셋 영문이름 가져오기
def get_mainpet_name(db: Session, asset_id: int):
    res = db.query(Asset).filter(Asset.asset_id == asset_id).first()
    # res = db.query(Asset).all()
    return res.asset_name


# 최근 운동 기록 가져오기
def get_user_ex_log(db: Session, user_id: int):
    ex_log = db.query(ExerciseLog).filter(ExerciseLog.user_id == user_id).order_by(ExerciseLog.exercise_endtime.desc()).first()
    return ex_log

# 친구 추천 리스트
def get_rec_fr(db: Session, user_id: int):
    user = get_user(db, user_id)
    strangers = get_strangers(db, user_id)
    for i in range(len(strangers)):
        gower_dis = ((abs(user.age - strangers[i].age) / 95) + (abs(user.weight - strangers[i].weight) / 170) + (abs(user.height - strangers[i].height) / 170) + (abs(user.ability - strangers[i].ability) / 3) + (abs(user.user_level - strangers[i].user_level) / 99))
        strangers[i].gower = gower_dis
        strangers[i].last_ex = get_user_ex_log(db, strangers[i].user_id)
        strangers[i].main_pet_asset_name = get_mainpet_name(db, strangers[i].main_pet_id)

    strangers_sort = sorted(strangers, key=lambda x: (x.gower, x.last_ex, x.user_id))

    res = strangers_sort[0:10]
    # res

    return res
