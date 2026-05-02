import matplotlib.pyplot as plt

bulan = ['Jan', 'Feb', 'Mar', 'Apr']
subs = [100, 200, 400, 600]

plt.plot(bulan, subs)

plt.title("Pertumbuhan Subscribers")
plt.xlabel("Bulan")
plt.ylabel("Jumlah Subscribers")

plt.savefig("Tugas1.png")
plt.show()
