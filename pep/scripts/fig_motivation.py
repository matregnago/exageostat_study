"""Fig. 8 of Nesi et al. (IPDPS'22), quantified: simulated iteration time per (gen, fact).
Each pair has a single simulated value, repeated over its 30 rows; the mean only collapses them.
Usage: python3 fig_motivation.py <csv.gz> <out.pdf>"""
import sys, gzip, csv, collections
import numpy as np, matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

src, out = sys.argv[1], sys.argv[2]
d = collections.defaultdict(list)
for r in csv.DictReader(gzip.open(src, "rt")):
    d[(int(r["gen"]), int(r["fact"]))].append(float(r["all_time"]))
m = {k: np.mean(v) for k, v in d.items()}
n = np.arange(2, 24)
Z = np.array([[m.get((g, f), np.nan) for f in n] for g in n])
Z = np.ma.masked_invalid(Z)
best = Z.min()

ramp = ["#cde2fb", "#9ec5f4", "#6da7ec", "#3987e5", "#256abf", "#184f95", "#0d366b"]
cmap = LinearSegmentedColormap.from_list("seq", ramp)
vmax = 45  # saturate so that the valley is readable

plt.rcParams.update({"font.size": 9, "font.family": "serif"})
fig, ax = plt.subplots(figsize=(5.6, 4.2))
im = ax.pcolormesh(n, n, Z, cmap=cmap, vmin=best, vmax=vmax, shading="nearest",
                   edgecolors="white", linewidth=0.3)
# cells within 1% of the best (orange outline)
for i, g in enumerate(n):
    for j, f in enumerate(n):
        if Z[i, j] <= 1.01 * best:
            ax.add_patch(plt.Rectangle((f - .5, g - .5), 1, 1, fill=False,
                                       ec="#f28e2b", lw=1.2))
pts = [((23, 23), "All nodes (41.1 s)", (17.5, 15.5)),
       ((23, 9), "Best 1D, gen = 23 (33.9 s)", (13, 11.5)),
       ((10, 8), "Best 2D (32.8 s)", (13, 7)),
       ((8, 8), "Best rigid (33.3 s)", (13, 3.5))]
for (g, f), lab, (tx, ty) in pts:
    ax.plot(f, g, "o", ms=5, mfc="white", mec="black", mew=1)
    ax.annotate(lab, (f, g), (tx, ty), ha="left", va="center", fontsize=8,
                arrowprops=dict(arrowstyle="-", lw=0.6, color="black"),
                bbox=dict(boxstyle="round,pad=0.2", fc="white", ec="none", alpha=0.85))
ax.set_xlabel("Number of factorization nodes")
ax.set_ylabel("Number of generation nodes")
ax.set_xticks(range(2, 24, 2)); ax.set_yticks(range(2, 24, 2))
ax.set_aspect("equal")
cb = fig.colorbar(im, ax=ax, extend="max", fraction=0.046, pad=0.03)
cb.set_label("Simulated iteration time (s)")
cb.outline.set_visible(False)
for s in ax.spines.values(): s.set_visible(False)
fig.tight_layout()
fig.savefig(out, bbox_inches="tight")
