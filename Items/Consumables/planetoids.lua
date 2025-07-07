SMODS.Atlas {
    path = "planetoids.png",
    key = "oid",
    px = 65,
    py = 79,
}

SMODS.ConsumableType {
    key = "Planetoid",
    collection_rows = {6, 6},
    primary_colour = HEX("D3ECF4"),
    secondary_colour = HEX("508DA0"),
    shop_rate = 0,

    loc_txt = {
        collection = "Planetoid Cards",
        label = "planetoid",
        name = "Planetoid Cards",
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
    set = "Planetoid",
    key = "kerberos",
    loc_txt = { 
        name = "Kerberos",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 0, y = 0 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "High Card", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "icarus",
    loc_txt = { 
        name = "Icarus",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 1, y = 0 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Pair", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "daedalus",
    loc_txt = { 
        name = "Daedalus",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 2, y = 0 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Three of a Kind", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "cardea",
    loc_txt = { 
        name = "Cardea",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 3, y = 0 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Full House", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "eureka",
    loc_txt = { 
        name = "Eureka",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 4, y = 0 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Four of a Kind", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "ixion",
    loc_txt = { 
        name = "Ixion",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 0, y = 1 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Five of a Kind", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "tyche",
    loc_txt = { 
        name = "Tyche",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 1, y = 1 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Flush Five", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "artemis",
    loc_txt = { 
        name = "Artemis",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 2, y = 1 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Flush House", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "euphrosyne",
    loc_txt = { 
        name = "Euphrosyne",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 3, y = 1 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "cry_Bulwark", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "hektor",
    loc_txt = { 
        name = "Hektor",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 4, y = 1 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "cry_UltPair", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "amalthea",
    loc_txt = { 
        name = "Amalthea",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 0, y = 2 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Flush", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "pan",
    loc_txt = { 
        name = "Pan",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 1, y = 2 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Straight", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "despina",
    loc_txt = { 
        name = "Despina",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 2, y = 2 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Straight Flush", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "miranda",
    loc_txt = { 
        name = "Miranda",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 3, y = 2 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "Two Pair", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "dalamud",
    loc_txt = { 
        name = "Dalamud",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 4, y = 2 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "valk_fullmansion", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "proto",
    loc_txt = { 
        name = "Protoplanetary Disk",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 0, y = 3 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "cry_Clusterfuck", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "tc25",
    loc_txt = { 
        name = "2015 TC25",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 1, y = 3 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "cry_WholeDeck", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Consumable {
    set = "Planetoid",
    key = "zero",
    loc_txt = { 
        name = "Zero",
        text = {
            "Level up {C:attention}#1#{}",
            "for each time {C:attention}#4#{} has been",
            "used this run",
            "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            credit("mailingway"),
        }
    },
    pos = { x = 2, y = 3 },
    atlas = "oid",
    display_size = {w=64, h=78},

    config = { extra = { handtype = "cry_None", increase = 1 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { localize(card.ability.extra.handtype, "poker_hands"), 1+(times_used(self.key)*card.ability.extra.increase),
                         card.ability.extra.increase, localize{type = "name_text", set = self.set, key = self.key} }}
        
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        
        level_up_hand(card, card.ability.extra.handtype, nil, 1+(times_used(self.key)*card.ability.extra.increase))

    end,
    in_pool = function(self)
        return (G.GAME.hands[self.config.extra.handtype].played > 0)
    end
}

SMODS.Booster {
    key = "planetoid_pack_1",
    atlas = "oid",
    kind = "Planetoid",
    group_key = "k_valk_planetoid",
    pos = {x=3, y=3},
    discovered = true,
    loc_txt = {
        name = "Planetoid Pack",
        text = {
            "Pick {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:planet}Planetoid{} cards to",
            "use immediately"
        },
        group_name = "Planetoid Pack"
    },

    draw_hand = false,
    config = {choose = 1, extra = 3},
    display_size = {w=64, h=78},
    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 2,
    cost = 5,

    create_card = function(self, card, i)
        ease_background_colour(HEX("508DA0"))
        return create_card("Planetoid", G.pack_cards, nil, nil, true, nil, nil, "valk_planetoid_pack")
        

    end,
    in_pool = function()
        return G.GAME.round_resets.ante >= 4
    end
}

SMODS.Booster {
    key = "planetoid_pack_2",
    atlas = "oid",
    kind = "Planetoid",
    group_key = "k_valk_planetoid",
    pos = {x=4, y=3},
    discovered = true,
    loc_txt = {
        name = "Planetoid Pack",
        text = {
            "Pick {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:planet}Planetoid{} cards to",
            "use immediately"
        },
        group_name = "Planetoid Pack"
    },

    draw_hand = false,
    config = {choose = 1, extra = 3},
    display_size = {w=64, h=78},
    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 2,
    cost = 5,

    create_card = function(self, card, i)
        ease_background_colour(HEX("508DA0"))
        return create_card("Planetoid", G.pack_cards, nil, nil, true, nil, nil, "valk_planetoid_pack")
        

    end,
    in_pool = function()
        return G.GAME.round_resets.ante >= 4
    end
}