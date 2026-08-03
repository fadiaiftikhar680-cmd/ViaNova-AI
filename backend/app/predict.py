import numpy as np
from PIL import Image
import io
from app.model_loader import get_model, CLASS_NAMES

IMG_SIZE = 224

def preprocess_image(image_bytes):
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    image = image.resize((IMG_SIZE, IMG_SIZE))
    array = np.array(image)
    array = np.expand_dims(array, axis=0)
    return array

def get_severity(confidence):
    if confidence >= 0.85:
        return "High"
    elif confidence >= 0.60:
        return "Medium"
    else:
        return "Low"

def get_road_health_score(damage_type, confidence):
    if damage_type == "Repair_Other":
        return int(90 - (confidence * 10))
    base = 100 - int(confidence * 70)
    return max(0, min(100, base))

def get_risk_level(score):
    if score >= 70:
        return "Low"
    elif score >= 40:
        return "Medium"
    else:
        return "High"

def get_recommendation(risk_level):
    if risk_level == "Low":
        return "Monitor the road periodically."
    elif risk_level == "Medium":
        return "Schedule maintenance soon."
    else:
        return "Immediate repair required."

def predict_image(image_bytes):
    model = get_model()
    processed = preprocess_image(image_bytes)
    predictions = model.predict(processed, verbose=0)[0]

    class_idx = int(np.argmax(predictions))
    confidence = float(predictions[class_idx])
    damage_type = CLASS_NAMES[class_idx]

    severity = get_severity(confidence)
    score = get_road_health_score(damage_type, confidence)
    risk = get_risk_level(score)
    recommendation = get_recommendation(risk)

    return {
        "damage_type": damage_type,
        "confidence": round(confidence * 100, 2),
        "severity": severity,
        "road_health_score": score,
        "risk_level": risk,
        "recommendation": recommendation
    }