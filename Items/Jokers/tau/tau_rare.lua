SMODS.Joker {
    bases = {"j_obelisk"},
    key = "tau_obelisk",
    loc_txt = {
        name = "{C:valk_fire}Tauic Obelisk{}",
        text = {
            "Gains {X:dark_edition,C:white}^#1#{} Mult per scored card if",
            "played hand is not your most played {C:attention}poker hand{}",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
        }
    },
	valk_artist = "Scraptake",
    config = { extra = { gain = 0.2, current = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.current}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if (context.before) then
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.gain
                end
            end

        end

        if (context.joker_main) then
            return {emult = card.ability.extra.current}
        end

    end
}

SMODS.Joker {
    bases = {"j_blueprint"},
    key = "tau_blueprint",
    loc_txt = {
        name = "{C:valk_fire}Tauic Blueprint{}",
        text = {
            "Copies abilities the 3 {C:attention}Jokers{} to the right",
        }
    },
	valk_artist = "Scraptake",
    blueprint_compat = true,
    config = { extra = {} },
    	loc_vars = function(self, info_queue, card)
		if card.area and card.area == G.jokers then
			local other_joker1
            local other_joker2
            local other_joker3
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					other_joker1 = G.jokers.cards[i + 1]
                    other_joker2 = G.jokers.cards[i + 2]
                    other_joker3 = G.jokers.cards[i + 3]
				end
			end
			local compatible1 = other_joker1 and other_joker1 ~= card and other_joker1.config.center.blueprint_compat
            local compatible2 = other_joker2 and other_joker2 ~= card and other_joker2.config.center.blueprint_compat
            local compatible3 = other_joker3 and other_joker3 ~= card and other_joker3.config.center.blueprint_compat
			main_end = {
				{
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes ={
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = compatible1 and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
									or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06,
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " "
											.. localize("k_" .. (compatible1 and "compatible" or "incompatible"))
											.. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
					},
				},
                {
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes ={
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = compatible2 and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
									or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06,
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " "
											.. localize("k_" .. (compatible2 and "compatible" or "incompatible"))
											.. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
					},
				},
                {
					n = G.UIT.C,
					config = { align = "bm", minh = 0.4 },
					nodes ={
						{
							n = G.UIT.C,
							config = {
								ref_table = card,
								align = "m",
								colour = compatible3 and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
									or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
								r = 0.05,
								padding = 0.06,
							},
							nodes = {
								{
									n = G.UIT.T,
									config = {
										text = " "
											.. localize("k_" .. (compatible3 and "compatible" or "incompatible"))
											.. " ",
										colour = G.C.UI.TEXT_LIGHT,
										scale = 0.32 * 0.8,
									},
								},
							},
						},
					},
				},
			}
		end
		return {
			main_end = main_end,
		}
	end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=0, y=3},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)
		local my_ind = vallkarri.index(card)
		local card_1,card_2,card_3 = G.jokers.cards[my_ind+1],G.jokers.cards[my_ind+2],G.jokers.cards[my_ind+3]

		return SMODS.merge_effects({
			SMODS.blueprint_effect(card, card_1, context),
			SMODS.blueprint_effect(card, card_2, context),
			SMODS.blueprint_effect(card, card_3, context),
			})
    end
}