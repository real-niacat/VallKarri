SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Freeway",
        text = {
            "Create a random {C:cry_exotic}Exotic{} Joker",
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
    set = "Spectral",
    loc_txt = { 
        name = "Luck",
        text = {
            "Select up to {C:attention}#1#{} Jokers, multiply all",
            "values on selected Jokers by between {C:attention}X#2#{} and {C:attention}X#3#{}",
            credit("mailingway"),
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
    set = "Spectral",
    loc_txt = { 
        name = "Faker",
        text = {
            "Select {C:attention}#1#{} Joker, create a {C:dark_edition}Negative{}",
            "and {C:attention}Perishable{} copy.",
            credit("mailingway"),
        }
    },
    key = "faker",
    pos = { x = 5, y = 10 },
    atlas = "main",
    -- is_soul = true,

    config = { extra = { jokers = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.jokers }}
        
    end,

    can_use = function(self, card)
        return #G.jokers.highlighted <= card.ability.extra.jokers and #G.jokers.highlighted > 0
    end,

    

    use = function(self, card, area, copier)
        
        for i,c in ipairs(G.jokers.highlighted) do

            local copy = copy_card(c)
            copy:set_edition("e_negative", true)
            copy.ability.perishable = true
            G.jokers:emplace(copy)

        end

    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = { 
        name = "://HIM",
        text = {
            "Randomize enhancement of all cards {C:attention}held-in-hand{}",
            "{C:inactive}(Vanilla enhancements only){}",
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

SMODS.Consumable {
    set = "Spectral",
    loc_txt = { 
        name = "://MISSINGNO",
        text = {
            "Randomize edition of all cards {C:attention}held-in-hand{}",
            "{C:inactive}(Vanilla editions only){}",
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