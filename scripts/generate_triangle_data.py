#!/usr/bin/env python3
"""Derive the exact power-basis Lean data and triangle-circle certificate."""
import hashlib
import json
import math
from fractions import Fraction as Q
from pathlib import Path
from polynomial_circle_certificate import chebyshev_to_power, exp_lower

root = Path(__file__).resolve().parents[1]
raw = (root / 'certificates/inverse_image_trimmed_130.json').read_bytes()
assert hashlib.sha256(raw).hexdigest() == 'c580b0f301451825a345606b3a5664b16cc7b1148a07a3fce8330eb61d556f05'
data = json.loads(raw)
coefficients = chebyshev_to_power(list(map(Q, data['chebyshev_coefficients'])))
m, k, ell = 130, 14, 38
radius = Q(100000001, 10**8)
filtered = [Q(0)] * (len(coefficients) + k)
for i, coefficient in enumerate(coefficients):
    for j in range(k + 1):
        filtered[i + j] += coefficient * (-1)**j * math.comb(k, j)
norm = sum(abs(c) * radius**j for j, c in enumerate(filtered))
norm_cap = (norm.numerator + norm.denominator - 1) // norm.denominator
filter_cap = 16385
assert (radius + 1)**k <= filter_cap
circle_cap = Q('52.36555')
binary_exponent = 9821
log_two_upper = Q(693147180559945310, 10**18)
taylor_argument = m * circle_cap - binary_exponent * log_two_upper
assert 0 < taylor_argument < 1
finite_bound = (2 * norm_cap + filter_cap)**53 * (radius + 1)**ell
assert finite_bound < Q(2)**binary_exponent * exp_lower(taylor_argument, 16)
record = {
    'witness_sha256': hashlib.sha256(raw).hexdigest(), 'degree': m,
    'filter_degree': k, 'remaining_power': ell, 'radius': str(radius),
    'M': str(norm_cap), 'H': filter_cap, 'weight_cap': str(circle_cap),
    'binary_exponent': binary_exponent, 'taylor_argument': str(taylor_argument),
    'taylor_terms': 16,
}
(root / 'certificates/triangle_130.json').write_text(json.dumps(record, indent=2) + '\n')


def rational(c):
    return f'({c.numerator} : ℚ) / {c.denominator}'


def declaration(name, values):
    return 'def ' + name + ' : List ℚ := [\n  ' + ',\n  '.join(map(rational, values)) + '\n]\n'


source = '''module

public import Submission.Refinement.PolynomialNorm

@[expose] public section

/-! Exact rational power coefficients converted from the published degree-130 witness.
The conversion is recorded by scripts/generate_triangle_data.py. -/

namespace CatalanMeasure.Refinement.Trimmed130

open Polynomial

'''
source += declaration('powerCoefficients', coefficients) + '\n'
source += declaration('filteredCoefficients', filtered)
source += '''
noncomputable def rationalP : ℚ[X] := polynomialFromCoeffs powerCoefficients
noncomputable def rationalQ : ℚ[X] := polynomialFromCoeffs filteredCoefficients
noncomputable def realP : ℝ[X] := rationalP.map (algebraMap ℚ ℝ)
def radius : ℚ := 100000001 / 100000000
'''
source += f'def normCap : ℚ := {norm_cap}\n'
source += '''def filterCap : ℚ := 16385
def circleCap : ℚ := 1047311 / 20000

end CatalanMeasure.Refinement.Trimmed130
'''
(root / 'Submission/Refinement/Trimmed130Data.lean').write_text(source)
print('Generated exact degree-130 power coefficients and triangle-circle data.')
