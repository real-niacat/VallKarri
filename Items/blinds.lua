SMODS.Blind {
    key = "fanningflames",
    loc_txt = {
        name = "Fanning Flames",
        text = {
            "All played cards become rental and marked for death",
            "Marked for death has no visual indicator",
            "Must play at least 4 cards"
        }
    },
    boss = {min = 32, max = 0},
    boss_colour = HEX("EB7632"),
    dollars = 0,
    mult = 1e100,
    calculate = function(self, blind, context)
		if context.individual and context.cardarea == G.play and context.other_card then
			context.other_card.ability.valk_marked_for_death = true
		end
	end,
    debuff_hand = function(self, cards, hand, handname, check)
        return (#cards < 4)
    end,
}