SMODS.ConsumableType {
    key = "SpecialCards",
    collection_rows = {3, 3},
    primary_colour = HEX("FFAFE7"),
    secondary_colour = HEX("FF7088"),
    shop_rate = 0,

    loc_txt = {
        collection = "Special Cards",
        label = "special",
        name = "Special Cards",
        undiscovered = {
            name = "go turn on unlock all",
            text = {
                "this mod is intended to be used",
                "with unlock all enabled"
            }
        }
    },
}


SMODS.Booster {
    key = "ascended_booster",
    atlas = "main",
    pos = {x=4, y=9},
    discovered = true,
    loc_txt = {
        name = "Ascended Booster Pack",
        text = {
            "Pick {C:attention}#1#{} of {C:attention}#2#{} {C:cry_ascendant}Powerful{} cards",
        },
        group_name = "Ascended Booster Pack"
    },

    draw_hand = false,
    config = {choose = 1, extra = 3},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 0.333,
    cost = 99,

    create_card = function(self, card, i)
        ease_background_colour(G.C.CRY_ASCENDANT)
        if (pseudorandom("valk_ascended_pack", 1, 2) == 1) then
            return create_card("Superplanet", G.pack_cards, nil, nil, nil, nil, nil, "valk_ascended_pack")
        else
            local choices = {"c_valk_absolutetau", "c_valk_safe_memoryleak", "c_valk_freeway"} --will add freeway when it exists
            local pick = pseudorandom("valk_ascended_pack", 1, #choices)
            

            return create_card("Consumable", G.pack_cards, nil, nil, nil, nil, choices[pick], "valk_ascended_pack")
        end

    end,
}

SMODS.Booster {
    key = "deckfixing",
    atlas = "phold",
    pos = {x=7, y=2},
    discovered = true,
    loc_txt = {
        name = "Deck Fixing Pack",
        text = {
            "Pick {C:attention}#1#{} of {C:attention}#2#{} {C:attention}deck-fixing{} cards to use immedietely",
        },
        group_name = "Deck Fixing Pack"
    },

    draw_hand = true,
    config = {choose = 1, extra = 3},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 1.2,
    cost = 9,

    create_card = function(self, card, i)
        ease_background_colour(G.C.ORANGE)
        local choices = {"c_death", "c_hanged_man", "c_cryptid", "c_strength", "c_cry_ctrl_v"} --will add freeway when it exists
        local pick = pseudorandom("valk_deckfixing_pack", 1, #choices)
            

        return create_card("Consumable", G.pack_cards, nil, nil, nil, nil, choices[pick], "valk_deckfixing_pack")

    end,
}



-- SMODS.Consumable {
local gwell = {
    set = "SpecialCards",
    loc_txt = {
        name = "Gravity Well",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Once used, +{X:inactive}[S]{} to {C:money}final score{} for {X:inactive}[N]{} hands",
            "{C:inactive}S = Score while this card is active, increasing exponentially.{}",
            "{C:inactive}N = Total hands this card was active.{}",
            "{C:inactive,s:1.2}Score: #3#, Hands: #4#{}",
            "{C:inactive,s:1.5}Currenty #2#{}",
            credit("Scraptake")
        }
    },

    no_doe = true,

    config = { extra = { multifactor = 0.5, stored = to_big(0), active = true, rounds = 0} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.multifactor, card.ability.extra.active and "charging up" or "discharging", card.ability.extra.stored, card.ability.extra.rounds}}
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        if (card.ability.extra.active) then
            card.ability.extra.active = false
        else
            card.ability.extra.active = true
            card.ability.extra.stored = to_big(0)
        end
    end,

    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        local active = card.ability.extra.active

        if (context.final_scoring_step and active) then --active is true by nature
            card.ability.extra.stored = to_big(card.ability.extra.stored + to_big(G.GAME.chips):pow(card.ability.extra.rounds/2))
            card.ability.extra.rounds = card.ability.extra.rounds + 1
            return {xmult = card.ability.extra.multifactor}
        end
        -- i have no fucking clue how elif works in lua
        if (context.final_scoring_step and not active) and card.ability.extra.rounds > 0 then
            G.GAME.chips = G.GAME.chips + card.ability.extra.stored
            card.ability.extra.rounds = card.ability.extra.rounds - 1
        end
    end,

    key = "gravitywell",
    pos = {x=2, y=0},
    -- soul_pos = {x=0,y=0},
    atlas = "main",
}

SMODS.Consumable {
    set = "SpecialCards",
    loc_txt = { 
        name = "The Lordess Call",
        text = {
            "{C:attention}+#1# Hand size {}and {C:attention}Card selection limit{}",
            "Creates {C:cry_azure,s:1.5}The Dormant Lordess{}",
            credit("Scraptake")
        }
    },
    key = "lordcall",
    pos = { x = 2, y = 1 },
    soul_pos = {x = 3, y = 1},
    atlas = "main",
    no_doe = true,
    -- soul_rate = 0.00001, --0.001%

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.morecards }}
        
    end,

    can_use = function(self, card)
        return true
    end,

    config = { extra = { morecards = 9} },

    use = function(self, card, area, copier)
        G.hand:change_size(card.ability.extra.morecards)
        SMODS.change_play_limit(card.ability.extra.morecards)
        SMODS.change_discard_limit(card.ability.extra.morecards)
        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra.morecards

        local lily = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_valk_dormantlordess", "valk_lordcall")
        lily:add_to_deck()
        lily.ability.cry_absolute = true
        G.jokers:emplace(lily)
        lily:juice_up(0.3, 0.5)

    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = { 
        name = "Luck",
        text = {
            "Select {C:attention}#1#{} joker, change all values on selected joker by between {C:attention}X#2#{} and {C:attention}X#3#{}",
            credit("Scraptake"),
            concept("techwizard72")
        }
    },
    key = "luck",
    pos = { x = 4, y = 4 },
    atlas = "main",
    soul_rate = 0.07,
    -- is_soul = true,

    config = { extra = { jokers = 1, limit = 50, base = 1.2} },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.jokers, card.ability.extra.base, card.ability.extra.base+(card.ability.extra.limit/100) }}
        
    end,

    can_use = function(self, card)
        return #G.jokers.highlighted <= card.ability.extra.jokers and #G.jokers.highlighted > 0
    end,

    

    use = function(self, card, area, copier)
        
        for i,c in ipairs(G.jokers.highlighted) do

            Cryptid.misprintize(c, {min=card.ability.extra.base, max=card.ability.extra.base+(card.ability.extra.limit/100)}, nil, true)

        end

    end
}

SMODS.Consumable {
    set = "Code",
    loc_txt = { 
        name = "://MEMORYLEAK",
        text = {
            "Create an {C:cry_azure}Unsurpassed{} Joker and a {C:black}Supercursed{} joker",
            credit("Scraptake")
        }
    },
    key = "memoryleak",
    pos = { x = 3, y = 4 },
    atlas = "main",
    -- soul_rate = 0.07,
    soul_rate = 0.7,
    -- is_soul = true,

    config = { extra = { valuemult = 1e-10, create_new = true, inc = 3} },

    loc_vars = function(self, info_queue, card)

        return {vars = { number_format(card.ability.extra.valuemult), card.ability.extra.inc }}
        
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        

        local usp = create_card("Joker", G.jokers, nil, "valk_unsurpassed", nil, nil, nil, "c_valk_memoryleak")
        usp:add_to_deck()
        G.jokers:emplace(usp)

        local bad = create_card("Joker", G.jokers, nil, "valk_supercursed", nil, nil, nil, "c_valk_memoryleak")
        bad:add_to_deck()
        G.jokers:emplace(bad)

    end
}

SMODS.Consumable {
    set = "Code",
    loc_txt = { 
        name = "://MEMORYPATCH",
        text = {
            "Create an {C:cry_azure}Unsurpassed{} Joker",
            credit("Scraptake")
        }
    },
    key = "safe_memoryleak",
    pos = { x = 3, y = 4 },
    atlas = "main",
    -- soul_rate = 0.07,
    soul_rate = 0,
    hidden = true,
    no_collection = true,
    -- is_soul = true,

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)

        return {vars = { number_format(card.ability.extra.valuemult), card.ability.extra.inc }}
        
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        

        local usp = create_card("Joker", G.jokers, nil, "valk_unsurpassed", nil, nil, nil, "c_valk_memoryleak")
        usp:add_to_deck()
        G.jokers:emplace(usp)

    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Freeway",
        text = {
            "Create a random {C:cry_exotic}Exotic{} joker",
            credit("Pangaea"),
        }
    },
    key = "freeway",
    atlas = "main",
    pos = {x=9, y=3, },
    soul_pos = {x=7, y=3, extra = {x=8, y=3}},
    soul_rate = 0,
    hidden = true,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        

        G.E_MANAGER:add_event(Event({
			trigger = "after",
			delay = 0.4,
			func = function()
				play_sound("timpani")
				local c = create_card("Joker", G.jokers, nil, "cry_exotic", nil, nil, nil, "valk_freeway")
				c:add_to_deck()
				G.jokers:emplace(c)
				c:juice_up(0.3, 0.5)
				return true
			end,
		}))
		delay(0.6)

    end
}