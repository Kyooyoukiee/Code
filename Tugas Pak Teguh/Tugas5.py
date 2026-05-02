import matplotlib.pyplot as plt

hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu']
suhu = [30, 32, 31, 29, 28, 30, 33]

plt.plot(hari, suhu, marker='o')
plt.title("Data Suhu Harian")
plt.xlabel("Hari")
plt.ylabel("Suhu (°C) ")

plt.savefig("Tugas5.png")
plt.show()
