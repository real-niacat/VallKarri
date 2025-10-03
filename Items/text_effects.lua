SMODS.DynaTextEffect {
    key = "floaty",
    func = function(dynatext, index, letter)
        local speed = 1.5
        local time = (G.TIMERS.REAL + (index*5))*speed
        local float_amount = 8
        letter.offset.x = math.sin(time*math.pi) * float_amount
        letter.offset.y = math.cos(time*math.pi) * float_amount
    end
}