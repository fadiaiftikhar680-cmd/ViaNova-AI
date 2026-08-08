import streamlit as st
import requests
from PIL import Image
import io
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go

st.set_page_config(page_title="ViaNova AI", page_icon="🛣️", layout="wide")

API_URL = "https://vianova-ai-production-69f1.up.railway.app"

# ---------- CUSTOM CSS ----------
st.markdown("""
<style>
.main { background-color: #0f1116; }
.stApp { background: linear-gradient(135deg, #0f2027 0%, #203a43 50%, #2c5364 100%); }
h1, h2, h3 { color: #ffffff; }
p, span, label { color: #e0e0e0; }
.metric-card {
    background: rgba(255,255,255,0.08);
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    border: 1px solid rgba(255,255,255,0.15);
}
.hero {
    text-align: center;
    padding: 40px 20px;
    background: rgba(255,255,255,0.05);
    border-radius: 16px;
    margin-bottom: 30px;
}
[data-testid="stSidebar"] { background-color: #0d1117; }
</style>
""", unsafe_allow_html=True)

# ---------- SIDEBAR NAVIGATION ----------
st.sidebar.title("🛣️ ViaNova AI")
page = st.sidebar.radio("Navigate", ["🏠 Home", "📷 Single Prediction", "📁 Batch Prediction", "ℹ️ About"])

CLASS_COLORS = {
    "Pothole": "#e74c3c",
    "Alligator_Crack": "#f39c12",
    "Longitudinal_Crack": "#3498db",
    "Transverse_Crack": "#9b59b6",
    "Repair_Other": "#2ecc71"
}

def severity_color(sev):
    return {"High": "#e74c3c", "Medium": "#f39c12", "Low": "#2ecc71"}.get(sev, "#95a5a6")

# ---------- HOME PAGE ----------
if page == "🏠 Home":
    st.markdown("""
    <div class="hero">
        <h1>🛣️ ViaNova AI</h1>
        <h3>Intelligent Road Damage Detection & Analysis System</h3>
        <p>Powered by Deep Learning (EfficientNetB0) — Detect potholes, cracks, and road damage instantly.</p>
    </div>
    """, unsafe_allow_html=True)

    col1, col2, col3, col4 = st.columns(4)
    features = [
        ("🎯", "AI Detection", "Detects 5 types of road damage with high accuracy"),
        ("📊", "Severity Analysis", "Automatic severity, risk level & road health scoring"),
        ("📁", "Batch Processing", "Analyze multiple images at once with analytics"),
        ("💡", "Smart Recommendations", "Get actionable repair recommendations instantly"),
    ]
    for col, (icon, title, desc) in zip([col1, col2, col3, col4], features):
        with col:
            st.markdown(f"""
            <div class="metric-card">
                <h2>{icon}</h2>
                <h4>{title}</h4>
                <p style="font-size:13px;">{desc}</p>
            </div>
            """, unsafe_allow_html=True)

    st.markdown("---")
    st.markdown("### 🚀 Get Started")
    st.write("Use the sidebar to navigate to **Single Prediction** for one image, or **Batch Prediction** to analyze multiple road images with full analytics.")

    st.markdown("### 🔍 Damage Types We Detect")
    dcol1, dcol2, dcol3, dcol4, dcol5 = st.columns(5)
    for col, (name, color) in zip([dcol1, dcol2, dcol3, dcol4, dcol5], CLASS_COLORS.items()):
        with col:
            st.markdown(f"""
            <div style="background:{color}; border-radius:10px; padding:15px; text-align:center; color:white; font-weight:bold; font-size:13px;">
                {name.replace('_',' ')}
            </div>
            """, unsafe_allow_html=True)

# ---------- SINGLE PREDICTION ----------
elif page == "📷 Single Prediction":
    st.title("📷 Single Image Analysis")
    st.write("Upload a road image to detect damage type, severity, and get repair recommendations.")

    uploaded_file = st.file_uploader("Upload a road image", type=["jpg", "jpeg", "png"])

    if uploaded_file is not None:
        image = Image.open(uploaded_file)
        col_img, col_result = st.columns([1, 1.3])

        with col_img:
            st.image(image, caption="Uploaded Image", use_container_width=True)
            analyze = st.button("🔍 Analyze Road Damage", use_container_width=True)

        if analyze:
            with st.spinner("Analyzing image..."):
                img_bytes = io.BytesIO()
                image.convert("RGB").save(img_bytes, format="JPEG")
                img_bytes.seek(0)
                try:
                    response = requests.post(f"{API_URL}/predict", files={"file": ("image.jpg", img_bytes, "image/jpeg")})
                    if response.status_code == 200:
                        result = response.json()
                        with col_result:
                            st.success("✅ Analysis Complete")
                            m1, m2 = st.columns(2)
                            m1.metric("Damage Type", result["damage_type"].replace("_", " "))
                            m1.metric("Confidence", f"{result['confidence']}%")
                            m2.metric("Road Health Score", f"{result['road_health_score']}/100")
                            m2.metric("Risk Level", result["risk_level"])
                            st.info(f"💡 **Recommendation:** {result['recommendation']}")

                            fig = go.Figure(go.Indicator(
                                mode="gauge+number",
                                value=result["road_health_score"],
                                title={"text": "Road Health Score"},
                                gauge={
                                    "axis": {"range": [0, 100]},
                                    "bar": {"color": severity_color(result["risk_level"])},
                                    "steps": [
                                        {"range": [0, 40], "color": "#e74c3c"},
                                        {"range": [40, 70], "color": "#f39c12"},
                                        {"range": [70, 100], "color": "#2ecc71"},
                                    ],
                                }
                            ))
                            fig.update_layout(height=300, margin=dict(t=40, b=10))
                            st.plotly_chart(fig, use_container_width=True)
                    else:
                        st.error(f"Error: {response.json().get('detail')}")
                except requests.exceptions.ConnectionError:
                    st.error("⚠️ Cannot connect to backend. Make sure FastAPI server is running.")

# ---------- BATCH PREDICTION ----------
elif page == "📁 Batch Prediction":
    st.title("📁 Batch Road Image Analysis")
    st.write("Upload multiple road images to analyze them all at once with full analytics dashboard.")

    uploaded_files = st.file_uploader("Upload multiple images", type=["jpg", "jpeg", "png"], accept_multiple_files=True)

    if uploaded_files:
        st.write(f"**{len(uploaded_files)} images selected**")

        if st.button("🔍 Analyze All Images", use_container_width=True):
            with st.spinner(f"Analyzing {len(uploaded_files)} images..."):
                files_payload = []
                for f in uploaded_files:
                    files_payload.append(("files", (f.name, f.getvalue(), "image/jpeg")))

                try:
                    response = requests.post(f"{API_URL}/predict-batch", files=files_payload)
                    if response.status_code == 200:
                        data = response.json()
                        results = data["results"]
                        df = pd.DataFrame(results)

                        st.success(f"✅ Analyzed {data['total']} images")

                        c1, c2, c3, c4 = st.columns(4)
                        c1.metric("Total Images", len(df))
                        c2.metric("Avg Confidence", f"{df['confidence'].mean():.1f}%")
                        c3.metric("Avg Health Score", f"{df['road_health_score'].mean():.0f}/100")
                        c4.metric("High Risk Count", int((df["risk_level"] == "High").sum()))

                        st.markdown("---")

                        gcol1, gcol2 = st.columns(2)

                        with gcol1:
                            st.subheader("Damage Type Distribution")
                            type_counts = df["damage_type"].value_counts().reset_index()
                            type_counts.columns = ["Damage Type", "Count"]
                            fig1 = px.pie(type_counts, names="Damage Type", values="Count",
                                          color="Damage Type", color_discrete_map=CLASS_COLORS, hole=0.4)
                            st.plotly_chart(fig1, use_container_width=True)

                        with gcol2:
                            st.subheader("Risk Level Breakdown")
                            risk_counts = df["risk_level"].value_counts().reset_index()
                            risk_counts.columns = ["Risk Level", "Count"]
                            fig2 = px.bar(risk_counts, x="Risk Level", y="Count", color="Risk Level",
                                          color_discrete_map={"High": "#e74c3c", "Medium": "#f39c12", "Low": "#2ecc71"})
                            st.plotly_chart(fig2, use_container_width=True)

                        st.subheader("Road Health Score by Image")
                        fig3 = px.bar(df, x="filename", y="road_health_score", color="risk_level",
                                      color_discrete_map={"High": "#e74c3c", "Medium": "#f39c12", "Low": "#2ecc71"},
                                      labels={"road_health_score": "Health Score", "filename": "Image"})
                        st.plotly_chart(fig3, use_container_width=True)

                        st.subheader("Detailed Results")
                        st.dataframe(df, use_container_width=True)

                        csv = df.to_csv(index=False).encode("utf-8")
                        st.download_button("⬇️ Download Report (CSV)", csv, "vianova_report.csv", "text/csv")

                    else:
                        st.error("Error processing batch request")
                except requests.exceptions.ConnectionError:
                    st.error("⚠️ Cannot connect to backend. Make sure FastAPI server is running.")

# ---------- ABOUT ----------
else:
    st.title("ℹ️ About ViaNova AI")
    st.write("""
    **ViaNova AI** is an intelligent road damage detection system built using
    Deep Learning (EfficientNetB0 Transfer Learning) trained on the RDD2022 dataset.

    **Technology Stack:**
    - AI Model: TensorFlow, Keras, EfficientNetB0
    - Backend: FastAPI
    - Frontend: Streamlit

    **Detected Damage Types:** Pothole, Alligator Crack, Longitudinal Crack, Transverse Crack, Repair/Other
    """)