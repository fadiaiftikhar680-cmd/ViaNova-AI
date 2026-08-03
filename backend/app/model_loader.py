import tensorflow as tf
import os

MODEL_PATH = os.path.join(os.path.dirname(__file__), "..", "models", "roadguardian_model.keras")

CLASS_NAMES = [
    "Alligator_Crack",
    "Longitudinal_Crack",
    "Pothole",
    "Repair_Other",
    "Transverse_Crack"
]

_model = None

def get_model():
    global _model
    if _model is None:
        print("Loading model from:", MODEL_PATH)
        _model = tf.keras.models.load_model(MODEL_PATH)
        print("Model loaded successfully")
    return _model