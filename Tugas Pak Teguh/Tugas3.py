import matplotlib.pyplot as plt

hari = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat']
hadir = [30, 32, 28, 29, 25]

plt.bar (hari, hadir, color='skyblue')
plt.title("Kehadiran Siswa per Hari")
plt.xlabel("Hari")
plt.ylabel("Jumlah Hadir")

plt.savefig("Tugas3.png")
plt.show()
