from crud import read
import random

def read_friends(db, user_id: int):
    friends = read.get_friends(db, user_id)
    return friends

def read_user(db, user_id: int):
    user = read.get_user(db, user_id)
    return user

def read_strangers(db, user_id: int):
    friends = read.get_strangers(db, user_id)
    return friends

def read_requset_friends(db, user_id: int):

    rec_friends = read.get_rec_fr(db, user_id)
    rec_friend = rec_friends[random.randint(0, 9)]
    res = {"friendId": rec_friend.user_id,
           "friendNickname": rec_friend.nickname,
           "friendUserLevel": rec_friend.user_level,
           "mainPetAssetName": rec_friend.main_pet_asset_name,
           }
    return res

# def read_user_ex_log(db, user_id: int):
#     res = read.get_user_ex_log(db, user_id)
#     return res

# def read_asset(db, asset_id: int):
#     res = read.get_mainpet_name(db, asset_id)
#     return res

