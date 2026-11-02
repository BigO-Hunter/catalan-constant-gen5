# The P-generator: how the degree-130 polynomial was found

The verifier's derivation report shows this repository changes eight Lean
data files against [direct-issue-87](https://github.com/bigospeedrun/verifier/issues/87)
— every one of them a transcription of the polynomial $P$ and its
certificate artifacts. This note documents how $P$ was produced. The
construction is the new contribution; the certification is entirely
upstream's, and the two are deliberately separable.

## The division of labor

Upstream's scripts are **certifiers, not searchers**: `verify_130.py`,
`root_tangent_certificate.py`, and the Lean `decide +kernel` gates check a
candidate $P$ in exact rational arithmetic, but nothing in the chain
*proposes* one. The upstream $P$ was tuned by hand downstream of a fixed
construction. The gap this work fills is the search layer: propose
candidates until the certifier accepts one that beats the incumbent.

## What P must satisfy

The inverse-image argument needs a rational degree-130 polynomial $P$ that:

1. **Oscillates across both support bands** — sign alternation at 132
   control points (62 left, 70 right), which yields exactly 130 real roots
   and the 61 + 69 inverse-branch structure;
2. **Stays above 1 in absolute value** across the bands, so every level
   $P(t) = y$, $y \in [-1,1]$, has the required simple real solutions; and
3. **Minimizes the circle-certificate weight** $w$ — the tangent bound
   $(2|P(z)|+1)^{53}|1-z|^{780} \le e^{130w}$ at radius $1+10^{-8}$. The
   incumbent carried $w = 52.184351$; the landed certificate carries
   $w = 52.184216$, and that $1.35 \times 10^{-4}$ flows through
   $\rho = 58c_2 + w$ directly into the exponent.

## The construction

A two-band **Zolotarev-type interpolation**:

- **Per-band alternating amplitude targets.** Each band gets a constant
  amplitude target with alternating sign across its control points —
  left band $\approx 1.0068$ starting $+$, right band $\approx 1.0016$
  starting $-$ (the phases are opposite). Interpolating
  $P(\text{control}_i) = \pm A_{\text{band}}$ at 131 points fixes $P$
  (degree $\le 130$) uniquely. Zolotarev's classical insight — the
  minimax rational approximant equioscillates with *constant* per-band
  amplitude — is what makes constant targets the natural search
  coordinate: near-equal ripple falls out of the interpolation for free.
- **Exact solve at high precision.** The 131-point system is solved at
  60-digit precision; the resulting coefficients are snapped to exact
  rationals and everything downstream is exact. (Floats are unsound
  here: the coefficient cancellation at these amplitudes is 15 digits
  deep.)
- **One freed parameter, steered by measurement.** Breaking the
  constant-amplitude symmetry — freeing the left band's amplitude alone
  and moving it by the measured sensitivity of the certificate weight
  $\partial w / \partial A_L$ (order $10^2$ at the optimum) — descends
  the certificate directly. The landed $P$ has the left amplitude at
  $+1.008$.

## What certifies it

Every claim above is checked, none is trusted:

- the 132 control points alternate in sign under **exact rational
  evaluation** of the snapped $P$;
- the 130 root brackets (61 + 69) are isolated and sign-checked exactly;
- the tangent-circle caps ($w = 52.184216$, binary exponent 19574,
  minimum-norm $10^{10}$) are recomputed by upstream's
  `root_tangent_certificate.py` with its asserts intact;
- the full Lean build (4990 jobs) passes with
  `Race.bound` depending only on `propext`, `Classical.choice`,
  `Quot.sound`; and
- the official verifier has posted **Lean Verified** for commit
  `e6e7bf6` (run 41356905042, 2026-11-02).

## What is not in this note

The automated steering loop — the iteration schedule, convergence
heuristics, and tuning constants that walk the amplitude parameters — is
not published at this time. It is engineering, not mathematics: the
construction above plus any numerical optimizer will find candidates in
this family. We keep the loop private while the speedrun is active.

## Attribution

The certificate chain that accepts or rejects every candidate — the
design $(58,9,3,5,3)$, determinant machinery, trial, trimmed support,
residual certificate, near-field argument, scalar gates, CellCert engine,
and Lean assembly — is upstream (OpenAI's irrationality argument;
S. Litsey; Cinna Davis) and is used unchanged. New here: the search
layer and the polynomial it found.
