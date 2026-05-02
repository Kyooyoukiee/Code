import pandas as pd 
from sklearn.linear_model import LinearRegression

csv_path = "Database/penjualan_harian.csv"
df = pd.read_csv(csv_path)

X = df[["Hari Ke"]]
Y = df["Jumlah Terjual"]

model = LinearRegression().fit(X, Y)

hari_baru = pd.DataFrame({"Hari Ke": [8]})
prediksi = model.predict(hari_baru)[0]

print("Koefisien:", model.coef_[0], "| Intercept:", model.intercept_)
print("Prediksi Jumlah Terjual Saat hari ke-8:", round(prediksi, 2))


