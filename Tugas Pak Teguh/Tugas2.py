import matplotlib.pyplot as plt

kategori = ['Makan', 'Transport', 'Game', 'Nabung']
pengeluaran = [40, 30, 20, 10]

plt.pie(pengeluaran, labels=kategori, autopct='%1.1f%%')
plt.title("Pengeluaran Uang Jajan")

plt.savefig("Tugas2.png")
plt.show()
