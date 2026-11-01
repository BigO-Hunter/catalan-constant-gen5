#!/usr/bin/env python3
"""Three exact circle bounds using tangents to a product of affine factors.

All roots are enclosed by exact rational sign checks. Their squared distances
are bounded by positive affine functions of Re(z). The inequality 1+t<=exp(t)
gives a global tangent bound for their product, with a rational slope.
"""
from decimal import Decimal, localcontext, ROUND_FLOOR
from fractions import Fraction as Q
import hashlib
import json
import math
from pathlib import Path
from polynomial_circle_certificate import chebyshev_to_power, exp_lower
from root_circle_certificate import root_brackets

root = Path(__file__).resolve().parents[1]
witness = root / 'certificates/inverse_image_trimmed_130.json'
raw = witness.read_bytes()
data = json.loads(raw)
coefficients = chebyshev_to_power(list(map(Q, data['chebyshev_coefficients'])))
intervals = root_brackets(data, coefficients)
r = Q(100000001, 10**8)
lc = coefficients[-1]
factors = [(r*r + a*a + 2*(b-a)*(r+1), -2*a) for a,b in intervals]
assert all(A+B*(-r)>0 and A+B*r>0 for A,B in factors)


def D(x):
    return r*r + 1 - 2*x


def slope(x):
    return 53*sum((B/(A+B*x) for A,B in factors),Q(0)) - 1560/D(x)


def base(x):
    p = lc*lc
    for A,B in factors:
        p *= A+B*x
    return p


with localcontext() as ctx:
    ctx.prec = 100
    dec = lambda x: Decimal(x.numerator)/Decimal(x.denominator)
    fs = [(dec(A),dec(B)) for A,B in factors]
    rd = dec(r)
    def dslope(x):
        return 53*sum((B/(A+B*x) for A,B in fs),Decimal(0))-1560/(rd*rd+1-2*x)
    lo,hi=Decimal('-.75'),Decimal('.75')
    assert dslope(lo)>0 and dslope(hi)<0
    for _ in range(100):
        mid=(lo+hi)/2
        if dslope(mid)>0:lo=mid
        else:hi=mid
    centre=Q(int((mid*10**20).to_integral_value(rounding=ROUND_FLOOR)),10**20)

epsilon=Q(1,10**10)
assert abs(slope(centre))*2*r<epsilon
assert slope(Q(-3,4))>0 and slope(Q(3,4))<0
minimum_norm=10**10
assert lc*lc*(r*r-Q(9,16))**130 > minimum_norm**2
wc=Q('52.184216');exponent=260*wc
loghi=Q(693147180559945310,10**18)


def exp_certificate(bound, x):
    j=int(float(x)/math.log(2))
    t=x-j*loghi
    assert 0<=t<1
    assert bound < Q(2)**j*exp_lower(t,16)
    return {'exponent':str(x),'binary_exponent':j,'taylor_argument':str(t),'taylor_terms':16}


points=[]
for label,x in [('centre',centre),('left',Q(-3,4)),('right',Q(3,4))]:
    value=base(x)
    cap=(value.numerator+value.denominator-1)//value.denominator
    assert value<=cap
    if label=='centre':
        bound=(2+Q(1,minimum_norm))**106*Q(cap)**53*D(x)**780
        e=exp_certificate(bound,exponent-epsilon)
    else:
        bound=Q(3)**106*(Q(cap)**53*D(x)**780+(r+1)**1560)
        e=exp_certificate(bound,exponent)
    points.append({'label':label,'x':str(x),'squared_norm_cap':str(cap),'exp_certificate':e})

record={'format':'catalan-root-tangent-circle-v1',
    'witness_sha256':hashlib.sha256(raw).hexdigest(),'degree':130,'radius':str(r),
    'weight_cap':str(wc),'root_intervals':[[str(a),str(b)] for a,b in intervals],
    'central_halfwidth':'3/4','central_minimum_norm':str(minimum_norm),
    'slope_allowance':str(epsilon),'points':points}
(root/'certificates/root_tangent_130.json').write_text(json.dumps(record,indent=2)+'\n')
print(json.dumps({k:v for k,v in record.items() if k!='root_intervals'},indent=2))
