from pydantic import BaseModel
from typing import List

class PredictionResponse(BaseModel):
    damage_type: str
    confidence: float
    severity: str
    road_health_score: int
    risk_level: str
    recommendation: str

class HealthResponse(BaseModel):
    status: str
    model_loaded: bool