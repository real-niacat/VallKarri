SMODS.Consumable {
    set = "Code",
    loc_txt = { 
        name = "://GASTER",
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
    set = "Code",
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

SMODS.Consumable {
    set = "Code",
    loc_txt = { 
        name = "://MEMORYLEAK",
        text = {
            "Create an {C:valk_unsurpassed}Unsurpassed{} Joker and a {C:black}SUPERCURSED{} Joker",
            credit("Scraptake")
        }
    },
    key = "memoryleak",
    pos = { x = 3, y = 4 },
    atlas = "main",
    -- soul_rate = 0.07,
    soul_rate = 0.35,
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