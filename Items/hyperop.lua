-- thanks ruby for the tetration function (except i had to modify it a lot because it was bugged)
local NaN = 0/0

--- Approximates W_0(x)
--- @param x number
--- @return number
local function lambert_w(x)
    local tolerance = 1e-10
    local w, wn
    local OMEGA = 0.56714329040978387299997
    if x == 0 then return 0 end
    if x == 1 then return OMEGA end
    if x < 10 then w = 0 else w = math.log(x) - math.log(math.log(x)) end
    for _ = 0,99 do
        wn = (x*math.exp(-w) + w*w) / (w+1)
        if (math.abs(wn-w) < tolerance*math.abs(wn)) then
            return wn
        end
        w=wn
    end

    -- this means you probably tried to calculate W_0 of an x < -1/e
    -- so don't do that :)
    error("Lambert W iteration failed to converge")
end

--- Calculates a ^^ b;
--- Less precise for high heights
--- @param base number
--- @param height number
--- @return number
function vallkarri.tetrate(base, height)
    -- just use Talisman's tetration if possible
    if Talisman then return to_big(base):tetrate(height) end

    -- avoid easy cases; taken from omeganum tetrate
    if height <= -2 then return NaN end
    if base == 0 then return height == 0 and NaN or math.ceil(height) % 2 end
    if base == 1 then return height == -1 and NaN or 1 end
    if height == -1 then return 0 end
    if height == 0 then return 1 end
    if height == 1 then return base end

    -- the function itself

    -- approximation
    if height > 1e6 then
        if base < math.e^(1/math.e) then
            local negln = -math.log(base)
            return lambert_w(negln) / negln
        end
        return base == 1 and 1 or (base > 0 and base < 1 and 0) or (base < 0 and NaN) or math.huge
    end

    -- exact
    local frac = height - math.floor(height)
    local tower = {}
    for i = 2, math.floor(height) do
        tower[#tower+1] = base
    end
    local tot = tower[#tower] ^ (base ^ frac)
    for i = #tower, 1, -1 do
        print(i, tower[i], tot)
        tot = tower[i] ^ tot
    end
    return tot
end