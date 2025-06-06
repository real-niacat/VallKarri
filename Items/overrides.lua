SMODS.Joker {
	key = "logo",
    loc_txt = {
        name = "VallKarri Logo",
        text = {
            "what"
        }
    },
    rarity = "valk_unobtainable",
    atlas = "main",
    pos = {x = 9, y = 2},
	hidden = true,
	no_collection = true,
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
	newcard.no_ui = true
	-- "borrowed" code from cryptid that does the exact same thing

	return ret
end


local hudcopy = create_UIBox_HUD
function create_UIBox_HUD(force)
	local res = hudcopy()

	if (G.GAME.nomult or force) then 

		res.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes[1].config.minw = 4
		res.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes[2] = {n=G.UIT.C, config={align = "cm"}, nodes={
			{n=G.UIT.T, config={id = "chipmult_op", text = "", lang = G.LANGUAGES['en-us'], scale = 0, colour = G.C.WHITE, shadow = true}},
		}}

		res.nodes[1].nodes[1].nodes[4].nodes[1].nodes[2].nodes[3] = {n=G.UIT.C, config={align = "cl", minw = 0, minh=0, r = 0,colour = G.C.BLACK, id = 'hand_mult_area', emboss = 0}, nodes={
			{n=G.UIT.O, config={scale = 0, func = 'flame_handler',no_role = true, id = 'flame_mult', object = Moveable(0,0,0,0), w = 0, h = 0}},
			{n=G.UIT.B, config={w=0.0,h=0.0}},
			{n=G.UIT.B, config={id = 'hand_mult', func = 'hand_mult_UI_set',object = DynaText({string = "", colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = false, float = true, scale = 0})}},
		}}
	end 

	return res
    -- test tst etetdstestredf
end

local fakeeval = evaluate_play_final_scoring

function evaluate_play_final_scoring(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
	if (mult and G.GAME.mult_disabled) then
		mult = 1
	end
	fakeeval(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
end

local hookref_atd = Card.add_to_deck

-- load other files here

-- stop loading other files because thats how code works
function Card.add_to_deck(self, from_debuff)
    hookref_atd(self, from_debuff)
    local allow = true
    owned_keys = {}

    for i,j in ipairs(G.jokers.cards) do
        table.insert(owned_keys,j.config.center_key)
    end

    for i,j in ipairs(G.consumeables.cards) do
        table.insert(owned_keys,j.config.center_key)
    end

    table.insert(owned_keys, self.config.center_key)
    
    -- print(owned_keys)

    for i,j in ipairs(merge_recipes) do
        
        if table:superset(owned_keys, j.input) then

            for k,ingredient in ipairs(j.input) do
                destroy_first_instance(ingredient)
            end
            -- destroy all cards that are part of recipe
            if table:contains(j.input, self.config.center_key) then
                self:quick_dissolve()
            end

            local swj = j.output:find("^j_")
            local area = swj and G.jokers or G.consumeables
            local type = swj and "Joker" or "Consumable"

            local output = create_card(type, area, nil, nil, nil, nil, j.output, "valk_fusion")
            output:add_to_deck()
            area:emplace(output)

        end

    end



    
end