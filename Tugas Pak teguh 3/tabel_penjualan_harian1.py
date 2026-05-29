import numpy as np
import pandas as pd
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

csv_path = "Database/penjualan_harian.csv"
df = pd.read_csv(csv_path)

X = df[["Hari Ke"]].values.astype("float32")
y = df["Jumlah Terjual"].values.astype("float32")

model = Sequential([Dense(1, input_shape=(1,))])
model.compile(optimizer="adam", loss="mse")
model.fit(X, y, epochs=200, verbose=0)

pred_8_nn = model.predict(np.array([[8.0]], dtype="float32"), verbose=0)[0][0]

print("Prediksi (Keras) hari_ke=8:", round(float(pred_8_nn), 2))


