print("Aditya Brata Tan - X PPLG A")
print("")
import pandas as pd 

csv_path = "Database/kopi.csv"
df = pd.read_csv(csv_path)

ringkas = df.groupby("Rasa Kopi")["Jumlah Terjual"].sum().reset_index()
ringkas = ringkas.sort_values("Jumlah Terjual")
kopi_terlaris = ringkas.loc[ringkas["Jumlah Terjual"].idxmax(), "Rasa Kopi"]

print("Ringkas Per Rasa:")
print(ringkas.to_string(index=True))
print("Rasa Kopi Terlaris:", kopi_terlaris)


