import numpy as np
import pandas as pd
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense

df = pd.DataFrame({"hari_ke": [1,2,3,4,5], "jumlah_terjual": [8,10,12,14,16]})

X = df[["hari_ke"]].values.astype("float32")
y = df["jumlah_terjual"].values.astype("float32")

model = Sequential([Dense(1, input_shape=(1,))])
model.compile(optimizer="adam", loss="mse")
model.fit(X, y, epochs=200, verbose=0)

pred_8_nn = model.predict(np.array([[8.0]], dtype="float32"), verbose=0)[0][0]

print("Prediksi (Keras) hari_ke=8:", round(float(pred_8_nn), 2))


