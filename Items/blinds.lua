SMODS.Atlas {
    key = "bli",
    path = "blinds.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
}

SMODS.Blind {
    key = "fanningflames",
    loc_txt = {
        name = "Fanning Flames",
        text = {
            "All played cards become marked for death",
            "Marked for death has no visual indicator",
            "Cards held in hand become rental",
            "Must play at least 4 cards"
        }
    },
    atlas = "bli",
    pos = {y = 0, x = 0},
    boss = {min = 32, max = 0},
    boss_colour = HEX("EB7632"),
    dollars = 0,
    mult = 1e100,
    calculate = function(self, blind, context)
		if context.after then
            for i,c in ipairs(G.play.cards) do
			    c.ability.valk_marked_for_death = true
            end
		end

        if context.before then
            for i,c in ipairs(G.hand.cards) do
                c.ability.rental = true
            end
        end
	end,
    debuff_hand = function(self, cards, hand, handname, check)
        return (#cards < 4)
    end,
}