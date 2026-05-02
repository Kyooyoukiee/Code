class Siswa:
    def __init__(self, nama, kelas, mapel, nilai=0):
        self.nama = nama
        self.kelas = kelas
        self.mapel = mapel
        self.__nilai = nilai

    def get_nilai(self):
        return self.__nilai
    
    def set_nilai(self, nilai):
        self.__nilai = nilai
        if 0 <= nilai <= 100:
            return
        
    def info_profil(self):
        print(f"Nama: {self.nama}")
        print(f"Kelas: {self.kelas}")
        print(f"Mapel: {self.mapel}")
        print(f"Nilai: {self.get_nilai()}")

    def info_status(self):
        if self.get_nilai() < 1 or self.get_nilai() > 100:
            return "Nilai tidak valid, masukkan nilai antara 0 sampai 100"
        elif self.get_nilai() >= 80:
            return "Tuntas"
        else:
            return "Remedial"

siswa1 = Siswa("Andi", "10A", "Matematika")
siswa2 = Siswa("Budi", "10B", "Bahasa Indonesia", 70)
siswa3 = Siswa("Denis", "10C", "IPA")

print("Informasi siswa yang tuntas:")
siswa1.set_nilai(85)
siswa1.info_profil()
print("Status:", siswa1.info_status())
print("")

print("Informasi siswa yang remedial:")
siswa2.info_profil()
print("Status:", siswa2.info_status())
print("---------------------------------")
print("Informasi nilai sesudah remedial:")
siswa2.set_nilai(80)
siswa2.info_profil()
print("")

print("Informasi siswa yang tidak valid:")
siswa3.set_nilai(110)
siswa3.info_profil()
print("Status:", siswa3.info_status())


