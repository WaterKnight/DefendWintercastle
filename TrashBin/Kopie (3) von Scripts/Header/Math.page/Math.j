//! runtextmacro Folder("Math")
    //! runtextmacro Struct("Integer")
        static integer MIN = -2147483645
    endstruct

    //! runtextmacro Struct("Hex")
        static string array MAP

        static method FromDec takes integer dec returns string
            local string result = ""
            local integer value

            if (dec < 0) then
                return Char.MINUS + thistype.FromDec(-dec)
            endif

            loop
                exitwhen (dec < 16)

                set value = Math.MinI(dec / 16, 15)

                set dec = dec - value * 16
                set result = result + thistype.MAP[value]
            endloop

            return (result + thistype.MAP[dec])
        endmethod

        static method ToDec takes string value returns integer
            local string digit
            local integer factor = 1
            local integer length = StringLength(value)
            local integer mapIndex
            local integer result = 0

            local integer iteration = length - 1

            if (SubString(value, 0, 1) == Char.MINUS) then
                return -thistype.ToDec(SubString(value, 1, length))
            endif

            loop
                exitwhen (iteration < 0)

                set digit = StringCase(SubString(value, iteration, iteration + 1), true)
                set mapIndex = 15

                loop
                    exitwhen (digit == thistype.MAP[mapIndex])

                    set mapIndex = mapIndex - 1
                endloop

                set result = result + mapIndex * factor

                set factor = factor * 16
                set iteration = iteration - 1
            endloop

            return result
        endmethod

        static method Add takes string a, string b returns string
            return thistype.FromDec(thistype.ToDec(a) + thistype.ToDec(b))
        endmethod

        static method Subtract takes string a, string b returns string
            return thistype.FromDec(thistype.ToDec(a) - thistype.ToDec(b))
        endmethod

        static method Multiply takes string a, string b returns string
            return thistype.FromDec(thistype.ToDec(a) * thistype.ToDec(b))
        endmethod

        static method Divide takes string a, string b returns string
        call BJDebugMsg("divide "+a+"/"+"b"+"-->"+I2S(thistype.ToDec(a))+"/"+I2S(thistype.ToDec(b))+"-->"+thistype.FromDec(thistype.ToDec(a) / thistype.ToDec(b)))
            return thistype.FromDec(thistype.ToDec(a) / thistype.ToDec(b))
        endmethod

        static method Init takes nothing returns nothing
            set thistype.MAP[0] = "0"
            set thistype.MAP[1] = "1"
            set thistype.MAP[2] = "2"
            set thistype.MAP[3] = "3"
            set thistype.MAP[4] = "4"
            set thistype.MAP[5] = "5"
            set thistype.MAP[6] = "6"
            set thistype.MAP[7] = "7"
            set thistype.MAP[8] = "8"
            set thistype.MAP[9] = "9"
            set thistype.MAP[10] = "A"
            set thistype.MAP[11] = "B"
            set thistype.MAP[12] = "C"
            set thistype.MAP[13] = "D"
            set thistype.MAP[14] = "E"
            set thistype.MAP[15] = "F"
        endmethod
    endstruct

    //! runtextmacro Struct("Shapes")
        static method DistToLine takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd, real x, real y returns real
            local real dX = x - sourceX
            local real dY = y - sourceY

            local real angleD = Math.AngleDifference(angle, Math.AtanByDeltas(dY, dX))
            local real d = Math.DistanceByDeltas(dX, dY)

            local real dLength = Math.Cos(angleD) * d
            local real dWidth = Math.Sin(angleD) * d

            if (dLength < 0.) then
                return Math.DistanceByDeltas(dLength, Math.Max(0., dWidth - widthStart))
            endif
            if (dLength > length) then
                return Math.DistanceByDeltas(dLength - length, Math.Max(0., dWidth - widthEnd))
            endif

            return Math.Max(0., dWidth - (widthStart + (widthEnd - widthStart) * dLength / length))
        endmethod

        static method InLine takes real sourceX, real sourceY, real length, real angle, real widthStart, real widthEnd, real x, real y returns boolean
            return (thistype.DistToLine(sourceX, sourceY, length, angle, widthStart, widthEnd, x, y) == 0.)
        endmethod

        static method InTriangle_Child takes real aX, real aY, real bX, real bY, real cX, real cY returns integer
            return Math.Sign(aX * (bY - cY) + aY * (cX - bX) + bX * cY - bY * cX)
        endmethod

        static method InTriangle takes real aX, real aY, real bX, real bY, real cX, real cY, real x, real y returns boolean
            local real avgX = (aX + bX + cX) / 3
            local real avgY = (aY + bY + cY) / 3

            if (thistype.InTriangle_Child(avgX, avgY, aX, aY, bX, bY) == thistype.InTriangle_Child(x, y, aX, aY, bX, bY)) then
                if (thistype.InTriangle_Child(avgX, avgY, aX, aY, cX, cY) == thistype.InTriangle_Child(x, y, aX, aY, cX, cY)) then
                    if (thistype.InTriangle_Child(avgX, avgY, bX, bY, cX, cY) == thistype.InTriangle_Child(x, y, bX, bY, cX, cY)) then
                        return true
                    endif
                endif
            endif

            return false
        endmethod

        static method InQuadrilateral takes real aX, real aY, real bX, real bY, real cX, real cY, real dX, real dY, real x, real y returns boolean
            if ((Math.AngleBetweenVectors(bX - aX, bY - aY, dX - aX, dY - aY) + Math.AngleBetweenVectors(bX - cX, bY - cY, dX - cX, dY - cY)) > (Math.AngleBetweenVectors(aX - bX, aY - bY, cX - bX, cY - bY) + Math.AngleBetweenVectors(aX - dX, aY - dY, cX - dX, cY - dY))) then
                if ((thistype.InTriangle(aX, aY, bX, bY, cX, cY, x, y)) or (thistype.InTriangle(aX, aY, cX, cY, dX, dY, x, y))) then
                    return true
                endif
            else
                if ((thistype.InTriangle(aX, aY, bX, bY, dX, dY, x, y)) or (thistype.InTriangle(bX, bY, cX, cY, dX, dY, x, y))) then
                    return true
                endif
            endif

            return false
        endmethod
    endstruct
endscope

function Acos_Wrapped takes real x returns real
    return Acos(x)
endfunction

function Atan_Wrapped takes real x returns real
    return Atan(x)
endfunction

function Sin_Wrapped takes real x returns real
    return Sin(x)
endfunction

function Cos_Wrapped takes real x returns real
    return Cos(x)
endfunction

function Tan_Wrapped takes real x returns real
    return Tan(x)
endfunction

//! runtextmacro StaticStruct("Math")
    static constant real EPSILON = 0.01
    static integer array LOGS_OF_2I
    static constant integer LOGS_OF_2I_COUNT = 1024
    static constant real PI = 3.141592654

    static constant real DEG_TO_RAD = thistype.PI / 180.
    static constant real DOUBLE_PI = 2 * thistype.PI
    static constant real EAST_ANGLE = 0.
    static constant real FULL_ANGLE = thistype.DOUBLE_PI
    static constant real HALF_ANGLE = thistype.PI
    static constant real HALF_PI = thistype.PI / 2
    static constant real NORTH_ANGLE = 0.5 * thistype.PI
    static integer array POWERS_OF_2I
    static constant integer POWERS_OF_2I_COUNT = 20
    static constant real QUARTER_ANGLE = thistype.HALF_PI
    static constant real RAD_TO_DEG = 180. / thistype.PI
    static constant real SOUTH_ANGLE = 1.5 * thistype.PI
    static constant real WEST_ANGLE = thistype.PI

    //! runtextmacro LinkToStaticStruct("Math", "Integer")
    //! runtextmacro LinkToStaticStruct("Math", "Hex")
    //! runtextmacro LinkToStaticStruct("Math", "Shapes")

    static method Acos takes real x returns real
        return Acos_Wrapped(x)
    endmethod

    static method Atan takes real x returns real
        return Atan_Wrapped(x)
    endmethod

    static method AtanByDeltas takes real y, real x returns real
        return Atan2(y, x)
    endmethod

    static method Cos takes real x returns real
        return Cos_Wrapped(x)
    endmethod

    static method Sin takes real x returns real
        return Sin_Wrapped(x)
    endmethod

    static method Tan takes real x returns real
        return Tan_Wrapped(x)
    endmethod

    static method Square takes real a returns real
        return (a * a)
    endmethod

    static method Sqrt takes real a returns real
        return SquareRoot(a)
    endmethod

    static method DistanceByDeltas takes real x, real y returns real
        return thistype.Sqrt(x * x + y * y)
    endmethod

    static method DistanceSquareByDeltas takes real x, real y returns real
        return (x * x + y * y)
    endmethod

    static method DistanceByDeltasWithZ takes real x, real y, real z returns real
        return thistype.Sqrt(x * x + y * y + z * z)
    endmethod

    static method DistanceSquareByDeltasWithZ takes real x, real y, real z returns real
        return (x * x + y * y + z * z)
    endmethod

    static method Max takes real a, real b returns real
        if (a > b) then
            return a
        endif

        return b
    endmethod

    static method MaxI takes integer a, integer b returns integer
        return Real.ToInt(thistype.Max(a, b))
    endmethod

    static method Min takes real a, real b returns real
        if (a < b) then
            return a
        endif

        return b
    endmethod

    static method GetMovementDuration takes real distance, real speed, real acceleration returns real
        local real result

        if (acceleration == 0.) then
            if (speed == 0.) then
                if (distance == 0.) then
                    return 0.
                endif

                return -1.
            endif

            return (distance / speed)
        endif

        set result = -speed / acceleration - thistype.Sqrt(speed * speed / acceleration / acceleration + 2 * distance / acceleration)

        if (result < 0.) then
            return (-speed / acceleration + thistype.Sqrt(speed * speed / acceleration / acceleration + 2 * distance / acceleration))
        endif

        return result
    endmethod

    static method Limit takes real value, real min, real max returns real
        return thistype.Min(thistype.Max(min, value), max)
    endmethod

    static method MinI takes integer a, integer b returns integer
        return Real.ToInt(thistype.Min(a, b))
    endmethod

    static method MinMax takes real a, real b, boolean flag returns real
        if (flag) then
            return thistype.Max(a, b)
        endif

        return thistype.Min(a, b)
    endmethod

    static method MinMaxI takes integer a, integer b, boolean flag returns integer
        return Real.ToInt(thistype.MinMax(a, b, flag))
    endmethod

    static method Abs takes real a returns real
        if (a < 0) then
            return -a
        endif

        return a
    endmethod

    static method Compare takes real a, limitop whichOperator, real b returns boolean
        if (whichOperator == LESS_THAN) then
            if (a < b) then
                return true
            endif
        elseif (whichOperator == LESS_THAN_OR_EQUAL) then
            if (a <= b) then
                return true
            endif
        elseif (whichOperator == EQUAL) then
            if (a == b) then
                return true
            endif
        elseif (whichOperator == NOT_EQUAL) then
            if (a != b) then
                return true
            endif
        elseif (whichOperator == GREATER_THAN) then
            if (a > b) then
                return true
            endif
        elseif (whichOperator == GREATER_THAN_OR_EQUAL) then
            if (a >= b) then
                return true
            endif
        endif

        return false
    endmethod

    static method CompareMinMax takes real a, real b, boolean flag returns boolean
        if (flag) then
            if (a > b) then
                return true
            endif
        else
            if (a < b) then
                return true
            endif
        endif

        return false
    endmethod

    static method Linear takes real dX, real dY, real min, real max returns real
        if (dY == 0.) then
            return ((max + min) / 2)
        endif

        return thistype.Limit(min + dX / dY * (max - min), min, max)
    endmethod

    static method RandomI takes integer lowBound, integer highBound returns integer
        return GetRandomInt(lowBound, highBound)
    endmethod

    static method Random takes real lowBound, real highBound returns real
        return GetRandomReal(lowBound, highBound)
    endmethod

    static method RandomLowRange takes real lowBound, real range returns real
        return thistype.Random(lowBound, lowBound + range)
    endmethod

    static method RandomAngle takes nothing returns real
        return thistype.Random(0., FULL_ANGLE)
    endmethod

    static method Sign takes real a returns integer
        if (a < 0) then
            return -1
        elseif (a == 0) then
            return 0
        endif

        return 1
    endmethod

    static method Power takes real base, real exponent returns real
        return Pow(base, exponent)
    endmethod

    static method PowerI takes integer base, integer exponent returns integer
        return Real.ToInt(thistype.Power(base, exponent))
    endmethod

    static method PowerOf2I takes integer exponent returns integer
        if (exponent > thistype.POWERS_OF_2I_COUNT) then
            call Game.DebugMsg("PowerOf2I: " + "index was too HIGH ("+I2S(exponent)+")")

            return thistype.PowerI(exponent, 2)
        endif

        return thistype.POWERS_OF_2I[exponent]
    endmethod

    static method AngleBetweenCoords takes real x1, real y1, real x2, real y2 returns real
        return thistype.AtanByDeltas(y2 - y1, x2 - x1)
    endmethod

    static method AngleBetweenVectors takes real aX, real aY, real bX, real bY returns real
        return thistype.Acos((aX * bX + aY * bY) / (thistype.Sqrt(aX * aX + aY * aY) * thistype.Sqrt(bX * bX + bY * bY)))
    endmethod

    static method Mod takes real dividend, real divisor returns real
        local real result

        //set dividend = thistype.CutReal(dividend)
        //set divisor = thistype.CutReal(divisor)

        if (divisor == 0) then
            set result = -1
        else
            set result = dividend - Real.ToInt(dividend / divisor) * divisor
            if (result < 0) then
                set result = result + divisor
            endif
        endif
        return result
    endmethod

    static method ModI takes integer dividend, integer divisor returns integer
        return Real.ToInt(thistype.Mod(dividend, divisor))
    endmethod

    static method RoundTo_GetDifference takes real dividend, real divisor returns real
        return thistype.Abs(dividend - Real.ToInt(dividend / divisor) * divisor)
    endmethod

    static method RoundTo takes real base, real interval returns real
        local real d
        local real d2

        if (interval == 0) then
            return 0.
        endif

        set d = thistype.RoundTo_GetDifference(base, interval)

        set d2 = thistype.Abs(interval) - d

        if (d2 < d) then
            return (base + thistype.Sign(interval) * d2)
        endif

        return (base - thistype.Sign(interval) * d)
    endmethod

    static method AngleDifference takes real a, real b returns real
        local real result

        set a = thistype.Mod(a, thistype.FULL_ANGLE)
        set b = thistype.Mod(b, thistype.FULL_ANGLE)

        set result = thistype.Abs(a - b)

        if (result > thistype.HALF_ANGLE) then
            return (thistype.FULL_ANGLE - result)
        endif

        return result
    endmethod

    static method CompareAngles takes real a, real b returns boolean
        set a = thistype.Mod(a, thistype.FULL_ANGLE)
        set b = thistype.Mod(b, thistype.FULL_ANGLE)

        if (a < b) then
            return false
        endif

        return true
    endmethod

    static method LimitAngle takes real value, real lowBound, real highBound returns real
        local real valueHighBoundD
        local real valueLowBoundD

        //set highBound = thistype.Mod(lowBound, thistype.FULL_ANGLE)
        //set lowBound = thistype.Mod(lowBound, thistype.FULL_ANGLE)
        //set value = thistype.Mod(value, thistype.FULL_ANGLE)

        set valueHighBoundD = thistype.AngleDifference(value, highBound)
        set valueLowBoundD = thistype.AngleDifference(value, lowBound)

        if (valueLowBoundD + valueHighBoundD - EPSILON > thistype.Abs(highBound - lowBound)) then
            if (valueLowBoundD < valueHighBoundD) then
                return lowBound
            endif

            return highBound
        endif

        return value
    endmethod

    static method Log takes real a, real b returns integer
        local integer result

        if (a == 0) then
            return 0
        endif

        set result = 0

        loop
            exitwhen (Pow(b, result / 10.) >= a)

            set result = result + 10
        endloop

        loop
            exitwhen (Pow(b, result / 10.) <= a)

            set result = result - 1
        endloop

        return (result / 10)
    endmethod

    static method LogI takes integer a, integer b returns integer
        return thistype.Log(a, b)
    endmethod

    static method LogOf2I takes integer a returns integer
        if (a > thistype.LOGS_OF_2I_COUNT) then
            //call Game.DebugMsg("LogOf2I: " + "index was too HIGH ("+I2S(a)+")")

            return thistype.LogI(a, 2)
        endif

        return thistype.LOGS_OF_2I[a]
    endmethod

    static method LogOf2I_Init takes nothing returns nothing
        local integer iteration = TEMP_INTEGER

        loop
            exitwhen (iteration < ARRAY_MIN)

            set thistype.LOGS_OF_2I[iteration] = thistype.LogI(iteration, 2)
            set iteration = iteration - 1

            set TEMP_INTEGER2 = TEMP_INTEGER2 + 1
            exitwhen (TEMP_INTEGER2 > 500)
        endloop

        if (iteration > ARRAY_EMPTY) then
            set TEMP_INTEGER = iteration
            set TEMP_INTEGER2 = 0

            call Code.Run(function thistype.LogOf2I_Init)
        endif
    endmethod

    static method Init takes nothing returns nothing
        local integer iteration = thistype.POWERS_OF_2I_COUNT

        loop
            exitwhen (iteration < ARRAY_MIN)

            set thistype.POWERS_OF_2I[iteration] = thistype.PowerI(2, iteration)

            set iteration = iteration - 1
        endloop

        set TEMP_INTEGER = thistype.LOGS_OF_2I_COUNT
        set TEMP_INTEGER2 = 0

        call Code.Run(function thistype.LogOf2I_Init)

        call thistype.Hex.Init()
    endmethod
endstruct