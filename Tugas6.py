class Laptop:
    def __init__(self, merk, ukuran_layar, prosesor, baterai):
        self.merk = merk
        self.__ukuran_layar = ukuran_layar
        self.prosesor = prosesor
        self.__baterai = baterai

    def get_ukuran_layar(self):
        return self.__ukuran_layar

    def get_baterai(self):
        return self.__baterai

    def cek_status_baterai(self):
        if self.__baterai < 20:
            return "Baterai lemah"
        elif self.__baterai >= 20 and self.__baterai <= 50:
            return "Baterai sedang"
        elif self.__baterai > 50:
            return "Baterai penuh"
        else:
            return "Baterai tidak valid"

    def info_laptop(self):
        print("Informasi Laptop")
        print("---------------------------------------------------------------------")
        print(f"Merk: {self.merk}")
        print(f"Ukuran Layar: {self.get_ukuran_layar()}")
        print(f"Prosesor: {self.prosesor}")
        print(f"Baterai: {self.get_baterai()}%")
        print(f"Status Baterai: {self.cek_status_baterai()}")

laptop1 = Laptop("Asus", "14 inci", "Core i5", 90)
laptop1.info_laptop()







