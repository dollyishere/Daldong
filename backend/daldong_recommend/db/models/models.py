from sqlalchemy import BigInteger, Column, Date, Float, ForeignKey, Integer, String, Table, Time
from sqlalchemy.dialects.mysql import BIT, DATETIME, TINYINT
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()
metadata = Base.metadata


class Asset(Base):
    __tablename__ = 'asset'

    asset_id = Column(BigInteger, primary_key=True)
    asset_name = Column(String(255), nullable=False)
    asset_price = Column(Integer, nullable=False)
    asset_type = Column(BIT(1), nullable=False)
    asset_unlock_level = Column(Integer, nullable=False)


class DailyMission(Base):
    __tablename__ = 'daily_mission'

    mission_id = Column(BigInteger, primary_key=True)
    mission_content = Column(String(255), nullable=False)
    mission_name = Column(String(255), nullable=False)
    missoin_date = Column(DATETIME(fsp=6), nullable=False)
    qualification_name = Column(String(255), nullable=False)
    qualification_num = Column(Integer, nullable=False)
    reward_point = Column(Integer, nullable=False)


class ExerciseRecommendDatum(Base):
    __tablename__ = 'exercise_recommend_data'

    rec_id = Column(Integer, primary_key=True)
    rec_age_range = Column(TINYINT, nullable=False)
    rec_bmi_grade = Column(TINYINT, nullable=False)
    rec_gender = Column(TINYINT(1), nullable=False)
    rec_ability = Column(TINYINT, nullable=False)
    rec_sports_step = Column(TINYINT, nullable=False)
    rec_rank = Column(TINYINT, nullable=False)
    rec_ex = Column(String(30), nullable=False)
    rec_video_url = Column(String(2000), nullable=False)
    space = Column(String(30))


class Level(Base):
    __tablename__ = 'level'

    level = Column(BigInteger, primary_key=True)
    required_exp = Column(Integer, nullable=False)


class Motion(Base):
    __tablename__ = 'motion'

    motion_id = Column(BigInteger, primary_key=True)
    motion_name = Column(String(255), nullable=False)
    motion_unlock_exp = Column(Integer, nullable=False)


class User(Base):
    __tablename__ = 'users'

    user_id = Column(BigInteger, primary_key=True)
    ability = Column(Integer)
    age = Column(Integer)
    gender = Column(BIT(1))
    height = Column(Float)
    main_pet_name = Column(String(255), nullable=False)
    nickname = Column(String(255), nullable=False)
    required_exp = Column(Integer, nullable=False)
    user_exp = Column(Integer, nullable=False)
    user_level = Column(Integer, nullable=False)
    user_point = Column(Integer, nullable=False)
    user_uid = Column(String(255), nullable=False)
    weight = Column(Float)
    main_back_id = Column(ForeignKey('asset.asset_id'), nullable=False, index=True)
    main_pet_id = Column(ForeignKey('asset.asset_id'), nullable=False, index=True)

    main_back = relationship('Asset', primaryjoin='User.main_back_id == Asset.asset_id')
    main_pet = relationship('Asset', primaryjoin='User.main_pet_id == Asset.asset_id')
    senders = relationship(
        'User',
        secondary='friend_request',
        primaryjoin='User.user_id == friend_request.c.receiver_id',
        secondaryjoin='User.user_id == friend_request.c.sender_id'
    )


class DailyExerciseLog(Base):
    __tablename__ = 'daily_exercise_log'

    daily_exercise_id = Column(BigInteger, primary_key=True)
    count = Column(Integer, nullable=False)
    ex_date = Column(Date, nullable=False)
    ex_time = Column(Time, nullable=False)
    kcal = Column(Integer, nullable=False)
    point = Column(Integer, nullable=False)
    user_id = Column(ForeignKey('users.user_id'), nullable=False, index=True)

    user = relationship('User')


class ExerciseLog(Base):
    __tablename__ = 'exercise_log'

    exercise_id = Column(BigInteger, primary_key=True)
    average_heart = Column(Integer, nullable=False)
    exercise_endtime = Column(DATETIME(fsp=6), nullable=False)
    exercise_kcal = Column(Integer, nullable=False)
    exercise_memo = Column(String(255))
    exercise_pet_exp = Column(Integer, nullable=False)
    exercise_point = Column(Integer, nullable=False)
    exercise_starttime = Column(DATETIME(fsp=6), nullable=False)
    exercise_time = Column(Time, nullable=False)
    ecercise_user_exp = Column(Integer, nullable=False)
    max_heart = Column(Integer, nullable=False)
    user_id = Column(ForeignKey('users.user_id'), nullable=False, index=True)

    user = relationship('User')


class Friend(Base):
    __tablename__ = 'friend'

    friend_id = Column(ForeignKey('users.user_id'), primary_key=True, nullable=False)
    user_id = Column(ForeignKey('users.user_id'), primary_key=True, nullable=False, index=True)
    is_sting = Column(BIT(1), nullable=False)

    friend = relationship('User', primaryjoin='Friend.friend_id == User.user_id')
    user = relationship('User', primaryjoin='Friend.user_id == User.user_id')


t_friend_request = Table(
    'friend_request', metadata,
    Column('receiver_id', ForeignKey('users.user_id'), primary_key=True, nullable=False),
    Column('sender_id', ForeignKey('users.user_id'), primary_key=True, nullable=False, index=True)
)


class Statistic(Base):
    __tablename__ = 'statistics'

    statistics_id = Column(BigInteger, primary_key=True)
    daily_count = Column(Integer)
    daily_ex_time = Column(Integer, nullable=False)
    daily_friend = Column(Integer)
    daily_kcal = Column(Integer, nullable=False)
    user_id = Column(ForeignKey('users.user_id'), nullable=False, unique=True)

    user = relationship('User')


class UserAsset(Base):
    __tablename__ = 'user_asset'

    asset_id = Column(ForeignKey('asset.asset_id'), primary_key=True, nullable=False)
    user_id = Column(ForeignKey('users.user_id'), primary_key=True, nullable=False, index=True)
    asset_type = Column(BIT(1), nullable=False)
    pet_exp = Column(Integer, nullable=False)
    pet_name = Column(String(255))

    asset = relationship('Asset')
    user = relationship('User')


class UserMission(Base):
    __tablename__ = 'user_mission'

    mission_id = Column(ForeignKey('daily_mission.mission_id'), primary_key=True, nullable=False)
    user_id = Column(ForeignKey('users.user_id'), primary_key=True, nullable=False, index=True)
    is_done = Column(BIT(1), nullable=False)
    is_receive = Column(BIT(1), nullable=False)

    mission = relationship('DailyMission')
    user = relationship('User')
