import pandas as pd 
import matplotlib.pyplot as plt

ringkas = pd.Series({"Latte": 17, "Cappuccino": 8, "Espresso": 12})
ax = ringkas.plot(
    kind="bar",
    color=["#8B5E3C", "#C08A5B", "#5C4033"],
    edgecolor="black",
    title="Total Penjualan per Rasa",
)
ax.set_xlabel("Rasa Kopi")
ax.set_ylabel("Jumlah Terjual")
plt.xticks(rotation=360, ha="center")

plt.savefig("Tugas Pak Teguh 3/grafik_kopi.png", dpi=300)
plt.show()




