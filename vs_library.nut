//-----------------------------------------------------------------------
//------------------- Copyright (c) samisalreadytaken -------------------
//                       github.com/samisalreadytaken
//-----------------------------------------------------------------------
local VERSION = "2.43.27",
    ROOT = ::getroottable(), CONST = ::getconsttable();
delete CONST.DEG2RADDIV2;
delete CONST.RAD2DEG2;
delete CONST.PI2;
delete CONST.PIDIV2;
delete CONST.FLT_MAX_N;
if ("VS" in ROOT) {
    local gVS = ::VS;
    if (typeof gVS == "table") {
        if (gVS.version == VERSION) {
            if (!(0 in gVS)) gVS[0] <- 0;
            if ((gVS[0] & 0x3E) == 0x3E) return
        }
    }
} else::VS <-{};;
local VS = {
    [0] = 0x3E,
    version = VERSION
}
if (::print.getinfos().native && !::Msg.getinfos().native)::Msg <-::print;;
if (::EntFireByHandle.getinfos().native)::DoEntFireByInstanceHandle <-::EntFireByHandle;;
local AddEvent = ::DoEntFireByInstanceHandle, Fmt = ::format, TI = ::FrameTime();
local PORTAL2 = "CPortal_Player" in ROOT && "TurnOnPotatos" in ::CPortal_Player && ::CPortal_Player.TurnOnPotatos.getinfos().native;
if (TI == 0.0) TI = 1.0 / (PORTAL2 ? 30.0 : 64.0);;
if (!PORTAL2) VS.Entities <-Entities;; {
    const FLT_EPSILON = 1.192092896e-7;;
    const FLT_MAX = 3.402823466e+38;;
    const FLT_MIN = 1.175494351e-38;;
    const INT_MAX = 0x7FFFFFFF;;
    const INT_MIN = 0x80000000;;
    const DEG2RAD = 0.017453293;;
    const RAD2DEG = 57.295779513;;
    const PI = 3.141592654;;
    const RAND_MAX = 0x7FFF;;
    const MAX_COORD_FLOAT = 16384.0;;
    const MAX_TRACE_LENGTH = 56755.840862417;;::CONST <-getconsttable();::DEG2RAD <-DEG2RAD;::RAD2DEG <-RAD2DEG;::MAX_COORD_FLOAT <-MAX_COORD_FLOAT;::MAX_TRACE_LENGTH <-MAX_TRACE_LENGTH;
    const DEG2RADDIV2 = 0.008726646;;
    const RAD2DEG2 = 114.591559026;;
    const PI2 = 6.283185307;;
    const PIDIV2 = 1.570796327;;
    const FLT_MAX_N = -3.402823466e+38;;
    local sin = sin, cos = cos, tan = tan, asin = asin, acos = acos, atan = atan, atan2 = atan2, sqrt = sqrt, rand = rand, pow = pow, log = log, exp = exp, array = array, RandomFloat = RandomFloat, Vector = Vector;
    local Quaternion = class {
        x = 0.0;
        y = 0.0;
        z = 0.0;
        w = 0.0;
        constructor(_x = 0.0, _y = 0.0, _z = 0.0, _w = 0.0) {
            x = _x;
            y = _y;
            z = _z;
            w = _w
        }

        function IsValid() {
            return (x > FLT_MAX_N && x < FLT_MAX) && (y > FLT_MAX_N && y < FLT_MAX) && (z > FLT_MAX_N && z < FLT_MAX) && (w > FLT_MAX_N && w < FLT_MAX)
        }

        function _get(i) {
            switch (i) {
                case 0:
                    return x;
                case 1:
                    return y;
                case 2:
                    return z;
                case 3:
                    return w
            }
            return rawget(i)
        }

        function _set(i, v) {
            switch (i) {
                case 0:
                    return x = v;
                case 1:
                    return y = v;
                case 2:
                    return z = v;
                case 3:
                    return w = v
            }
            return rawset(i, v)
        }

        function _typeof() {
            return "Quaternion"
        }

        function _tostring(): (Fmt) {
            return Fmt("Quaternion(%.6g, %.6g, %.6g, %.6g)", x, y, z, w)
        }
    }
    Quaternion._add <- function(v): (Quaternion) {
        return Quaternion(x + v.x, y + v.y, z + v.z, w + v.w)
    }
    Quaternion._sub <- function(v): (Quaternion) {
        return Quaternion(x - v.x, y - v.y, z - v.z, w - v.w)
    }
    Quaternion._mul <- function(v): (Quaternion) {
        return Quaternion(x * v, y * v, z * v, w * v)
    }
    Quaternion._div <- function(v): (Quaternion) {
        local f = 1.0 / v;
        return Quaternion(x * f, y * f, z * f, w * f)
    }
    Quaternion._unm <- function(): (Quaternion) {
        return Quaternion(-x, -y, -z, -w)
    }
    local CArrayOpMan; {
        local CArrayOpManSub = class {
            [0x7E] = 0;
            [0x7F] = null;
            constructor(p) {
                this[0x7F] = p
            }

            function _get(i) {
                return this[0x7F][this[0x7E] + i]
            }

            function _set(i, v) {
                this[0x7F][this[0x7E] + i] = v
            }
        };
        CArrayOpMan = class {
            [0x7F] = null;
            constructor(p): (CArrayOpManSub) {
                this[0x7F] = CArrayOpManSub(p)
            }

            function _get(i) {
                local _ = this[0x7F];
                _[0x7E] = 4 * i;
                return _
            }
        }
        const M_00 = 0;;
        const M_01 = 1;;
        const M_02 = 2;;
        const M_03 = 3;;
        const M_10 = 4;;
        const M_11 = 5;;
        const M_12 = 6;;
        const M_13 = 7;;
        const M_20 = 8;;
        const M_21 = 9;;
        const M_22 = 10;;
        const M_23 = 11;;
        const M_30 = 12;;
        const M_31 = 13;;
        const M_32 = 14;;
        const M_33 = 15;;
        local matrix3x4_t = class {
            [0] = null;
            constructor(m00 = 0.0, m01 = 0.0, m02 = 0.0, m03 = 0.0, m10 = 0.0, m11 = 0.0, m12 = 0.0, m13 = 0.0, m20 = 0.0, m21 = 0.0, m22 = 0.0, m23 = 0.0) {
                this[0] = [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23]
            }

            function Init(m00 = 0.0, m01 = 0.0, m02 = 0.0, m03 = 0.0, m10 = 0.0, m11 = 0.0, m12 = 0.0, m13 = 0.0, m20 = 0.0, m21 = 0.0, m22 = 0.0, m23 = 0.0) {
                local m = this[0];
                m[M_00] = m00;
                m[M_01] = m01;
                m[M_02] = m02;
                m[M_03] = m03;
                m[M_10] = m10;
                m[M_11] = m11;
                m[M_12] = m12;
                m[M_13] = m13;
                m[M_20] = m20;
                m[M_21] = m21;
                m[M_22] = m22;
                m[M_23] = m23
            }

            function InitXYZ(vX, vY, vZ, vT) {
                local m = this[0];
                m[M_00] = vX.x;
                m[M_10] = vX.y;
                m[M_20] = vX.z;
                m[M_01] = vY.x;
                m[M_11] = vY.y;
                m[M_21] = vY.z;
                m[M_02] = vZ.x;
                m[M_12] = vZ.y;
                m[M_22] = vZ.z;
                m[M_03] = vT.x;
                m[M_13] = vT.y;
                m[M_23] = vT.z
            }

            function _cloned(src) {
                this[0] = clone src[0]
            }

            function _tostring(): (Fmt) {
                local m = this[0];
                return Fmt("[ (%.6g, %.6g, %.6g), (%.6g, %.6g, %.6g), (%.6g, %.6g, %.6g), (%.6g, %.6g, %.6g) ]", m[M_00], m[M_01], m[M_02], m[M_10], m[M_11], m[M_12], m[M_20], m[M_21], m[M_22], m[M_03], m[M_13], m[M_23])
            }

            function _typeof() {
                return "matrix3x4_t"
            }
            _man = null;

            function _get(i): (CArrayOpMan) {
                if (!_man) _man = CArrayOpMan(this[0]);
                if (i == "m") return _man;
                return _man[i]
            }
        }, VMatrix = class extends matrix3x4_t {
            [0] = null;
            constructor(m00 = 0.0, m01 = 0.0, m02 = 0.0, m03 = 0.0, m10 = 0.0, m11 = 0.0, m12 = 0.0, m13 = 0.0, m20 = 0.0, m21 = 0.0, m22 = 0.0, m23 = 0.0, m30 = 0.0, m31 = 0.0, m32 = 0.0, m33 = 1.0) {
                this[0] = [m00, m01, m02, m03, m10, m11, m12, m13, m20, m21, m22, m23, m30, m31, m32, m33]
            }

            function Init(m00 = 0.0, m01 = 0.0, m02 = 0.0, m03 = 0.0, m10 = 0.0, m11 = 0.0, m12 = 0.0, m13 = 0.0, m20 = 0.0, m21 = 0.0, m22 = 0.0, m23 = 0.0, m30 = 0.0, m31 = 0.0, m32 = 0.0, m33 = 1.0) {
                local m = this[0];
                m[M_00] = m00;
                m[M_01] = m01;
                m[M_02] = m02;
                m[M_03] = m03;
                m[M_10] = m10;
                m[M_11] = m11;
                m[M_12] = m12;
                m[M_13] = m13;
                m[M_20] = m20;
                m[M_21] = m21;
                m[M_22] = m22;
                m[M_23] = m23;
                m[M_30] = m30;
                m[M_31] = m31;
                m[M_32] = m32;
                m[M_33] = m33
            }

            function Identity() {
                local m = this[0];
                m[M_00] = m[M_11] = m[M_22] = m[M_33] = 1.0;
                m[M_01] = m[M_02] = m[M_03] = m[M_10] = m[M_12] = m[M_13] = m[M_20] = m[M_21] = m[M_23] = m[M_30] = m[M_31] = m[M_32] = 0.0
            }

            function _tostring(): (Fmt) {
                local m = this[0];
                return Fmt("[ (%.6g, %.6g, %.6g, %.6g), (%.6g, %.6g, %.6g, %.6g), (%.6g, %.6g, %.6g, %.6g), (%.6g, %.6g, %.6g, %.6g) ]", m[M_00], m[M_01], m[M_02], m[M_03], m[M_10], m[M_11], m[M_12], m[M_13], m[M_20], m[M_21], m[M_22], m[M_23], m[M_30], m[M_31], m[M_32], m[M_33])
            }

            function _typeof() {
                return "VMatrix"
            }
        }
        local _VEC = Vector(), _QUAT = Quaternion();
        VS.fabs <- function(f) {
            if (0.0 <= f) return f;
            return -f
        }
        local fabs = VS.fabs;::max <- function(a, b) {
            if (a > b) return a;
            return b
        }::min <- function(a, b) {
            if (a < b) return a;
            return b
        }::clamp <- function(v, l, h) {
            if (h < l) return h;
            if (v < l) return l;
            if (v > h) return h;
            return v
        }
        VS.IsInteger <- function(f) {
            return f.tointeger() == f
        }
        VS.IsLookingAt <- function(A, B, D, t) {
            B = B - A;
            B.Norm();
            return B.Dot(D) >= t
        }
        VS.GetAngle <- function(A, B): (atan2) {
            B = B - A;
            local p = atan2(-B.z, B.Length2D()) * RAD2DEG, y = atan2(B.y, B.x) * RAD2DEG;
            B.x = p;
            B.y = y;
            B.z = 0.0;
            return B
        }
        VS.VectorVectors <- function(vF, vR, vU): (Vector) {
            if (!vF.x && !vF.y) {
                vR.y = 0xFFFFFFFF;
                vU.x = -vF.z;
                vR.x = vR.z = vU.y = vU.z = 0.0
            } else {
                local r = vF.Cross(Vector(0.0, 0.0, 1.0));
                r.Norm();
                vR.x = r.x;
                vR.y = r.y;
                vR.z = r.z;
                local u = vR.Cross(vF);
                u.Norm();
                vU.x = u.x;
                vU.y = u.y;
                vU.z = u.z
            }
        }
        local VectorVectors = VS.VectorVectors;
        VS.AngleVectors <- function(a, vF = _VEC, vR = null, vU = null): (sin, cos) {
            local sr, cr, yr = DEG2RAD * a.y, sy = sin(yr), cy = cos(yr), pr = DEG2RAD * a.x, sp = sin(pr), cp = cos(pr);
            if (a.z) {
                local rr = DEG2RAD * a.z;
                sr = -sin(rr);
                cr = cos(rr)
            } else {
                sr = 0.0;
                cr = 1.0
            };
            if (vF) {
                vF.x = cp * cy;
                vF.y = cp * sy;
                vF.z = -sp
            };
            if (vR) {
                vR.x = sr * sp * cy + cr * sy;
                vR.y = sr * sp * sy - cr * cy;
                vR.z = sr * cp
            };
            if (vU) {
                vU.x = cr * sp * cy - sr * sy;
                vU.y = cr * sp * sy + sr * cy;
                vU.z = cr * cp
            };
            return vF
        }
        VS.VectorAngles <- function(vF, o = _VEC): (atan2) {
            local y = 0.0, p = y;
            if (!vF.y && !vF.x) {
                if (vF.z > 0.0) p = 270.0;
                else p = 90.0
            } else {
                y = atan2(vF.y, vF.x) * RAD2DEG;
                if (y < 0.0) y += 360.0;
                p = atan2(-vF.z, vF.Length2D()) * RAD2DEG;
                if (p < 0.0) p += 360.0
            };
            o.x = p;
            o.y = y;
            o.z = 0.0;
            return o
        }
        VS.VectorYawRotate <- function(V, a, o = _VEC): (sin, cos) {
            a = DEG2RAD * a;
            local sy = sin(a), cy = cos(a);
            local x = V.x * cy - V.y * sy, y = V.x * sy + V.y * cy;
            o.x = x;
            o.y = y;
            o.z = V.z;
            return o
        }
        VS.YawToVector <- function(y): (Vector, sin, cos) {
            y = DEG2RAD * y;
            return Vector(cos(y), sin(y), 0.0)
        }
        VS.VecToYaw <- function(v): (atan2) {
            if (!v.y && !v.x) return 0.0;
            return atan2(v.y, v.x) * RAD2DEG
        }
        VS.VecToPitch <- function(v): (atan2) {
            if (!v.y && !v.x) {
                if (v.z < 0.0) return 180.0;
                return -180.0
            };
            return atan2(-v.z, v.Length2D()) * RAD2DEG
        }
        VS.VectorIsZero <- function(v) {
            return !v.x && !v.y && !v.z
        }
        VS.VectorsAreEqual <- function(a, b, t = 0.0) {
            local x = a.x - b.x, y = a.y - b.y, z = a.z - b.z;
            if (0.0 > x) x = -x;
            if (0.0 > y) y = -y;
            if (0.0 > z) z = -z;
            return (x <= t && y <= t && z <= t)
        }
        VS.AnglesAreEqual <- function(a, b, t = 0.0) {
            a = (a - b) % 360.0;
            if (a > 180.0) a -= 360.0;
            else if (-180.0 > a) a += 360.0;;
            if (0.0 > a) a = -a;
            return a <= t
        }
        VS.CloseEnough <- function(a, b, e = 1.e-3) {
            a = a - b;
            if (0.0 > a) a = -a;
            return a <= e
        }
        VS.Approach <- function(t, v, s) {
            local dt = t - v;
            if (dt > s) return v + s;
            if (-s > dt) return v - s;
            return t
        }
        VS.ApproachVector <- function(t, v, s) {
            local dv = t - v, dt = dv.Norm();
            if (dt > s) return v + dv * s;
            if (-s > dt) return v - dv * s;
            return t
        }
        VS.ApproachAngle <- function(t, v, s) {
            local _360 = 360.0, _180 = 180.0;
            t %= _360;
            if (t > _180) t -= _360;
            else if (-_180 > t) t += _360;;
            v %= _360;
            if (v > _180) v -= _360;
            else if (-_180 > v) v += _360;;
            local dt = (t - v) % _360;
            if (dt > _180) dt -= _360;
            else if (-_180 > dt) dt += _360;;
            if (s < 0.0) s = -s;
            if (dt > s) return v + s;
            if (-s > dt) return v - s;
            return t
        }
        VS.AngleDiff <- function(A, B) {
            local _360 = 360.0, _180 = 180.0;
            A = (A - B) % _360;
            if (A > _180) return A - _360;
            if (-_180 > A) return A + _360;
            return A
        }
        VS.AngleNormalize <- function(A) {
            local _360 = 360.0, _180 = 180.0;
            A %= _360;
            if (A > _180) return A - _360;
            if (-_180 > A) return A + _360;
            return A
        }
        VS.QAngleNormalize <- function(A) {
            local _360 = 360.0, _180 = 180.0;
            A.x %= _360;
            if (A.x > _180) A.x -= _360;
            else if (-_180 > A.x) A.x += _360;;
            A.y %= _360;
            if (A.y > _180) A.y -= _360;
            else if (-_180 > A.y) A.y += _360;;
            A.z %= _360;
            if (A.z > _180) A.z -= _360;
            else if (-_180 > A.z) A.z += _360;;
            return A
        }
        VS.SnapDirectionToAxis <- function(V, e = 0.002) {
            local p = 1.0 - e, f = V.x < 0.0;
            if ((f ? -V.x : V.x) > p) {
                V.x = f ? -1.0 : 1.0;
                V.y = V.z = 0.0;
                return V
            };
            f = V.y < 0.0;
            if ((f ? -V.y : V.y) > p) {
                V.y = f ? -1.0 : 1.0;
                V.z = V.x = 0.0;
                return V
            };
            f = V.z < 0.0;
            if ((f ? -V.z : V.z) > p) {
                V.z = f ? -1.0 : 1.0;
                V.x = V.y = 0.0;
                return V
            }
        }
        VS.VectorNegate <- function(v) {
            v.x = -v.x;
            v.y = -v.y;
            v.z = -v.z;
            return v
        }
        VS.VectorCopy <- function(a, o) {
            o.x = a.x;
            o.y = a.y;
            o.z = a.z;
            return o
        }
        VS.VectorMin <- function(a, b, o = _VEC) {
            if (a.x < b.x) o.x = a.x;
            else o.x = b.x;
            if (a.y < b.y) o.y = a.y;
            else o.y = b.y;
            if (a.z < b.z) o.z = a.z;
            else o.z = b.z;
            return o
        }
        VS.VectorMax <- function(a, b, o = _VEC) {
            if (a.x > b.x) o.x = a.x;
            else o.x = b.x;
            if (a.y > b.y) o.y = a.y;
            else o.y = b.y;
            if (a.z > b.z) o.z = a.z;
            else o.z = b.z;
            return o
        }
        VS.VectorAbs <- function(v) {
            if (0.0 > v.x) v.x = -v.x;
            if (0.0 > v.y) v.y = -v.y;
            if (0.0 > v.z) v.z = -v.z;
            return v
        }
        VS.VectorAdd <- function(a, b, o) {
            o.x = a.x + b.x;
            o.y = a.y + b.y;
            o.z = a.z + b.z;
            return o
        }
        VS.VectorSubtract <- function(a, b, o) {
            o.x = a.x - b.x;
            o.y = a.y - b.y;
            o.z = a.z - b.z;
            return o
        }
        VS.VectorScale <- function(a, b, o) {
            o.x = a.x * b;
            o.y = a.y * b;
            o.z = a.z * b;
            return o
        }
        VS.VectorMultiply <- function(a, b, o) {
            o.x = a.x * b.x;
            o.y = a.y * b.y;
            o.z = a.z * b.z
        }
        VS.VectorDivide <- function(a, b, o) {
            o.x = a.x / b.x;
            o.y = a.y / b.y;
            o.z = a.z / b.z
        }
        VS.VectorMA <- function(p, s, v, o = _VEC) {
            o.x = p.x + s * v.x;
            o.y = p.y + s * v.y;
            o.z = p.z + s * v.z;
            return o
        }
        local VectorAdd = VS.VectorAdd, VectorSubtract = VS.VectorSubtract;
        VS.RandomVector <- function(l = -RAND_MAX, h = RAND_MAX): (Vector, RandomFloat) {
            return Vector(RandomFloat(l, h), RandomFloat(l, h), RandomFloat(l, h))
        }
        VS.RandomVectorInUnitSphere <- function(v): (rand, sin, cos, acos, pow) {
            local p = acos(1.0 - rand() * 0.00006103702), t = rand() * 0.00019175345, r = pow(rand() * 0.00003051851, 0.333333), s = sin(p) * r;
            v.x = cos(t) * s;
            v.y = sin(t) * s;
            v.z = cos(p) * r;
            return r
        }
        VS.RandomVectorOnUnitSphere <- function(v): (rand, sin, cos, acos) {
            local p = acos(1.0 - rand() * 0.00006103702), t = rand() * 0.00019175345, s = sin(p);
            v.x = cos(t) * s;
            v.y = sin(t) * s;
            v.z = cos(p)
        }
        VS.ExponentialDecay <- function(d, t, dt): (log, exp) {
            return exp(log(d) / t * dt)
        }
        VS.ExponentialDecayHalf <- function(t, dt): (exp) {
            return exp(-0.6931471806 / t * dt)
        }
        VS.ExponentialDecayIntegral <- function(d, t, dt): (log, pow) {
            return (pow(d, dt / t) * t - t) / log(d)
        }
        VS.SimpleSpline <- function(v) {
            local vv = v * v;
            return 3.0 * vv - 2.0 * vv * v
        }
        VS.SimpleSplineRemapVal <- function(v, A, B, C, D) {
            if (A == B) {
                if (v >= B) return D;
                return C
            };
            local l = (v - A) / (B - A), q = l * l;
            return C + (D - C) * (3.0 * q - 2.0 * q * l)
        }
        VS.SimpleSplineRemapValClamped <- function(v, A, B, C, D) {
            if (A == B) {
                if (v >= B) return D;
                return C
            };
            local l = (v - A) / (B - A);
            if (l <= 0.0) return C;
            if (l >= 1.0) return D;
            local q = l * l;
            return C + (D - C) * (3.0 * q - 2.0 * q * l)
        }
        VS.RemapVal <- function(v, A, B, C, D) {
            if (A == B) {
                if (v >= B) return D;
                return C
            };
            return C + (D - C) * (v - A) / (B - A)
        }
        VS.RemapValClamped <- function(v, A, B, C, D) {
            if (A == B) {
                if (v >= B) return D;
                return C
            };
            local l = (v - A) / (B - A);
            if (l <= 0.0) return C;
            if (l >= 1.0) return D;
            return C + (D - C) * l
        }
        VS.Bias <- function(x, b): (log, pow) {
            local e = 0.0;
            if (-1.0 != b) e = log(b) * -1.442695041;
            return pow(x, e)
        }
        local Bias = VS.Bias;
        VS.Gain <- function(x, t): (Bias) {
            if (x < 0.5) return Bias(2.0 * x, 1.0 - t) * 0.5;
            return 1.0 - Bias(2.0 - 2.0 * x, 1.0 - t) * 0.5
        }
        VS.SmoothCurve <- function(x): (cos) {
            return (1.0 - cos(x * PI)) * 0.5
        }
        VS.MovePeak <- function(x, p) {
            if (x < p) return x * 0.5 / p;
            return 0.5 + 0.5 * (x - p) / (1.0 - p)
        }
        local MovePeak = VS.MovePeak, Gain = VS.Gain;
        VS.SmoothCurve_Tweak <- function(x, p, s): (MovePeak, Gain, cos) {
            local m = MovePeak(x, p), t = Gain(m, s);
            return (1.0 - cos(t * PI)) * 0.5
        }
        VS.Lerp <- function(A, B, f) {
            return A + (B - A) * f
        }
        VS.FLerp <- function(f1, f2, i1, i2, x) {
            return f1 + (f2 - f1) * (x - i1) / (i2 - i1)
        }
        VS.VectorLerp <- function(v1, v2, f, o = _VEC) {
            local v = v1 + (v2 - v1) * f;
            o.x = v.x;
            o.y = v.y;
            o.z = v.z;
            return o
        }
        VS.DotProductAbs <- function(A, B) {
            local x = A.x * B.x, y = A.y * B.y, z = A.z * B.z;
            if (0.0 > x) x = -x;
            if (0.0 > y) y = -y;
            if (0.0 > z) z = -z;
            return x + y + z
        }
        local DotProductAbs = VS.DotProductAbs;
        VS.VectorTransform <- function(A, B, o = _VEC) {
            B = B[0];
            local x = A.x, y = A.y, z = A.z;
            o.x = x * B[M_00] + y * B[M_01] + z * B[M_02] + B[M_03];
            o.y = x * B[M_10] + y * B[M_11] + z * B[M_12] + B[M_13];
            o.z = x * B[M_20] + y * B[M_21] + z * B[M_22] + B[M_23];
            return o
        }
        VS.VectorITransform <- function(A, B, o = _VEC) {
            B = B[0];
            local in1t0 = A.x - B[M_03], in1t1 = A.y - B[M_13], in1t2 = A.z - B[M_23], x = in1t0 * B[M_00] + in1t1 * B[M_10] + in1t2 * B[M_20], y = in1t0 * B[M_01] + in1t1 * B[M_11] + in1t2 * B[M_21], z = in1t0 * B[M_02] + in1t1 * B[M_12] + in1t2 * B[M_22];
            o.x = x;
            o.y = y;
            o.z = z;
            return o
        }
        VS.VectorRotate <- function(A, B, o = _VEC) {
            B = B[0];
            local x = A.x, y = A.y, z = A.z;
            o.x = x * B[M_00] + y * B[M_01] + z * B[M_02];
            o.y = x * B[M_10] + y * B[M_11] + z * B[M_12];
            o.z = x * B[M_20] + y * B[M_21] + z * B[M_22];
            return o
        }
        local VectorRotate = VS.VectorRotate;
        VS.VectorRotateByAngle <- function(A, B, o = _VEC): (matrix3x4_t, VectorRotate) {
            local m = matrix3x4_t();
            AngleMatrix(B, null, m);
            return VectorRotate(A, m, o)
        }
        VS.VectorRotateByQuaternion <- function(A, B, o = _VEC) {
            local in2x = B.x, in2y = B.y, in2z = B.z, in2w = B.w, qvx = in2y * A.z - in2z * A.y + in2w * A.x, qvy = in2z * A.x + in2w * A.y - in2x * A.z, qvz = in2x * A.y - in2y * A.x + in2w * A.z, qvw = in2x * A.x + in2y * A.y + in2z * A.z;
            o.x = qvx * in2w - qvy * in2z + qvz * in2y + qvw * in2x;
            o.y = qvx * in2z + qvy * in2w - qvz * in2x + qvw * in2y;
            o.z = qvy * in2x + qvz * in2w + qvw * in2z - qvx * in2y;
            return o
        }
        VS.VectorIRotate <- function(A, B, o = _VEC) {
            B = B[0];
            local x = A.x, y = A.y, z = A.z;
            o.x = x * B[M_00] + y * B[M_10] + z * B[M_20];
            o.y = x * B[M_01] + y * B[M_11] + z * B[M_21];
            o.z = x * B[M_02] + y * B[M_12] + z * B[M_22];
            return o
        }
        local VectorITransform = VS.VectorITransform, VectorTransform = VS.VectorTransform, VectorIRotate = VS.VectorIRotate;
        VS.VectorMatrix <- function(vf, m): (Vector, VectorVectors) {
            local vr = Vector(), up = Vector();
            VectorVectors(vf, vr, up);
            m = m[0];
            m[M_00] = vf.x;
            m[M_10] = vf.y;
            m[M_20] = vf.z;
            m[M_01] = -vr.x;
            m[M_11] = -vr.y;
            m[M_21] = -vr.z;
            m[M_02] = up.x;
            m[M_12] = up.y;
            m[M_22] = up.z
        }
        VS.MatrixVectors <- function(m, vf, vr, vu) {
            m = m[0];
            vf.x = m[M_00];
            vf.y = m[M_10];
            vf.z = m[M_20];
            vr.x = -m[M_01];
            vr.y = -m[M_11];
            vr.z = -m[M_21];
            vu.x = m[M_02];
            vu.y = m[M_12];
            vu.z = m[M_22]
        }
        VS.MatrixAngles <- function(m, a = _VEC, p = null): (sqrt, atan2) {
            m = m[0];
            if (p) {
                p.x = m[M_03];
                p.y = m[M_13];
                p.z = m[M_23]
            };
            local f0 = m[M_00], f1 = m[M_10], xy = sqrt(f0 * f0 + f1 * f1);
            if (xy > 0.001) {
                a.y = atan2(f1, f0) * RAD2DEG;
                a.x = atan2(-m[M_20], xy) * RAD2DEG;
                a.z = atan2(m[M_21], m[M_22]) * RAD2DEG
            } else {
                a.y = atan2(-m[M_01], m[M_11]) * RAD2DEG;
                a.x = atan2(-m[M_20], xy) * RAD2DEG;
                a.z = 0.0
            };
            return a
        }
        VS.AngleMatrix <- function(a, p, m): (sin, cos) {
            local ay = DEG2RAD * a.y, ax = DEG2RAD * a.x, az = DEG2RAD * a.z;
            local sy = sin(ay), cy = cos(ay), sp = sin(ax), cp = cos(ax), sr = sin(az), cr = cos(az), crcy = cr * cy, crsy = cr * sy, srcy = sr * cy, srsy = sr * sy;
            m = m[0];
            m[M_00] = cp * cy;
            m[M_10] = cp * sy;
            m[M_20] = -sp;
            m[M_01] = sp * srcy - crsy;
            m[M_11] = sp * srsy + crcy;
            m[M_21] = sr * cp;
            m[M_02] = sp * crcy + srsy;
            m[M_12] = sp * crsy - srcy;
            m[M_22] = cr * cp;
            if (p) {
                m[M_03] = p.x;
                m[M_13] = p.y;
                m[M_23] = p.z
            } else m[M_03] = m[M_13] = m[M_23] = 0.0
        }
        VS.AngleIMatrix <- function(a, p, mat): (sin, cos, VectorRotate) {
            local ay = DEG2RAD * a.y, ax = DEG2RAD * a.x, az = DEG2RAD * a.z, sy = sin(ay), cy = cos(ay), sp = sin(ax), cp = cos(ax), sr = sin(az), cr = cos(az), srsp = sr * sp, crsp = cr * sp, m = mat[0];
            m[M_00] = cp * cy;
            m[M_01] = cp * sy;
            m[M_02] = -sp;
            m[M_10] = srsp * cy - cr * sy;
            m[M_11] = srsp * sy + cr * cy;
            m[M_12] = sr * cp;
            m[M_20] = crsp * cy + sr * sy;
            m[M_21] = crsp * sy - sr * cy;
            m[M_22] = cr * cp;
            if (p) {
                local v = VectorRotate(p, mat);
                m[M_03] = -v.x;
                m[M_13] = -v.y;
                m[M_23] = -v.z
            } else m[M_03] = m[M_13] = m[M_23] = 0.0
        }
        local MatrixAngles = VS.MatrixAngles, AngleMatrix = VS.AngleMatrix, AngleIMatrix = VS.AngleIMatrix;
        VS.QuaternionsAreEqual <- function(a, b, t = 0.0) {
            local x = a.x - b.x, y = a.y - b.y, z = a.z - b.z, w = a.w - b.w;
            if (0.0 > x) x = -x;
            if (0.0 > y) y = -y;
            if (0.0 > z) z = -z;
            if (0.0 > w) w = -w;
            return (x <= t && y <= t && z <= t && w <= t)
        }
        VS.QuaternionNormalize <- function(q): (sqrt) {
            local r = q.x * q.x + q.y * q.y + q.z * q.z + q.w * q.w;
            if (r) {
                local i = 1.0 / sqrt(r);
                q.w *= i;
                q.z *= i;
                q.y *= i;
                q.x *= i
            };
            return r
        }
        VS.QuaternionAlign <- function(p, q, qt = _QUAT) {
            local px = p.x, py = p.y, pz = p.z, pw = p.w, qx = q.x, qy = q.y, qz = q.z, qw = q.w, a = (px - qx) * (px - qx) + (py - qy) * (py - qy) + (pz - qz) * (pz - qz) + (pw - qw) * (pw - qw), b = (px + qx) * (px + qx) + (py + qy) * (py + qy) + (pz + qz) * (pz + qz) + (pw + qw) * (pw + qw);
            if (a > b) {
                qt.x = -qx;
                qt.y = -qy;
                qt.z = -qz;
                qt.w = -qw
            } else if (qt != q) {
                qt.x = qx;
                qt.y = qy;
                qt.z = qz;
                qt.w = qw
            };;
            return qt
        }
        local QuaternionNormalize = VS.QuaternionNormalize, QuaternionAlign = VS.QuaternionAlign;
        VS.QuaternionMult <- function(p, q, qt = _QUAT): (QuaternionAlign) {
            local q2 = QuaternionAlign(p, q), px = p.x, py = p.y, pz = p.z, pw = p.w, qx = q2.x, qy = q2.y, qz = q2.z, qw = q2.w;
            qt.x = px * qw + py * qz - pz * qy + pw * qx;
            qt.y = py * qw + pz * qx + pw * qy - px * qz;
            qt.z = px * qy - py * qx + pz * qw + pw * qz;
            qt.w = pw * qw - px * qx - py * qy - pz * qz;
            return qt
        }
        local QuaternionMult = VS.QuaternionMult;
        VS.QuaternionConjugate <- function(p, q) {
            q.x = -p.x;
            q.y = -p.y;
            q.z = -p.z;
            q.w = p.w
        }
        VS.QuaternionMA <- function(p, s, q, qt = _QUAT): (QuaternionNormalize, QuaternionMult) {
            QuaternionScale(q, s, qt);
            QuaternionMult(p, qt, qt);
            QuaternionNormalize(qt);
            return qt
        }
        VS.QuaternionAdd <- function(p, q, qt = _QUAT): (QuaternionAlign) {
            local q2 = QuaternionAlign(p, q);
            qt.x = p.x + q2.x;
            qt.y = p.y + q2.y;
            qt.z = p.z + q2.z;
            qt.w = p.w + q2.w;
            return qt
        }
        VS.QuaternionDotProduct <- function(p, q) {
            return p.x * q.x + p.y * q.y + p.z * q.z + p.w * q.w
        }
        VS.QuaternionInvert <- function(p, q) {
            local r = p.x * p.x + p.y * p.y + p.z * p.z + p.w * p.w;
            if (r) {
                local i = 1.0 / r;
                q.x = -p.x * i;
                q.y = -p.y * i;
                q.z = -p.z * i;
                q.w = p.w * i
            }
        }
        VS.QuaternionBlendNoAlign <- function(p, q, t, qt = _QUAT): (QuaternionNormalize) {
            local sclp = 1.0 - t, sclq = t;
            qt.x = sclp * p.x + sclq * q.x;
            qt.y = sclp * p.y + sclq * q.y;
            qt.z = sclp * p.z + sclq * q.z;
            qt.w = sclp * p.w + sclq * q.w;
            QuaternionNormalize(qt);
            return qt
        }
        local QuaternionBlendNoAlign = VS.QuaternionBlendNoAlign;
        VS.QuaternionBlend <- function(p, q, t, qt = _QUAT): (QuaternionAlign, QuaternionBlendNoAlign) {
            return QuaternionBlendNoAlign(p, QuaternionAlign(p, q), t, qt)
        }
        VS.QuaternionIdentityBlend <- function(p, t, qt = _QUAT): (QuaternionNormalize) {
            local sclp = 1.0 - t;
            qt.x = p.x * sclp;
            qt.y = p.y * sclp;
            qt.z = p.z * sclp;
            if (qt.w < 0.0) qt.w = p.w * sclp - t;
            else qt.w = p.w * sclp + t;
            QuaternionNormalize(qt);
            return qt
        }
        VS.QuaternionSlerpNoAlign <- function(p, q, t, qt = _QUAT): (sin, acos) {
            local sclp, sclq;
            local c = p.x * q.x + p.y * q.y + p.z * q.z + p.w * q.w;
            if (c > -0.999999) {
                if (c < 0.999999) {
                    local o = acos(c), n = 1.0 / sin(o);
                    sclp = sin((1.0 - t) * o) * n;
                    sclq = sin(t * o) * n
                } else {
                    sclp = 1.0 - t;
                    sclq = t
                };
                qt.x = sclp * p.x + sclq * q.x;
                qt.y = sclp * p.y + sclq * q.y;
                qt.z = sclp * p.z + sclq * q.z;
                qt.w = sclp * p.w + sclq * q.w
            } else {
                sclp = sin((1.0 - t) * PIDIV2);
                sclq = sin(t * PIDIV2);
                qt.x = sclp * p.x - sclq * q.y;
                qt.y = sclp * p.y + sclq * q.x;
                qt.z = sclp * p.z - sclq * q.w;
                qt.w = sclp * p.w + sclq * q.z
            };
            return qt
        }
        local QuaternionSlerpNoAlign = VS.QuaternionSlerpNoAlign;
        VS.QuaternionSlerp <- function(p, q, t, qt = _QUAT): (QuaternionAlign, QuaternionSlerpNoAlign) {
            return QuaternionSlerpNoAlign(p, QuaternionAlign(p, q), t, qt)
        }
        VS.QuaternionExp <- function(p, q): (sqrt, sin, cos) {
            local t = sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
            if (t > FLT_EPSILON) {
                local S = sin(t) / t;
                q.x = S * p.x;
                q.y = S * p.y;
                q.z = S * p.z
            } else {
                q.x = p.x;
                q.y = p.y;
                q.z = p.z
            };
            q.w = cos(t)
        }
        VS.QuaternionLn <- function(p, q): (acos, sin) {
            if (p.w < 0.99999 || -0.99999 < p.w) {
                local t = acos(p.w);
                local S = t / sin(t);
                q.x = S * p.x;
                q.y = S * p.y;
                q.z = S * p.z
            } else {
                q.x = p.x;
                q.y = p.y;
                q.z = p.z
            };
            q.w = 0.0
        }
        VS.QuaternionSquad <- function(Q0, Q1, Q2, Q3, T, qt): (Quaternion, QuaternionSlerpNoAlign) {
            local SQ2 = Q2, SQ0 = Q0, SQ3 = Q3; {
                local aQ12x = Q1.x + Q2.x, aQ12y = Q1.y + Q2.y, aQ12z = Q1.z + Q2.z, aQ12w = Q1.w + Q2.w, LS12 = aQ12x * aQ12x + aQ12y * aQ12y + aQ12z * aQ12z + aQ12w * aQ12w, sQ12x = Q1.x - Q2.x, sQ12y = Q1.y - Q2.y, sQ12z = Q1.z - Q2.z, sQ12w = Q1.w - Q2.w, LD12 = sQ12x * sQ12x + sQ12y * sQ12y + sQ12z * sQ12z + sQ12w * sQ12w;
                if (LS12 < LD12) SQ2 = Quaternion(-Q2.x, -Q2.y, -Q2.z, -Q2.w)
            } {
                local aQ01x = Q0.x + Q1.x, aQ01y = Q0.y + Q1.y, aQ01z = Q0.z + Q1.z, aQ01w = Q0.w + Q1.w, LS01 = aQ01x * aQ01x + aQ01y * aQ01y + aQ01z * aQ01z + aQ01w * aQ01w, sQ01x = Q0.x - Q1.x, sQ01y = Q0.y - Q1.y, sQ01z = Q0.z - Q1.z, sQ01w = Q0.w - Q1.w, LD01 = sQ01x * sQ01x + sQ01y * sQ01y + sQ01z * sQ01z + sQ01w * sQ01w;
                if (LS01 < LD01) SQ0 = Quaternion(-Q0.x, -Q0.y, -Q0.z, -Q0.w)
            } {
                local aQ23x = SQ2.x + Q3.x, aQ23y = SQ2.y + Q3.y, aQ23z = SQ2.z + Q3.z, aQ23w = SQ2.w + Q3.w, LS23 = aQ23x * aQ23x + aQ23y * aQ23y + aQ23z * aQ23z + aQ23w * aQ23w, sQ23x = SQ2.x - Q3.x, sQ23y = SQ2.y - Q3.y, sQ23z = SQ2.z - Q3.z, sQ23w = SQ2.w - Q3.w, LD23 = sQ23x * sQ23x + sQ23y * sQ23y + sQ23z * sQ23z + sQ23w * sQ23w;
                if (LS23 < LD23) SQ3 = Quaternion(-Q3.x, -Q3.y, -Q3.z, -Q3.w)
            }
            local pA = Quaternion(), pB = Quaternion(); {
                local LnQ0 = Quaternion(), LnQ2 = Quaternion(), LnQ1 = Quaternion(), LnQ3 = Quaternion(); {
                    local InvQ1 = Quaternion(), InvQ2 = Quaternion();
                    QuaternionInvert(Q1, InvQ1);
                    QuaternionInvert(SQ2, InvQ2);
                    LnQ0.x = SQ0.w * InvQ1.x + SQ0.x * InvQ1.w + SQ0.y * InvQ1.z - SQ0.z * InvQ1.y;
                    LnQ0.y = SQ0.w * InvQ1.y - SQ0.x * InvQ1.z + SQ0.y * InvQ1.w + SQ0.z * InvQ1.x;
                    LnQ0.z = SQ0.w * InvQ1.z + SQ0.x * InvQ1.y - SQ0.y * InvQ1.x + SQ0.z * InvQ1.w;
                    LnQ0.w = SQ0.w * InvQ1.w - SQ0.x * InvQ1.x - SQ0.y * InvQ1.y - SQ0.z * InvQ1.z;
                    QuaternionLn(LnQ0, LnQ0);
                    LnQ2.x = SQ2.w * InvQ1.x + SQ2.x * InvQ1.w + SQ2.y * InvQ1.z - SQ2.z * InvQ1.y;
                    LnQ2.y = SQ2.w * InvQ1.y - SQ2.x * InvQ1.z + SQ2.y * InvQ1.w + SQ2.z * InvQ1.x;
                    LnQ2.z = SQ2.w * InvQ1.z + SQ2.x * InvQ1.y - SQ2.y * InvQ1.x + SQ2.z * InvQ1.w;
                    LnQ2.w = SQ2.w * InvQ1.w - SQ2.x * InvQ1.x - SQ2.y * InvQ1.y - SQ2.z * InvQ1.z;
                    QuaternionLn(LnQ2, LnQ2);
                    LnQ1.x = Q1.w * InvQ2.x + Q1.x * InvQ2.w + Q1.y * InvQ2.z - Q1.z * InvQ2.y;
                    LnQ1.y = Q1.w * InvQ2.y - Q1.x * InvQ2.z + Q1.y * InvQ2.w + Q1.z * InvQ2.x;
                    LnQ1.z = Q1.w * InvQ2.z + Q1.x * InvQ2.y - Q1.y * InvQ2.x + Q1.z * InvQ2.w;
                    LnQ1.w = Q1.w * InvQ2.w - Q1.x * InvQ2.x - Q1.y * InvQ2.y - Q1.z * InvQ2.z;
                    QuaternionLn(LnQ1, LnQ1);
                    LnQ3.x = SQ3.w * InvQ2.x + SQ3.x * InvQ2.w + SQ3.y * InvQ2.z - SQ3.z * InvQ2.y;
                    LnQ3.y = SQ3.w * InvQ2.y - SQ3.x * InvQ2.z + SQ3.y * InvQ2.w + SQ3.z * InvQ2.x;
                    LnQ3.z = SQ3.w * InvQ2.z + SQ3.x * InvQ2.y - SQ3.y * InvQ2.x + SQ3.z * InvQ2.w;
                    LnQ3.w = SQ3.w * InvQ2.w - SQ3.x * InvQ2.x - SQ3.y * InvQ2.y - SQ3.z * InvQ2.z;
                    QuaternionLn(LnQ3, LnQ3)
                }
                local ExpQ02 = Quaternion(), ExpQ13 = Quaternion();
                ExpQ02.x = -0.25 * (LnQ0.x + LnQ2.x);
                ExpQ02.y = -0.25 * (LnQ0.y + LnQ2.y);
                ExpQ02.z = -0.25 * (LnQ0.z + LnQ2.z);
                ExpQ02.w = -0.25 * (LnQ0.w + LnQ2.w);
                QuaternionExp(ExpQ02, ExpQ02);
                ExpQ13.x = -0.25 * (LnQ1.x + LnQ3.x);
                ExpQ13.y = -0.25 * (LnQ1.y + LnQ3.y);
                ExpQ13.z = -0.25 * (LnQ1.z + LnQ3.z);
                ExpQ13.w = -0.25 * (LnQ1.w + LnQ3.w);
                QuaternionExp(ExpQ13, ExpQ13);
                pA.x = ExpQ02.x * Q1.w + ExpQ02.y * Q1.z - ExpQ02.z * Q1.y + ExpQ02.w * Q1.x;
                pA.y = ExpQ02.y * Q1.w + ExpQ02.z * Q1.x + ExpQ02.w * Q1.y - ExpQ02.x * Q1.z;
                pA.z = ExpQ02.x * Q1.y - ExpQ02.y * Q1.x + ExpQ02.z * Q1.w + ExpQ02.w * Q1.z;
                pA.w = ExpQ02.w * Q1.w - ExpQ02.x * Q1.x - ExpQ02.y * Q1.y - ExpQ02.z * Q1.z;
                pB.x = ExpQ13.x * SQ2.w + ExpQ13.y * SQ2.z - ExpQ13.z * SQ2.y + ExpQ13.w * SQ2.x;
                pB.y = ExpQ13.y * SQ2.w + ExpQ13.z * SQ2.x + ExpQ13.w * SQ2.y - ExpQ13.x * SQ2.z;
                pB.z = ExpQ13.x * SQ2.y - ExpQ13.y * SQ2.x + ExpQ13.z * SQ2.w + ExpQ13.w * SQ2.z;
                pB.w = ExpQ13.w * SQ2.w - ExpQ13.x * SQ2.x - ExpQ13.y * SQ2.y - ExpQ13.z * SQ2.z
            }
            local Q03 = Quaternion(), Q12 = Quaternion();
            QuaternionSlerpNoAlign(Q1, SQ2, T, Q03);
            QuaternionSlerpNoAlign(pA, pB, T, Q12);
            T = (T - T * T) * 2.0;
            return QuaternionSlerpNoAlign(Q03, Q12, T, qt)
        }
        VS.QuaternionAverageExponential <- function(q, n, pp): (Quaternion) {
            local pF = pp[0];
            if (n == 1) {
                q.x = pF.x;
                q.y = pF.y;
                q.z = pF.z;
                q.w = pF.w;
                return
            };
            local w = 1.0 / n, sum = Quaternion(), tmp = Quaternion();
            for (local i = 0; i < n; ++i) {
                QuaternionAlign(pF, pp[i], tmp);
                QuaternionLn(tmp, tmp);
                sum.x += tmp.x * w;
                sum.y += tmp.y * w;
                sum.z += tmp.z * w;
                sum.w += tmp.w * w
            }
            return QuaternionExp(sum, q)
        }
        VS.QuaternionAngleDiff <- function(p, q): (Quaternion, QuaternionMult, sqrt, asin) {
            local n = Quaternion(-q.x, -q.y, -q.z, q.w), d = QuaternionMult(p, n), s = sqrt(d.x * d.x + d.y * d.y + d.z * d.z);
            if (s > 1.0) s = 1.0;
            return asin(s) * RAD2DEG2
        }
        VS.QuaternionScale <- function(p, t, q): (sqrt, sin, asin) {
            local s = sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
            if (s > 1.0) s = 1.0;
            local r = sin(asin(s) * t);
            t = r / (s + FLT_EPSILON);
            q.x = p.x * t;
            q.y = p.y * t;
            q.z = p.z * t;
            r = 1.0 - r * r;
            if (r < 0.0) r = 0.0;
            r = sqrt(r);
            if (0.0 > p.w) q.w = -r;
            else q.w = r
        }
        VS.RotationDeltaAxisAngle <- function(a0, a1, pA): (Quaternion) {
            local q0 = Quaternion(), q1 = Quaternion();
            AngleQuaternion(a0, q0);
            AngleQuaternion(a1, q1);
            QuaternionScale(q0, -1.0, q0);
            local r = QuaternionMult(q1, q0);
            QuaternionNormalize(r);
            return QuaternionAxisAngle(r, pA)
        }
        VS.RotationDelta <- function(a0, a1, out): (matrix3x4_t) {
            local m0 = matrix3x4_t(), m1 = matrix3x4_t();
            AngleIMatrix(a0, null, m0);
            AngleMatrix(a1, null, m1);
            ConcatRotations(m1, m0, m1);
            return MatrixAngles(m1, out)
        }
        VS.MatrixQuaternionFast <- function(m, q): (sqrt) {
            m = m[0];
            local t;
            if (m[M_22] < 0.0) {
                if (m[M_00] > m[M_11]) {
                    t = 1.0 + m[M_00] - m[M_11] - m[M_22];
                    q.x = t;
                    q.y = m[M_01] + m[M_10];
                    q.z = m[M_02] + m[M_20];
                    q.w = m[M_21] - m[M_12]
                } else {
                    t = 1.0 - m[M_00] + m[M_11] - m[M_22];
                    q.x = m[M_01] + m[M_10];
                    q.y = t;
                    q.z = m[M_21] + m[M_12];
                    q.w = m[M_02] - m[M_20]
                }
            } else {
                if (-m[M_11] > m[M_00]) {
                    t = 1.0 - m[M_00] - m[M_11] + m[M_22];
                    q.x = m[M_02] + m[M_20];
                    q.y = m[M_21] + m[M_12];
                    q.z = t;
                    q.w = m[M_10] - m[M_01]
                } else {
                    t = 1.0 + m[M_00] + m[M_11] + m[M_22];
                    q.x = m[M_21] - m[M_12];
                    q.y = m[M_02] - m[M_20];
                    q.z = m[M_10] - m[M_01];
                    q.w = t
                }
            };
            local f = 0.5 / sqrt(t);
            q.x *= f;
            q.y *= f;
            q.z *= f;
            q.w *= f
        }
        local MatrixQuaternionFast = VS.MatrixQuaternionFast;
        VS.QuaternionMatrix <- function(q, p, m) {
            m = m[0];
            local x = q.x, y = q.y, z = q.z, w = q.w, x2 = x + x, y2 = y + y, z2 = z + z, xx = x * x2, xy = x * y2, xz = x * z2, yy = y * y2, yz = y * z2, zz = z * z2, wx = w * x2, wy = w * y2, wz = w * z2;
            m[M_00] = 1.0 - (yy + zz);
            m[M_10] = xy + wz;
            m[M_20] = xz - wy;
            m[M_01] = xy - wz;
            m[M_11] = 1.0 - (xx + zz);
            m[M_21] = yz + wx;
            m[M_02] = xz + wy;
            m[M_12] = yz - wx;
            m[M_22] = 1.0 - (xx + yy);
            if (p) {
                m[M_03] = p.x;
                m[M_13] = p.y;
                m[M_23] = p.z
            } else m[M_03] = m[M_13] = m[M_23] = 0.0
        }
        VS.QuaternionAngles2 <- function(q, a = _VEC): (asin, atan2) {
            local m11 = (2.0 * q.w * q.w) + (2.0 * q.x * q.x) - 1.0, m12 = (2.0 * q.x * q.y) + (2.0 * q.w * q.z), m13 = (2.0 * q.x * q.z) - (2.0 * q.w * q.y), m23 = (2.0 * q.y * q.z) + (2.0 * q.w * q.x), m33 = (2.0 * q.w * q.w) + (2.0 * q.z * q.z) - 1.0;
            a.y = RAD2DEG * atan2(m12, m11);
            a.x = RAD2DEG * asin(-m13);
            a.z = RAD2DEG * atan2(m23, m33);
            return a
        }
        local QuaternionMatrix = VS.QuaternionMatrix;
        VS.QuaternionAngles <- function(q, a = _VEC): (matrix3x4_t, QuaternionMatrix, MatrixAngles) {
            local m = matrix3x4_t();
            QuaternionMatrix(q, null, m);
            return MatrixAngles(m, a)
        }
        VS.QuaternionAxisAngle <- function(q, vx): (acos) {
            local a = acos(q.w) * RAD2DEG2;
            if (a > 180.0) a -= 360.0;
            vx.x = q.x;
            vx.y = q.y;
            vx.z = q.z;
            vx.Norm();
            return a
        }
        VS.AxisAngleQuaternion <- function(vx, a, q = _QUAT): (sin, cos) {
            a *= DEG2RADDIV2;
            local sa = sin(a);
            q.x = vx.x * sa;
            q.y = vx.y * sa;
            q.z = vx.z * sa;
            q.w = cos(a);
            return q
        }
        VS.AngleQuaternion <- function(a, q = _QUAT): (sin, cos) {
            local ay = a.y * DEG2RADDIV2, ax = a.x * DEG2RADDIV2, az = a.z * DEG2RADDIV2, sy = sin(ay), cy = cos(ay), sp = sin(ax), cp = cos(ax), sr = sin(az), cr = cos(az), srcp = sr * cp, crsp = cr * sp, crcp = cr * cp, srsp = sr * sp;
            q.x = srcp * cy - crsp * sy;
            q.y = crsp * cy + srcp * sy;
            q.z = crcp * sy - srsp * cy;
            q.w = crcp * cy + srsp * sy;
            return q
        }
        local AngleQuaternion = VS.AngleQuaternion;
        VS.MatrixQuaternion <- function(m, q = _QUAT): (AngleQuaternion, MatrixAngles) {
            return AngleQuaternion(MatrixAngles(m), q)
        }
        VS.BasisToQuaternion <- function(vF, vR, vU, q = _QUAT): (matrix3x4_t, MatrixQuaternionFast) {
            MatrixQuaternionFast(matrix3x4_t(vF.x, -vR.x, vU.x, 0.0, vF.y, -vR.y, vU.y, 0.0, vF.z, -vR.z, vU.z, 0.0), q);
            return q
        }
        VS.MatricesAreEqual <- function(A, B, t = 0.0) {
            B = B[0];
            foreach(i, v in A[0]) {
                local f = v - B[i];
                if (0.0 > f) f = -f;
                if (f > t) return false
            }
            return true
        }
        VS.MatrixCopy <- function(A, B) {
            local i = 0, b1 = M_30 in A[i], b2 = M_30 in B[i];
            if ((b1 != b2) || B._man) {
                A = A[i];
                B = B[i];
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                B[i] = A[i];
                ++i;
                if (b1 && b2) {
                    B[i] = A[i];
                    ++i;
                    B[i] = A[i];
                    ++i;
                    B[i] = A[i];
                    ++i;
                    B[i] = A[i]
                };
                return
            };
            B[i] = clone A[i]
        }
        VS.MatrixInvert <- function(in1, out) {
            in1 = in1[0];
            out = out[0];
            if (in1 == out) {
                local t = out[M_01];
                out[M_01] = out[M_10];
                out[M_10] = t;
                t = out[M_02];
                out[M_02] = out[M_20];
                out[M_20] = t;
                t = out[M_12];
                out[M_12] = out[M_21];
                out[M_21] = t
            } else {
                out[M_00] = in1[M_00];
                out[M_01] = in1[M_10];
                out[M_02] = in1[M_20];
                out[M_10] = in1[M_01];
                out[M_11] = in1[M_11];
                out[M_12] = in1[M_21];
                out[M_20] = in1[M_02];
                out[M_21] = in1[M_12];
                out[M_22] = in1[M_22]
            };
            local t0 = in1[M_03], t1 = in1[M_13], t2 = in1[M_23];
            out[M_03] = -(t0 * out[M_00] + t1 * out[M_01] + t2 * out[M_02]);
            out[M_13] = -(t0 * out[M_10] + t1 * out[M_11] + t2 * out[M_12]);
            out[M_23] = -(t0 * out[M_20] + t1 * out[M_21] + t2 * out[M_22])
        }
        VS.MatrixInverseGeneral <- function(src, dst): (array) {
            local mat = [array(8, 0.0), array(8, 0.0), array(8, 0.0), array(8, 0.0)], rm = [0, 1, 2, 3];
            src = src[0];
            for (local i = 0; i < 4; ++i) {
                local ii = 4 * i, m = mat[i];
                m[0] = src[ii];
                m[1] = src[ii + 1];
                m[2] = src[ii + 2];
                m[3] = src[ii + 3];
                m[4] = m[5] = m[6] = m[7] = 0.0;
                m[i + 4] = 1.0
            }
            for (local mul, ir = 0; ir < 4; ++ir) {
                local fl = 1.e-6, il = 0xFFFFFFFF;
                for (local it = ir; it < 4; ++it) {
                    local ft = mat[rm[it]][ir];
                    if (0.0 > ft) ft = -ft;
                    if (ft > fl) {
                        il = it;
                        fl = ft
                    }
                }
                if (il == 0xFFFFFFFF) return false;
                local t = rm[il];
                rm[il] = rm[ir];
                rm[ir] = t;
                local m0 = mat[rm[ir]];
                mul = 1.0 / m0[ir];
                m0[0] *= mul;
                m0[1] *= mul;
                m0[2] *= mul;
                m0[3] *= mul;
                m0[4] *= mul;
                m0[5] *= mul;
                m0[6] *= mul;
                m0[7] *= mul;
                m0[ir] = 1.0;
                for (local i = 0; i < 4; ++i)
                    if (i != ir) {
                        local m1 = mat[rm[i]];
                        mul = m1[ir];
                        m1[0] -= m0[0] * mul;
                        m1[1] -= m0[1] * mul;
                        m1[2] -= m0[2] * mul;
                        m1[3] -= m0[3] * mul;
                        m1[4] -= m0[4] * mul;
                        m1[5] -= m0[5] * mul;
                        m1[6] -= m0[6] * mul;
                        m1[7] -= m0[7] * mul;
                        m1[ir] = 0.0
                    }
            }
            dst = dst[0];
            for (local i = 0; i < 4; ++i) {
                local m = mat[rm[i]], ii = 4 * i;
                dst[ii] = m[4];
                dst[ii + 1] = m[5];
                dst[ii + 2] = m[6];
                dst[ii + 3] = m[7]
            }
            return true
        }
        VS.MatrixInverseTR <- function(src, dst) {
            local m = dst[0];
            m[M_30] = m[M_31] = m[M_32] = 0.0;
            m[M_33] = 1.0;
            return MatrixInvert(src, dst)
        }
        VS.MatrixRowDotProduct <- function(in1, row, in2) {
            row = row * 4;
            in1 = in1[0];
            return in1[row] * in2.x + in1[row + 1] * in2.y + in1[row + 2] * in2.z
        }
        VS.MatrixColumnDotProduct <- function(in1, col, in2) {
            in1 = in1[0];
            return in1[col] * in2.x + in1[4 + col] * in2.y + in1[8 + col] * in2.z
        }
        VS.MatrixGetColumn <- function(A, n, v = _VEC) {
            A = A[0];
            v.x = A[n];
            v.y = A[4 + n];
            v.z = A[8 + n];
            return v
        }
        VS.MatrixSetColumn <- function(A, n, m) {
            m = m[0];
            m[n] = A.x;
            m[4 + n] = A.y;
            m[8 + n] = A.z
        }
        VS.MatrixScaleBy <- function(f, m) {
            m = m[0];
            m[M_00] *= f;
            m[M_10] *= f;
            m[M_20] *= f;
            m[M_01] *= f;
            m[M_11] *= f;
            m[M_21] *= f;
            m[M_02] *= f;
            m[M_12] *= f;
            m[M_22] *= f
        }
        VS.MatrixScaleByZero <- function(m) {
            m = m[0];
            m[M_00] = m[M_10] = m[M_20] = m[M_01] = m[M_11] = m[M_21] = m[M_02] = m[M_12] = m[M_22] = 0.0
        }
        VS.SetIdentityMatrix <- function(m) {
            m = m[0];
            m[M_00] = m[M_11] = m[M_22] = 1.0;
            m[M_01] = m[M_02] = m[M_03] = m[M_10] = m[M_12] = m[M_13] = m[M_20] = m[M_21] = m[M_23] = 0.0
        }
        VS.SetScaleMatrix <- function(x, y, z, m) {
            m = m[0];
            m[M_00] = x;
            m[M_11] = y;
            m[M_22] = z;
            m[M_01] = m[M_02] = m[M_03] = m[M_10] = m[M_12] = m[M_13] = m[M_20] = m[M_21] = m[M_23] = 0.0
        }
        VS.ComputeCenterMatrix <- function(org, a, mins, maxs, m): (VectorRotate, AngleMatrix) {
            AngleMatrix(a, null, m);
            local v = VectorRotate((mins + maxs) * 0.5, m) + org;
            m = m[0];
            m[M_03] = v.x;
            m[M_13] = v.y;
            m[M_23] = v.z
        }
        VS.ComputeCenterIMatrix <- function(org, a, mins, maxs, m): (VectorRotate, AngleIMatrix) {
            AngleIMatrix(a, null, m);
            local v = (mins + maxs) * -0.5 - VectorRotate(org, m);
            m = m[0];
            m[M_03] = v.x;
            m[M_13] = v.y;
            m[M_23] = v.z
        }
        VS.ComputeAbsMatrix <- function(A, out): (fabs) {
            A = A[0];
            out = out[0];
            out[M_00] = fabs(A[M_00]);
            out[M_01] = fabs(A[M_01]);
            out[M_02] = fabs(A[M_02]);
            out[M_10] = fabs(A[M_10]);
            out[M_11] = fabs(A[M_11]);
            out[M_12] = fabs(A[M_12]);
            out[M_20] = fabs(A[M_20]);
            out[M_21] = fabs(A[M_21]);
            out[M_22] = fabs(A[M_22])
        }
        VS.ConcatRotations <- function(A, B, out) {
            local M_00 = M_00, M_01 = M_01, M_02 = M_02, M_10 = M_10, M_11 = M_11, M_12 = M_12, M_20 = M_20, M_21 = M_21, M_22 = M_22;
            A = A[M_00];
            B = B[M_00];
            out = out[M_00];
            local i2m00 = B[M_00], i2m01 = B[M_01], i2m02 = B[M_02], i2m10 = B[M_10], i2m11 = B[M_11], i2m12 = B[M_12], i2m20 = B[M_20], i2m21 = B[M_21], i2m22 = B[M_22], m0 = A[M_00] * i2m00 + A[M_01] * i2m10 + A[M_02] * i2m20, m1 = A[M_00] * i2m01 + A[M_01] * i2m11 + A[M_02] * i2m21, m2 = A[M_00] * i2m02 + A[M_01] * i2m12 + A[M_02] * i2m22;
            out[M_00] = m0;
            out[M_01] = m1;
            out[M_02] = m2;
            m0 = A[M_10] * i2m00 + A[M_11] * i2m10 + A[M_12] * i2m20;
            m1 = A[M_10] * i2m01 + A[M_11] * i2m11 + A[M_12] * i2m21;
            m2 = A[M_10] * i2m02 + A[M_11] * i2m12 + A[M_12] * i2m22;
            out[M_10] = m0;
            out[M_11] = m1;
            out[M_12] = m2;
            m0 = A[M_20] * i2m00 + A[M_21] * i2m10 + A[M_22] * i2m20;
            m1 = A[M_20] * i2m01 + A[M_21] * i2m11 + A[M_22] * i2m21;
            m2 = A[M_20] * i2m02 + A[M_21] * i2m12 + A[M_22] * i2m22;
            out[M_20] = m0;
            out[M_21] = m1;
            out[M_22] = m2
        }
        VS.ConcatTransforms <- function(A, B, out) {
            local M_00 = M_00, M_01 = M_01, M_02 = M_02, M_03 = M_03, M_10 = M_10, M_11 = M_11, M_12 = M_12, M_13 = M_13, M_20 = M_20, M_21 = M_21, M_22 = M_22, M_23 = M_23;
            A = A[M_00];
            B = B[M_00];
            out = out[M_00];
            local i2m00 = B[M_00], i2m01 = B[M_01], i2m02 = B[M_02], i2m03 = B[M_03], i2m10 = B[M_10], i2m11 = B[M_11], i2m12 = B[M_12], i2m13 = B[M_13], i2m20 = B[M_20], i2m21 = B[M_21], i2m22 = B[M_22], i2m23 = B[M_23], m0 = A[M_00] * i2m00 + A[M_01] * i2m10 + A[M_02] * i2m20, m1 = A[M_00] * i2m01 + A[M_01] * i2m11 + A[M_02] * i2m21, m2 = A[M_00] * i2m02 + A[M_01] * i2m12 + A[M_02] * i2m22, m3 = A[M_00] * i2m03 + A[M_01] * i2m13 + A[M_02] * i2m23 + A[M_03];
            out[M_00] = m0;
            out[M_01] = m1;
            out[M_02] = m2;
            out[M_03] = m3;
            m0 = A[M_10] * i2m00 + A[M_11] * i2m10 + A[M_12] * i2m20;
            m1 = A[M_10] * i2m01 + A[M_11] * i2m11 + A[M_12] * i2m21;
            m2 = A[M_10] * i2m02 + A[M_11] * i2m12 + A[M_12] * i2m22;
            m3 = A[M_10] * i2m03 + A[M_11] * i2m13 + A[M_12] * i2m23 + A[M_13];
            out[M_10] = m0;
            out[M_11] = m1;
            out[M_12] = m2;
            out[M_13] = m3;
            m0 = A[M_20] * i2m00 + A[M_21] * i2m10 + A[M_22] * i2m20;
            m1 = A[M_20] * i2m01 + A[M_21] * i2m11 + A[M_22] * i2m21;
            m2 = A[M_20] * i2m02 + A[M_21] * i2m12 + A[M_22] * i2m22;
            m3 = A[M_20] * i2m03 + A[M_21] * i2m13 + A[M_22] * i2m23 + A[M_23];
            out[M_20] = m0;
            out[M_21] = m1;
            out[M_22] = m2;
            out[M_23] = m3
        }
        VS.MatrixMultiply <- function(A, B, out) {
            local M_00 = M_00, M_01 = M_01, M_02 = M_02, M_03 = M_03, M_10 = M_10, M_11 = M_11, M_12 = M_12, M_13 = M_13, M_20 = M_20, M_21 = M_21, M_22 = M_22, M_23 = M_23, M_30 = M_30, M_31 = M_31, M_32 = M_32, M_33 = M_33;
            A = A[M_00];
            B = B[M_00];
            out = out[M_00];
            local i2m00 = B[M_00], i2m01 = B[M_01], i2m02 = B[M_02], i2m03 = B[M_03], i2m10 = B[M_10], i2m11 = B[M_11], i2m12 = B[M_12], i2m13 = B[M_13], i2m20 = B[M_20], i2m21 = B[M_21], i2m22 = B[M_22], i2m23 = B[M_23], i2m30 = B[M_30], i2m31 = B[M_31], i2m32 = B[M_32], i2m33 = B[M_33], m0 = A[M_00] * i2m00 + A[M_01] * i2m10 + A[M_02] * i2m20 + A[M_03] * i2m30, m1 = A[M_00] * i2m01 + A[M_01] * i2m11 + A[M_02] * i2m21 + A[M_03] * i2m31, m2 = A[M_00] * i2m02 + A[M_01] * i2m12 + A[M_02] * i2m22 + A[M_03] * i2m32, m3 = A[M_00] * i2m03 + A[M_01] * i2m13 + A[M_02] * i2m23 + A[M_03] * i2m33;
            out[M_00] = m0;
            out[M_01] = m1;
            out[M_02] = m2;
            out[M_03] = m3;
            m0 = A[M_10] * i2m00 + A[M_11] * i2m10 + A[M_12] * i2m20 + A[M_13] * i2m30;
            m1 = A[M_10] * i2m01 + A[M_11] * i2m11 + A[M_12] * i2m21 + A[M_13] * i2m31;
            m2 = A[M_10] * i2m02 + A[M_11] * i2m12 + A[M_12] * i2m22 + A[M_13] * i2m32;
            m3 = A[M_10] * i2m03 + A[M_11] * i2m13 + A[M_12] * i2m23 + A[M_13] * i2m33;
            out[M_10] = m0;
            out[M_11] = m1;
            out[M_12] = m2;
            out[M_13] = m3;
            m0 = A[M_20] * i2m00 + A[M_21] * i2m10 + A[M_22] * i2m20 + A[M_23] * i2m30;
            m1 = A[M_20] * i2m01 + A[M_21] * i2m11 + A[M_22] * i2m21 + A[M_23] * i2m31;
            m2 = A[M_20] * i2m02 + A[M_21] * i2m12 + A[M_22] * i2m22 + A[M_23] * i2m32;
            m3 = A[M_20] * i2m03 + A[M_21] * i2m13 + A[M_22] * i2m23 + A[M_23] * i2m33;
            out[M_20] = m0;
            out[M_21] = m1;
            out[M_22] = m2;
            out[M_23] = m3;
            m0 = A[M_30] * i2m00 + A[M_31] * i2m10 + A[M_32] * i2m20 + A[M_33] * i2m30;
            m1 = A[M_30] * i2m01 + A[M_31] * i2m11 + A[M_32] * i2m21 + A[M_33] * i2m31;
            m2 = A[M_30] * i2m02 + A[M_31] * i2m12 + A[M_32] * i2m22 + A[M_33] * i2m32;
            m3 = A[M_30] * i2m03 + A[M_31] * i2m13 + A[M_32] * i2m23 + A[M_33] * i2m33;
            out[M_30] = m0;
            out[M_31] = m1;
            out[M_32] = m2;
            out[M_33] = m3
        }
        VS.MatrixBuildRotationAboutAxis <- function(axis, ang, dst): (sin, cos) {
            ang = ang * DEG2RAD;
            local c = cos(ang); {
                local xx = axis.x * axis.x, yy = axis.y * axis.y, zz = axis.z * axis.z;
                dst = dst[0];
                dst[M_00] = xx + c - xx * c;
                dst[M_11] = yy + c - yy * c;
                dst[M_22] = zz + c - zz * c
            } {
                c = 1.0 - c;
                local xyc = axis.x * axis.y * c, yzc = axis.y * axis.z * c, xzc = axis.z * axis.x * c, s = sin(ang), xs = axis.x * s, ys = axis.y * s, zs = axis.z * s;
                dst[M_10] = xyc + zs;
                dst[M_20] = xzc - ys;
                dst[M_01] = xyc - zs;
                dst[M_21] = yzc + xs;
                dst[M_02] = xzc + ys;
                dst[M_12] = yzc - xs
            }
            dst[M_03] = dst[M_13] = dst[M_23] = 0.0
        }
        local MatrixBuildRotationAboutAxis = VS.MatrixBuildRotationAboutAxis;
        VS.MatrixBuildRotation <- function(m, v1, v2): (Vector, fabs, acos, MatrixBuildRotationAboutAxis) {
            local a = v1.Dot(v2);
            if (a > 0.999999) return SetIdentityMatrix(m);
            if (-0.999999 > a) {
                local v = Vector(), i = "x";
                if (fabs(v2.y) < fabs(v2[i])) i = "y";
                if (fabs(v2.z) < fabs(v2[i])) i = "z";
                v[i] = 1.0;
                local t = v.Dot(v2);
                v.x -= v2.x * t;
                v.y -= v2.y * t;
                v.z -= v2.z * t;
                v.Norm();
                return MatrixBuildRotationAboutAxis(v, 180.0, m)
            };
            local v = v1.Cross(v2);
            v.Norm();
            return MatrixBuildRotationAboutAxis(v, acos(a) * RAD2DEG, m)
        }
        VS.Vector3DMultiplyProjective <- function(A, B, dst) {
            A = A[0];
            local x = B.x, y = B.y, z = B.z, w = 1.0 / (A[M_30] * x + A[M_31] * y + A[M_32] * z);
            dst.x = w * (A[M_00] * x + A[M_01] * y + A[M_02] * z);
            dst.y = w * (A[M_10] * x + A[M_11] * y + A[M_12] * z);
            dst.z = w * (A[M_20] * x + A[M_21] * y + A[M_22] * z)
        }
        VS.Vector3DMultiplyPositionProjective <- function(A, B, dst) {
            A = A[0];
            local x = B.x, y = B.y, z = B.z, w = 1.0 / (A[M_30] * x + A[M_31] * y + A[M_32] * z + A[M_33]);
            dst.x = w * (A[M_00] * x + A[M_01] * y + A[M_02] * z + A[M_03]);
            dst.y = w * (A[M_10] * x + A[M_11] * y + A[M_12] * z + A[M_13]);
            dst.z = w * (A[M_20] * x + A[M_21] * y + A[M_22] * z + A[M_23])
        }
        VS.TransformAABB <- function(mat, minI, maxI, minO, maxO): (Vector, fabs, VectorAdd, VectorSubtract, VectorTransform) {
            local pl = (minI + maxI) * 0.5, el = maxI - pl, pw = VectorTransform(pl, mat);
            mat = mat[0];
            local ew = Vector(fabs(el.x * mat[M_00]) + fabs(el.y * mat[M_01]) + fabs(el.z * mat[M_02]), fabs(el.x * mat[M_10]) + fabs(el.y * mat[M_11]) + fabs(el.z * mat[M_12]), fabs(el.x * mat[M_20]) + fabs(el.y * mat[M_21]) + fabs(el.z * mat[M_22]));
            VectorSubtract(pw, ew, minO);
            VectorAdd(pw, ew, maxO)
        }
        VS.ITransformAABB <- function(mat, minI, maxI, minO, maxO): (Vector, fabs, VectorAdd, VectorSubtract, VectorITransform) {
            local pw = (minI + maxI) * 0.5, ew = maxI - pw, pl = VectorITransform(pw, mat);
            mat = mat[0];
            local el = Vector(fabs(ew.x * mat[M_00]) + fabs(ew.y * mat[M_10]) + fabs(ew.z * mat[M_20]), fabs(ew.x * mat[M_01]) + fabs(ew.y * mat[M_11]) + fabs(ew.z * mat[M_21]), fabs(ew.x * mat[M_02]) + fabs(ew.y * mat[M_12]) + fabs(ew.z * mat[M_22]));
            VectorSubtract(pl, el, minO);
            VectorAdd(pl, el, maxO)
        }
        VS.RotateAABB <- function(mat, minI, maxI, minO, maxO): (Vector, fabs, VectorAdd, VectorSubtract, VectorRotate) {
            local pl = (minI + maxI) * 0.5, el = maxI - pl, p1 = VectorRotate(pl, mat);
            mat = mat[0];
            local e1 = Vector(fabs(el.x * mat[M_00]) + fabs(el.y * mat[M_01]) + fabs(el.z * mat[M_02]), fabs(el.x * mat[M_10]) + fabs(el.y * mat[M_11]) + fabs(el.z * mat[M_12]), fabs(el.x * mat[M_20]) + fabs(el.y * mat[M_21]) + fabs(el.z * mat[M_22]));
            VectorSubtract(p1, e1, minO);
            VectorAdd(p1, e1, maxO)
        }
        VS.IRotateAABB <- function(mat, minI, maxI, minO, maxO): (Vector, fabs, VectorAdd, VectorSubtract, VectorIRotate) {
            local p0 = (minI + maxI) * 0.5, e0 = maxI - p0, p1 = VectorIRotate(p0, mat);
            mat = mat[0];
            local e1 = Vector(fabs(e0.x * mat[M_00]) + fabs(e0.y * mat[M_10]) + fabs(e0.z * mat[M_20]), fabs(e0.x * mat[M_01]) + fabs(e0.y * mat[M_11]) + fabs(e0.z * mat[M_21]), fabs(e0.x * mat[M_02]) + fabs(e0.y * mat[M_12]) + fabs(e0.z * mat[M_22]));
            VectorSubtract(p1, e1, minO);
            VectorAdd(p1, e1, maxO)
        }
        VS.GetBoxVertices <- function(org, ang, mins, maxs, pVx): (matrix3x4_t, Vector, VectorAdd, VectorRotate, AngleMatrix) {
            local v, rot = matrix3x4_t();
            AngleMatrix(ang, null, rot);
            v = pVx[0];
            v.x = mins.x;
            v.y = mins.y;
            v.z = mins.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v);
            v = pVx[1];
            v.x = maxs.x;
            v.y = mins.y;
            v.z = mins.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v);
            v = pVx[2];
            v.x = mins.x;
            v.y = maxs.y;
            v.z = mins.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v);
            v = pVx[3];
            v.x = maxs.x;
            v.y = maxs.y;
            v.z = mins.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v);
            v = pVx[4];
            v.x = mins.x;
            v.y = mins.y;
            v.z = maxs.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v);
            v = pVx[5];
            v.x = maxs.x;
            v.y = mins.y;
            v.z = maxs.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v);
            v = pVx[6];
            v.x = mins.x;
            v.y = maxs.y;
            v.z = maxs.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v);
            v = pVx[7];
            v.x = maxs.x;
            v.y = maxs.y;
            v.z = maxs.z;
            VectorRotate(v, rot, v);
            VectorAdd(v, org, v)
        }
        VS.MatrixBuildPerspective <- function(dst, fov, ar, zn, zf): (tan) {
            local w = -0.5 / tan(fov * DEG2RADDIV2), r = zf / (zn - zf);
            dst = dst[0];
            dst[M_01] = dst[M_03] = dst[M_10] = dst[M_13] = dst[M_20] = dst[M_21] = dst[M_30] = dst[M_31] = dst[M_33] = 0.0;
            dst[M_00] = w;
            dst[M_11] = w * ar;
            dst[M_02] = dst[M_12] = 0.5;
            dst[M_22] = -r;
            dst[M_32] = 1.0;
            dst[M_23] = zn * r
        }
        VS.MatrixBuildPerspectiveX <- function(dst, fov, ar, zn, zf): (tan) {
            local w = 1.0 / tan(fov * DEG2RAD), r = zf / (zn - zf);
            dst = dst[0];
            dst[M_01] = dst[M_02] = dst[M_03] = dst[M_10] = dst[M_12] = dst[M_13] = dst[M_20] = dst[M_21] = dst[M_30] = dst[M_31] = dst[M_33] = 0.0;
            dst[M_00] = w;
            dst[M_11] = w * ar;
            dst[M_22] = r;
            dst[M_32] = -1.0;
            dst[M_23] = zn * r
        }
        VS.ComputeCameraVariables <- function(vT, vF, vR, vU, m) {
            m = m[0];
            m[M_00] = vR.x;
            m[M_01] = vR.y;
            m[M_02] = vR.z;
            m[M_03] = -vR.Dot(vT);
            m[M_10] = vU.x;
            m[M_11] = vU.y;
            m[M_12] = vU.z;
            m[M_13] = -vU.Dot(vT);
            m[M_20] = -vF.x;
            m[M_21] = -vF.y;
            m[M_22] = -vF.z;
            m[M_23] = vF.Dot(vT);
            m[M_30] = m[M_31] = m[M_32] = 0.0;
            m[M_33] = 1.0
        }
        VS.WorldToScreenMatrix <- function(m, org, fw, rt, up, fov, ar, zn, zf): (VMatrix) {
            local v2p = VMatrix(), w2v = VMatrix();
            MatrixBuildPerspectiveX(v2p, fov * 0.5, ar, zn, zf);
            ComputeCameraVariables(org, fw, rt, up, w2v);
            MatrixMultiply(v2p, w2v, v2p);
            m = m[0];
            v2p = v2p[0];
            m[M_00] = v2p[M_00];
            m[M_01] = v2p[M_01];
            m[M_02] = v2p[M_02];
            m[M_03] = v2p[M_03];
            m[M_10] = v2p[M_10];
            m[M_11] = v2p[M_11];
            m[M_12] = v2p[M_12];
            m[M_13] = v2p[M_13];
            m[M_20] = v2p[M_20];
            m[M_21] = v2p[M_21];
            m[M_22] = v2p[M_22];
            m[M_23] = v2p[M_23];
            m[M_30] = v2p[M_30];
            m[M_31] = v2p[M_31];
            m[M_32] = v2p[M_32];
            m[M_33] = v2p[M_33]
        }
        local Vector3DMultiplyPositionProjective = VS.Vector3DMultiplyPositionProjective;
        VS.ScreenToWorld <- function(x, y, s2w, out = _VEC): (Vector, Vector3DMultiplyPositionProjective) {
            local v = Vector(2.0 * x - 1.0, 1.0 - 2.0 * y, 1.0);
            Vector3DMultiplyPositionProjective(s2w, v, out);
            return out
        }
        VS.WorldToScreen <- function(v, w2s, out = _VEC): (Vector, Vector3DMultiplyPositionProjective) {
            Vector3DMultiplyPositionProjective(w2s, v, out);
            local s = 0.5;
            out.x = s + out.x * s;
            out.y = s - out.y * s;
            return out
        }
        VS.CalcFovY <- function(v, ar): (tan, atan) {
            if (v < 1.0 || v > 179.0) v = 90.0;
            return atan(tan(DEG2RADDIV2 * v) / ar) * RAD2DEG2
        }
        VS.CalcFovX <- function(v, ar): (tan, atan) {
            return atan(tan(DEG2RADDIV2 * v) * ar) * RAD2DEG2
        }
        local initFD = function() {
            local Line = DebugDrawLine, mul = VS.Vector3DMultiplyPositionProjective, w1 = Vector(), w2 = Vector(), D = function(l1, l2, m, r, g, b, z, t): (Vector, mul, Line, w1, w2) {
                mul(m, l1, w1);
                mul(m, l2, w2);
                return Line(w1, w2, r, g, b, z, t)
            }
            local v000 = Vector(-1.0, -1.0, 0.0), v001 = Vector(-1.0, -1.0, 1.0), v011 = Vector(-1.0, 1.0, 1.0), v010 = Vector(-1.0, 1.0, 0.0), v100 = Vector(1.0, -1.0, 0.0), v101 = Vector(1.0, -1.0, 1.0), v111 = Vector(1.0, 1.0, 1.0), v110 = Vector(1.0, 1.0, 0.0), fr = [v000, v001, v001, v011, v011, v010, v010, v000, v100, v101, v101, v111, v111, v110, v110, v100, v000, v100, v001, v101, v011, v111, v010, v110];
            VS.DrawFrustum <- function(v2w, r, g, b, z, t): (D, fr) {
                D(fr[0], fr[1], v2w, r, g, b, z, t);
                D(fr[2], fr[3], v2w, r, g, b, z, t);
                D(fr[4], fr[5], v2w, r, g, b, z, t);
                D(fr[6], fr[7], v2w, r, g, b, z, t);
                D(fr[8], fr[9], v2w, r, g, b, z, t);
                D(fr[10], fr[11], v2w, r, g, b, z, t);
                D(fr[12], fr[13], v2w, r, g, b, z, t);
                D(fr[14], fr[15], v2w, r, g, b, z, t);
                D(fr[16], fr[17], v2w, r, g, b, z, t);
                D(fr[18], fr[19], v2w, r, g, b, z, t);
                D(fr[20], fr[21], v2w, r, g, b, z, t);
                return D(fr[22], fr[23], v2w, r, g, b, z, t)
            }
            local DrawFrustum = VS.DrawFrustum, WorldToScreenMatrix = VS.WorldToScreenMatrix, MatrixInverseGeneral = VS.MatrixInverseGeneral;
            VS.DrawViewFrustum <- function(vT, vF, vR, vU, fv, ar, zn, zf, r, g, b, z, tm): (VMatrix, WorldToScreenMatrix, MatrixInverseGeneral, DrawFrustum) {
                local m = VMatrix();
                WorldToScreenMatrix(m, vT, vF, vR, vU, fv, ar, zn, zf);
                MatrixInverseGeneral(m, m);
                return DrawFrustum(m, r, g, b, z, tm)
            }
        }
        VS.DrawFrustum <- function(m, r, g, b, z, t): (initFD) {
            initFD();
            return DrawFrustum(m, r, g, b, z, t)
        }
        VS.DrawViewFrustum <- function(vT, vF, vR, vU, fv, ar, zn, zf, r, g, b, z, tm): (initFD) {
            initFD();
            return DrawViewFrustum(vT, vF, vR, vU, fv, ar, zn, zf, r, g, b, z, tm)
        }
        local initBD = function() {
            local Line = DebugDrawLine, GetBoxVertices = VS.GetBoxVertices, pV = [Vector(), Vector(), Vector(), Vector(), Vector(), Vector(), Vector(), Vector()];
            VS.DrawBoxAngles <- function(p, n, x, a, r, g, b, z, tm): (pV, GetBoxVertices, Line) {
                GetBoxVertices(p, a, n, x, pV);
                local v0 = pV[0], v1 = pV[1], v2 = pV[2], v3 = pV[3], v4 = pV[4], v5 = pV[5], v6 = pV[6], v7 = pV[7];
                Line(v0, v1, r, g, b, z, tm);
                Line(v0, v2, r, g, b, z, tm);
                Line(v1, v3, r, g, b, z, tm);
                Line(v2, v3, r, g, b, z, tm);
                Line(v0, v4, r, g, b, z, tm);
                Line(v1, v5, r, g, b, z, tm);
                Line(v2, v6, r, g, b, z, tm);
                Line(v3, v7, r, g, b, z, tm);
                Line(v5, v7, r, g, b, z, tm);
                Line(v5, v4, r, g, b, z, tm);
                Line(v4, v6, r, g, b, z, tm);
                return Line(v7, v6, r, g, b, z, tm)
            }
        }
        VS.DrawBoxAngles <- function(p, n, x, a, r, g, b, z, tm): (initBD) {
            initBD();
            return DrawBoxAngles(p, n, x, a, r, g, b, z, tm)
        }
        local Line = DebugDrawLine;
        VS.DrawSphere <- function(pos, fRd, nTh, nPh, r, g, b, z, tm): (array, Vector, sin, cos, Line) {
            ++nTh;
            local pVx = array(nPh * nTh), i, j, c = 0;
            for (i = 0; i < nPh; ++i)
                for (j = 0; j < nTh; ++j) {
                    local u = j / (nTh - 1).tofloat(), v = i / (nPh - 1).tofloat(), th = PI2 * u, ph = PI * v, sp = fRd * sin(ph);
                    pVx[c++] = Vector(pos.x + (sp * cos(th)), pos.y + (sp * sin(th)), pos.z + (fRd * cos(ph)))
                }
            for (i = 0; i < nPh - 1; ++i)
                for (j = 0; j < nTh - 1; ++j) {
                    local x = nTh * i + j;
                    Line(pVx[x], pVx[x + nTh], r, g, b, z, tm);
                    Line(pVx[x], pVx[x + 1], r, g, b, z, tm)
                }
        }
        local initC = function() {
            local Line = DebugDrawLine, capPos = [-0.01, -0.01, 1.0, 0.51, 0.0, 0.86, 0.44, 0.25, 0.86, 0.25, 0.44, 0.86, -0.01, 0.51, 0.86, -0.26, 0.44, 0.86, -0.45, 0.25, 0.86, -0.51, 0.0, 0.86, -0.45, -0.26, 0.86, -0.26, -0.45, 0.86, -0.01, -0.51, 0.86, 0.25, -0.45, 0.86, 0.44, -0.26, 0.86, 0.86, 0.0, 0.51, 0.75, 0.43, 0.51, 0.43, 0.75, 0.51, -0.01, 0.86, 0.51, -0.44, 0.75, 0.51, -0.76, 0.43, 0.51, -0.87, 0.0, 0.51, -0.76, -0.44, 0.51, -0.44, -0.76, 0.51, -0.01, -0.87, 0.51, 0.43, -0.76, 0.51, 0.75, -0.44, 0.51, 1.0, 0.0, 0.01, 0.86, 0.5, 0.01, 0.49, 0.86, 0.01, -0.01, 1.0, 0.01, -0.51, 0.86, 0.01, -0.87, 0.5, 0.01, -1.0, 0.0, 0.01, -0.87, -0.5, 0.01, -0.51, -0.87, 0.01, -0.01, -1.0, 0.01, 0.49, -0.87, 0.01, 0.86, -0.51, 0.01, 1.0, 0.0, -0.02, 0.86, 0.5, -0.02, 0.49, 0.86, -0.02, -0.01, 1.0, -0.02, -0.51, 0.86, -0.02, -0.87, 0.5, -0.02, -1.0, 0.0, -0.02, -0.87, -0.5, -0.02, -0.51, -0.87, -0.02, -0.01, -1.0, -0.02, 0.49, -0.87, -0.02, 0.86, -0.51, -0.02, 0.86, 0.0, -0.51, 0.75, 0.43, -0.51, 0.43, 0.75, -0.51, -0.01, 0.86, -0.51, -0.44, 0.75, -0.51, -0.76, 0.43, -0.51, -0.87, 0.0, -0.51, -0.76, -0.44, -0.51, -0.44, -0.76, -0.51, -0.01, -0.87, -0.51, 0.43, -0.76, -0.51, 0.75, -0.44, -0.51, 0.51, 0.0, -0.87, 0.44, 0.25, -0.87, 0.25, 0.44, -0.87, -0.01, 0.51, -0.87, -0.26, 0.44, -0.87, -0.45, 0.25, -0.87, -0.51, 0.0, -0.87, -0.45, -0.26, -0.87, -0.26, -0.45, -0.87, -0.01, -0.51, -0.87, 0.25, -0.45, -0.87, 0.44, -0.26, -0.87, 0.0, 0.0, -1.0], capIdx = [0, 4, 16, 28, 40, 52, 64, 73, 70, 58, 46, 34, 22, 10, 0, -1, 0, 1, 13, 25, 37, 49, 61, 73, 67, 55, 43, 31, 19, 7, 0, -1, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 61, -1, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 49, -1, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 37, -1, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 25, -1, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 13, -1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1], capVtx = array(74), matRot = matrix3x4_t();
            VS.VectorMatrix(Vector(0, 0, 1), matRot);
            VS.DrawCapsule <- function(v0, v1, f, r, g, b, z, t): (capPos, capIdx, capVtx, Line, matRot, Vector, matrix3x4_t) {
                local vn = v0 - v1, vd = v1 - v0, matCap = matrix3x4_t();
                vn.Norm();
                VectorMatrix(vn, matCap);
                ConcatTransforms(matCap, matRot, matCap);
                for (local i = 0; i < 74; ++i) {
                    local j = i * 3;
                    local v = Vector(capPos[j], capPos[j + 1], capPos[j + 2]);
                    VectorRotate(v, matCap, v);
                    v *= f;
                    if (capPos[j + 2] > 0.0) v += vd;
                    capVtx[i] = v + v0
                }
                local i = 0;
                do {
                    local i0 = capIdx[i], i1 = capIdx[++i];
                    if (i1 == 0xFFFFFFFF) {
                        ++i;
                        continue
                    };
                    Line(capVtx[i0], capVtx[i1], r, g, b, z, t)
                } while (i != 114)
            }
        }
        VS.DrawCapsule <- function(v1, v2, fR, r, g, b, z, tm): (initC) {
            initC();
            return DrawCapsule(v1, v2, fR, r, g, b, z, tm)
        }
        VS.DrawHorzArrow <- function(v1, v2, fW, r, g, b, z, tm): (Line, Vector) {
            local vd = v2 - v1;
            vd.Norm();
            local vu = Vector(0, 0, 1), vr = vd.Cross(vu), rad = fW * 0.5, sr = vr * rad, sw = vr * fW, ep = v2 - vd * fW, p1 = v1 - sr, p2 = ep - sr, p3 = ep - sw, p4 = v2, p5 = ep + sw, p6 = ep + sr, p7 = v1 + sr;
            Line(p1, p2, r, g, b, z, tm);
            Line(p2, p3, r, g, b, z, tm);
            Line(p3, p4, r, g, b, z, tm);
            Line(p4, p5, r, g, b, z, tm);
            Line(p5, p6, r, g, b, z, tm);
            return Line(p6, p7, r, g, b, z, tm)
        }
        VS.DrawVertArrow <- function(v1, v2, fW, r, g, b, z, tm): (Line, Vector) {
            local vd = v2 - v1;
            vd.Norm();
            local vu = Vector(), vr = Vector(), rad = fW * 0.5;
            VectorVectors(vd, vr, vu);
            local ur = vu * rad, uw = vu * fW, ep = v2 - vd * fW, p1 = v1 - ur, p2 = ep - ur, p3 = ep - uw, p4 = v2, p5 = ep + uw, p6 = ep + ur, p7 = v1 + ur;
            Line(p1, p2, r, g, b, z, tm);
            Line(p2, p3, r, g, b, z, tm);
            Line(p3, p4, r, g, b, z, tm);
            Line(p4, p5, r, g, b, z, tm);
            Line(p5, p6, r, g, b, z, tm);
            return Line(p6, p7, r, g, b, z, tm)
        }
        local cplane_t = class {
            normal = null;
            dist = 0.0;
            type = 0;
            sindex = "";
            signbits = 0
        } {
            local QuaternionAngles = VS.QuaternionAngles, QuaternionSlerp = VS.QuaternionSlerp, VectorMA = VS.VectorMA, VectorLerp = VS.VectorLerp;
            enum INTERPOLATE {
                DEFAULT,
                CATMULL_ROM_NORMALIZEX,
                EASE_IN,
                EASE_OUT,
                EASE_INOUT,
                BSPLINE,
                LINEAR_INTERP,
                KOCHANEK_BARTELS,
                KOCHANEK_BARTELS_EARLY,
                KOCHANEK_BARTELS_LATE,
                SIMPLE_CUBIC,
                CATMULL_ROM,
                CATMULL_ROM_NORMALIZE,
                CATMULL_ROM_TANGENT,
                EXPONENTIAL_DECAY,
                HOLD
            }
            VS.Interpolator_GetKochanekBartelsParams <- function(typ, tbc) {
                switch (typ) {
                    case INTERPOLATE.KOCHANEK_BARTELS:
                        tbc[0] = 0.77;
                        tbc[1] = 0.0;
                        tbc[2] = 0.77;
                        break;
                    case INTERPOLATE.KOCHANEK_BARTELS_EARLY:
                        tbc[0] = 0.77;
                        tbc[1] = -1.0;
                        tbc[2] = 0.77;
                        break;
                    case INTERPOLATE.KOCHANEK_BARTELS_LATE:
                        tbc[0] = 0.77;
                        tbc[1] = 1.0;
                        tbc[2] = 0.77;
                        break;
                    default:
                        tbc[0] = tbc[1] = tbc[2] = 0.0;
                        break
                }
            }
            VS.Interpolator_CurveInterpolate <- function(typ, v0, v1, v2, v3, f, out): (sin) {
                out.x = out.y = out.z = 0.0;
                switch (typ) {
                    case INTERPOLATE.DEFAULT:
                    case INTERPOLATE.CATMULL_ROM_NORMALIZEX:
                        Catmull_Rom_Spline_NormalizeX(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.CATMULL_ROM:
                        Catmull_Rom_Spline(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.CATMULL_ROM_NORMALIZE:
                        Catmull_Rom_Spline_Normalize(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.CATMULL_ROM_TANGENT:
                        Catmull_Rom_Spline_Tangent(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.EASE_IN:
                        f = sin(f * PIDIV2);
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.EASE_OUT:
                        f = 1.0 - sin(f * PIDIV2 + PIDIV2);
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.EASE_INOUT:
                        f = SimpleSpline(f);
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.LINEAR_INTERP:
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.KOCHANEK_BARTELS:
                    case INTERPOLATE.KOCHANEK_BARTELS_EARLY:
                    case INTERPOLATE.KOCHANEK_BARTELS_LATE:
                        local tbc = [null, null, null];
                        Interpolator_GetKochanekBartelsParams(typ, tbc);
                        Kochanek_Bartels_Spline_NormalizeX(tbc[0], tbc[1], tbc[2], v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.SIMPLE_CUBIC:
                        Cubic_Spline_NormalizeX(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.BSPLINE:
                        BSpline(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.EXPONENTIAL_DECAY:
                        local dt = v2.x - v1.x;
                        if (dt > 0.0) {
                            f = 1.0 - ExponentialDecay(0.001, dt, f * dt);
                            out.y = v1.y + f * (v2.y - v1.y)
                        } else out.y = v1.y;
                        break;
                    case INTERPOLATE.HOLD:
                        out.y = v1.y;
                        break;
                    default:
                        Msg(format("Unknown interpolation type %d\n", typ))
                }
            }
            VS.Interpolator_CurveInterpolate_NonNormalized <- function(typ, v0, v1, v2, v3, f, out): (sin) {
                out.x = out.y = out.z = 0.0;
                switch (typ) {
                    case INTERPOLATE.CATMULL_ROM_NORMALIZEX:
                    case INTERPOLATE.DEFAULT:
                    case INTERPOLATE.CATMULL_ROM:
                    case INTERPOLATE.CATMULL_ROM_NORMALIZE:
                    case INTERPOLATE.CATMULL_ROM_TANGENT:
                        Catmull_Rom_Spline(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.EASE_IN:
                        f = sin(f * PIDIV2);
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.EASE_OUT:
                        f = 1.0 - sin(f * PIDIV2 + PIDIV2);
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.EASE_INOUT:
                        f = SimpleSpline(f);
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.LINEAR_INTERP:
                        VectorLerp(v1, v2, f, out);
                        break;
                    case INTERPOLATE.KOCHANEK_BARTELS:
                    case INTERPOLATE.KOCHANEK_BARTELS_EARLY:
                    case INTERPOLATE.KOCHANEK_BARTELS_LATE:
                        local tbc = [null, null, null];
                        Interpolator_GetKochanekBartelsParams(typ, tbc);
                        Kochanek_Bartels_Spline(tbc[0], tbc[1], tbc[2], v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.SIMPLE_CUBIC:
                        Cubic_Spline(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.BSPLINE:
                        BSpline(v0, v1, v2, v3, f, out);
                        break;
                    case INTERPOLATE.EXPONENTIAL_DECAY:
                        local dt = v2.x - v1.x;
                        if (dt > 0.0) {
                            f = 1.0 - ExponentialDecay(0.001, dt, f * dt);
                            out.y = v1.y + f * (v2.y - v1.y)
                        } else out.y = v1.y;
                        break;
                    case INTERPOLATE.HOLD:
                        out.y = v1.y;
                        break;
                    default:
                        Msg(format("Unknown interpolation type %d\n", typ))
                }
            }
            VS.Spline_Normalize <- function(p1, p2, p3, p4, p1n, p4n): (VectorLerp) {
                local dt = p3.x - p2.x;
                p1n.x = p1.x;
                p1n.y = p1.y;
                p1n.z = p1.z;
                p4n.x = p4.x;
                p4n.y = p4.y;
                p4n.z = p4.z;
                if (dt) {
                    if (p1.x != p2.x) VectorLerp(p2, p1, dt / (p2.x - p1.x), p1n);
                    if (p4.x != p3.x) VectorLerp(p3, p4, dt / (p4.x - p3.x), p4n)
                }
            }
            local Spline_Normalize = VS.Spline_Normalize;
            VS.Catmull_Rom_Spline <- function(p1, p2, p3, p4, t, out) {
                local th = t * 0.5, t2 = t * th, t3 = t * t2, a = -t3 + 2.0 * t2 - th, b = 3.0 * t3 - 5.0 * t2 + 1.0, c = -3.0 * t3 + 4.0 * t2 + th, d = t3 - t2;
                out.x = a * p1.x + b * p2.x + c * p3.x + d * p4.x;
                out.y = a * p1.y + b * p2.y + c * p3.y + d * p4.y;
                out.z = a * p1.z + b * p2.z + c * p3.z + d * p4.z
            }
            local Catmull_Rom_Spline = VS.Catmull_Rom_Spline;
            VS.Catmull_Rom_Spline_Tangent <- function(p1, p2, p3, p4, t, out) {
                local t3 = 1.5 * t * t, a = -t3 + 2.0 * t - 0.5, b = 3.0 * t3 - 5.0 * t, c = -3.0 * t3 + 4.0 * t + 0.5, d = t3 - t;
                out.x = a * p1.x + b * p2.x + c * p3.x + d * p4.x;
                out.y = a * p1.y + b * p2.y + c * p3.y + d * p4.y;
                out.z = a * p1.z + b * p2.z + c * p3.z + d * p4.z
            }
            VS.Catmull_Rom_Spline_Integral <- function(p1, p2, p3, p4, t, out) {
                local tt = t * t, ttt = tt * t;
                local o = p2 * t - (p1 - p3) * (tt * 0.25) + (p1 * 2.0 - p2 * 5.0 + p3 * 4.0 - p4) * (ttt * 0.166667) - (p1 - p2 * 3.0 + p3 * 3.0 - p4) * (ttt * t * 0.125);
                out.x = o.x;
                out.y = o.y;
                out.z = o.z
            }
            VS.Catmull_Rom_Spline_Integral2 <- function(p1, p2, p3, p4, out) {
                local o = ((p2 + p3) * 3.25 - (p1 + p4) * 0.25) * 0.166667;
                out.x = o.x;
                out.y = o.y;
                out.z = o.z
            }
            VS.Catmull_Rom_Spline_Normalize <- function(p1, p2, p3, p4, t, out): (VectorMA, Catmull_Rom_Spline) {
                local dt = (p3 - p2).Length(), p1n = p1 - p2, p4n = p4 - p3;
                p1n.Norm();
                p4n.Norm();
                VectorMA(p2, dt, p1n, p1n);
                VectorMA(p3, dt, p4n, p4n);
                return Catmull_Rom_Spline(p1n, p2, p3, p4n, t, out)
            }
            VS.Catmull_Rom_Spline_Integral_Normalize <- function(p1, p2, p3, p4, t, out): (VectorMA) {
                local dt = (p3 - p2).Length(), p1n = p1 - p2, p4n = p4 - p3;
                p1n.Norm();
                p4n.Norm();
                VectorMA(p2, dt, p1n, p1n);
                VectorMA(p3, dt, p4n, p4n);
                return Catmull_Rom_Spline_Integral(p1n, p2, p3, p4n, t, out)
            }
            VS.Catmull_Rom_Spline_NormalizeX <- function(p1, p2, p3, p4, t, out): (Vector, Spline_Normalize, Catmull_Rom_Spline) {
                local p1n = Vector(), p4n = Vector();
                Spline_Normalize(p1, p2, p3, p4, p1n, p4n);
                return Catmull_Rom_Spline(p1n, p2, p3, p4n, t, out)
            }
            VS.Hermite_Spline <- function(p1, p2, d1, d2, t, out) {
                local t2 = t * t, t3 = t * t2, b1 = 2.0 * t3 - 3.0 * t2 + 1.0, b2 = 1.0 - b1, b3 = t3 - 2.0 * t2 + t, b4 = t3 - t2;
                out.x = b1 * p1.x + b2 * p2.x + b3 * d1.x + b4 * d2.x;
                out.y = b1 * p1.y + b2 * p2.y + b3 * d1.y + b4 * d2.y;
                out.z = b1 * p1.z + b2 * p2.z + b3 * d1.z + b4 * d2.z
            }
            VS.Hermite_SplineF <- function(p1, p2, d1, d2, t) {
                local t2 = t * t, t3 = t * t2, b1 = 2.0 * t3 - 3.0 * t2 + 1.0;
                return b1 * p1 + (1.0 - b1) * p2 + (t3 - 2.0 * t2 + t) * d1 + (t3 - t2) * d2
            }
            local Hermite_Spline = VS.Hermite_Spline, Hermite_SplineF = VS.Hermite_SplineF;
            VS.Hermite_Spline3V <- function(p0, p1, p2, t, out): (Hermite_Spline) {
                return Hermite_Spline(p1, p2, p1 - p0, p2 - p1, t, out)
            }
            VS.Hermite_Spline3F <- function(p0, p1, p2, t): (Hermite_SplineF) {
                return Hermite_SplineF(p1, p2, p1 - p0, p2 - p1, t)
            }
            local Hermite_Spline3F = VS.Hermite_Spline3F;
            VS.Hermite_Spline3Q <- function(q0, q1, q2, t, out): (Quaternion, QuaternionAlign, QuaternionNormalize, Hermite_Spline3F) {
                local q0a = Quaternion(), q1a = Quaternion();
                QuaternionAlign(q2, q0, q0a);
                QuaternionAlign(q2, q1, q1a);
                out.x = Hermite_Spline3F(q0a.x, q1a.x, q2.x, t);
                out.y = Hermite_Spline3F(q0a.y, q1a.y, q2.y, t);
                out.z = Hermite_Spline3F(q0a.z, q1a.z, q2.z, t);
                out.w = Hermite_Spline3F(q0a.w, q1a.w, q2.w, t);
                QuaternionNormalize(out)
            }
            VS.Kochanek_Bartels_Spline <- function(fT, fB, fC, p1, p2, p3, p4, t, o) {
                local ONE = 1.0, ffa = (ONE - fT) * (ONE + fC) * (ONE + fB), ffb = (ONE - fT) * (ONE - fC) * (ONE - fB), ffc = (ONE - fT) * (ONE - fC) * (ONE + fB), ffd = (ONE - fT) * (ONE + fC) * (ONE - fB), th = t * 0.5, t2 = t * th, t3 = t * t2, a = t3 * -ffa + t2 * 2.0 * ffa - th * ffa, b = t3 * (4.0 + ffa - ffb - ffc) + t2 * (-6.0 - 2.0 * ffa + 2.0 * ffb + ffc) + th * (ffa - ffb) + ONE, c = t3 * (-4.0 + ffb + ffc - ffd) + t2 * (6.0 - 2.0 * ffb - ffc + ffd) + th * ffb, d = t3 * ffd - t2 * ffd;
                o.x = a * p1.x + b * p2.x + c * p3.x + d * p4.x;
                o.y = a * p1.y + b * p2.y + c * p3.y + d * p4.y;
                o.z = a * p1.z + b * p2.z + c * p3.z + d * p4.z
            }
            local Kochanek_Bartels_Spline = VS.Kochanek_Bartels_Spline;
            VS.Kochanek_Bartels_Spline_NormalizeX <- function(fT, fB, fC, p1, p2, p3, p4, t, out): (Vector, Spline_Normalize, Kochanek_Bartels_Spline) {
                local p1n = Vector(), p4n = Vector();
                Spline_Normalize(p1, p2, p3, p4, p1n, p4n);
                return Kochanek_Bartels_Spline(fT, fB, fC, p1n, p2, p3, p4n, t, out)
            }
            VS.Cubic_Spline <- function(p1, p2, p3, p4, t, out) {
                local t2 = t * t, t3 = t * t2, b = t3 * 2.0 - t2 * 3.0 + 1.0, c = t3 * -2.0 + t2 * 3.0;
                out.x = b * p2.x + c * p3.x;
                out.y = b * p2.y + c * p3.y;
                out.z = b * p2.z + c * p3.z
            }
            local Cubic_Spline = VS.Cubic_Spline;
            VS.Cubic_Spline_NormalizeX <- function(p1, p2, p3, p4, t, out): (Vector, Spline_Normalize, Cubic_Spline) {
                local p1n = Vector(), p4n = Vector();
                Spline_Normalize(p1, p2, p3, p4, p1n, p4n);
                return Cubic_Spline(p1n, p2, p3, p4n, t, out)
            }
            VS.BSpline <- function(p1, p2, p3, p4, t, out) {
                local th = t * 0.166667, t2 = t * th, t3 = t * t2, a = -t3 + t2 * 3.0 - th * 3.0 + 0.166667, b = t3 * 3.0 - t2 * 6.0 + 0.666668, c = t3 * -3.0 + t2 * 3.0 + th * 3.0 + 0.166667;
                out.x = a * p1.x + b * p2.x + c * p3.x + t3 * p4.x;
                out.y = a * p1.y + b * p2.y + c * p3.y + t3 * p4.y;
                out.z = a * p1.z + b * p2.z + c * p3.z + t3 * p4.z
            }
            local BSpline = VS.BSpline;
            VS.BSpline_NormalizeX <- function(p1, p2, p3, p4, t, out): (Vector, Spline_Normalize, BSpline) {
                local p1n = Vector(), p4n = Vector();
                Spline_Normalize(p1, p2, p3, p4, p1n, p4n);
                return BSpline(p1n, p2, p3, p4n, t, out)
            }
            VS.Parabolic_Spline <- function(p1, p2, p3, p4, t, out) {
                local th = t * 0.5, t2 = t * th, a = t2 - t + 0.5, b = t2 * -2.0 + t + 0.5;
                out.x = a * p1.x + b * p2.x + t2 * p3.x;
                out.y = a * p1.y + b * p2.y + t2 * p3.y;
                out.z = a * p1.z + b * p2.z + t2 * p3.z
            }
            local Parabolic_Spline = VS.Parabolic_Spline;
            VS.Parabolic_Spline_NormalizeX <- function(p1, p2, p3, p4, t, out): (Vector, Spline_Normalize, Parabolic_Spline) {
                local p1n = Vector(), p4n = Vector();
                Spline_Normalize(p1, p2, p3, p4, p1n, p4n);
                return Parabolic_Spline(p1n, p2, p3, p4n, t, out)
            }
            VS.RangeCompressor <- function(v, lo, hi, bs): (Hermite_SplineF) {
                if (bs < lo) bs = lo;
                else if (bs > hi) bs = hi;;
                local mid = (bs + v - lo) / (hi - lo), targ = mid * 2.0 - 1.0;
                local fAbs;
                if (targ < 0.0) fAbs = -targ;
                else fAbs = targ;
                if (fAbs > 0.75) {
                    local t = (fAbs - 0.75) / 1.25;
                    if (t < 1.0) {
                        if (targ > 0.0) targ = Hermite_SplineF(0.75, 1.0, 0.75, 0.0, t);
                        else targ = -Hermite_SplineF(0.75, 1.0, 0.75, 0.0, t)
                    } else {
                        if (0.0 < targ) targ = 1.0;
                        else targ = -1.0
                    }
                };
                mid = (targ + 1.0) * 0.5;
                return (lo * (1.0 - mid) + hi * mid) - bs
            }
            VS.InterpolateAngles <- function(v1, v2, t, out = _VEC): (Quaternion, AngleQuaternion, QuaternionAngles, QuaternionSlerp) {
                if (v1 == v2) return v1;
                local q = Quaternion(), p = Quaternion();
                AngleQuaternion(v1, q);
                AngleQuaternion(v2, p);
                local r = QuaternionSlerp(q, p, t);
                return QuaternionAngles(r, out)
            }
        }
        VS.PointOnLineNearestPoint <- function(vs, ve, p) {
            local v1 = ve - vs, d = v1.Dot(p - vs) / v1.LengthSqr();
            if (d <= 0.0) return vs;
            if (d >= 1.0) return ve;
            return vs + v1 * d
        }
        VS.CalcSqrDistanceToAABB <- function(mins, maxs, pt) {
            local dt, d = 0.0;
            if (pt.x < mins.x) {
                dt = mins.x - pt.x;
                d += dt * dt
            } else if (pt.x > maxs.x) {
                dt = pt.x - maxs.x;
                d += dt * dt
            };;
            if (pt.y < mins.y) {
                dt = mins.y - pt.y;
                d += dt * dt
            } else if (pt.y > maxs.y) {
                dt = pt.y - maxs.y;
                d += dt * dt
            };;
            if (pt.z < mins.z) {
                dt = mins.z - pt.z;
                d += dt * dt
            } else if (pt.z > maxs.z) {
                dt = pt.z - maxs.z;
                d += dt * dt
            };;
            return d
        }
        VS.CalcClosestPointOnAABB <- function(mins, maxs, pt, out = _VEC) {
            if (pt.x < mins.x) out.x = mins.x;
            else if (maxs.x < pt.x) out.x = maxs.x;
            else out.x = pt.x;;
            if (pt.y < mins.y) out.y = mins.y;
            else if (maxs.y < pt.y) out.y = maxs.y;
            else out.y = pt.y;;
            if (pt.z < mins.z) out.z = mins.z;
            else if (maxs.z < pt.z) out.z = maxs.z;
            else out.z = pt.z;;
            return out
        }
        local Ray_t = class {
            m_Start = null;
            m_Delta = null;
            m_StartOffset = null;
            m_Extents = null;
            m_IsRay = null;
            m_IsSwept = null;

            function Init(v1, v2, mins = null, maxs = null): (Vector) {
                m_Delta = v2 - v1;
                m_IsSwept = m_Delta.LengthSqr() != 0.0;
                if (mins) {
                    m_Extents = (maxs - mins) * 0.5;
                    m_IsRay = m_Extents.LengthSqr() < 1.e-6;
                    m_StartOffset = (mins + maxs) * -0.5;
                    m_Start = v1 - m_StartOffset
                } else {
                    m_Extents = Vector();
                    m_IsRay = true;
                    m_StartOffset = Vector();
                    m_Start = v1 * 1.0
                }
            }
        }
        local trace_t = class {
            startpos = null;
            endpos = null;
            fraction = 1.0;
            allsolid = false;
            startsolid = false;
            fractionleftsolid = 0.0;
            plane = null;
            constructor(): (cplane_t) {
                plane = cplane_t()
            }
        }
        VS.ComputeBoxOffset <- function(ray): (fabs) {
            if (ray.m_IsRay) return 1.e-3;
            local f = fabs(ray.m_Extents.x * ray.m_Delta.x) + fabs(ray.m_Extents.y * ray.m_Delta.y) + fabs(ray.m_Extents.z * ray.m_Delta.z), l = ray.m_Delta.LengthSqr();
            if (l >= 1.0) return (f / l) + 1.e-3;
            return f + 1.e-3
        }
        local ComputeBoxOffset = VS.ComputeBoxOffset;
        VS.IntersectRayWithTriangle <- function(ray, v1, v2, v3, b1): (ComputeBoxOffset) {
            local ed1 = v2 - v1, ed2 = v3 - v1;
            if (b1) {
                local n = ed1.Cross(ed2);
                if (n.Dot(ray.m_Delta) >= 0.0) return 0xFFFFFFFF
            };
            local dXe2 = ray.m_Delta.Cross(ed2);
            local fd = dXe2.Dot(ed1);
            if (fd < 1.e-6 && fd > -1.e-6) return 0xFFFFFFFF;
            fd = 1.0 / fd;
            local org = ray.m_Start - v1;
            local u = dXe2.Dot(org) * fd;
            if ((u < 0.0) || (u > 1.0)) return 0xFFFFFFFF;
            local oXe1 = org.Cross(ed1);
            local v = oXe1.Dot(ray.m_Delta) * fd;
            if ((v < 0.0) || (v + u > 1.0)) return 0xFFFFFFFF;
            local boxt = 1.e-3;
            if (!ray.m_IsRay) boxt = ComputeBoxOffset(ray);
            local t = oXe1.Dot(ed2) * fd;
            if ((-boxt > t) || (t > 1.0 + boxt)) return 0xFFFFFFFF;
            if (t < 0.0) return 0.0;
            if (t > 1.0) return 1.0;
            return t
        }
        VS.ComputeIntersectionBarycentricCoordinates <- function(ray, v1, v2, v3, uvt): (ComputeBoxOffset) {
            local ed1 = v2 - v1, ed2 = v3 - v1;
            local dXe2 = ray.m_Delta.Cross(ed2);
            local fd = dXe2.Dot(ed1);
            if (fd < 1.e-6 && fd > -1.e-6) return false;
            fd = 1.0 / fd;
            local org = ray.m_Start - v1;
            uvt[0] = dXe2.Dot(org) * fd;
            local oXe1 = org.Cross(ed1);
            uvt[1] = oXe1.Dot(ray.m_Delta) * fd;
            local boxt = 1.e-3;
            if (!ray.m_IsRay) boxt = ComputeBoxOffset(ray);
            local t = uvt[2] = oXe1.Dot(ed2) * fd;
            if ((-boxt > t) || (t > 1.0 + boxt)) return false;
            return true
        }
        VS.IsPointInBox <- function(v, n, x) {
            return (v.x >= n.x && v.x <= x.x && v.y >= n.y && v.y <= x.y && v.z >= n.z && v.z <= x.z)
        }
        VS.IsBoxIntersectingBox <- function(n1, x1, n2, x2) {
            if ((n1.x > x2.x) || (x1.x < n2.x)) return false;
            if ((n1.y > x2.y) || (x1.y < n2.y)) return false;
            if ((n1.z > x2.z) || (x1.z < n2.z)) return false;
            return true
        }
        VS.IsPointInCone <- function(pt, org, vx, c, l) {
            local dt = pt - org, s = dt.Norm(), dot = dt.Dot(vx);
            if (dot < c) return false;
            if (s * dot > l) return false;
            return true
        }
        VS.IsSphereIntersectingSphere <- function(v1, r1, v2, r2) {
            r2 = r1 + r2;
            return (v2 - v1).LengthSqr() <= (r2 * r2)
        }
        VS.IsBoxIntersectingSphere <- function(mins, maxs, pt, rad) {
            local dt;
            if (pt.x < mins.x) dt = pt.x - mins.x;
            else if (pt.x > maxs.x) dt = maxs.x - pt.x;;
            if (pt.y < mins.y) dt = pt.y - mins.y;
            else if (pt.y > maxs.y) dt = maxs.y - pt.y;;
            if (pt.z < mins.z) dt = pt.z - mins.z;
            else if (pt.z > maxs.z) dt = maxs.z - pt.z;;
            return dt * dt < rad * rad
        }
        VS.IsCircleIntersectingRectangle <- function(mins, maxs, pt, rad) {
            local dt;
            if (pt.x < mins.x) dt = pt.x - mins.x;
            else if (pt.x > maxs.x) dt = maxs.x - pt.x;;
            if (pt.y < mins.y) dt = pt.y - mins.y;
            else if (pt.y > maxs.y) dt = maxs.y - pt.y;;
            return dt * dt < rad * rad
        }
        VS.IsRayIntersectingSphere <- function(vO, vDt, vPt, r, tol = 0.0) {
            r += tol;
            local r2s = vPt - vO, num = r2s.Dot(vDt), t = 0.0;
            if (t < num) {
                local den = vDt.LengthSqr();
                if (num > den) t = 1.0;
                else t = num / den
            };
            return (vO + vDt * t - vPt).LengthSqr() <= r * r
        }
        VS.IntersectInfiniteRayWithSphere <- function(vO, vDt, vPt, r, pT): (sqrt) {
            local s2r = vO - vPt, a = vDt.LengthSqr();
            if (a) {
                local b = 2.0 * s2r.Dot(vDt), c = s2r.LengthSqr() - r * r, ds = b * b - 4.0 * a * c;
                if (ds < 0.0) return false;
                ds = sqrt(ds);
                local oo2a = 0.5 / a;
                pT[0] = (-ds - b) * oo2a;
                pT[1] = (ds - b) * oo2a;
                return true
            };
            pT[0] = pT[1] = 0.0;
            return s2r.LengthSqr() <= r * r
        }
        VS.IsBoxIntersectingRay <- function(mins, maxs, org, vDt, tol = 0.0) {
            local tmin = FLT_MAX_N, tmax = FLT_MAX, EPS = 1.e-8;
            if (vDt.x < EPS && vDt.x > -EPS) {
                if ((org.x < mins.x - tol) || (org.x > maxs.x + tol)) return false
            } else {
                local idt = 1.0 / vDt.x, t1 = (mins.x - tol - org.x) * idt, t2 = (maxs.x + tol - org.x) * idt;
                if (t1 > t2) {
                    local tmp = t1;
                    t1 = t2;
                    t2 = tmp
                };
                if (t1 > tmin) tmin = t1;
                if (t2 < tmax) tmax = t2;
                if (tmin > tmax) return false;
                if (tmax < 0.0) return false;
                if (tmin > 1.0) return false
            };
            if (vDt.y < EPS && vDt.y > -EPS) {
                if ((org.y < mins.y - tol) || (org.y > maxs.y + tol)) return false
            } else {
                local idt = 1.0 / vDt.y, t1 = (mins.y - tol - org.y) * idt, t2 = (maxs.y + tol - org.y) * idt;
                if (t1 > t2) {
                    local tmp = t1;
                    t1 = t2;
                    t2 = tmp
                };
                if (t1 > tmin) tmin = t1;
                if (t2 < tmax) tmax = t2;
                if (tmin > tmax) return false;
                if (tmax < 0.0) return false;
                if (tmin > 1.0) return false
            };
            if (vDt.z < EPS && vDt.z > -EPS) {
                if ((org.z < mins.z - tol) || (org.z > maxs.z + tol)) return false
            } else {
                local idt = 1.0 / vDt.z, t1 = (mins.z - tol - org.z) * idt, t2 = (maxs.z + tol - org.z) * idt;
                if (t1 > t2) {
                    local tmp = t1;
                    t1 = t2;
                    t2 = tmp
                };
                if (t1 > tmin) tmin = t1;
                if (t2 < tmax) tmax = t2;
                if (tmin > tmax) return false;
                if (tmax < 0.0) return false;
                if (tmin > 1.0) return false
            };
            return true
        }
        local IsBoxIntersectingRay = VS.IsBoxIntersectingRay;
        VS.IsBoxIntersectingRay2 <- function(org, mins, maxs, ray, tol = 0.0): (IsBoxIntersectingRay) {
            if (ray.m_IsSwept) return IsBoxIntersectingRay(org + mins - ray.m_Extents, org + maxs + ray.m_Extents, ray.m_Start, ray.m_Delta, tol);
            local rayMins = ray.m_Start - ray.m_Extents, rayMaxs = ray.m_Start + ray.m_Extents;
            if (tol) {
                rayMins.x -= tol;
                rayMins.y -= tol;
                rayMins.z -= tol;
                rayMaxs.x += tol;
                rayMaxs.y += tol;
                rayMaxs.z += tol
            };
            return IsBoxIntersectingBox(mins, maxs, rayMins, rayMaxs)
        }
        VS.IntersectRayWithRay <- function(v0, d0, v1, d1, pT) {
            local v0xv1 = d0.Cross(d1), lsq = v0xv1.LengthSqr();
            if (lsq) {
                local p1p0 = v1 - v0, AxC = p1p0.Cross(v0xv1);
                AxC.x = -AxC.x;
                AxC.y = -AxC.y;
                AxC.z = -AxC.z;
                local detT = AxC.Dot(d1);
                AxC = p1p0.Cross(v0xv1);
                AxC.x = -AxC.x;
                AxC.y = -AxC.y;
                AxC.z = -AxC.z;
                local detS = AxC.Dot(d0);
                local invL = 1.0 / lsq, t = detT * invL, s = detS * invL;
                pT[0] = t;
                pT[1] = s;
                local i0 = v0 + d0 * t;
                local i1 = v1 + d1 * s;
                return (i0.x == i1.x && i0.y == i1.y && i0.z == i1.z)
            };
            pT[0] = pT[1] = 0.0;
            return false
        }
        VS.IntersectRayWithPlane <- function(org, dir, n, dist) {
            local d = dir.Dot(n);
            if (d) return (dist - org.Dot(n)) / d;
            return 0.0
        }
        VS.IntersectRayWithBox <- function(v1, vDt, mins, maxs, tol, tr) {
            local Z = 0.0, f, d1, d2, t2 = 1.0, t1 = -t2, hs = -1, ss = true;
            for (local i = 0; i < 6; ++i) {
                switch (i) {
                    case 0:
                        d1 = mins.x - v1.x;
                        d2 = d1 - vDt.x;
                        break;
                    case 1:
                        d1 = mins.y - v1.y;
                        d2 = d1 - vDt.y;
                        break;
                    case 2:
                        d1 = mins.z - v1.z;
                        d2 = d1 - vDt.z;
                        break;
                    case 3:
                        d1 = v1.x - maxs.x;
                        d2 = d1 + vDt.x;
                        break;
                    case 4:
                        d1 = v1.y - maxs.y;
                        d2 = d1 + vDt.y;
                        break;
                    case 5:
                        d1 = v1.z - maxs.z;
                        d2 = d1 + vDt.z;
                        break
                }
                if (d1 > Z && d2 > Z) {
                    if (2 in tr) tr[2] = false;
                    return false
                };
                if (d1 <= Z && d2 <= Z) continue;
                if (d1 > Z) ss = false;
                if (d1 > d2) {
                    f = d1 - tol;
                    if (f < Z) f = Z;
                    f /= (d1 - d2);
                    if (f > t1) {
                        t1 = f;
                        hs = i
                    }
                } else {
                    f = (d1 + tol) / (d1 - d2);
                    if (f < t2) t2 = f
                }
            }
            tr[0] = t1;
            tr[1] = t2;
            if (2 in tr) {
                tr[2] = ss;
                tr[3] = hs
            };
            return ss || (t1 < t2 && t1 >= Z)
        }
        local IntersectRayWithBox = VS.IntersectRayWithBox;
        VS.ClipRayToBox <- function(rayStart, rayDelta, mins, maxs, tol, pT): (IntersectRayWithBox) {
            pT.startpos = rayStart;
            pT.endpos = rayStart + rayDelta;
            pT.fraction = 1.0;
            pT.startsolid = pT.allsolid = false;
            local tr = [0.0, 0.0, 0, false];
            if (IntersectRayWithBox(rayStart, rayDelta, mins, maxs, tol, tr)) {
                local plane = pT.plane;
                pT.startsolid = tr[2];
                if (tr[0] < tr[1] && tr[0] >= 0.0) {
                    pT.fraction = tr[0];
                    VectorMA(pT.startpos, tr[0], rayDelta, pT.endpos);
                    plane.normal = Vector();
                    if (tr[3] >= 3) {
                        local hitside = tr[3] - 3;
                        local i = ('x' + hitside).tochar();
                        plane.type = hitside;
                        plane.sindex = i;
                        plane.dist = maxs[i];
                        plane.normal[i] = 1.0
                    } else {
                        local hitside = tr[3];
                        local i = ('x' + hitside).tochar();
                        plane.type = hitside;
                        plane.sindex = i;
                        plane.dist = -mins[i];
                        plane.normal[i] = -1.0
                    };
                    return true
                };
                if (pT.startsolid) {
                    pT.allsolid = (tr[1] <= 0.0) || (tr[1] >= 1.0);
                    pT.fraction = 0.0;
                    pT.fractionleftsolid = tr[1];
                    pT.endpos = pT.startpos * 1;
                    plane.dist = pT.startpos.x;
                    plane.normal = Vector(1.0, 0.0, 0.0);
                    plane.type = 0;
                    plane.sindex = "x";
                    pT.startpos = rayStart + rayDelta * tr[1];
                    return true
                }
            };
            return false
        }
        local ClipRayToBox = VS.ClipRayToBox;
        VS.ClipRayToBox2 <- function(ray, mins, maxs, tol, tr): (ClipRayToBox) {
            if (ray.m_IsRay) return ClipRayToBox(ray.m_Start, ray.m_Delta, mins, maxs, tol, tr);
            local r = ClipRayToBox(ray.m_Start, ray.m_Delta, mins - ray.m_Extents, maxs + ray.m_Extents, tol, tr);
            tr.startpos += ray.m_StartOffset;
            tr.endpos += ray.m_StartOffset;
            return r
        }
        VS.IntersectRayWithOBB <- function(rayStart, rayDelta, mat, mins, maxs, tol, tr): (Vector, VectorITransform, VectorIRotate, IntersectRayWithBox) {
            local v1 = Vector(), vd = Vector();
            VectorITransform(rayStart, mat, v1);
            VectorIRotate(rayDelta, mat, vd);
            return IntersectRayWithBox(v1, vd, mins, maxs, tol, tr)
        }
        VS.ClipRayToOBB <- function(rayStart, rayDelta, matOBB, minsOBB, maxsOBB, tol, tr): (fabs, Vector, ClipRayToBox) {
            tr.startpos = rayStart;
            tr.endpos = rayStart + rayDelta;
            tr.fraction = 1.0;
            tr.startsolid = tr.allsolid = false;
            local boxExt = (minsOBB + maxsOBB) * 0.5, boxCtr = Vector();
            VectorTransform(boxExt, matOBB, boxCtr);
            boxExt = maxsOBB - boxExt;
            local ext = Vector(), uext = Vector(), segCtr = rayStart + rayDelta - boxCtr, mat = matOBB[0];
            ext.x = rayDelta.x * mat[M_00] + rayDelta.y * mat[M_10] + rayDelta.z * mat[M_20];
            uext.x = fabs(ext.x);
            local coord = segCtr.x * mat[M_00] + segCtr.y * mat[M_10] + segCtr.z * mat[M_20];
            if (fabs(coord) > (boxExt.x + uext.x)) return false;
            ext.y = rayDelta.x * mat[M_01] + rayDelta.y * mat[M_11] + rayDelta.z * mat[M_21];
            uext.y = fabs(ext.y);
            coord = segCtr.x * mat[M_01] + segCtr.y * mat[M_11] + segCtr.z * mat[M_21];
            if (fabs(coord) > (boxExt.y + uext.y)) return false;
            ext.z = rayDelta.x * mat[M_02] + rayDelta.y * mat[M_12] + rayDelta.z * mat[M_22];
            uext.z = fabs(ext.z);
            coord = segCtr.x * mat[M_02] + segCtr.y * mat[M_12] + segCtr.z * mat[M_22];
            if (fabs(coord) > (boxExt.z + uext.z)) return false;
            local cx = rayDelta.Cross(segCtr);
            local cext = cx.x * mat[M_00] + cx.y * mat[M_10] + cx.z * mat[M_20];
            if (fabs(cext) > (boxExt.y * uext.z + boxExt.z * uext.y)) return false;
            cext = cx.x * mat[M_01] + cx.y * mat[M_11] + cx.z * mat[M_21];
            if (fabs(cext) > (boxExt.x * uext.z + boxExt.z * uext.x)) return false;
            cext = cx.x * mat[M_02] + cx.y * mat[M_12] + cx.z * mat[M_22];
            if (fabs(cext) > (boxExt.x * uext.y + boxExt.y * uext.x)) return false;
            local v0 = Vector();
            VectorITransform(rayStart, matOBB, v0);
            ext *= 2.0;
            if (!ClipRayToBox(v0, ext, minsOBB, maxsOBB, tol, tr)) return false;
            VectorTransform(tr.endpos, matOBB, tr.endpos);
            tr.startpos = rayStart;
            tr.fraction *= 2.0;
            local plane = tr.plane;
            local normal = plane.normal;
            local s = normal[plane.sindex];
            normal.x = s * mat[plane.type];
            normal.y = s * mat[4 + plane.type];
            normal.z = s * mat[8 + plane.type];
            plane.dist = tr.endpos.Dot(normal);
            plane.type = 3;
            plane.sindex = "x";
            return true
        }
        local map0 = function(dir, mins, maxs, p) {
            local fl = dir[0], n = (fl > 0.0).tointeger();
            p[n] = maxs[0] * fl;
            p[1 - n] = mins[0] * fl;
            fl = dir[1];
            n = (fl > 0.0).tointeger();
            p[n] += maxs[1] * fl;
            p[1 - n] += mins[1] * fl;
            fl = dir[2];
            n = (fl > 0.0).tointeger();
            p[n] += maxs[2] * fl;
            p[1 - n] += mins[2] * fl
        }, map1 = function(dir, i1, i2, mins, maxs, p) {
            local n = (dir[i1] > 0.0).tointeger();
            p[n] = maxs[i1] * dir[i1];
            p[1 - n] = mins[i1] * dir[i1];
            n = (dir[i2] > 0.0).tointeger();
            p[n] += maxs[i2] * dir[i2];
            p[1 - n] += mins[i2] * dir[i2]
        }, map2 = [2, 1, 0, 2, 0, 1, ], map3 = [4, 8, 8, 0, 4, 0, ], ClipRayToOBB = VS.ClipRayToOBB;
        VS.ClipRayToOBB2 <- function(ray, matOBB, minsOBB, maxsOBB, tol, tr): (ClipRayToOBB, map0, map1, Vector, array, fabs, map2, map3) {
            if (ray.m_IsRay) return ClipRayToOBB(ray.m_Start, ray.m_Delta, matOBB, minsOBB, maxsOBB, tol, tr);
            tr.startpos = ray.m_Start + ray.m_StartOffset;
            tr.endpos = tr.startpos + ray.m_Delta;
            tr.fraction = 1.0;
            tr.startsolid = tr.allsolid = false; {
                local c = (minsOBB + maxsOBB) * 0.5;
                c.x += matOBB[0][M_03];
                c.y += matOBB[0][M_13];
                c.z += matOBB[0][M_23];
                local vh = (maxsOBB - minsOBB) * 0.5;
                local r = vh.Length() + ray.m_Extents.Length();
                if (!IsRayIntersectingSphere(ray.m_Start, ray.m_Delta, c, r, tol)) return false
            }
            local loclRayOrg = Vector(), loclRayDir = Vector();
            VectorITransform(ray.m_Start, matOBB, loclRayOrg);
            VectorIRotate(ray.m_Delta, matOBB, loclRayDir);
            local ppNormal = array(15), ppDist = array(15);
            for (local i = 15; i--;) ppDist[i] = [0.0, 0.0];
            for (local i = 0, rgflMins = [minsOBB.x, minsOBB.y, minsOBB.z], rgflMaxs = [maxsOBB.x, maxsOBB.y, maxsOBB.z], rgflExt = [ray.m_Extents.x, ray.m_Extents.y, ray.m_Extents.z], mat = matOBB[0]; i < 3; ++i) {
                ppNormal[i] = [0.0, 0.0, 0.0];
                ppNormal[i][i] = 1.0;
                local extDot = fabs(mat[i] * rgflExt[0]) + fabs(mat[4 + i] * rgflExt[1]) + fabs(mat[8 + i] * rgflExt[2]);
                ppDist[i][0] = rgflMins[i] - extDot;
                ppDist[i][1] = rgflMaxs[i] + extDot;
                ppNormal[i + 3] = [mat[i * 4], mat[i * 4 + 1], mat[i * 4 + 2]];
                map0(ppNormal[i + 3], rgflMins, rgflMaxs, ppDist[i + 3]);
                ppDist[i + 3][0] -= rgflExt[i];
                ppDist[i + 3][1] += rgflExt[i];
                local ext0 = rgflExt[map2[i * 2]], ext1 = rgflExt[map2[i * 2 + 1]], row0 = map3[i * 2], row1 = map3[i * 2 + 1];
                ppNormal[i + 6] = [0.0, -mat[i * 4 + 2], mat[i * 4 + 1]];
                map1(ppNormal[i + 6], 1, 2, rgflMins, rgflMaxs, ppDist[i + 6]);
                extDot = fabs(mat[row0]) * ext0 + fabs(mat[row1]) * ext1;
                ppDist[i + 6][0] -= extDot;
                ppDist[i + 6][1] += extDot;
                ppNormal[i + 9] = [mat[i * 4 + 2], 0.0, -mat[i * 4]];
                map1(ppNormal[i + 9], 0, 2, rgflMins, rgflMaxs, ppDist[i + 9]);
                extDot = fabs(mat[row0 + 1]) * ext0 + fabs(mat[row1 + 1]) * ext1;
                ppDist[i + 9][0] -= extDot;
                ppDist[i + 9][1] += extDot;
                ppNormal[i + 12] = [-mat[i * 4 + 1], mat[i * 4], 0.0];
                map1(ppNormal[i + 12], 0, 1, rgflMins, rgflMaxs, ppDist[i + 12]);
                extDot = fabs(mat[row0 + 2]) * ext0 + fabs(mat[row1 + 2]) * ext1;
                ppDist[i + 12][0] -= extDot;
                ppDist[i + 12][1] += extDot
            }
            tr.startsolid = true;
            local hitplane = -1, hitside = hitplane, enterfrac = -1.0, leavefrac = 1.0; {
                local d1 = [0.0, 0.0], d2 = [0.0, 0.0], f, loclRayEnd = loclRayOrg + loclRayDir;
                for (local i = 0; i < 15; ++i) {
                    local pNormal = ppNormal[i], pDist = ppDist[i], dot0 = pNormal[0] * loclRayOrg.x + pNormal[1] * loclRayOrg.y + pNormal[2] * loclRayOrg.z, dot1 = pNormal[0] * loclRayEnd.x + pNormal[1] * loclRayEnd.y + pNormal[2] * loclRayEnd.z;
                    d1[0] = -(dot0 - pDist[0]);
                    d2[0] = -(dot1 - pDist[0]);
                    d1[1] = dot0 - pDist[1];
                    d2[1] = dot1 - pDist[1];
                    for (local j = 0; j < 2; ++j) {
                        if (d1[j] > 0.0 && d2[j] > 0.0) return false;
                        if (d1[j] <= 0.0 && d2[j] <= 0.0) continue;
                        if (d1[j] > 0.0) tr.startsolid = false;
                        local dn = 1.0 / (d1[j] - d2[j]);
                        if (d1[j] > d2[j]) {
                            f = d1[j] - tol;
                            if (f < 0.0) f = 0.0;
                            f *= dn;
                            if (f > enterfrac) {
                                enterfrac = f;
                                hitplane = i;
                                hitside = j
                            }
                        } else {
                            f = (d1[j] + tol) * dn;
                            if (f < leavefrac) leavefrac = f
                        }
                    }
                }
            }
            if (enterfrac < leavefrac && enterfrac >= 0.0) {
                tr.fraction = enterfrac;
                VectorMA(tr.startpos, enterfrac, ray.m_Delta, tr.endpos);
                local pNormal = ppNormal[hitplane], normal, dist;
                if (hitside == 0) {
                    normal = Vector(-pNormal[0], -pNormal[1], -pNormal[2]);
                    dist = -ppDist[hitplane][hitside]
                } else {
                    normal = Vector(pNormal[0], pNormal[1], pNormal[2]);
                    dist = ppDist[hitplane][hitside]
                };
                local pn = Vector();
                tr.plane.normal = pn;
                tr.plane.type = 3;
                tr.plane.sindex = "x";
                VectorRotate(normal, matOBB, pn);
                tr.plane.dist = tr.endpos.Dot(pn);
                return true
            };
            if (tr.startsolid) {
                tr.allsolid = (leavefrac <= 0.0) || (leavefrac >= 1.0);
                tr.fraction = 0.0;
                tr.endpos = tr.startpos;
                tr.plane.dist = tr.startpos.x;
                tr.plane.normal = Vector(1.0, 0.0, 0.0);
                tr.plane.type = 0;
                tr.plane.sindex = "x";
                return true
            };
            return false
        }
        VS.IsRayIntersectingOBB <- function(ray, org, ang, mins, maxs): (matrix3x4_t, Vector, AngleIMatrix, VectorTransform, VectorRotate, IsBoxIntersectingRay, DotProductAbs) {
            if (!ang.x && !ang.y && !ang.z) return IsBoxIntersectingRay(org + mins, org + maxs, ray.m_Start, ray.m_Delta);
            if (ray.m_IsRay) {
                local w2b = matrix3x4_t(), v0 = Vector(), vD = Vector();
                AngleIMatrix(ang, org, w2b);
                VectorTransform(ray.m_Start, w2b, v0);
                VectorRotate(ray.m_Delta, w2b, vD);
                return IsBoxIntersectingRay(mins, maxs, v0, vD)
            };
            if (!ray.m_IsSwept) return IsOBBIntersectingOBB(ray.m_Start, Vector(), ray.m_Extents * -1, ray.m_Extents, org, ang, mins, maxs, 0.0);
            local b22w = matrix3x4_t();
            ComputeCenterMatrix(org, ang, mins, maxs, b22w);
            local rayC = VectorMA(ray.m_Start, 0.5, ray.m_Delta) * -1.0;
            local w2b1 = matrix3x4_t(1.0, 0.0, 0.0, rayC.x, 0.0, 1.0, 0.0, rayC.y, 0.0, 0.0, 1.0, rayC.z), b1s = Vector(ray.m_Extents.x + fabs(ray.m_Delta.x) * 0.5, ray.m_Extents.y + fabs(ray.m_Delta.y) * 0.5, ray.m_Extents.z + fabs(ray.m_Delta.z) * 0.5), b2s = (maxs - mins) * 0.5;
            if (ComputeSeparatingPlane(w2b1, b22w, b1s, b2s, 0.0)) return false;
            local rayDir = ray.m_Delta * 1;
            rayDir.Norm();
            local rayDir2 = VectorIRotate(rayDir, b22w);
            VectorAbs(rayDir2);
            b22w = b22w[0];
            local ctrDt = Vector(b22w[M_03] - ray.m_Start.x, b22w[M_13] - ray.m_Start.y, b22w[M_23] - ray.m_Start.z), normal = rayDir.Cross(Vector(b22w[M_00], b22w[M_10], b22w[M_20])), projDt = normal.Dot(ctrDt);
            if (0.0 > projDt) projDt = -projDt;
            local projSum = rayDir2.z * b2s.y + rayDir2.y * b2s.z + DotProductAbs(normal, ray.m_Extents);
            if (projDt > projSum) return false;
            normal = rayDir.Cross(Vector(b22w[M_01], b22w[M_11], b22w[M_21]));
            projDt = normal.Dot(ctrDt);
            if (0.0 > projDt) projDt = -projDt;
            projSum = rayDir2.z * b2s.x + rayDir2.x * b2s.z + DotProductAbs(normal, ray.m_Extents);
            if (projDt > projSum) return false;
            normal = rayDir.Cross(Vector(b22w[M_02], b22w[M_12], b22w[M_22]));
            projDt = normal.Dot(ctrDt);
            if (0.0 > projDt) projDt = -projDt;
            projSum = rayDir2.y * b2s.x + rayDir2.x * b2s.y + DotProductAbs(normal, ray.m_Extents);
            if (projDt > projSum) return false;
            return true
        }
        VS.ComputeSeparatingPlane <- function(w2b1, b22w, b1s, b2s, t, normal = _VEC): (matrix3x4_t, Vector, fabs) {
            local b22b1 = matrix3x4_t();
            ConcatTransforms(w2b1, b22w, b22b1);
            w2b1 = w2b1[0];
            local b2o = Vector(), ab22b1 = matrix3x4_t();
            MatrixGetColumn(b22b1, 3, b2o);
            ComputeAbsMatrix(b22b1, ab22b1);
            local bproj = b1s.x + MatrixRowDotProduct(ab22b1, 0, b2s), oproj = fabs(b2o.x) + t;
            if (oproj > bproj) {
                normal.x = w2b1[M_00];
                normal.y = w2b1[M_01];
                normal.z = w2b1[M_02];
                return true
            };
            bproj = b1s.y + MatrixRowDotProduct(ab22b1, 1, b2s);
            oproj = fabs(b2o.y) + t;
            if (oproj > bproj) {
                normal.x = w2b1[M_10];
                normal.y = w2b1[M_11];
                normal.z = w2b1[M_12];
                return true
            };
            bproj = b1s.z + MatrixRowDotProduct(ab22b1, 2, b2s);
            oproj = fabs(b2o.z) + t;
            if (oproj > bproj) {
                normal.x = w2b1[M_20];
                normal.y = w2b1[M_21];
                normal.z = w2b1[M_22];
                return true
            };
            bproj = b2s.x + MatrixColumnDotProduct(ab22b1, 0, b1s);
            oproj = fabs(MatrixColumnDotProduct(b22b1, 0, b2o)) + t;
            if (oproj > bproj) {
                MatrixGetColumn(b22w, 0, normal);
                return true
            };
            bproj = b2s.y + MatrixColumnDotProduct(ab22b1, 1, b1s);
            oproj = fabs(MatrixColumnDotProduct(b22b1, 1, b2o)) + t;
            if (oproj > bproj) {
                MatrixGetColumn(b22w, 1, normal);
                return true
            };
            bproj = b2s.z + MatrixColumnDotProduct(ab22b1, 2, b1s);
            oproj = fabs(MatrixColumnDotProduct(b22b1, 2, b2o)) + t;
            if (oproj > bproj) {
                MatrixGetColumn(b22w, 2, normal);
                return true
            };
            ab22b1 = ab22b1[0];
            b22b1 = b22b1[0];
            if (ab22b1[M_00] < 0.999) {
                bproj = b1s.y * ab22b1[M_20] + b1s.z * ab22b1[M_10] + b2s.y * ab22b1[M_02] + b2s.z * ab22b1[M_01];
                oproj = fabs(-b2o.y * b22b1[M_20] + b2o.z * b22b1[M_10]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 0, normal);
                    local v = Vector(w2b1[M_00], w2b1[M_01], w2b1[M_02]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_01] < 0.999) {
                bproj = b1s.y * ab22b1[M_21] + b1s.z * ab22b1[M_11] + b2s.x * ab22b1[M_02] + b2s.z * ab22b1[M_00];
                oproj = fabs(-b2o.y * b22b1[M_21] + b2o.z * b22b1[M_11]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 1, normal);
                    local v = Vector(w2b1[M_00], w2b1[M_01], w2b1[M_02]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_02] < 0.999) {
                bproj = b1s.y * ab22b1[M_22] + b1s.z * ab22b1[M_12] + b2s.x * ab22b1[M_01] + b2s.y * ab22b1[M_00];
                oproj = fabs(-b2o.y * b22b1[M_22] + b2o.z * b22b1[M_12]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 2, normal);
                    local v = Vector(w2b1[M_00], w2b1[M_01], w2b1[M_02]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_10] < 0.999) {
                bproj = b1s.x * ab22b1[M_20] + b1s.z * ab22b1[M_00] + b2s.y * ab22b1[M_12] + b2s.z * ab22b1[M_11];
                oproj = fabs(b2o.x * b22b1[M_20] - b2o.z * b22b1[M_00]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 0, normal);
                    local v = Vector(w2b1[M_10], w2b1[M_11], w2b1[M_12]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_11] < 0.999) {
                bproj = b1s.x * ab22b1[M_21] + b1s.z * ab22b1[M_01] + b2s.x * ab22b1[M_12] + b2s.z * ab22b1[M_10];
                oproj = fabs(b2o.x * b22b1[M_21] - b2o.z * b22b1[M_01]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 1, normal);
                    local v = Vector(w2b1[M_10], w2b1[M_11], w2b1[M_12]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_12] < 0.999) {
                bproj = b1s.x * ab22b1[M_22] + b1s.z * ab22b1[M_02] + b2s.x * ab22b1[M_11] + b2s.y * ab22b1[M_10];
                oproj = fabs(b2o.x * b22b1[M_22] - b2o.z * b22b1[M_02]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 2, normal);
                    local v = Vector(w2b1[M_10], w2b1[M_11], w2b1[M_12]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_20] < 0.999) {
                bproj = b1s.x * ab22b1[M_10] + b1s.y * ab22b1[M_00] + b2s.y * ab22b1[M_22] + b2s.z * ab22b1[M_21];
                oproj = fabs(-b2o.x * b22b1[M_10] + b2o.y * b22b1[M_00]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 0, normal);
                    local v = Vector(w2b1[M_20], w2b1[M_21], w2b1[M_22]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_21] < 0.999) {
                bproj = b1s.x * ab22b1[M_11] + b1s.y * ab22b1[M_01] + b2s.x * ab22b1[M_22] + b2s.z * ab22b1[M_20];
                oproj = fabs(-b2o.x * b22b1[M_11] + b2o.y * b22b1[M_01]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 1, normal);
                    local v = Vector(w2b1[M_20], w2b1[M_21], w2b1[M_22]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            if (ab22b1[M_22] < 0.999) {
                bproj = b1s.x * ab22b1[M_12] + b1s.y * ab22b1[M_02] + b2s.x * ab22b1[M_21] + b2s.y * ab22b1[M_20];
                oproj = fabs(-b2o.x * b22b1[M_12] + b2o.y * b22b1[M_02]) + t;
                if (oproj > bproj) {
                    MatrixGetColumn(b22w, 2, normal);
                    local v = Vector(w2b1[M_20], w2b1[M_21], w2b1[M_22]).Cross(normal);
                    normal.x = v.x;
                    normal.y = v.y;
                    normal.z = v.z;
                    return true
                }
            };
            return false
        }
        VS.IsOBBIntersectingOBB <- function(org1, ang1, min1, max1, org2, ang2, min2, max2, t): (matrix3x4_t) {
            local w2b1 = matrix3x4_t(), b22w = matrix3x4_t();
            ComputeCenterIMatrix(org1, ang1, min1, max1, w2b1);
            ComputeCenterMatrix(org2, ang2, min2, max2, b22w);
            return !ComputeSeparatingPlane(w2b1, b22w, (max1 - min1) * 0.5, (max2 - min2) * 0.5, t)
        }::Quaternion <-Quaternion;::matrix3x4_t <-matrix3x4_t;::VMatrix <-VMatrix;::Ray_t <-Ray_t;::trace_t <-trace_t
    }
}::Ent <- function(s, i = null) {
    return Entities.FindByName(i, s)
}.bindenv(::VS);::Entc <- function(s, i = null) {
    return Entities.FindByClassname(i, s)
}.bindenv(::VS);::VecToString <- function(v): (Fmt) return Fmt("Vector(%.6g, %.6g, %.6g)", v.x, v.y, v.z); {
    if (!("{F71A8D}" in ROOT)) ROOT["{F71A8D}"] <-[];
    local g_Players = ROOT["{F71A8D}"];::SetPlayerFOV <- function(pl, iFOV, flRate = 0.0) {
        if (pl = ToExtendedPlayer(pl)) return pl.SetFOV(iFOV, flRate)
    }.bindenv(::VS);
    local NullSort = function(a, b) {
        local oa = a && a.ref(), ob = b && b.ref();
        if (oa && !ob) return 1;
        if (!oa && ob) return -1;
        return 0
    }, OwnerSort = function(a, b) {
        local oa = a && a.ref() && a.ref().GetOwner(), ob = b && b.ref() && b.ref().GetOwner();
        if (oa && !ob) return 1;
        if (!oa && ob) return -1;
        return 0
    }, SetNameSafe = function(ent, name) {
        if (ent && ent.IsValid()) ent.__KeyValueFromString("targetname", name)
    }, GetNatFn;
    if (PORTAL2) GetNatFn = function(p, s) {
        switch (p[s].getinfos().paramscheck) {
            case 0:
            case 1:
                return function(): (p, s) return p[s]();
            case 2:
                return function(a): (p, s) return p[s](a);
            case 3:
                return function(a, b): (p, s) return p[s](a, b);
            case 4:
                return function(a, b, c): (p, s) return p[s](a, b, c)
        }
    } else GetNatFn = function(p, s) return p[s].bindenv(p);
    VS.ToExtendedPlayer <- function(pl): (g_Players, ROOT, NullSort, OwnerSort, AddEvent, SetNameSafe, FrameTime, GetNatFn, PORTAL2) {
        foreach(p in g_Players) if (p.self == pl || p == pl) return p;
        if ((typeof pl != "instance") || !(pl instanceof CBasePlayer) || !pl.IsValid()) return;
        for (local i = g_Players.len(); i--;)
            if (!g_Players[i].IsValid()) g_Players.remove(i);
        pl.ValidateScriptScope();
        local sc = pl.GetScriptScope();
        if (!("{E3D627}" in ROOT)) ROOT["{E3D627}"] <-[];
        local g_Eyes = ROOT["{E3D627}"], eye;
        g_Eyes.sort(NullSort);
        g_Eyes.sort(OwnerSort);
        for (local i = g_Eyes.len(); i--;) {
            local v = g_Eyes[i];
            if (!v) {
                g_Eyes.remove(i);
                continue
            };
            local o = v.GetOwner();
            if (!o || o == pl) {
                eye = v;
                break
            }
        }
        if (!eye) {
            eye = Entities.CreateByClassname("logic_measure_movement");
            MakePersistent(eye);
            eye.__KeyValueFromInt("measuretype", 1);
            eye.__KeyValueFromString("measurereference", "");
            eye.__KeyValueFromString("measureretarget", "");
            eye.__KeyValueFromFloat("targetscale", 1.0);
            local sz = "vs.ref_" + UniqueString();
            eye.__KeyValueFromString("targetname", sz);
            eye.__KeyValueFromString("targetreference", sz);
            eye.__KeyValueFromString("target", sz);
            AddEvent(eye, "SetMeasureReference", sz, 0.0, null, null);
            AddEvent(eye, "Enable", "", 0.0, null, null);
            g_Eyes.insert(0, eye.weakref());
            if (PORTAL2) {
                eye.__KeyValueFromString("vscripts", " ");
                eye.ValidateScriptScope();
                eye.GetScriptScope().DispatchPrecache <- function(): (AddEvent, SetNameSafe) {
                    local pl = self.GetOwner(), n0 = pl.GetName(), n1 = __vname;
                    pl.__KeyValueFromString("targetname", n1);
                    AddEvent(self, "SetMeasureTarget", n1, 0.0, null, null);
                    VS.EventQueue.AddEvent(SetNameSafe, FrameTime() + 0.001, [null, pl, n0])
                }
            }
        }; {
            local n0 = pl.GetName(), n1 = sc.__vname;
            pl.__KeyValueFromString("targetname", n1);
            AddEvent(eye, "SetMeasureTarget", n1, 0.0, null, null);
            EventQueue.AddEvent(SetNameSafe, FrameTime() + 0.001, [null, pl, n0])
        }
        eye.SetOwner(pl);
        local bot, uid, nid, pnm;
        if (!("userid" in sc)) {
            if ("Events" in this && Events.m_bFixedUp) Msg("Warning!!! VS.ToExtendedPlayer was called before player was spawned!\n");
            sc.userid <--1
        };
        if (!("networkid" in sc)) sc.networkid <-"";
        if (!("name" in sc)) sc.name <-"";
        if ("GetUserID" in pl) sc.userid = pl.GetUserID();
        else if ("GetPlayerUserId" in pl) sc.userid = pl.GetPlayerUserId();;
        if ("GetNetworkIDString" in pl) sc.networkid = pl.GetNetworkIDString();
        if ("GetPlayerName" in pl) sc.name = pl.GetPlayerName();
        if ("IsBot" in pl) bot = pl.IsBot();
        else bot = sc.networkid == "BOT";
        uid = sc.userid;;
        nid = sc.networkid;
        pnm = sc.name;
        local CExtendedPlayer__ = class {
            static self = pl;
            static m_EntityIndex = pl.entindex();
            static m_ScriptScope = sc;
            static userid = uid;
            static networkid = nid;
            static name = pnm;
            static fakeplayer = bot;
            IsBot = bot ? function() {
                return true
            } : function() {
                return false
            };
            GetUserID = (uid > 0) ? function() : (uid) {
                return uid
            }: function(): (sc) {
                return sc.userid
            };
            GetNetworkIDString = (nid == "") ? function() : (sc) {
                return sc.networkid
            }: function(): (nid) {
                return nid
            };
            GetPlayerName = bot ? function() : (pnm) {
                return pnm
            }: function(): (sc) {
                return sc.name
            };
            EyeAngles = GetNatFn(eye, "GetAngles");
            EyeForward = GetNatFn(eye, "GetForwardVector");
            EyeRight = GetNatFn(eye, "GetLeftVector");
            EyeUp = GetNatFn(eye, "GetUpVector");

            function SetName(sz) {
                return self.__KeyValueFromString("targetname", sz)
            }

            function SetEffects(n) {
                return self.__KeyValueFromInt("effects", n)
            }

            function SetMoveType(n) {
                return self.__KeyValueFromInt("movetype", n)
            }
            GetFOV = null;
            SetFOV = null;

            function SetParent(p, s): (AddEvent) {
                AddEvent(self, "SetParent", "!activator", 0.0, p, null);
                if (s != "") return AddEvent(self, "SetParentAttachment", s, 0.0, null, null)
            }

            function SetInputCallback(inp, fn, env) {
                Msg("CExtendedPlayer::SetInputCallback() is deprecated, use VS::SetInputCallback()instead!\n");
                return VS.SetInputCallback(this, inp, fn, env)
            }
            _tostring = GetNatFn(pl, "tostring");
            getclass = GetNatFn(pl, "getclass")
        }
        CExtendedPlayer__.GetFOV <-CExtendedPlayer__.SetFOV <- function(...): (ROOT, NullSort, OwnerSort, AddEvent, GetNatFn) {
            if (!("{D9154C}" in ROOT)) ROOT["{D9154C}"] <-[];
            local g_ViewEnts = ROOT["{D9154C}"], hView;
            g_ViewEnts.sort(NullSort);
            g_ViewEnts.sort(OwnerSort);
            for (local i = g_ViewEnts.len(); i--;) {
                local v = g_ViewEnts[i];
                if (!v) {
                    g_ViewEnts.remove(i);
                    continue
                };
                local o = v.GetOwner();
                if (!o || o == self) {
                    hView = v;
                    break
                }
            }
            if (!hView) {
                hView = Entities.CreateByClassname("point_viewcontrol");
                VS.MakePersistent(hView);
                hView.__KeyValueFromInt("spawnflags", 129);
                hView.__KeyValueFromInt("effects", 32);
                hView.__KeyValueFromInt("movetype", 8);
                hView.__KeyValueFromInt("renderamt", 0);
                hView.__KeyValueFromInt("rendermode", 2);
                g_ViewEnts.insert(0, hView.weakref())
            };
            hView.SetOwner(self);
            AddEvent(hView, "Enable", "", 0.0, self, null);
            AddEvent(hView, "Disable", "", 0.0, null, null);
            GetFOV = GetNatFn(hView, "GetFov");
            SetFOV = GetNatFn(hView, "SetFov");
            return 90.0
        }
        foreach(k, v in pl.getclass()) CExtendedPlayer__[k] <-GetNatFn(pl, k);
        local p = CExtendedPlayer__();
        g_Players.append(p);
        return p
    }.bindenv(::VS);
    VS.SetInputCallback <- function(pl, inp, fn, env): (AddEvent, ROOT, NullSort, OwnerSort) {
        if (!(pl = ToExtendedPlayer(pl))) return;
        if (!("{5E457F}" in ROOT)) ROOT["{5E457F}"] <-[];
        local p, g_GameUIs = ROOT["{5E457F}"];
        g_GameUIs.sort(NullSort);
        g_GameUIs.sort(OwnerSort);
        for (local i = g_GameUIs.len(); i--;) {
            local v = g_GameUIs[i];
            if (!v) {
                g_GameUIs.remove(i);
                continue
            };
            local o = v.GetOwner();
            if (!o || o == pl.self) {
                v.SetTeam(0);
                p = v;
                break
            }
        }
        if (!p) {
            p = Entities.CreateByClassname("game_ui");
            p.__KeyValueFromInt("spawnflags", 128);
            p.__KeyValueFromFloat("fieldofview", -1);
            MakePersistent(p);
            p.__KeyValueFromString("targetname", "");
            g_GameUIs.insert(0, p.weakref());
            p.ValidateScriptScope()
        };
        p.SetOwner(pl.self);
        local sc = p.GetScriptScope();
        if (!("m_pCallbacks" in sc)) sc.m_pCallbacks <-{};
        if (!inp) {
            if (p.GetTeam() && p.GetOwner()) AddEvent(p, "Deactivate", "", 0.0, pl.self, null);
            p.SetTeam(0);
            foreach(input, cb in sc.m_pCallbacks) {
                if (input in sc) delete sc[input];
                p.DisconnectOutput(input, input)
            }
            sc.m_pCallbacks.clear();
            return
        };
        switch (inp) {
            case "+use":
                inp = "PlayerOff";
                break;
            case "+attack":
                inp = "PressedAttack";
                break;
            case "-attack":
                inp = "UnpressedAttack";
                break;
            case "+attack2":
                inp = "PressedAttack2";
                break;
            case "-attack2":
                inp = "UnpressedAttack2";
                break;
            case "+forward":
                inp = "PressedForward";
                break;
            case "-forward":
                inp = "UnpressedForward";
                break;
            case "+back":
                inp = "PressedBack";
                break;
            case "-back":
                inp = "UnpressedBack";
                break;
            case "+moveleft":
                inp = "PressedMoveLeft";
                break;
            case "-moveleft":
                inp = "UnpressedMoveLeft";
                break;
            case "+moveright":
                inp = "PressedMoveRight";
                break;
            case "-moveright":
                inp = "UnpressedMoveRight";
                break;
            default:
                throw "VS::SetInputCallback: invalid input"
        }
        local ctx;
        switch (typeof env) {
            case "string":
                ctx = env;
                env = null;
                break;
            case "table":
            case "instance":
            case "class":
                ctx = 0;
                break;
            default:
                throw "VS::SetInputCallback: invalid context"
        }
        if (!(inp in sc.m_pCallbacks)) sc.m_pCallbacks[inp] <-{};
        local cb = sc.m_pCallbacks[inp];
        if (!fn) {
            if (ctx in cb) {
                delete cb[ctx];
                if (!cb.len()) {
                    if (inp != "PlayerOff") {
                        if (inp in sc) sc[inp] = null;
                        p.DisconnectOutput(inp, inp)
                    }
                }
            };
            return
        };
        if (env) cb[ctx] <-fn.bindenv(env);
        else cb[ctx] <-fn;
        if ((inp != "PlayerOff") && (!(inp in sc) || !sc[inp])) {
            sc[inp] <- function(): (cb) {
                foreach(fn in cb) fn(this)
            }.bindenv(pl);
            p.ConnectOutput(inp, inp)
        };
        if (!("PlayerOff" in sc) || !sc.PlayerOff) {
            if (!("PlayerOff" in sc.m_pCallbacks)) sc.m_pCallbacks.PlayerOff <-{};
            local cb = sc.m_pCallbacks.PlayerOff;
            sc.PlayerOff <- function(): (cb, p, AddEvent) {
                AddEvent(p, "Activate", "", 0.0, self, null);
                foreach(fn in cb) fn(this)
            }.bindenv(pl);
            p.ConnectOutput("PlayerOff", "PlayerOff")
        };
        if (!p.GetTeam()) {
            p.SetTeam(1);
            AddEvent(p, "Activate", "", 0.0, pl.self, null)
        }
    }
} {
    local tr1 = TraceLine, tr2;
    if (!PORTAL2) tr2 = TraceLinePlayersIncluded;;
    const MASK_NPCWORLDSTATIC = 0x2000b;;
    const MASK_SOLID = 0x200400b;;
    class VS.TraceLine {
        constructor(v1, v2, e = null, nm = MASK_NPCWORLDSTATIC): (tr1, tr2) {
            startpos = v1;
            endpos = v2;
            ignore = e;
            mask = nm;
            switch (nm) {
                case MASK_NPCWORLDSTATIC:
                    fraction = tr1(v1, v2, e);
                    return;
                case MASK_SOLID:
                    fraction = tr2(v1, v2, e);
                    return;
                default:
                    throw "invalid trace mask"
            }
        }

        function _typeof() {
            return "trace_t"
        }
        startpos = null;
        endpos = null;
        ignore = null;
        fraction = null;
        hitpos = null;
        normal = null;
        mask = null
    }
    local CTrace = VS.TraceLine;
    if (!PORTAL2) CTrace.Entities <-Entities;;
    VS.TraceDir <- function(v1, d, f = MAX_TRACE_LENGTH, e = null, m = MASK_NPCWORLDSTATIC): (CTrace) {
        return CTrace(v1, v1 + d * f, e, m)
    }
    VS.TraceLine.DidHit <- function() {
        return fraction != 1.0
    }
    VS.TraceLine.GetEnt <- function(fR) {
        if (!hitpos) GetPos();
        return Entities.FindByClassnameNearest("*", hitpos, fR)
    }
    VS.TraceLine.GetEntByName <- function(name, fR) {
        if (!hitpos) GetPos();
        return Entities.FindByNameNearest(name, hitpos, fR)
    }
    VS.TraceLine.GetEntByClassname <- function(name, fR) {
        if (!hitpos) GetPos();
        return Entities.FindByClassnameNearest(name, hitpos, fR)
    }
    VS.TraceLine.GetPos <- function() {
        if (hitpos) return hitpos;
        if (fraction != 1.0) return hitpos = startpos + (endpos - startpos) * fraction;
        return hitpos = endpos
    }
    VS.TraceLine.GetDist <- function() {
        if (!hitpos) GetPos();
        return (startpos - hitpos).Length()
    }
    VS.TraceLine.GetDistSqr <- function() {
        if (!hitpos) GetPos();
        return (startpos - hitpos).LengthSqr()
    }
    VS.TraceLine.GetNormal <- function(): (Vector, CTrace) {
        if (normal) return normal;
        local up = Vector(0., 0.05, 0.1), v0 = startpos, dt = endpos - v0;
        dt.Norm();
        local v1 = v0 + dt.Cross(up), v2 = v0 + up;
        v0 = GetPos();
        dt = dt * MAX_TRACE_LENGTH;
        v1 = v0 - CTrace(v1, v1 + dt, ignore, mask).GetPos();
        v2 = v0 - CTrace(v2, v2 + dt, ignore, mask).GetPos();
        up = normal = v1.Cross(v2);
        up.Norm();
        return up
    }
}
VS.UniqueString <- function(): (DoUniqueString) {
    return DoUniqueString("").slice(0, -1)
}
VS.DumpScope <- function(I, A = false, P = true, G = true, D = 0) {
    local _S = ["Assert", "Document", "Documentation", "PrintHelp", "RetrieveNativeSignature", "RegisterFunctionDocumentation", "UniqueString", "IncludeScript", "Entities", "CSimpleCallChainer", "CCallChainer", "LateBinder", "__ReplaceClosures", "__DumpScope", "printl", "VSquirrel_OnCreateScope", "VSquirrel_OnReleaseScope", "PrecacheCallChain", "OnPostSpawnCallChain", "DispatchOnPostSpawn", "DispatchPrecache", "OnPostSpawn", "PostSpawn", "Precache", "PreSpawnInstance", "__EntityMakerResult", "__FinishSpawn", "__ExecutePreSpawn", "EntFireByHandle", "EntFire", "RAND_MAX", "_version_", "_intsize_", "PI", "_charsize_", "_floatsize_", "__vname", "__vrefs", "{847D4B}", "{F71A8D}", "{E3D627}", "{5E457F}", "{D9154C}", "ToExtendedPlayer", "VS", "PrecacheModel", "PrecacheScriptSound", "VecToString", "Ent", "Entc", "Quaternion", "matrix3x4_t", "VMatrix", "Ray_t", "trace_t", "max", "min", "clamp", "MAX_COORD_FLOAT", "MAX_TRACE_LENGTH", "DEG2RAD", "RAD2DEG", "CONST"];
    local dn = function(c) for (local i = c; i--;) print("   ");
    local SW = Entities.First().GetScriptScope();
    if (G) print(" ------------------------------\n");
    if (I) {
        foreach(key, val in I) {
            local ty = typeof val, bS = false;
            if (!A) {
                switch (ty) {
                    case "native function":
                        bS = true;
                        break;
                    case "class":
                        foreach(k, v in val) {
                            if (typeof v == "native function") {
                                bS = true;
                                break
                            }
                        }
                        break;
                    case "table":
                        if (val == SW || "{7D6E9A}" in val) bS = true;
                        break
                }
                if (!bS) {
                    foreach(k in _S) if (key == k) {
                        bS = true;
                        break
                    }
                }
            } else if (key == "VS" || key == "Documentation") bS = true;;
            if (!bS) {
                dn(D);
                print(key);
                switch (ty) {
                    case "table":
                        print("(TABLE) : " + val.len());
                        if (!P) break;
                        print("\n");
                        dn(D);
                        print("{\n");
                        DumpScope(val, A, P, false, D + 1);
                        dn(D);
                        print("}");
                        break;
                    case "array":
                        print("(ARRAY) : " + val.len());
                        if (!P) break;
                        print("\n");
                        dn(D);
                        print("[\n");
                        DumpScope(val, A, P, false, D + 1);
                        dn(D);
                        print("]");
                        break;
                    case "string":
                        print(" = \"" + val + "\"");
                        break;
                    case "Vector":
                        print(" = " + VecToString(val));
                        break;
                    default:
                        print(" = " + val)
                }
                print("\n")
            }
        }
    } else print("(NULL)\n");
    if (G) print(" ------------------------------\n")
}
VS.ArrayToTable <- function(a) {
    local t = {}
    foreach(i, v in a) t[i] <-v;
    return t
}
VS.PrintStack <- function(l = 0): (Fmt, getstackinfos, ROOT, CBaseEntity) {
    if (l < 0) l = 0;
    l += 2;
    print("\nCALLSTACK\n");
    local si, st = [];
    while (si = getstackinfos(l++)) {
        if (si.src == "NATIVE" && si.func == "pcall") break;
        if (l >= 12) break;
        print(Fmt("*FUNCTION [%s()] %s line [%d]\n", si.func, si.src, si.line));
        st.append(si)
    }
    print("\nLOCALS\n");
    foreach(si in st) {
        local T;
        foreach(nm, v in si.locals) {
            switch (typeof v) {
                case "integer":
                    print(Fmt("[%s] %d\n", nm, v));
                    break;
                case "float":
                    print(Fmt("[%s] %.14g\n", nm, v));
                    break;
                case "string":
                    print(Fmt("[%s] \"%s\"\n", nm, v));
                    break;
                case "table":
                    if (nm == "this") {
                        T = v;
                        break
                    };
                    if (v == ROOT) {
                        print(Fmt("[%s] TABLE (ROOT)\n", nm));
                        break
                    };
                    print(Fmt("[%s] TABLE\n", nm));
                    break;
                case "function":
                    print(Fmt("[%s] CLOSURE\n", nm));
                    break;
                case "native function":
                    print(Fmt("[%s] NATIVECLOSURE\n", nm));
                    break;
                case "bool":
                    print(Fmt("[%s] %s\n", nm, "" + v));
                    break;
                case "instance":
                    if (v instanceof CBaseEntity) {
                        print(Fmt("[%s] CBaseEntity\n", nm));
                        break
                    };
                default:
                    print(Fmt("[%s] %s\n", nm, (typeof v).toupper()))
            }
        }
        if (T) {
            if (T == ROOT) print("[this] TABLE (ROOT)\n");
            else {
                local s;
                if (s = GetVarName(T)) print(Fmt("[this] TABLE (%s)\n", s));
                else print("[this] TABLE\n")
            }
        }
    }
}
VS.GetCaller <- function(): (getstackinfos) return getstackinfos(3).locals["this"];
VS.GetCallerFunc <- function(): (getstackinfos) return getstackinfos(3).func;
VS.GetVarName <- function(v) {
    local t = typeof v;
    if (t == "function" || t == "native function") return v.getinfos().name;
    local r = _8B78B6AE(t, v);
    if (r) return r;
    foreach(k, w in getstackinfos(2).locals) if (w == v) return k
}
VS._8B78B6AE <- function(t, i, s = ROOT) {
    foreach(k, v in s) {
        if (v == i) return k;
        if (typeof v == "table" && k != "VS" && k != "Documentation") {
            local r = _8B78B6AE(t, i, v);
            if (r) return r
        }
    }
}
local World = Entc("worldspawn");
if (!World) {
    Msg("ERROR: could not find worldspawn\n");
    World = VS.CreateEntity("soundent")
};;::delay <- function(X, T = 0.0, E = World, A = null, C = null): (AddEvent) return AddEvent(E, "RunScriptCode", "" + X, T, A, C); {
    local EQ = {
        m_flNextQueue = -1.0,
        m_flLastQueue = -1.0
    }
    VS.EventQueue <-EQ;
    local E = [null, null];
    E[1] = FLT_MAX_N;
    EQ.Dump <- function(tk = false, dn = 0): (E, Time, Fmt, TI) {
        local g = function(i): (Fmt) {
            if (i == null) return "(NULL)";
            local s = "" + i;
            local t = s.find("0x");
            if (t == null) return s;
            return Fmt("(%s)", s.slice(t, -1))
        }, T2T = function(dt): (TI) {
            return ((0.5 + dt) / TI).tointeger()
        }, n = "";
        for (local i = dn; i--;) n += "    ";
        Msg(Fmt(n + "VS::EventQueue::Dump: %.6g : next(%.6g), last(%.6g)\n", tk ? T2T(Time()) : Time(), tk ? (m_flNextQueue == -1.0 ? -1.0 : T2T(m_flNextQueue)) : m_flNextQueue, tk ? T2T(m_flLastQueue) : m_flLastQueue));
        for (local ev = E; ev = ev[0];) {
            local fn = ev[3].getinfos().name, ta = typeof ev[4] == "array" && ev[4].len();
            Msg(Fmt(n + "   (%s) func '%s'%s, %s '%s', activator '%s', caller '%s'\n", tk ? "" + T2T(ev[1]) : Fmt("%.2f", ev[1]), fn ? fn : "<unnamed>", g(ev[3]), ta ? "arg" : "env", g(ta ? ev[4][0] : ev[5]), g(ev[6]), g(ev[7])))
        }
        Msg(n + "VS::EventQueue::Dump: end.\n")
    }.bindenv(EQ);
    EQ.Clear <- function(): (E) {
        local ev = E[0];
        while (ev) {
            local next = ev[0];
            ev[0] = null;
            ev[2] = null;
            ev = next
        }
        E[0] = null;
        m_flNextQueue = m_flLastQueue = -1.0
    }.bindenv(EQ);
    EQ.CancelEventsByInput <- function(f): (E) {
        local ev = E;
        while (ev = ev[0]) {
            if (f == ev[3]) {
                ev[2][0] = ev[0];
                if (ev[0]) ev[0][2] = ev[2]
            }
        }
        if (!E[0]) m_flNextQueue = -1.0
    }.bindenv(EQ);
    EQ.RemoveEvent <- function(ev): (E) {
        if (typeof ev == "weakref") ev = ev.ref();
        local pe = E;
        while (pe = pe[0]) {
            if (ev == pe) {
                ev[2][0] = ev[0];
                if (ev[0]) ev[0][2] = ev[2];
                if (!E[0]) m_flNextQueue = -1.0;
                return
            }
        }
    }.bindenv(EQ);
    EQ.AddEventInternal <- function(iv, dl): (World, Time, AddEvent, E, TI) {
        local t = Time();
        local fft = t + dl;
        iv[1] = fft;
        local ev = E;
        while (ev[0]) {
            if (iv[1] < ev[0][1]) break;
            ev = ev[0]
        }
        iv[0] = ev[0];
        iv[2] = ev;
        ev[0] = iv;
        if (m_flLastQueue != t) {
            m_flLastQueue = t;
            if ((m_flNextQueue == -1.0) || (fft < m_flNextQueue)) {
                m_flNextQueue = fft;
                AddEvent(World, "CallScriptFunction", "VS_EventQueue_ServiceEvents", 0.0, iv[6], iv[7])
            } else if (E[0] && ((t - E[0][1] - 0.001) >= TI)) {
                Clear();
                return AddEventInternal(iv, dl)
            }
        };
        return iv.weakref()
    }.bindenv(EQ);
    local AddEventInternal = EQ.AddEventInternal;
    EQ.AddEvent <- function(fn, dl, av = null, ar = null, cr = null): (AddEventInternal) {
        local ev = [null, null, null, fn, null, null, ar, cr];
        switch (typeof av) {
            case "array":
                ev[4] = av;
                break;
            case "table":
            case "instance":
            case "class":
                ev[5] = av;
                break
        }
        return AddEventInternal(ev, dl)
    }.bindenv(EQ);
    EQ.CreateEvent <- function(fn, av = null, ar = null, cr = null) {
        local ev = [null, null, null, fn, null, null, ar, cr];
        switch (typeof av) {
            case "array":
                ev[4] = av;
                break;
            case "table":
            case "instance":
            case "class":
                ev[5] = av;
                break
        }
        return ev
    }
    EQ.ServiceEvents <- function(): (World, AddEvent, E, Time) {
        local t = Time(), ev = E;
        while (ev = ev[0]) {
            local f = ev[1];
            if (f <= t) {
                local f = ev[3];
                if (f) {
                    local p = ev[4];
                    if (p) f.acall(p);
                    else f.call(ev[5])
                };
                ev[2][0] = ev[0];
                if (ev[0]) ev[0][2] = ev[2];
                ev = E
            } else {
                m_flNextQueue = f;
                return AddEvent(World, "CallScriptFunction", "VS_EventQueue_ServiceEvents", f - t, ev[6], ev[7])
            }
        }
        m_flNextQueue = -1.0
    }.bindenv(EQ);
    World.ValidateScriptScope();
    World.GetScriptScope().VS_EventQueue_ServiceEvents <-EQ.ServiceEvents.weakref()
}
if (!PORTAL2) {
    ::Chat <- function(s): (ScriptPrintMessageChatAll) return ScriptPrintMessageChatAll(" " + s);::ChatTeam <- function(i, s): (ScriptPrintMessageChatTeam) return ScriptPrintMessageChatTeam(i, " " + s);::Alert <-ScriptPrintMessageCenterAll;::AlertTeam <-ScriptPrintMessageCenterTeam;::CenterPrintAll <- function(s): (ScriptPrintMessageCenterAllWithParams) {
        return ScriptPrintMessageCenterAllWithParams("#SFUI_ContractKillStart", "</font>" + s + "                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                ", "", "")
    }
    enum TextColor {
        Normal = "\x1", Red = "\x2", Purple = "\x3", Location = "\x4", Achievement = "\x5", Award = "\x6", Penalty = "\x7", Silver = "\x8", Gold = "\x9", Common = "\xA", Uncommon = "\xB", Rare = "\xC", Mythical = "\xD", Legendary = "\xE", Ancient = "\xF", Immortal = "\x10"
    }::TextColor <-CONST.TextColor
};;::EntFireByHandle <- function(T, A, V = "", dl = 0.0, ar = null, cr = null): (AddEvent) return AddEvent(T, "" + A, "" + V, dl, ar, cr);::EntFire <- function(T, A, V = "", dl = 0.0, ar = null): (DoEntFire) {
    if (!V) V = "";
    local cr;
    if ("self" in this) {
        cr = self;
        if (!ar) ar = self
    };
    return DoEntFire("" + T, "" + A, "" + V, dl, ar, cr)
}
if ("PrecacheModel" in CBaseEntity)::PrecacheModel <- function(s): (World) return World.PrecacheModel(s);;::PrecacheScriptSound <- function(s): (World) return World.PrecacheSoundScript(s);
if (PORTAL2) VS.MakePersistent <-dummy;
else VS.MakePersistent <- function(e) return e.__KeyValueFromString("classname", "soundent");;
VS.SetParent <- function(t, p): (AddEvent) {
    if (p) return AddEvent(t, "SetParent", "!activator", 0.0, p, null);
    return AddEvent(t, "ClearParent", "", 0.0, null, null)
}
VS.CreateTimer <- function(D, fq, lo = null, hi = null, oc = false, ps = false): (AddEvent) {
    local e = CreateEntity("logic_timer", null, ps);
    if (fq != null) {
        e.__KeyValueFromInt("UseRandomTime", 0);
        e.__KeyValueFromFloat("RefireTime", fq.tofloat())
    } else {
        e.__KeyValueFromFloat("LowerRandomBound", lo.tofloat());
        e.__KeyValueFromFloat("UpperRandomBound", hi.tofloat());
        e.__KeyValueFromInt("UseRandomTime", 1);
        e.__KeyValueFromInt("spawnflags", oc.tointeger())
    };
    AddEvent(e, D ? "Disable" : "Enable", "", 0.0, null, null);
    return e
}
VS.Timer <- function(D, fq, fn = null, sc = null, nv = false, ps = false) {
    if (fq == null) {
        Msg("\nERROR:\nRefire time cannot be null in VS.Timer\nUse VS.CreateTimer for randomised fire times.\n");
        throw "NULL REFIRE TIME"
    };
    local h = CreateTimer(D, fq, null, null, null, ps);
    OnTimer(h, fn, sc ? sc : GetCaller(), nv);
    return h
}
VS.OnTimer <- function(e, fn, sc = null, nv = false) return AddOutput(e, "OnTimer", fn, sc ? sc : GetCaller(), nv);
VS.AddOutput <- function(p, op, tg, ip = "", pm = "", dl = 0.0, nt = -1): (Fmt, compilestring) {
    switch (typeof tg) {
        case "string":
            if (tg.find("(") == null) return p.__KeyValueFromString(op, Fmt("%s,%s,%s,%f,%d", tg, ip, pm, dl, nt));
            else tg = compilestring(tg);
        case "function":
            if (ip == "") ip = GetCaller();
            if (pm == "") pm = false;
            p.ValidateScriptScope();
            local sc = p.GetScriptScope();
            sc[op] <-pm ? tg : tg.bindenv(ip);
            return p.ConnectOutput(op, op)
    }
}
VS.CreateEntity <- function(c, kv = null, p = false) {
    local e = Entities.CreateByClassname(c);
    if (typeof kv == "table") foreach(k, v in kv) SetKeyValue(e, k, v);
    if (p) MakePersistent(e);
    return e
}
VS.SetKeyValue <- function(p, k, v) {
    switch (typeof v) {
        case "float":
            return p.__KeyValueFromFloat(k, v);
        case "integer":
        case "bool":
            return p.__KeyValueFromInt(k, v.tointeger());
        case "string":
            return p.__KeyValueFromString(k, v);
        case "Vector":
            return p.__KeyValueFromVector(k, v);
        case "null":
            return true;
        default:
            throw "VS::SetKeyValue: invalid input: " + typeof v
    }
}
VS.SetName <- function(e, n) return e.__KeyValueFromString("targetname", "" + n);
VS.DumpEnt <- function(I = null): (Fmt) {
    if (!I) {
        local e;
        while (e = Entities.Next(e)) {
            local s = e.GetScriptScope();
            if (s) Msg(Fmt("%s :: %s\n", "" + e, s.__vname))
        }
        return
    };
    if (typeof I == "string") {
        local e;
        while (e = Entities.Next(e))
            if ("" + e == I) I = e
    };
    if (typeof I == "instance") {
        if (I.IsValid()) {
            local s = I.GetScriptScope();
            if (s) {
                Msg(Fmt("--- Script dump for entity %s\n", "" + I));
                DumpScope(s, 0, 1, 0, 1);
                Msg("--- End script dump\n")
            } else return Msg(Fmt("Entity has no script scope! %s\n", "" + I))
        } else return Msg("Invalid entity!\n")
    } else if (I) {
        local e;
        while (e = Entities.Next(e)) {
            local s = e.GetScriptScope();
            if (s) {
                Msg(Fmt("\n--- Script dump for entity %s\n", "" + e));
                DumpScope(s, 0, 1, 0, 1);
                Msg("--- End script dump\n")
            }
        }
    }
}
if (!PORTAL2) {
    VS.GetPlayersAndBots <- function() {
        local e, P = [], B = [];
        while (e = Entities.FindByClassname(e, "cs_bot")) B.append(e.weakref());
        e = null;
        while (e = Entities.FindByClassname(e, "player")) {
            local s = e.GetScriptScope();
            if ("networkid" in s && s.networkid == "BOT") B.append(e.weakref());
            else P.append(e.weakref())
        }
        return [P, B]
    }
    VS.GetAllPlayers <- function() {
        local e, a = [];
        while (e = Entities.FindByClassname(e, "player")) a.append(e.weakref());
        e = null;
        while (e = Entities.FindByClassname(e, "cs_bot")) a.append(e.weakref());
        return a
    }
    VS.DumpPlayers <- function(d = false): (Fmt) {
        local a = GetPlayersAndBots(), p = a[0], b = a[1];
        Msg(Fmt("\n=======================================\n%d players found\n%d bots found\n", p.len(), b.len()));
        local c = function(_s, _a): (d, Fmt) {
            foreach(e in _a) {
                local s = e.GetScriptScope();
                if (s) s = GetVarName(s);
                if (!s) s = "null";
                Msg(Fmt("%s - %s :: %s\n", _s, "" + e, s));
                if (d && s != "null") DumpEnt(e)
            }
        }
        c("[BOT]   ", b);
        c("[PLAYER]", p);
        Msg("=======================================\n")
    }
};;
VS.GetLocalPlayer <- function(b = null) {
    local e = GetPlayerByIndex(1);
    if (e) SetName(e, "localplayer");
    if (b)::HPlayer <-e.weakref();
    return e
}
VS.GetPlayerByIndex <- function(i) {
    local e;
    while (e = Entities.FindByClassname(e, "player"))
        if (e.entindex() == i) return e;
    e = null;
    while (e = Entities.FindByClassname(e, "cs_bot"))
        if (e.entindex() == i) return e
}
VS.GetEntityByIndex <- function(i, c = "*") {
    local e;
    while (e = Entities.FindByClassname(e, c))
        if (e.entindex() == i) return e
}
VS.IsPointSized <- function(h) {
    local v = h.GetBoundingMaxs();
    return !v.x && !v.y && !v.z
}
if (!PORTAL2 && (!(0 in ::VS) || !(::VS[0] & 0x10))) {
    local Events = delegate::VS: {
        m_hProxy = null,
        m_bFixedUp = false,
        m_SV = null,
        m_Players = null,
        m_ppCache = null,
        m_pSpawner = null,
        m_pListeners = null,
        s_szEventName = null,
        s_hListener = null,
        s_fnSynchronous = null,
        __rem = null,
        __tmp = null,
        m_DeferredReg = null,
        Msg = Msg
    }
    VS.Events <- Events;
    if (!("{847D4B}" in ROOT)) ROOT["{847D4B}"] <-array(64);;
    local gED = ROOT["{847D4B}"];
    VS.GetPlayerByUserid <- function(i): (Entities) {
        if (i in m_Players) return m_Players[i];
        if (!m_Players) m_Players = {};
        local p;
        while (p = Entities.FindByClassname(p, "player")) {
            local s = p.GetScriptScope();
            if ("userid" in s && s.userid == i) {
                m_Players[i] <-p.weakref();
                return p
            }
        }
        p = null;
        while (p = Entities.FindByClassname(p, "cs_bot")) {
            local s = p.GetScriptScope();
            if ("userid" in s && s.userid == i) {
                m_Players[i] <-p.weakref();
                return p
            }
        }
    }.bindenv(VS.Events);
    local OnPlayerConnect = function(ev): (gED, ROOT, SendToConsole) {
        if (ev.networkid != "") {
            local idx;
            foreach(i, v in gED) if (!gED[i]) {
                idx = i;
                break
            };
            if (idx == null) {
                for (local i = 32; i < 64; ++i) {
                    gED[i - 32] = gED[i];
                    gED[i] = null
                }
                idx = 32;
                Msg("VS::OnPlayerConnect: ERROR!!! Player data is not being processed\n")
            };
            gED[idx] = ev;
            return
        };
        if (m_SV) {
            local sc = m_SV.remove(0);
            if (!sc || !("self" in sc)) return Msg("VS::Events: invalid scope in validation\n");
            if (!sc.__vrefs || !sc.self || !sc.self.IsValid()) return Msg("VS::Events: invalid entity in validation\n");
            if ("userid" in sc && sc.userid != ev.userid && sc.userid != -1) Msg("VS::Events: ERROR!!! conflict! [" + sc.userid + ", " + ev.userid + "]\n");
            if (ev.userid in m_Players && m_Players[ev.userid] != sc.self) Msg("VS::Events: ERROR!!! conflict! [" + sc.self + ", " + m_Players[ev.userid] + "]\n");
            sc.userid <-ev.userid;
            if (!("name" in sc)) sc.name <-"";
            if (!("networkid" in sc)) sc.networkid <-"";
            SendToConsole("banid 0.05 " + ev.userid);
            if (!(0 in m_SV)) m_SV = null
        }
    }.bindenv(VS.Events);
    local OnPlayerBan = function(ev) {
        if (!ev.userid) return;
        if (ev.kicked) return;
        local p = GetPlayerByUserid(ev.userid);
        if (!p) return Msg("VS::Events: validation failed to find player! [" + ev.userid + "]\n");
        local sc = p.GetScriptScope();
        if (sc.name != "" && sc.name != ev.name) Msg(format("VS::Events: validation: [%d] overwriting name '%s' -> '%s'\n", ev.userid, sc.name, ev.name));
        if (sc.networkid != "" && sc.networkid != ev.networkid) Msg(format("VS::Events: validation: [%d] overwriting networkid '%s' -> '%s'\n", ev.userid, sc.networkid, ev.networkid));
        sc.name = ev.name;
        sc.networkid = ev.networkid
    }.bindenv(VS.Events);
    local OnPlayerSpawn = function(ev): (gED, Fmt, ROOT) {
        foreach(i, data in gED) {
            if (!data) return;
            if (data.userid == ev.userid) {
                local p = GetPlayerByIndex(data.index + 1);
                if (!p || !p.ValidateScriptScope()) {
                    gED[i] = null;
                    Msg("VS::OnPlayerConnect: invalid player entity [" + data.userid + "] [" + (data.index + 1) + "]\n");
                    return
                };
                local sc = p.GetScriptScope();
                if ("networkid" in sc && sc.networkid != "") {
                    Msg("VS::OnPlayerConnect: ERROR!!! Something has gone wrong! ");
                    if (sc.networkid == data.networkid) {
                        gED[i] = null;
                        Msg(Fmt("Duplicated data. [%d]\n", data.userid))
                    } else {
                        Msg(Fmt("Conflicting data. [%d] ('%s', '%s')\n", data.userid, sc.networkid, data.networkid))
                    };
                    return
                };
                sc.userid <-data.userid;
                sc.name <-data.name;
                sc.networkid <-data.networkid;
                gED[i] = null;
                gED.sort();
                gED.reverse();
                return
            }
        }
    }.bindenv(VS.Events);
    local ValidateUserid = function(p): (AddEvent, Fmt, Entities) {
        if (!p || !p.IsValid() || (p.GetClassname() != "player") || !p.ValidateScriptScope()) return Msg(Fmt("VS::ValidateUserid: invalid input: %s\n", "" + p));
        if (!m_SV) m_SV = [];
        local sc = p.GetScriptScope(), b = 1;
        foreach(v in m_SV) if (v == sc) {
            b = 0;
            break
        };
        if (b) m_SV.append(sc.weakref());
        if (!m_hProxy) {
            local h = Entities.CreateByClassname("info_game_event_proxy");
            h.__KeyValueFromString("event_name", "player_connect");
            MakePersistent(h);
            m_hProxy = h.weakref()
        };
        return AddEvent(m_hProxy, "GenerateGameEvent", "", 0, p, null)
    }.bindenv(VS.Events);
    local __RemovePooledString = function(sz) {
        __rem = sz;
        m_pSpawner.SpawnEntity();
        __rem = null
    }.bindenv(VS.Events);
    local SpawnEntity = function(ev): (Entities) {
        if (!m_pSpawner) {
            local p = Entities.CreateByClassname("env_entity_maker");
            p.__KeyValueFromString("EntityTemplate", "vs.eventlistener");
            MakePersistent(p);
            m_pSpawner = p.weakref()
        };
        s_szEventName = ev;
        m_pSpawner.SpawnEntity();
        local r = s_hListener;
        s_szEventName = s_hListener = null;
        return r
    }
    local __ExecutePreSpawn = function(p) {
        local vs = VS.Events;
        if (vs.__rem) {
            p.__KeyValueFromString("targetname", vs.__rem);
            p.__KeyValueFromString("EventName", "player_connect");
            return p.Destroy()
        };
        if (!vs.s_szEventName) {
            Msg("VS::Events::PreSpawn: invalid call origin\n");
            return p.Destroy()
        };
        p.__KeyValueFromString("targetname", "");
        p.__KeyValueFromString("EventName", vs.s_szEventName);
        p.__KeyValueFromInt("FetchEventData", 1);
        p.__KeyValueFromInt("IsEnabled", 1);
        p.__KeyValueFromInt("TeamNum", -1);
        __EntityMakerResult = {
            [""] = null
        }
    }
    local __FinishSpawn = function() {
        __EntityMakerResult = null
    }
    local PostSpawn = function(pp) {
        local p = pp[""];
        s_hListener = p;
        MakePersistent(p);
        p.ValidateScriptScope();
        local sc = p.GetScriptScope();
        delegate delegate delegate sc.parent: {
            _delslot = function(k) {
                delete parent.parent[k]
            }
        }: {
            _newslot = null,
            ["{7D6E9A}"] = null
        }: sc;
        sc.rawdelete("event_data");
        if (!s_fnSynchronous) {
            local ch = [];
            if (!m_ppCache) m_ppCache = [];
            m_ppCache.append(ch.weakref());
            sc.parent._newslot = function(k, v): (ch) {
                if (k == "event_data") return ch.insert(0, v);
                return rawset(k, v)
            }
            sc.parent._get <- function(k): (ch) {
                if (k == "event_data") return ch.pop();
                return rawget(k)
            }
            local n = sc.__vname, i = n.find("_");
            n = s_szEventName + "_" + n.slice(0, i);
            p.__KeyValueFromString("targetname", n);
            p.__KeyValueFromString("OnEventFired", n + ",CallScriptFunction,");
            sc[""] <-null
        }
    }.bindenv(VS.Events);
    local OnPostSpawn = function(): (__RemovePooledString, OnPlayerConnect, OnPlayerSpawn, OnPlayerBan, ValidateUserid) {
        local VS = VS;
        if (!VS.Events.m_bFixedUp) {
            VS.Events.m_bFixedUp = true;
            Msg("VS::Events init " + VS.version + "\n");
            VS.StopListeningToAllGameEvents("VS::Events");
            VS.ListenToGameEvent("player_connect", OnPlayerConnect, "VS::Events");
            VS.ListenToGameEvent("player_spawn", OnPlayerSpawn, "VS::Events");
            VS.ListenToGameEvent("server_addban", OnPlayerBan, "VS::Events");
            VS.ListenToGameEvent("player_activate", function(ev): (ValidateUserid) {
                foreach(i, v in GetAllPlayers()) {
                    local t = v.GetScriptScope();
                    if (!("userid" in t) || t.userid == -1) ValidateUserid(v)
                }
            }.bindenv(VS), "VS::Events");
            if (VS.Events.m_DeferredReg) {
                foreach(p in VS.Events.m_DeferredReg) VS.ListenToGameEvent.pacall(p);
                VS.Events.m_DeferredReg = null
            }
        };
        local Pl = VS.Events.m_Players;
        if (Pl && Pl.len()) {
            local t = [];
            foreach(k, v in Pl) if (!v || !v.IsValid()) t.append(k);
            foreach(v in t) delete Pl[v]
        };
        if (VS.Events.__tmp) __RemovePooledString(VS.Events.__tmp);
        VS.Events.__tmp = __vname
    }
    VS.ListenToGameEvent <- function(ev, fn, ctx, sync = 0): (SpawnEntity) {
        local err, c;
        if ((typeof fn != "function") && (typeof fn != "native function")) {
            err = "invalid callback param"
        } else {
            c = fn.getinfos().parameters.len();
            if (c != 2 && c != 1) err = "invalid callback param: wrong number of parameters"
        };
        if (typeof ctx != "string") err = "invalid context param";
        if (typeof ev != "string") err = "invalid eventname param";
        if (err) {
            Msg(format("\nAN ERROR HAS OCCURED [%s]\n", err));
            return PrintStack()
        };
        if (!m_pListeners) m_pListeners = {};
        if (!(ev in m_pListeners)) m_pListeners[ev] <-{};
        local pListener = m_pListeners[ev];
        if (!(ctx in pListener)) pListener[ctx] <-null;
        if (!m_bFixedUp) {
            if (!m_DeferredReg) m_DeferredReg = [];
            m_DeferredReg.append([this, ev, fn, ctx, sync]);
            return
        };
        local p = pListener[ctx];
        if (!p || !p.IsValid()) {
            if (sync || ctx == "VS::Events") s_fnSynchronous = fn;
            else s_fnSynchronous = null;
            if (!(p = SpawnEntity(ev))) return Msg("VS::ListenToGameEvent: ERROR!!! NULL ent!\n");
            pListener[ctx] = p.weakref();
            if (s_fnSynchronous) {
                s_fnSynchronous = null;
                if (ctx == "VS::Events") {
                    p.GetScriptScope().parent._newslot = function(k, v): (fn) {
                        if (k == "event_data") return fn(v)
                    }
                    return
                }
            }
        };
        local sc = p.GetScriptScope();
        if (!!sync == sc.parent.rawin("_get")) {
            Msg("VS::ListenToGameEvent: changing synchronicity of " + ev + ":" + ctx + "\n");
            p.Destroy();
            return ListenToGameEvent(ev, fn, ctx, sync)
        };
        if (!sync) {
            if (c == 1) sc[""] = fn;
            else sc[""] = function(): (fn) return fn(event_data)
        } else {
            if (c == 1) sc.parent._newslot = function(k, v): (fn, ev, ctx) {
                if (k == "event_data") try fn()
                catch (x) return print(format("\nAN ERROR HAS OCCURED [%s] ON EVENT [%s:%s]\n\n", x, ev, ctx))
            } else sc.parent._newslot = function(k, v): (fn, ev, ctx) {
                if (k == "event_data") try fn(v)
                catch (x) return print(format("\nAN ERROR HAS OCCURED [%s] ON EVENT [%s:%s]\n\n", x, ev, ctx))
            }
        }
    }.bindenv(VS.Events);
    VS.StopListeningToAllGameEvents <- function(ctx): (dummy) {
        if (m_pListeners) foreach(v in m_pListeners) {
            if (ctx in v) {
                local p = v[ctx];
                if ((typeof p == "instance") && p.IsValid()) {
                    p.GetScriptScope().parent._newslot = dummy;
                    p.Destroy()
                };
                delete v[ctx]
            }
        }
    }.bindenv(VS.Events);
    VS.Events.DumpListeners <- function() {
        if (m_pListeners && m_pListeners.len()) {
            local ll = [];
            foreach(ev, v in m_pListeners) ll.append(ev);
            ll.sort();
            local Fmt = format;
            foreach(ev in ll) {
                local v = m_pListeners[ev];
                foreach(ctx, p in v) {
                    if (ctx != "VS::Events") {
                        if (p && (typeof p == "instance") && p.IsValid()) {
                            Msg(Fmt("  %-32.32s  | %-32.64s |  %.64s\n", ev, ctx, p.GetName()))
                        } else {
                            Msg(Fmt("  %-32.32s  | %-32.64s |  <null>\n", ev, ctx))
                        }
                    }
                }
            }
        }
    }.bindenv(VS.Events);
    VS.Events.InitTemplate <- function(sc): (__ExecutePreSpawn, __FinishSpawn, PostSpawn, OnPostSpawn) {
        local self;
        if (!("self" in sc) || !(self = sc.self) || !self.IsValid() || self.GetClassname() != "point_template") throw "VS::Events::InitTemplate: invalid entity";
        self.__KeyValueFromInt("spawnflags", 0);
        self.__KeyValueFromString("targetname", "vs.eventlistener");
        sc.__EntityMakerResult <-null;
        sc.__ExecutePreSpawn <-__ExecutePreSpawn;
        sc.__FinishSpawn <-__FinishSpawn;
        sc.PreSpawnInstance <-1;
        sc.PostSpawn <-PostSpawn;
        sc.OnPostSpawn <-OnPostSpawn.bindenv(sc);
        if (m_ppCache) {
            for (local i = m_ppCache.len(); i--;) {
                local v = m_ppCache[i];
                if (v) v.clear();
                else m_ppCache.remove(i)
            }
        };
        if ("EventQueue" in VS) VS.EventQueue.Clear()
    }
};; {
    local Log = {
        export = false,
        file_prefix = "vs.log",
        filter = "L ",
        _dev = null,
        _data = null,
        _cb = null,
        _file = null,
        _inprogress = false
    }
    VS.Log <-Log;
    Log.Add <- function(s) {
        return _data.append(s)
    }.bindenv(Log);
    Log.Pop <- function() {
        return _data.pop()
    }.bindenv(Log);
    Log.Clear <- function() {
        if (_data) _data.clear();
        else _data = []
    }.bindenv(Log);
    local Cmd = SendToConsole;
    Log.Run <- function(fn = null, env = null): (Cmd, developer, Fmt, TI) {
        if (!_data) return;
        if (_inprogress) return;
        if (typeof fn == "function") {
            if (env) fn = fn.bindenv(env);
            _cb = fn
        };
        nL <-_data.len();
        nD <-1984;
        nC <-0;
        nN <-nD < nL ? nD : nL;
        _inprogress = true;
        if (
            export) {
            local s = _file = file_prefix[0] == ':' ? file_prefix.slice(1) : Fmt("%s_%s", file_prefix, VS.UniqueString());
            _dev = developer();
            Cmd(Fmt("developer 0;con_filter_enable 1;con_filter_text_out\"%s\";con_filter_text\"\";con_logfile\"%s.log\";script VS.EventQueue.AddEvent(VS.Log._Write,%g,VS.Log)", filter, s, TI * 4.0));
            return s
        } else Cmd("script VS.Log._Write()")
    }.bindenv(Log);
    local EQA = VS.EventQueue.AddEvent;
    Log._Write <- function(): (Msg, EQA, Cmd) {
        {
            local t = filter, p = Msg, L = _data;
            if (
                export)
                for (local i = nC; i < nN; ++i) p(t + L[i]);
            else
                for (local i = nC; i < nN; ++i) p(L[i])
        }
        nC += nD;
        local i = nN + nD;
        if (i < nL) nN = i;
        else nN = nL;
        if (nC >= nN) {
            _data = nL = nD = nC = nN = null;
            _inprogress = false;
            if (
                export) Cmd("con_logfile\"\";con_filter_text_out\"\";con_filter_text\"\";con_filter_enable 0;developer " + _dev + ";script VS.Log._Dispatch()");
            else _Dispatch();
            return
        };
        return EQA(_Write, 0.002, this)
    }
    Log._Dispatch <- function() {
        if (_cb) {
            _cb(_file);
            _cb = _file = null
        }
    }
} {
    local gVS = ::VS, T;
    if ("version" in gVS) {
        local pV1 = split(gVS.version, "."), pV2 = split(VS.version, ".");
        if (!((2 in pV1) && (2 in pV2))) return;
        local s = function(p) {
            local x = p[0].len();
            while (0 <= --x) {
                local c = p[0][x];
                if (c > '9' || c < '0') {
                    p[0] = p[0].slice(x, p[0].len());
                    break
                }
            }
            x = 0;
            for (local i = p.len() - 1, l = p[i].len(); ++x < l;) {
                local c = p[i][x];
                if (c > '9' || c < '0') {
                    p[i] = p[i].slice(0, x);
                    break
                }
            }
        }
        s(pV1);
        s(pV2);
        local l1 = pV1.len(), l2 = pV2.len();
        if (l2 > l1) {
            pV1.resize(l2, 0);
            l1 = l2
        } else if (l2 < l1) pV2.resize(l1, 0);;
        local x = 0;
        do {
            local v1 = pV1[x].tointeger(), v2 = pV2[x].tointeger();
            if (v2 != v1) {
                T = v2 > v1;
                break
            }
        } while (++x < l1);
        if (T == null)
            if ((gVS[0] & VS[0]) == VS[0]) return
    };
    if (T == null) {
        foreach(k, v in VS) gVS.rawset(k, v);::ToExtendedPlayer <-VS.ToExtendedPlayer.weakref();
        print(format("VS v%s [%Xh]\n", gVS.version, gVS[0]))
    } else {
        local n = gVS[0] | VS[0];
        print(format("VS v%s [%Xh] %d(%Xh|%Xh)\n", gVS.version, n, T.tointeger(), gVS[0], VS[0]));
        if (T) {
            foreach(k, v in VS) {
                if (k == "Events") continue;
                gVS.rawset(k, v)
            }::ToExtendedPlayer <-VS.ToExtendedPlayer.weakref()
        } else {
            foreach(k, v in VS) if (!(k in gVS)) {
                if (k == "Events") continue;
                gVS.rawset(k, v)
            }
        };
        gVS[0] = n
    };
    VS = null;
    return collectgarbage()
}