SMODS.Atlas {
    path = "planetoids.png",
    key = "oid",
    px = 65,
    py = 79,
}

SMODS.ConsumableType {
    key = "Planetoid",
    collection_rows = { 6, 6 },
    primary_colour = HEX("D3ECF4"),
    secondary_colour = HEX("508DA0"),
    shop_rate = 0.05,
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
    default = "c_valk_micrometeoroid",
}

local function key_to_name(str)
    str = str:gsub("__", ".")
    str = str:gsub("_", " ")
    str = str:gsub("(%a)([%w%.]*)", function(first, rest) return first:upper() .. rest end)
    return str
end

local planetoid_cards = {

    { pos = { x = 0, y = 0 }, hand = "High Card",        name = "Kerberos" },
    { pos = { x = 1, y = 0 }, hand = "Pair",             name = "Icarus" },
    { pos = { x = 3, y = 2 }, hand = "Two Pair",         name = "Miranda" },
    { pos = { x = 2, y = 0 }, hand = "Three of a Kind",  name = "Daedalus" },
    { pos = { x = 1, y = 2 }, hand = "Straight",         name = "Pan" },
    { pos = { x = 0, y = 2 }, hand = "Flush",            name = "Amalthea" },
    { pos = { x = 3, y = 0 }, hand = "Full House",       name = "Cardea" },
    { pos = { x = 4, y = 0 }, hand = "Four of a Kind",   name = "Eureka" },
    { pos = { x = 2, y = 2 }, hand = "Straight Flush",   name = "Despina" },
    { pos = { x = 1, y = 1 }, hand = "Five of a Kind",   name = "Tyche" },
    { pos = { x = 2, y = 1 }, hand = "Flush House",      name = "Artemis" },
    { pos = { x = 0, y = 1 }, hand = "Flush Five",       name = "Ixion" },
    { pos = { x = 4, y = 2 }, hand = "valk_fullmansion", name = "Dalamud" },

    { pos = { x = 3, y = 1 }, hand = "cry_Bulwark",      name = "Euphrosyne",          dep = { "Cryptid" } },
    { pos = { x = 4, y = 1 }, hand = "cry_UltPair",      name = "Hektor",              dep = { "Cryptid" } },
    { pos = { x = 0, y = 3 }, hand = "cry_Clusterfuck",  name = "Protoplanetary_Disk", dep = { "Cryptid" } },
    { pos = { x = 1, y = 3 }, hand = "cry_WholeDeck",    name = "2015_TC25",           dep = { "Cryptid" } },
    { pos = { x = 2, y = 3 }, hand = "cry_None",         name = "Zero",                dep = { "Cryptid" } },


}

local planetoid_map = {}
for i,v in ipairs(planetoid_cards) do
    planetoid_map[v.hand] = true
end

for _,v in ipairs(G.handlist) do
    if not planetoid_map[v] then
        local planetoid = {
            pos = {
                x = 4, y = 4
            },
            hand = v,
            name = "Unnamed Planetoid",
            discovered = true,
            no_collection = true
        }
        table.insert(planetoid_cards, planetoid)
    end
end

SMODS.Consumable {
    set = "Planetoid",
    key = "micrometeoroid",
    loc_txt = {
        name = "Micrometeoroid",
        text = {
            "{C:mult}+#2#{} Mult and {C:chips}+#2#{} Chips on all hands",
            "Increase by {C:attention}#2#{} for each {C:attention}#3#{} used this run",
            "{C:inactive}(Currently {C:attention}+#1#{C:inactive} Chips and Mult)",
        }
    },
    valk_artist = "mailingway",
    pos = { x = 1, y = 4 },
    atlas = "oid",
    display_size = { w = 64, h = 78 },
    cost = 0,
    config = { extra = { increase = 0.5 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { 1 + (times_used(self.key) * card.ability.extra.increase),
                card.ability.extra.increase, localize { type = "name_text", set = self.set, key = self.key } }
        }
    end,
    can_use = function()
        return true
    end,
    use = function(self, card, area, copier)
        local v = (times_used(self.key) * card.ability.extra.increase)
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 }, { handname = localize("k_all_hands") })
        -- chips = "+" .. v, mult = "+" .. v,

        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0.5 }, { chips = "+" .. v, })
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0.5 }, { mult = "+" .. v, })
        for key,hand in pairs(G.GAME.hands) do
            G.GAME.hands[key].mult = hand.mult+v
            G.GAME.hands[key].chips = hand.chips+v
        end
        vallkarri.reset_hand_text()
    end,
    in_pool = function(self)
        return false
    end,
}


for i, planetoid in ipairs(planetoid_cards) do
    SMODS.Consumable {
        set = "Planetoid",
        key = planetoid.name ~= "Unnamed Planetoid" and planetoid.name or planetoid.hand.."_auto_planetoid",
        loc_txt = {
            name = planetoid.name or "placeholder to be overwritten lel",
            text = {
                "Level up {C:attention}#1#{}",
                "for each time {C:attention}#4#{} has been",
                "used this run",
                "{C:inactive}(Currently {C:attention}#2#{C:inactive})",
            }
        },
        valk_artist = "mailingway",
        pos = planetoid.pos,
        discovered = planetoid.discovered,
        no_collection = planetoid.no_collection,
        atlas = "oid",
        display_size = { w = 64, h = 78 },

        config = { extra = { handtype = planetoid.hand, increase = 1 } },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { localize(card.ability.extra.handtype, "poker_hands"), 1 +
                (times_used(self.key) * card.ability.extra.increase),
                    card.ability.extra.increase, localize { type = "name_text", set = self.set, key = self.key } }
            }
        end,
        can_use = function()
            return true
        end,
        use = function(self, card, area, copier)
            update_hand_text({ sound = 'button', volume = 0.7, pitch = 1.1, delay = 0 },
                { handname = localize(card.ability.extra.handtype, "poker_hands") })
            level_up_hand(card, card.ability.extra.handtype, nil,
                1 + (times_used(self.key) * card.ability.extra.increase))
            vallkarri.reset_hand_text()
        end,
        in_pool = function(self)
            return (G.GAME.hands[self.config.extra.handtype].played > 0)
        end,
        dependencies = planetoid.dep,
    }
end

SMODS.Booster {
    key = "planetoid_pack_1",
    atlas = "oid",
    kind = "Planetoid",
    pos = { x = 3, y = 3 },
    discovered = true,
    loc_txt = {
        name = "Planetoid Pack",
        text = {
            "Pick {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:planet}Planetoid{} cards to",
            "use immediately"
        },
        group_name = "Planetoid Booster Pack"
    },

    draw_hand = false,
    config = { choose = 1, extra = 3 },
    display_size = { w = 64, h = 78 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
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
    pos = { x = 4, y = 3 },
    discovered = true,
    loc_txt = {
        name = "Planetoid Pack",
        text = {
            "Pick {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:planet}Planetoid{} cards to",
            "use immediately"
        },
        group_name = "Planetoid Booster Pack"
    },

    draw_hand = false,
    config = { choose = 1, extra = 3 },
    display_size = { w = 64, h = 78 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.choose, card.ability.extra } }
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
