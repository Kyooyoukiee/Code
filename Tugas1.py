class PH:
    def __init__(self, nama_mobil, mesin, warna, tahun_keluaran):
        self.nama_mobil = nama_mobil
        self.mesin = mesin
        self.warna = warna
        self.tahun_keluaran = tahun_keluaran

    def Deskripsi_Mobil(self):
        print(self.nama_mobil, "menggunakan mesin", self.mesin, "yang berwarna",
               self.warna, "dan tahun keluaran", self.tahun_keluaran)

mobil1 = PH("Pagani Huayra", "V12 Twin Turbo", "Putih", 2011)
mobil1.Deskripsi_Mobil()

class BB(PH):
    pass

mobil2 = BB("Bugatti Bolide", "W16 Quad Turbo", "Biru", 2020)
mobil2.Deskripsi_Mobil()




