from typing import List
from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware

from app.model_loader import get_model
from app.predict import predict_image
from app.schemas import PredictionResponse, HealthResponse

app = FastAPI(title="RoadGuardian AI API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def load_model_on_startup():
    get_model()


@app.get("/")
def root():
    return {"message": "RoadGuardian AI API is running"}


@app.get("/health", response_model=HealthResponse)
def health_check():
    return {"status": "ok", "model_loaded": True}


@app.post("/predict", response_model=PredictionResponse)
async def predict(file: UploadFile = File(...)):
    if not file.content_type.startswith("image/"):
        raise HTTPException(status_code=400, detail="File must be an image")

    image_bytes = await file.read()
    result = predict_image(image_bytes)
    return result


@app.post("/predict-batch")
async def predict_batch(files: List[UploadFile] = File(...)):
    results = []

    for file in files:
        if not file.content_type.startswith("image/"):
            continue

        image_bytes = await file.read()
        result = predict_image(image_bytes)
        result["filename"] = file.filename
        results.append(result)

    if not results:
        raise HTTPException(status_code=400, detail="No valid image files were uploaded")

    return {"total": len(results), "results": results}