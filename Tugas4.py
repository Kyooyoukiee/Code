class Tiket_Bus:
    def __init__(self, nama_penumpang, tujuan, harga):
        self.nama_penumpang = nama_penumpang
        self.tujuan = tujuan
        self.harga = harga

    def tampilkan_info(self):
        print(f"Nama Penumpang: {self.nama_penumpang}")
        print(f"Tujuan: {self.tujuan}")
        print(f"Harga: {self.harga}")

class Kasir(Tiket_Bus):
    def __init__(self, nama_penumpang, tujuan, harga):
        super().__init__(nama_penumpang, tujuan, harga)
        self.total = 0

    def beli_tiket(self, jumlah):
        harga_total = self.harga * jumlah
        self.total = harga_total
        print(f"Beli {jumlah} tiket untuk {self.nama_penumpang}")
        print(f"Total: Rp{self.total}")

tiket1 = Kasir("Andi", "Jakarta", 50000)
tiket2 = Kasir("Budi", "Bandung", 40000)

print("")
print("KASIR TIKET BUS")
print("1. Tiket 1:")
tiket1.tampilkan_info()
print("\n2. Tiket 2:")
tiket2.tampilkan_info()

print("\n3. Beli Tiket:")
tiket1.beli_tiket(2)
tiket2.beli_tiket(3)

print("\n SELESAI")





