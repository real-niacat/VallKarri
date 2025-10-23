if not SMODS.DynaTextEffect then
    return
end

local function bpow(b,e)
    return (math.abs(b)^e)*(b/math.abs(b))
end

SMODS.DynaTextEffect {
    key = "floaty",
    func = function(dynatext, index, letter)
        local speed = 1.5
        local time = (G.TIMERS.REAL + (index * 5)) * speed
        local float_amount = 8
        letter.offset.x = math.sin(time * math.pi) * float_amount
        letter.offset.y = math.cos(time * math.pi) * float_amount
    end
}

SMODS.DynaTextEffect {
    key = "glitch",
    func = function(dynatext, index, letter)
        local chars = "!@#$%^&*()_-=><"
        local t = (G.TIMERS.REAL + (index * 5)) * (math.sin(index * 0.2) * 3 * (index ^ 0.55))
        t = math.floor(t)
        local oldt = t
        t = t % 10
        local li = index ^ 0.1


        letter.offset.x = bpow(((math.sin(oldt) * 4) * li), 2.8)
        letter.offset.y = bpow((math.cos(oldt) * math.pi) * li, 1.8)

        if t <= 2 then
            letter.offset.x = bpow(letter.offset.x, index / 7)
            letter.offset.y = bpow(letter.offset.y, index / 11)
        end

        letter.offset.x = bpow(letter.offset.x,0.7)
        letter.offset.y = bpow(letter.offset.y, 0.7)
    end
}


SMODS.DynaTextEffect {
    key = "censor",
    func = function(dynatext, index, letter)
        local chars = "!@#$%^&*????abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        math.randomseed(math.floor(index*G.TIMERS.REAL))
        local a = math.random(1,#chars)
        letter.letter = love.graphics.newText(dynatext.font.FONT, string.sub(chars, a,a))
    end
}
