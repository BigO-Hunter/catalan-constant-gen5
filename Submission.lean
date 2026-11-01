import Submission.CatalanStatement
import Submission.Refinement.Trimmed130Measure
import Submission.Improvement.Trimmed130Decay

/-!
# Catalan irrationality-exponent bound 528.2327

This entrypoint uses the unchanged Big O Speedrun target definition. The
determinant estimate and the arithmetic normalization are proved in the imported
modules. Every finite numerical certificate is checked by the Lean kernel.
-/

namespace Race

theorem bound : BigOSpeedrun.Catalan.Bound ((5282327 : ℚ) / 10000) :=
  CatalanMeasure.GenD.Refinement.Trimmed130.verifier_bound_of_decay
    CatalanMeasure.GenD.Refinement.Trimmed130.delta_small

end Race

#print axioms Race.bound
