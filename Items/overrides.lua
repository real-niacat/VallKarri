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
    no_doe = true,
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

    -- G.HUD:get_UIE_by_ID("chipmult_op").UIT = 0
    -- G.HUD:get_UIE_by_ID("hand_mult_area").UIT = 0
    -- G.HUD:get_UIE_by_ID("hand_mult").UIT = 0
    -- G.HUD:get_UIE_by_ID("flame_mult").UIT = 0
    -- G.HUD:get_UIE_by_ID("hand_chip_area").config.minw = 4
    -- G.HUD:get_UIE_by_ID("hand_mult_area").config.minw = 0
    -- G.HUD:get_UIE_by_ID("hand_mult_area").config.minh = 0
    -- G.HUD:get_UIE_by_ID("chipmult_op").scale = 0

	if (G.GAME.mult_disabled or force) then 

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
            if table:vcontains(j.input, self.config.center_key) then
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


local edcopy = ease_dollars

function ease_dollars(mod, instant)
    if #SMODS.find_card("j_valk_tau_creditcard") > 0 and to_big(mod) < to_big(0) then

        edcopy(mod, instant)
        edcopy(-(mod*0.75), instant)
        return
    end

    if G.GAME.price_mod then
        edcopy(mod + G.GAME.price_mod, true)
        return
    end

    edcopy(mod, instant)
end

local fakeupd = Game.update
function Game:update(dt)
    fakeupd(self, dt)

    if (G.GAME.mult_disabled and G.STATE and G.STATE == 1) then
        -- refresh during blinds
        G.HUD:get_UIE_by_ID("hand_mult_area").UIT = 0
    end

end

local fakestart = Game.start_run
function Game:start_run(args)
    fakestart(self, args)

    for i,center in pairs(G.P_CENTERS) do
        if center.oldrarity then

            -- remove from the old pool
            local pool = G.P_JOKER_RARITY_POOLS[center.rarity]
            for idx = #pool, 1, -1 do
                if pool[idx] == center.key then
                    table.remove(pool, idx)
                    break
                end
            end

            -- readd to it's original pool
            G.P_JOKER_RARITY_POOLS[center.oldrarity][center.key] = center

            center.rarity = center.oldrarity


        end
    end
end

glcui = nil

local gcui = generate_card_ui
function generate_card_ui(_c,full_UI_table,specific_vars,card_type,badges,hide_desc,main_start,main_end,card)
	local tab = gcui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    glcui = tab
    local center = G.P_CENTERS[_c.key]

    if not center then
        return tab
    end

    if not center.displaying_lore then
        return tab
    end

    local ex_lang = G.LANGUAGES["en-us"]
    tab.main = {}

    for i,line in ipairs(center.lore) do
        -- print(line)
        tab.main[#tab.main+1] = {{
            n = 1,
            config = {
                scale = 0.315,
                outline_colour = G.C.UI.OUTLINE_LIGHT,
                text_drawable = love.graphics.newText(ex_lang.font.FONT, {G.C.UI.TEXT_INACTIVE,line}),
                colour = G.C.UI.TEXT_INACTIVE,
                text = line,
                lang = ex_lang
            }
        }}
    end

    return tab
end

G.FUNCS.can_learn_more = function(e)
    if e.config.ref_table:can_learn_more() then 
        e.config.colour = HEX("e5bf3a")
        e.config.button = 'learn_more'
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end

G.FUNCS.learn_more = function(button)
    local card = button.config.ref_table
    card.config.center.displaying_lore = not card.config.center.displaying_lore

    -- print(card.config.center.displaying_lore)
    
end

function Card:can_learn_more(context)
    return true
end

local fakeusesell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ref = fakeusesell(card)
    -- print(ref)
    -- print(ref.nodes[1])

    if card.config.center.lore then

        ref.nodes[1].nodes[#ref.nodes[1].nodes+1] = {n=G.UIT.C, config={align = "tm"}, nodes={
        {n=G.UIT.C, config={ref_table = card, align = "cr",padding = 0.1, r=0.08, minw = 1.25, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = false, button = 'learn_more', func = 'can_learn_more'}, nodes={
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
            {n=G.UIT.C, config={align = "tm"}, nodes={
            {n=G.UIT.R, config={align = "cm", maxw = 1.25}, nodes={
                {n=G.UIT.T, config={text = "Toggle lore",colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true}}
            }},
            }}
        }},
        }}

    end

    return ref
end

local calceff = SMODS.calculate_individual_effect
function SMODS.calculate_individual_effect(effect, scored_card, key, amount, from_edition)

    calceff(effect, scored_card, key, amount, from_edition)

    if next(SMODS.find_card("j_valk_cascade")) then

        if key == "xchips" or key == "x_chips" or key == "Xchip_mod" then
            play_sound('timpani')
            G.GAME.blind.chips = G.GAME.blind.chips / amount
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.HUD_blind:recalculate()
            G.hand_text_area.blind_chips:juice_up()
        end

    end

end