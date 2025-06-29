vallkarri.custom_colours = {
    VALK_PRESTIGIOUS = {HEX("60f542"), HEX("5efaff")}
}

local updhook = Game.update

for name,color in pairs(vallkarri.custom_colours) do
    G.C[name] = {0, 0, 0, 0}
end
function Game:update(dt)
	updhook(self, dt)
	--copied from cryptid, basically.
    -- sowwy :(
	local anim_timer = self.TIMERS.REAL * 1.5
	local p = 0.5 * (math.sin(anim_timer) + 1)
	for k, c in pairs(vallkarri.custom_colours) do
		if not G.C[k] then
			G.C[k] = { 0, 0, 0, 0 }
		end
		for i = 1, 4 do
			G.C[k][i] = c[1][i] * p + c[2][i] * (1 - p)
		end
	end

    for name,colors in pairs(vallkarri.custom_colours) do
        if G.C.RARITY[string.lower(name)] then
            G.C.RARITY[string.lower(name)] = G.C[name]
        end
    end
end