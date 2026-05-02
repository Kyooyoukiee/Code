print("Aditya Brata Tan - X PPLG A")
print("")
import pandas as pd
import numpy as np 

csv_path = "Database/siswa.csv"
df = pd.read_csv(csv_path)

df_bersih = df.drop_duplicates()
df_bersih["Nilai"] = df_bersih["Nilai"].fillna(0)
df_bersih = df_bersih.reset_index(drop=True)

rata_sebelum = df["Nilai"].dropna().mean()
rata_sesudah = df_bersih["Nilai"].mean()

print("Rata-rata sebelum pembersihan:", rata_sebelum)
print("Rata-rata setelah pembersihan:", rata_sesudah)
print("\nData bersih:")
print(df_bersih.to_string(index=True))


