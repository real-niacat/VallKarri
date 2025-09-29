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
        }
    },
    valk_artist = "Scraptake",
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
        }
    },
    valk_artist = "Scraptake",
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
        }
    },
    valk_artist = "Scraptake",
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
        }
    },
    valk_artist = "Scraptake",
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
        }
    },
    valk_artist = "Scraptake",
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