from fastapi import FastAPI
from pydantic import BaseModel
import os

app = FastAPI(title="ACA Python Starter", version="1.0.0")

class PredictIn(BaseModel):
    text: str

class PredictOut(BaseModel):
    tokens: int
    upper: str

@app.get("/")
def root():
    return {
        "name": "ACA Python Starter",
        "env": os.getenv("APP_ENV", "dev"),
        "message": "Hello from Azure Container Apps!",
    }

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

@app.post("/predict", response_model=PredictOut)
def predict(inp: PredictIn):
    # dummy business logic
    t = inp.text.strip()
    return PredictOut(tokens=len(t.split()), upper=t.upper())
