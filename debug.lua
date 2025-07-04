local g = Game.update
function Game:update(dt)
    g(self, dt)
    ease_background_colour(G.C.CRY_ASCENDANT)
end