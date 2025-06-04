SMODS.Joker {
	key = "logo",
    loc_txt = {
        name = "VallKarri Logo",
        text = {
            "Also play Entropy!"
        }
    },
    rarity = "valk_unobtainable",
    atlas = "main",
    pos = {x = 9, y = 2},
}

local mainmenu = Game.main_menu
Game.main_menu = function(change_context)
	local ret = mainmenu(change_context)
	local newcard = Card(
		G.title_top.T.x,
		G.title_top.T.y,
		G.CARD_W,
		G.CARD_H,
		G.P_CARDS.empty,
		G.P_CENTERS.j_valk_logo,
		{ bypass_discovery_center = true }
	)

	G.title_top:emplace(newcard)
	newcard.T.w = newcard.T.w * 1.1 * 1.2
	newcard.T.h = newcard.T.h * 1.1 * 1.2
	-- newcard.no_ui = true
	-- "borrowed" code from cryptid that does the exact same thing

	return ret
end