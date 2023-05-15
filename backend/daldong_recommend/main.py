from fastapi import FastAPI
from routes.reco import router as reco_router
from routes.friend import router as friend_router

app = FastAPI() # FastAPI 모듈
app.include_router(reco_router) # 다른 route파일들을 불러와 포함시킴
app.include_router(friend_router) # 다른 route파일들을 불러와 포함시킴

@app.get("/") # Route Path
def index():
    return {
        "Python": "Framework",
    }