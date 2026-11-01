module

public import Submission.Refinement.Trimmed130ZeroData
public import Submission.Refinement.Trimmed130Degree
public import Submission.Refinement.AffineProduct

@[expose] public section

/-! Exact data for the three-tangent circle certificate. -/

namespace CatalanMeasure.Refinement.Trimmed130.Sharp

def distanceFactors : List (ℚ × ℚ) := zeroBrackets.map fun ab =>
  (radius ^ 2 + ab.1 ^ 2 + 2 * (ab.2 - ab.1) * (radius + 1), -2 * ab.1)

def circleDistanceRat (x : ℚ) : ℚ := radius ^ 2 + 1 - 2 * x
def baseRat (x : ℚ) : ℚ := leadingCoefficient ^ 2 * affineProductRat distanceFactors x
def slopeRat (x : ℚ) : ℚ := 53 * affineSlopeRat distanceFactors x - 1560 / circleDistanceRat x

noncomputable def circleDistance (x : ℝ) : ℝ := (radius : ℝ) ^ 2 + 1 - 2 * x
noncomputable def base (x : ℝ) : ℝ := (leadingCoefficient : ℝ) ^ 2 * affineProduct distanceFactors x
noncomputable def slope (x : ℝ) : ℝ := 53 * affineSlope distanceFactors x - 1560 / circleDistance x
noncomputable def weightedBase (x : ℝ) : ℝ := base x ^ 53 * circleDistance x ^ 780

def centre : ℚ := -14335156893077131701 / 100000000000000000000
def halfWidth : ℚ := 3 / 4
def epsilon : ℚ := 1 / 10000000000
def minimumNorm : ℚ := 10000000000
def sharpWeightCap : ℚ := 52184216 / 1000000

def centreCap : ℚ :=
  1950682588315710423258022523926588605270356514442907705201729933422259702467986548689714645096571086832887
def leftCap : ℚ :=
  99616124253283501260043429253687753234812178477563730880150757111507479595699840783169570
def rightCap : ℚ :=
  9860959229725021255713147221508649688964417498368415025224991887473221767167108838621354

def centreBound : ℚ :=
  (2 + 1 / minimumNorm) ^ 106 * centreCap ^ 53 * circleDistanceRat centre ^ 780
def leftBound : ℚ :=
  3 ^ 106 * (leftCap ^ 53 * circleDistanceRat (-halfWidth) ^ 780 + (radius + 1) ^ 1560)
def rightBound : ℚ :=
  3 ^ 106 * (rightCap ^ 53 * circleDistanceRat halfWidth ^ 780 + (radius + 1) ^ 1560)

def binaryExponent : ℕ := 19574
def centralTaylorArgument : ℚ := 13404385976525103 / 50000000000000000
def outerTaylorArgument : ℚ := 13404385981525103 / 50000000000000000

theorem circleDistance_cast (x : ℚ) :
    (circleDistanceRat x : ℝ) = circleDistance (x : ℝ) := by
  simp [circleDistanceRat, circleDistance]

theorem base_cast (x : ℚ) : (baseRat x : ℝ) = base (x : ℝ) := by
  simp [baseRat, base, affineProduct_cast]

theorem slope_cast (x : ℚ) : (slopeRat x : ℝ) = slope (x : ℝ) := by
  simp [slopeRat, slope, affineSlope_cast, circleDistance_cast]

end CatalanMeasure.Refinement.Trimmed130.Sharp
