from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.connection import get_db
from apis import friendrecommend  # main logic

router = APIRouter(
    prefix="/friend",  # url 앞에 고정적으로 붙는 경로추가
)  # Route 분리

@router.get("/friends/{user_id}")  # Route Path
def read_friends(user_id: int, db: Session = Depends(get_db)):
    res = friendrecommend.read_friends(db=db, user_id=user_id)  # apis 호출

    return {"res": res}  # 결과

@router.get("/strangers/{user_id}")  # Route Path
def read_friends(user_id: int, db: Session = Depends(get_db)):
    res = friendrecommend.read_strangers(db=db, user_id=user_id)  # apis 호출

    return {"res": res}  # 결과

@router.get("/{user_id}")  # Route Path
def read_requset_friends(user_id: int, db: Session = Depends(get_db)):
    res = friendrecommend.read_requset_friends(db=db, user_id=user_id)  # apis 호출

    return res  # 결과


# @router.get("/ex/{user_id}")  # Route Path
# def read_user_ex_log(user_id: int, db: Session = Depends(get_db)):
#     res = friendrecommend.read_user_ex_log(db=db, user_id=user_id)  # apis 호출
#
#     return res  # 결과

# @router.get("/asset/{asset_id}")  # Route Path
# def read_user_ex_log(asset_id: int, db: Session = Depends(get_db)):
#     res = friendrecommend.read_asset(db=db, asset_id=asset_id)  # apis 호출
#
#     return res  # 결과

