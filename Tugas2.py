class Elektronik:
    def __init__(self, merek, tipe):
        self.merek = merek
        self.tipe = tipe

    def info(self):
        return f"Merek {self.merek} | Tipe {self.tipe}"
    
class Smartphone(Elektronik):
    def __init__(self, merek, tipe, harga):
        super().__init__(merek, tipe)
        self.harga = harga

    def info(self):
        info = super().info()
        return f"{info} | Harga {self.harga}"
print("")
print("Masukkan informasi smartphone")
merek = input("Masukkan merek smartphone: ")
tipe = input("Masukkan tipe smartphone: ")
harga = input("Masukkan harga smartphone: ")

print("")
print("----------Hasil-----------")
smartphone1 = Smartphone(merek, tipe, harga)
print("Informasi Smartphone:")
print(smartphone1.info())



