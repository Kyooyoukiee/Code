class Mobil:
    def __init__(self, merk, kecepatan):
        self.merk = merk
        self.__kecepatan = kecepatan

    def get_kecepatan(self):
        return self.__kecepatan

    def set_kecepatan(self, kecepatan_baru):
        if kecepatan_baru >= 0 and kecepatan_baru <= 300:
            self.__kecepatan = kecepatan_baru
        else:
            print("Kecepatan tidak valid")
    
    def tampilkan_info(self):
        print(f"Merk: {self.merk}")
        print(f"Kecepatan: {self.__kecepatan} km/h")

mobil1 = Mobil("Toyota", 70)

print("Merk:", mobil1.merk)
print("Kecepatan Sekarang:", mobil1.get_kecepatan())
mobil1.set_kecepatan(80)
mobil1.tampilkan_info()


