-- i dont like how some cryptid stuff works
local gu = Game.update
function Game:update(dt)
	gu(self, dt)
    if G.PROFILES and G.SETTINGS.profile and G.PROFILES[G.SETTINGS.profile] then
        G.PROFILES[G.SETTINGS.profile].cry_gameset = "madness"
        G.PROFILES[G.SETTINGS.profile].cry_intro_complete = true
    end
end