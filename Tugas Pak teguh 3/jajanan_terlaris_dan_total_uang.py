import pandas as pd

csv = "Database/jajanan.csv"
df = pd.read_csv(csv)

df["Total Uang"] = df["Harga"] * df["Jumlah Terjual"]
top = df.loc[df["Total Uang"].idxmax()]

print(df)
print("\nJajanan total uang terbesar:")
print(f"{'Nama Jajanan':<15}: {top['Nama Jajanan']}")
print(f"{'Harga':<15}: {(top['Harga'])}")
print(f"{'Jumlah Terjual':<15}: {(top['Jumlah Terjual'])}")
print(f"{'Total Uang':<15}: {(top['Total Uang'])}")


