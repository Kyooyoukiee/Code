class Siswa: 
    def __init__(self, nama, nis, kelas):
        self.__nama = nama
        self.__nis = nis
        self.__kelas = kelas

    def get_nama(self):
        return self.__nama
    
    def get_nis(self):
        return self.__nis
    
    def get_kelas(self):
        return self.__kelas
    
class Pendaftaran(Siswa):
    def __init__(self,nama, nis, kelas, tanggal, bulan, tahun, biaya):
        super().__init__(nama, nis, kelas)
        self.__tanggal = tanggal
        self.__bulan = bulan
        self.__tahun = tahun
        self.__biaya = biaya

    def get_tanggal(self):
        return self.__tanggal

    def get_bulan(self):
        return self.__bulan

    def get_tahun(self):
        return self.__tahun

    def get_biaya(self):
        return self.__biaya

    def tampilkan_data(self):
        print("Nama Siswa:", self.get_nama())
        print("NIS:", self.get_nis())
        print("Kelas:", self.get_kelas())
        print("Tanggal Pendaftaran:", f"{self.get_tanggal()}/{self.get_bulan()}/{self.get_tahun()}")
        print("Biaya Pendaftaran:", self.get_biaya())

print("=== Pendaftaran Siswa Baru ===")

while True:
    nama = input("Nama Siswa: ")
    if nama.strip():
        break
    print("Nama tidak boleh kosong.")

while True:
    nis = input("NIS: ")
    if nis.strip():
        break
    print("NIS tidak boleh kosong.")

while True:
    tanggal = input("Tanggal Pendaftaran (DD): ")
    if tanggal.isdigit() and 1 <= int(tanggal) <= 31:
        tanggal = tanggal.zfill(2)
        break
    print("Masukkan tanggal antara 1 sampai 31.")

while True:
    bulan = input("Bulan Pendaftaran (MM): ")
    if bulan.isdigit() and 1 <= int(bulan) <= 12:
        bulan = bulan.zfill(2)
        break
    print("Masukkan bulan antara 1 sampai 12.")

while True:
    tahun = input("Tahun Pendaftaran (YYYY): ")
    if tahun.isdigit() and len(tahun) == 4:
        break
    print("Masukkan tahun dengan 4 digit.")

while True:
    print()
    print("Pilih kelas pendaftaran:")
    print("1. Regular")
    print("2. Olimpiade")
    jenis = input("Masukkan pilihan kelas (1/2): ")

    if jenis == "1":
        kelas = "Regular"
        biaya = "Rp.100.000"
        break
    elif jenis == "2":
        kelas = "Olimpiade"
        biaya = "Rp.150.000"
        break
    else:
        print("Pilihan tidak valid! Silakan masukkan 1 atau 2.")

pendaftaran = Pendaftaran(nama, nis, kelas, tanggal, bulan, tahun, biaya)

print("\n=== Detail Data Pendaftaran Siswa ===")
pendaftaran.tampilkan_data()
