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

def centre : ℚ := -3583875397597853387/25000000000000000000
def halfWidth : ℚ := 3 / 4
def epsilon : ℚ := 1 / 10000000000
def minimumNorm : ℚ := 10000000000
def sharpWeightCap : ℚ := 13045891/250000

def centreCap : ℚ :=
  1943490794275642356067842021681015162848877481832832385685026935763091101380721302943483659191879926136919
def leftCap : ℚ :=
  99290113467379854424174062477883732587597509502737966990578140735280464484475979693839693
def rightCap : ℚ :=
  9819443199989211261344008965078068417896842309318766260934878536787728250771829892296663

def centreBound : ℚ :=
  (2 + 1 / minimumNorm) ^ 106 * centreCap ^ 53 * circleDistanceRat centre ^ 780
def leftBound : ℚ :=
  3 ^ 106 * (leftCap ^ 53 * circleDistanceRat (-halfWidth) ^ 780 + (radius + 1) ^ 1560)
def rightBound : ℚ :=
  3 ^ 106 * (rightCap ^ 53 * circleDistanceRat halfWidth ^ 780 + (radius + 1) ^ 1560)

def binaryExponent : ℕ := 19574
def centralTaylorArgument : ℚ := 637277/10000000
def outerTaylorArgument : ℚ := 637277/10000000

theorem circleDistance_cast (x : ℚ) :
    (circleDistanceRat x : ℝ) = circleDistance (x : ℝ) := by
  simp [circleDistanceRat, circleDistance]

theorem base_cast (x : ℚ) : (baseRat x : ℝ) = base (x : ℝ) := by
  simp [baseRat, base, affineProduct_cast]

theorem slope_cast (x : ℚ) : (slopeRat x : ℝ) = slope (x : ℝ) := by
  simp [slopeRat, slope, affineSlope_cast, circleDistance_cast]

end CatalanMeasure.Refinement.Trimmed130.Sharp
