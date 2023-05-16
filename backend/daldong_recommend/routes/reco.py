from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from db.connection import get_db
from apis import exerciserecommend  # main logic

router = APIRouter(
    prefix="/user",  # url 앞에 고정적으로 붙는 경로추가
)  # Route 분리


# @router.get("/")  # Route Path
# def read_users(db: Session = Depends(get_db)):
#     res = exerciserecommend.read_users(db=db)  # apis 호출
#
#     return {"res": res}  # 결과

@router.get("/{user_uid}")
async def ex_get(user_uid: str, whether: str = "Clear", template: float = 20, db: Session = Depends(get_db)):
    user_id = exerciserecommend.read_user_id(db, user_uid)
    res = exerciserecommend.ex_get(db=db, user_id=user_id, whether=whether, template=template)
    return {"Exercise": res}
