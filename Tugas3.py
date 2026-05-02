class Barang:
    def __init__(self, nama, harga):
        self.nama = nama
        self.harga = harga
        self.stok = 10

    def info(self):
        print(f"{self.nama} - Rp{self.harga}")

class Kasir(Barang):
    def __init__(self, nama, harga):
        super().__init__(nama, harga)
        self.total = 0

    def beli(self, jumlah):
        harga_total = self.harga * jumlah
        self.total = harga_total
        print(f"Beli {jumlah} {self.nama}")
        print(f"Total: Rp{self.total}")

    def info(self):
        super().info()
        print(f"Total Belanja: Rp{self.total}")

mie = Kasir("Mie Goreng", 15000)
roti = Kasir("Roti Tawar", 5000)

print("KASIR SEDERHANA")
print("1. Mie Goreng")
mie.info()

print("\n2. Beli:")
mie.beli(2)

print("\n3. Roti Tawar:")
roti.info()
roti.beli(3)

print("\n SELESAI")



