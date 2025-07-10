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
            "Add a {C:green}1%{} chance for Jokers to spawn as {C:valk_unsurpassed}Unsurpassed{}",
            "Add a {C:green}2%{} chance for Jokers to spawn as {C:cry_cursed}Cursed{}",
            "Add a {C:green}2%{} chance for Jokers to spawn as {C:cry_cursed}Supercursed{}",
            credit("Scraptake")
        }
    },
    key = "memoryleak",
    pos = { x = 3, y = 4 },
    atlas = "main",
    -- soul_rate = 0.07,
    soul_rate = 0.35,
    -- is_soul = true,

    config = { extra = {} },

    loc_vars = function(self, info_queue, card)

        return {vars = {}}
        
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        

        G.GAME.unsurpassed_replace = G.GAME.unsurpassed_replace and (G.GAME.unsurpassed_replace+1) or 1 
        G.GAME.cursed_replace = G.GAME.cursed_replace and (G.GAME.cursed_replace+1) or 1 
        G.GAME.supercursed_replace = G.GAME.supercursed_replace and (G.GAME.supercursed_replace+1) or 1 

    end
}