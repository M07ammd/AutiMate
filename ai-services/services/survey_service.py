import os
import pickle
import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
MODEL_PATH = os.path.join(BASE_DIR, 'models', 'random_forest_model.pkl')

model = None
if os.path.exists(MODEL_PATH):
    with open(MODEL_PATH, 'rb') as f:
        model = pickle.load(f)

encoders = {}
cat_cols = ['gender', 'ethnicity', 'jaundice', 'autism', 'Country_of_res', 'used_app_before', 'relation']
X_COLUMNS_ORDER = [
    'A1_Score','A2_Score','A3_Score','A4_Score','A5_Score',
    'A6_Score','A7_Score','A8_Score','A9_Score','A10_Score',
    'age', 'gender', 'ethnicity', 'jaundice', 'autism',
    'Country_of_res', 'used_app_before', 'result', 'relation'
]

def prepare_encoders():
    csv_path = os.path.join(BASE_DIR, 'data', 'Autism_data.csv')
    if not os.path.exists(csv_path):
        return
        
    data = pd.read_csv(csv_path)
    data = data[data['age'] != 'age']
    data['age'] = data['age'].apply(lambda x: int(float(x)) if pd.notna(x) else 0)
    data = data.rename(columns={'austim':'autism', 'contry_of_res':'Country_of_res'})
    data = data.drop(columns=['age_desc','ID'], errors='ignore')
    data['ethnicity'] = data['ethnicity'].replace('?', data['ethnicity'].mode()[0]).replace('others','Others')
    data['relation'] = data['relation'].replace('?', data['relation'].mode()[0])
    
    mapping = {'Viet Nam':'Vietnam', 'AmericanSamoa':'United States', 'Hong Kong': 'China'}
    data['Country_of_res'] = data['Country_of_res'].replace(mapping)
    
    categorical_columns = data.select_dtypes(include=['object']).columns
    for col in categorical_columns:
        le = LabelEncoder()
        le.fit(data[col])
        encoders[col] = le

prepare_encoders()

def safe_transform(le, value):
    try:
        return le.transform([value])[0]
    except:
        return 0

def predict_autism(data_dict: dict) -> dict:
    if model is None:
        raise Exception("Model not loaded")

    df = pd.DataFrame([data_dict])

    if 'ethnicity' in df.columns and df['ethnicity'].iloc[0] == "?":
        df['ethnicity'] = "White-European"
    if 'Country_of_res' in df.columns and df['Country_of_res'].iloc[0] == "Others":
        df['Country_of_res'] = "United States"
    if 'relation' in df.columns and df['relation'].iloc[0] == "?":
        df['relation'] = "Self"

    for col in cat_cols:
        if col in encoders and col in df.columns:
            df[col] = df[col].apply(lambda x: safe_transform(encoders[col], x))

    for col in X_COLUMNS_ORDER:
        if col not in df.columns:
            df[col] = 0
    df = df[X_COLUMNS_ORDER]

    prediction = int(model.predict(df)[0])
    proba = model.predict_proba(df)
    probability = float(np.max(proba)) * 100
    if np.isnan(probability):
        probability = 0.0

    return {
        "prediction": prediction,
        "probability": round(probability, 2)
    }
