Berat_Kg = float(input("Masukkan berat badan: "))
Tinggi_M = float(input("Masukkan tinggi badan: "))

BMI = Berat_Kg / (Tinggi_M * Tinggi_M)

if BMI < 18.5:
    kategori = "Kurus"
elif BMI < 25:
    kategori = "Normal"
else:
    kategori = "Gemuk"

print("BMI: ", BMI)
print("Kategori: ", kategori)

