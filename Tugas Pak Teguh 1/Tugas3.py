import random 

choices = ["Batu", "Gunting", "Kertas"]
pemain = input("Masukkan pilihan Anda (Batu, Gunting, Kertas): ")
if pemain not in choices:
    print("Pilihan tidak valid. Silakan pilih Batu, Gunting, atau Kertas.")
    exit()

komputer = random.choice(choices)

print("Pilihan komputer: ", komputer)
if pemain == komputer:
    print("Hasil: Seri!")
elif (pemain == "Batu" and komputer == "Gunting") or \
     (pemain == "Gunting" and komputer == "Kertas") or \
     (pemain == "Kertas" and komputer == "Batu"):
    print("Hasil: Anda Menang!")
else:
    print("Hasil: Komputer Menang!")
