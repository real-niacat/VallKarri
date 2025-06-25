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
            "Pick {C:attention}#1#{} of up to {C:attention}#2#{} {C:cry_ascendant}Powerful{} cards",
            "to use immedietely or take"
        },
        group_name = "Ascended Booster Pack"
    },

    draw_hand = false,
    config = {choose = 1, extra = 7},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 0.666,
    cost = 99,

    create_card = function(self, card, i)
        ease_background_colour(G.C.CRY_ASCENDANT)
        local r = pseudorandom("valk_ascended_pack", 1, 3)
        if (r == 1) then
            return create_card("Superplanet", G.pack_cards, nil, nil, true, nil, nil, "valk_ascended_pack")
        elseif r == 2 then
            local choices = {"c_valk_absolutetau", "c_valk_memoryleak", "c_valk_freeway"} --will add freeway when it exists
            local pick = pseudorandom("valk_ascended_pack", 1, #choices)
            

            return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_ascended_pack")
        elseif r == 3 then
            local choices = {"c_valk_perfected_gem", "c_valk_socket", "c_valk_binding_energy", "c_valk_halo_fragment"} --will add freeway when it exists
            local pick = pseudorandom("valk_ascended_pack", 1, #choices)
            

            return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_ascended_pack")
        end

    end,
}

SMODS.Booster {
    key = "deckfixing",
    atlas = "main",
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
            

        return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_deckfixing_pack")

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
            "Select up to {C:attention}#1#{} jokers, multiply all",
            "values on selected jokers by between {C:attention}X#2#{} and {C:attention}X#3#{}",
            credit("Scraptake"),
        }
    },
    key = "luck",
    pos = { x = 4, y = 4 },
    atlas = "main",
    soul_rate = 0.07,
    -- is_soul = true,

    config = { extra = { jokers = 2, limit = 50, base = 1.2} },

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
    cost = 50,

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


SMODS.Consumable {
    key = "perfected_gem",
    set = "SpecialCards",
    loc_txt = {
        name = "Perfected Gem",
        text = {
            "Useless alone, part of a bigger picture.",
            credit("Scraptake"),
        }
    },
    atlas = "main",
    pos = {x=13, y=0, },
    soul_pos = {x=14, y=0},

    can_use = function(self, card)
        return (card.area ~= G.consumeables)
    end,

    use = function(self, card, area, copier)
        simple_create("Consumable", G.consumeables, card.config.center.key)
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(1)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(-1)
        end
    end,
}

SMODS.Consumable {
    key = "socket",
    set = "SpecialCards",
    loc_txt = {
        name = "Gem Socket",
        text = {
            "Useless alone, part of a bigger picture.",
            credit("Scraptake"),
        }
    },
    atlas = "main",
    pos = {x=13, y=1, },
    soul_pos = {x=14, y=1},

    can_use = function(self, card)
        return (card.area ~= G.consumeables)
    end,

    use = function(self, card, area, copier)
        simple_create("Consumable", G.consumeables, card.config.center.key)
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(1)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(-1)
        end
    end,
}

SMODS.Consumable {
    key = "socketed_gem",
    set = "SpecialCards",
    loc_txt = {
        name = "Socketed Gem",
        text = {
            "Useless alone, part of a bigger picture.",
            credit("Scraptake"),
        }
    },
    atlas = "main",
    pos = {x=13, y=4, },
    soul_pos = {x=14, y=4},

    can_use = function(self, card)
        return (card.area ~= G.consumeables)
    end,

    use = function(self, card, area, copier)
        simple_create("Consumable", G.consumeables, card.config.center.key)
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(1)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(-1)
        end
    end,
}

SMODS.Consumable {
    key = "binding_energy",
    set = "SpecialCards",
    loc_txt = {
        name = "Binding Energy",
        text = {
            "Useless alone, part of a bigger picture.",
            credit("Scraptake"),
        }
    },
    atlas = "main",
    pos = {x=13, y=3, },
    soul_pos = {x=14, y=3},

    can_use = function(self, card)
        return (card.area ~= G.consumeables)
    end,

    use = function(self, card, area, copier)
        simple_create("Consumable", G.consumeables, card.config.center.key)
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(1)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(-1)
        end
    end,
}

SMODS.Consumable {
    key = "halo_fragment",
    set = "SpecialCards",
    loc_txt = {
        name = "Halo Fragment",
        text = {
            "Useless alone, part of a bigger picture.",
            credit("Scraptake"),
        }
    },
    atlas = "main",
    pos = {x=13, y=2, },
    soul_pos = {x=14, y=2},

    can_use = function(self, card)
        return (card.area ~= G.consumeables)
    end,

    use = function(self, card, area, copier)
        simple_create("Consumable", G.consumeables, card.config.center.key)
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(1)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.consumeables:change_size(-1)
        end
    end,
}

-- SMODS.Consumable {
--     key = "",
--     set = "Tarot",
--     loc_txt = {
--         name = "",
--         text = {
--             "",
--         }
--     },
--     config = { extra = { } },
--     atlas = "main",
--     pos = {x=10, y=0, },

--     loc_vars = function(self, info_queue, card)
        
--     end,
--     can_use = function(self, card)
--         return (card.area ~= G.consumeables)
--     end,

--     use = function(self, card, area, copier)
--         simple_create("Consumable", G.consumeables, card.config.center.key)
--     end
-- }

SMODS.Consumable {
    key = "iron_maiden",
    set = "Tarot",
    loc_txt = {
        name = "Iron Maiden",
        text = {
            "Select up to {C:attention}#1#{} cards, convert",
            "all selected cards into the {C:attention}leftmost{} card, then",
            "apply {C:attention}steel{} to all of them"
        }
    },
    config = { extra = { cards = 5 } },
    atlas = "main",
    pos = {x=10, y=0, },
    no_grc = true,

    in_pool = function()
        return false
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards 
    end,

    use = function(self, card, area, copier)
        local first_card = G.hand.highlighted[1]
        do_while_flipped(G.hand.highlighted, function(ca)
            copy_card(first_card, ca)
            ca:set_ability("m_steel")
            G.hand:remove_from_highlighted(ca)
        end)
    end
}


SMODS.Consumable {
    key = "the_pope",
    set = "Tarot",
    loc_txt = {
        name = "The Pope",
        text = {
            "Give all cards {C:attention}held-in-hand{}",
            "the same random {C:attention}vanilla enhancement{} and {C:attention}edition{}"
        }
    },
    config = { extra = { } },
    atlas = "main",
    pos = {x=11, y=0, },
    no_grc = true,

    in_pool = function()
        return false
    end,

    loc_vars = function(self, info_queue, card)

    end,
    can_use = function(self, card)
        return #G.hand.cards > 0
    end,

    use = function(self, card, area, copier)
        local moptions = {"m_bonus", "m_mult", "m_wild", "m_glass", "m_steel", "m_stone", "m_gold", "m_lucky"}
        local eoptions = {"e_foil", "e_holo", "e_polychrome", "e_negative"}

        local choices = {
            enhancement = moptions[pseudorandom("pope_enh", 1, #moptions)],
            edition = eoptions[pseudorandom("pope_edi", 1, #eoptions)]
        }

        do_while_flipped(G.hand.cards, function(card)
            card:set_ability(choices.enhancement)
            card:set_edition(choices.edition, true)
        end)
    end
}

SMODS.Consumable {
    key = "gods_finger",
    set = "Tarot",
    loc_txt = {
        name = "God's Fingers",
        text = {
            "Select up to {C:attention}#1#{} cards,",
            "{C:red}destroy{} all selected cards and create a ",
            "{C:dark_edition}negative{} {C:rare}rare{} {C:attention}joker{} for each card destroyed"
        }
    },
    config = { extra = { cards = 3 } },
    atlas = "main",
    pos = {x=12, y=0, },
    no_grc = true,

    in_pool = function()
        return false
    end,

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_negative
        return {vars = {card.ability.extra.cards}}
    end,
    can_use = function(self, card)
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards 
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.1,
            func = function()
                for i,c in ipairs(G.hand.highlighted) do
                    c:start_dissolve({G.C.BLACK}, nil, 2 * G.SETTINGS.GAMESPEED)
                    local joker = create_card("Joker", G.jokers, nil, 3, nil, nil, nil, "valk_godsfinger")
                    joker:add_to_deck()
                    joker:set_edition("e_negative", true)
                    G.jokers:emplace(joker)
                end
                return true
            end
        }))
    end
}

SMODS.Consumable {
    key = "the_killer",
    set = "Tarot",
    loc_txt = {
        name = "The Killer",
        text = {
            "Create {C:attention}#1#{} negative consumable for every {C:attention}#2#{}",
            "{C:tarot}tarot{} cards used in run",
            "{C:inactive}(Currently #3#){}"
        }
    },
    config = { extra = { per = 1, req = 2 } },
    atlas = "main",
    pos = {x=10, y=1, },
    no_grc = true,

    in_pool = function()
        return false
    end,

    loc_vars = function(self, info_queue, card)
        local sum = 0
        for i,amt in pairs(G.GAME.consumeable_usage) do
            if G.GAME.consumeable_usage[i].set and G.GAME.consumeable_usage[i].set == "Tarot" then
                sum = sum + G.GAME.consumeable_usage[i].count
            end
        end
        
        return {
            vars = {
                card.ability.extra.per,
                card.ability.extra.req,
                math.floor(sum/card.ability.extra.req)*card.ability.extra.per
            }
        }
    end,
    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.1,
            func = function()
                local sum = 0
                for i,amt in pairs(G.GAME.consumeable_usage) do
                    if G.GAME.consumeable_usage[i].set and G.GAME.consumeable_usage[i].set == "Tarot" then
                        sum = sum + G.GAME.consumeable_usage[i].count
                    end
                end

                local count = math.floor(sum/card.ability.extra.req)*card.ability.extra.per

                for i=1,count do
                    local c = create_card("Consumeables", G.consumeables, nil, nil, nil, nil, nil, "valk_killer")
                    c:add_to_deck()
                    c:set_edition("e_negative", true)
                    G.consumeables:emplace(c)
                    c:juice_up()
                end

                return true
            end
        }))

    end
}

SMODS.Consumable {
    key = "gameshow",
    set = "Tarot",
    loc_txt = {
        name = "Gameshow",
        text = {
            "Each joker has a {C:green}#1# in [Sell Value]{} chance to",
            "multiply all its values by its {C:money}Sell Value{}"
        }
    },
    config = { extra = { } },
    atlas = "main",
    pos = {x=11, y=1, },
    no_grc = true,

    in_pool = function()
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {
            G.GAME.probabilities.normal
        }}
    end,
    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        
        for i,joker in ipairs(G.jokers.cards) do

            if pseudorandom("valk_gameshow", 1, joker.sell_cost) <= G.GAME.probabilities.normal then
                do_while_flipped({joker}, function(card)
                    Cryptid.manipulate(card, {type = "X", value = card.sell_cost})
                end)
            end

        end

    end
}

SMODS.Consumable {
    key = "the_knight",
    set = "Tarot",
    loc_txt = {
        name = "The Knight",
        text = {
            "Select up to {C:attention}#1#{} cards,",
            "apply a random {C:attention}CCD{} to all selected cards"
        }
    },
    config = { extra = { cards = 5 } },
    atlas = "main",
    pos = {x=12, y=1, },
    no_grc = true,

    in_pool = function()
        return false
    end,

    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.cards
        }}
    end,
    can_use = function(self, card)
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.cards 
    end,

    use = function(self, card, area, copier)
        
        do_while_flipped(G.hand.highlighted, function(c)
            c:set_ability(Cryptid.random_consumable("valk_knight"), true, nil)
            G.hand:remove_from_highlighted(c)
        end)
        

    end
}

SMODS.Consumable {
    set = "Code",
    loc_txt = { 
        name = "://MISSINGNO",
        text = {
            "Randomize edition of all cards {C:attention}held-in-hand{}",
            "{C:inactive}(Only vanilla editions can be picked){}",
            credit("Scraptake")
        }
    },
    key = "missingno",
    pos = { x = 1, y = 9 },
    atlas = "main",

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)
        
    end,

    can_use = function(self, card)
        return (#G.hand.cards > 0)
    end,

    update = function(self, card)
        card.children.center:set_sprite_pos({x = math.random(1, 2), y = 9 })
    end,

    use = function(self, card, area, copier)
        
        do_while_flipped(G.hand.cards, function(c)
            local valid = {"e_foil", "e_holo", "e_polychrome", "e_negative"}
            c:set_edition(valid[pseudorandom("valk_missingno", 1, #valid)], true)
        end)
        

    end
}

SMODS.Consumable {
    set = "Code",
    loc_txt = { 
        name = "://GASTER",
        text = {
            "Randomize enhancement of all cards {C:attention}held-in-hand{}",
            "{C:inactive}(Only vanilla enhancement can be picked){}",
            credit("Scraptake")
        }
    },
    key = "gaster",
    pos = { x = 8, y = 9 },
    atlas = "main",

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)
        
    end,

    can_use = function(self, card)
        return (#G.hand.cards > 0)
    end,

    use = function(self, card, area, copier)
        
        do_while_flipped(G.hand.cards, function(c)
            local valid = {"m_bonus", "m_mult", "m_wild", "m_glass", "m_steel", "m_gold", "m_lucky"}
            c:set_ability(valid[pseudorandom("valk_missingno", 1, #valid)])
        end)
        

    end
}