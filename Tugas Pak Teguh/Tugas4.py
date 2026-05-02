import numpy as np
import matplotlib.pyplot as plt

nilai = np.random.randint(50, 100, 100)

plt.hist(nilai, bins=10, color='yellow', edgecolor='black')
plt.title("Sebaran Nilai Ujian")
plt.xlabel("Nilai")
plt.ylabel("Jumlah Siswa")

plt.savefig("Tugas4.png")
plt.show()
