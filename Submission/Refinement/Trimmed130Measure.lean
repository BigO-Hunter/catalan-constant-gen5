import Submission.Refinement.Trimmed130Scalars
import Submission.Refinement.EndpointBridge
import Submission.Refinement.Fallback5318833

/-!
# Arithmetic and verifier assembly for the trimmed degree-130 construction

This theorem isolates the remaining analytic input: the complete, eventual
determinant estimate with the exact rho and tDelta of Trimmed130Scalars.
The arithmetic normalizer, nonvanishing theorem and target bridge are explicit.
-/

namespace CatalanMeasure.GenD.Refinement.Trimmed130

open Filter Polynomial CatalanMeasure.Parametric OAI.InternalCatalan
open CatalanMeasure.GenD.Uniform.Arithmetic
open CatalanMeasure.GenD.Uniform.Bank540.Ledger
open CatalanMeasure.GenD.Uniform.Bank540.Ledger3
open CatalanMeasure.GenD.Uniform.Bank532

theorem denominatorExponent_eq : denominatorExponent = gDg gain532 := by
  rw [gain532_exact]
  rfl

theorem endpoint_of_decay
    (hdecay : ∀ ε : ℝ, 0 < ε → ∀ᶠ N : ℕ in atTop, ∀ x : ℝ,
      |x - catalan| ≤ Real.exp (-(rho * (N : ℝ))) →
        |aeval x (deltaPoly D58.Odd.design N)| ≤
          Real.exp (-((tDelta - ε) * (N : ℝ) ^ 2))) :
    ∀ᶠ b : ℕ in atTop, ∀ a : ℤ,
      (b : ℝ) ^ (-bound) < |catalan - (a : ℝ) / b| := by
  exact measure_of_design_real D58.Odd.design
    { B := bound
      Z := canonicalNormalizer design D58.Odd.design_admissible (famLB (fams532 hosts532)) 79
        (by rw [D58.Odd.design_H]; norm_num)
      w := omega
      ρ := rho
      η := eta
      κ := kappa
      δ := delta
      pay := by rw [D58.n0_sub_g0]; exact pay
      gD := denominatorExponent
      D_growth := fun ε hε => by
        rw [denominatorExponent_eq]
        filter_upwards [partial_growth532 hosts532 hε] with N hN
        unfold gDg
        convert hN using 2
      tΔ := tDelta
      delta_small := hdecay
      eta_le := decay_margin
      nonvanishing := D58.nonvanishing_d58 D58.C3.c3_d58 }

theorem verifier_bound_of_decay
    (hdecay : ∀ ε : ℝ, 0 < ε → ∀ᶠ N : ℕ in atTop, ∀ x : ℝ,
      |x - catalan| ≤ Real.exp (-(rho * (N : ℝ))) →
        |aeval x (deltaPoly D58.Odd.design N)| ≤
          Real.exp (-((tDelta - ε) * (N : ℝ) ^ 2))) :
    BigOSpeedrun.Catalan.Bound ((5282327 : ℚ) / 10000) := by
  apply CatalanMeasure.Refinement.bound_of_endpoint (by norm_num)
  simpa [BigOSpeedrun.Catalan.Endpoint, BigOSpeedrun.Catalan.constant,
    bound, catalan] using endpoint_of_decay hdecay

end CatalanMeasure.GenD.Refinement.Trimmed130

#print axioms CatalanMeasure.GenD.Refinement.Trimmed130.verifier_bound_of_decay
