from sqlalchemy.orm import Session
from db.models.models import User, ExerciseRecommendDatum
from sqlalchemy import and_

def get_users(db: Session):
    return db.query(User).all()

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
