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

SMODS.Consumable {
    key = "perfected_gem",
    set = "SpecialCards",
    loc_txt = {
        name = "Perfected Gem",
        text = {
            "Useless alone, part of a bigger picture.",
            "Can {C:attention}combine{} with other cards",
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
            "Can {C:attention}combine{} with other cards",
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
            "Can {C:attention}combine{} with other cards",
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
            "Can {C:attention}combine{} with other cards",
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
            "Can {C:attention}combine{} with other cards",
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

SMODS.Consumable {
    set = "SpecialCards",
    loc_txt = { 
        name = "The Lordess Call",
        text = {
            "{C:attention}+#1# Hand size {}and {C:attention}Card selection limit{}",
            "Creates {C:valk_blue,s:1.5}The Dormant Lordess{}",
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