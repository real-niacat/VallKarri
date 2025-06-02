local mainmenu = Game.main_menu
Game.main_menu = function(change_context)
	local ret = mainmenu(change_context)
	-- adds a Cryptid spectral to the main menu
	local newcard = Card(
		G.title_top.T.x,
		G.title_top.T.y,
		G.CARD_W,
		G.CARD_H,
		G.P_CARDS.empty,
		G.P_CENTERS.j_valk_vallkarrilua,
		{ bypass_discovery_center = true }
	)
	-- recenter the title
	-- G.title_top.T.w = G.title_top.T.w * 1.7675
	-- G.title_top.T.x = G.title_top.T.x - 0.8
	G.title_top:emplace(newcard)
	-- make the card look the same way as the title screen Ace of Spades
	newcard.T.w = newcard.T.w * 1.1 * 1.2
	newcard.T.h = newcard.T.h * 1.1 * 1.2
	-- newcard.children.floating_sprite.T.w = newcard.children.floating_sprite.T.w * 1.1 * 1.2
	-- newcard.children.floating_sprite.T.h = newcard.children.floating_sprite.T.h * 1.1 * 1.2 
	newcard.no_ui = true

	-- draw_shader(_shader, _shadow_height, _send, _no_tilt, other_obj, ms, mr, mx, my, custom_shader, tilt_shadow)
	-- newcard.children.floating_sprite:draw_shader(nil, nil, nil, nil, nil, nil, nil, 1.1*1.2, 1.1*1.2, nil, nil )

	-- get_first(G.title_top.cards).children.floating_sprite.CT.w = get_first(G.title_top.cards).children.floating_sprite.CT.w * 1.1 * 1.2

	return ret
end