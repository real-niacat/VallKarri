SMODS.ConsumableType {
    key = "Superplanet",
    collection_rows = { 4, 4 },
    primary_colour = HEX("1378D6"),
    secondary_colour = HEX("0058A0"),
    shop_rate = 0.01,

    loc_txt = {
        collection = "Superplanet Cards",
        label = "superplanet",
        name = "Super-planet Card",
        undiscovered = {
            name = "Distant Planet",
            text = {
                "Unlock this {C:valk_superplanet}Super-planet{}",
                "by using it in a run"
            }
        }
    },
    default = "c_valk_thornezytkow",

}

local lc = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        lc()
    end
    G.ARGS.LOC_COLOURS.valk_superplanet = HEX("0058A0")
    return lc(_c, _default)
end

G.C.VALK_SUPERPLANET = HEX("0058A0")

SMODS.Atlas {
    key = "csm",
    path = "super_planets.png",
    px = 71,
    py = 95,
}

SMODS.Consumable {
    set = "Superplanet",
    key = "thornezytkow",
    loc_txt = {
        name = "Thorne-Zytkow Object",
        text = {
            "{C:chips}+#1#{} Chips and {C:mult}+#2#{} Mult per level for all hands",
            "plus another {C:attention}#3#{} of both for every level on any hand",

        }
    },
    valk_artist = "mailingway",

    config = { extra = { chips = 1, mult = 1, plus = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.mult, card.ability.extra.plus } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        for i, hand in pairs(G.GAME.hands) do
            if (hand.level) then
                levels = levels + hand.level
            end
        end



        local chips = levels * card.ability.extra.plus * card.ability.extra.chips
        local mult = levels * card.ability.extra.plus * card.ability.extra.mult

        vallkarri.l_chipsmult_allhands(card, chips, mult)
    end,

    atlas = "csm",
    pos = { x = 4, y = 0 },

    no_grc = true,
    no_doe = true,
}

SMODS.Consumable {
    set = "Superplanet",
    key = "planckstar",
    loc_txt = {
        name = "Planck Star",
        text = {
            "All hands gain " .. expomult("#1#") .. " Mult,",
            "plus another " .. expomult("#1#") .. " Mult for every 5 levels on",
            "{C:attention}High Card{}, {C:attention}Pair{}, and {C:attention}Two Pair{}",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,

    config = { extra = { emult = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.emult } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        levels = levels + G.GAME.hands["High Card"].level
        levels = levels + G.GAME.hands["Pair"].level
        levels = levels + G.GAME.hands["Two Pair"].level



        local value = card.ability.extra.emult ^ (card.ability.extra.emult ^ math.floor(levels / 5))
        local str = "^" .. tostring(value)
        vallkarri.simple_hand_text("all")
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { mult = str })

        for i, hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].mult) then
                G.GAME.hands[i].mult = G.GAME.hands[i].mult ^ value
            end
        end
    end,


    atlas = "csm",
    pos = { x = 3, y = 0 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "cosmicstring",
    loc_txt = {
        name = "Cosmic String",
        text = {
            "All hands gain " .. expochips("#1#") .. " Chips,",
            "plus another " .. expochips("#1#") .. " Chips for every 5 levels on",
            "{C:attention}Five of a Kind{}, {C:attention}Flush House{}, and {C:attention}Flush Five{}",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,

    config = { extra = { echips = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.echips } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        levels = levels + G.GAME.hands["Five of a Kind"].level
        levels = levels + G.GAME.hands["Flush House"].level
        levels = levels + G.GAME.hands["Flush Five"].level


        -- i know the math here is incorrect but
        -- who's going to correct me on it?
        local value = card.ability.extra.echips ^ (card.ability.extra.echips ^ math.floor(levels / 5))
        local str = "^" .. tostring(value)
        vallkarri.simple_hand_text("all")
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { chips = str })

        for i, hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].chips) then
                G.GAME.hands[i].chips = G.GAME.hands[i].chips ^ value
            end
        end
    end,


    atlas = "csm",
    pos = { x = 0, y = 0 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "hdb",
    loc_txt = {
        name = "HD 209458-B",
        text = {
            "All hands gain " .. expomult("#1#") .. " Mult,",
            "plus another " .. expomult("#1#") .. " Mult for every 5 levels on",
            "{C:attention}Three of a Kind{}, {C:attention}Straight{}, and {C:attention}Flush{}",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,

    config = { extra = { echips = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.echips } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        levels = levels + G.GAME.hands["Three of a Kind"].level
        levels = levels + G.GAME.hands["Straight"].level
        levels = levels + G.GAME.hands["Flush"].level


        -- i know the math here is incorrect but
        -- who's going to correct me on it?
        local value = card.ability.extra.echips ^ (card.ability.extra.echips ^ math.floor(levels / 5))
        local str = "^" .. tostring(value)
        vallkarri.simple_hand_text("all")
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { mult = str })

        for i, hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].mult) then
                G.GAME.hands[i].mult = G.GAME.hands[i].mult ^ value
            end
        end
    end,


    atlas = "csm",
    pos = { x = 1, y = 0 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "milkyway",
    loc_txt = {
        name = "Milky Way",
        text = {
            "All hands gain " .. expomult("#1#") .. " Chips & Mult,",
            "plus another " .. expomult("#1#") .. " Chips & Mult for",
            "every {C:attention}Jolly Joker{} owned",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,

    config = { extra = { eeall = 1.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.eeall } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local value = card.ability.extra.eeall

        for i, joker in pairs(G.jokers.cards) do
            if joker.config.center.key == "j_jolly" then
                value = value ^ card.ability.extra.eeall
            end
        end

        local str = "^" .. tostring(value)
        vallkarri.simple_hand_text("all")
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { mult = str })

        for i, hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].mult and G.GAME.hands[i].chips) then
                G.GAME.hands[i].mult = G.GAME.hands[i].mult ^ value
                G.GAME.hands[i].chips = G.GAME.hands[i].chips ^ value
            end
        end
    end,


    atlas = "csm",
    pos = { x = 6, y = 0 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "eulogia",
    loc_txt = {
        name = "{f:6}εὐλογία{}",
        text = {
            "Level up all hands {C:attention}once{},",
            "then multiply all hand levels by {C:attention}#1#{}.",
            "Double this value for each {C:attention,f:6}#2#{} used in run",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                2 ^ times_used(self.key),
                localize { type = "name_text", set = self.set, key = self.key }
            }
        }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        level_all_hands(card, 1)
        level_all_hands(card, nil, (2 ^ times_used(self.key)) - 1)
    end,


    atlas = "csm",
    pos = { x = 7, y = 0 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "barnard",
    loc_txt = {
        name = "Nada",
        text = {
            expochips("#1#") .. " Chips on {C:attention}Full Mansion{}",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,
    config = { extra = { evalue = 9 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.evalue
            }
        }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local value = card.ability.extra.evalue
        local str = "^" .. number_format(value)
        vallkarri.simple_hand_text("cry_None")
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { chips = str })

        G.GAME.hands["valk_fullmansion"].chips = G.GAME.hands["valk_fullmansion"].chips ^ value
    end,
    in_pool = function(self, args)
        return G.GAME.hands["valk_fullmansion"].played > 0
    end,



    atlas = "csm",
    pos = { x = 8, y = 0 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "bootesvoid",
    loc_txt = {
        name = "Zip",
        text = {
            expochips("#1#") .. " Mult on {C:attention}Full Mansion{}",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,
    config = { extra = { evalue = 9 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.evalue
            }
        }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local value = card.ability.extra.evalue
        local str = "^" .. number_format(value)
        vallkarri.simple_hand_text("cry_None")
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { mult = str })

        G.GAME.hands["valk_fullmansion"].mult = G.GAME.hands["valk_fullmansion"].mult ^ value
    end,
    in_pool = function(self, args)
        return G.GAME.hands["valk_fullmansion"].played > 0
    end,


    atlas = "csm",
    pos = { x = 9, y = 0 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "lynxconstellation",
    loc_txt = {
        name = "Lynx Constellation",
        text = {
            expochips("#1#") .. " Chips & Mult on {C:attention}All hands{}",
            "for each {C:attention}Kitty{} Joker owned",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,
    soul_rate = 5,
    config = { extra = { evalue = 1.9 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.evalue
            }
        }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        for i, joker in ipairs(G.jokers.cards) do
            if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                levels = levels + 1
            end
        end



        local value = (card.ability.extra.evalue ^ levels)
        local str = "^" .. number_format(value)
        vallkarri.simple_hand_text("all")
        update_hand_text({ sound = 'button', volume = 0.7, pitch = 1, delay = 1 }, { chips = str, mult = str })

        for i, hand in pairs(G.GAME.hands) do
            G.GAME.hands[i].chips = G.GAME.hands[i].chips ^ value
            G.GAME.hands[i].mult = G.GAME.hands[i].mult ^ value
        end
    end,
    in_pool = function(self, args)
        for i, joker in ipairs(G.jokers.cards) do
            if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                return true
            end
        end
        return false
    end,


    atlas = "csm",
    pos = { x = 0, y = 1 },
    no_grc = true,
    no_doe = true,

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "lmcx",
    loc_txt = {
        name = "LMC X-1",
        text = {
            "Raise all hand levels to their respective {C:gold}Ascension Power{}",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,

    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.eechips } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        for i, hand in pairs(G.GAME.hands) do
            local lvl = G.GAME.hands[i].level
            local asc = G.GAME.hands[i].AscensionPower
            if asc and to_big(lvl) >= to_big(1) then
                level_up_hand(card, i, false, (lvl ^ asc) - lvl)
            end
        end
    end,


    atlas = "csm",
    pos = { x = 2, y = 0 },
    no_grc = true,
    no_doe = true,
    dependencies = { "entr" },

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "neve",
    loc_txt = {
        name = "NeVe 1",
        text = {
            "Multiply {C:chips}chips{} and {C:mult}mult{} of all hands by {C:attention}#1#{}",
            "{X:dark_edition,C:white}^^#2#{} Chips and Mult on all hands",
            "{X:gold,C:white}^#3#{} Ascension Power of all hands",
        }
    },
    valk_artist = "mailingway",
    no_doe = true,

    config = { extra = { mult = 5, tet = 1.05, exp = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.tet, card.ability.extra.exp } }
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        for i, hand in pairs(G.GAME.hands) do
            hand.mult = to_big(hand.mult):mul(card.ability.extra.mult)
            hand.chips = to_big(hand.chips):mul(card.ability.extra.mult)

            hand.l_chips = to_big(hand.l_chips):tetrate(card.ability.extra.tet):add(1)
            hand.l_mult = to_big(hand.l_mult):tetrate(card.ability.extra.tet):add(1)

            if (hand.AscensionPower) then
                hand.AscensionPower = to_big(hand.AscensionPower):pow(card.ability.extra.exp)
            end
        end
    end,


    atlas = "csm",
    pos = { x = 5, y = 0 },
    no_grc = true,
    no_doe = true,
    dependencies = { "Talisman", "entr" },

    demicoloncompat = true,
    force_use = function(self, card)
        self:use(card)
    end
}

SMODS.Booster {
    key = "superplanet_1",
    weight = 0.28,
    kind = "superplanet",
    cost = 16,
    pos = { x = 0, y = 2 },
    atlas = "csm",
    -- group_key = "superplanet_pack",
    config = { extra = 3, choose = 1 },
    loc_txt = {
        name = "Cosmic Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:valk_superplanet}Superplanet{} cards to",
            "be used immediately"
        },
        group_name = "Cosmic Booster Pack"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.choose or self.config.choose, card.ability.extra or self.config.extra }
        }
    end,

    create_card = function(self, card, i)
        return create_card("Superplanet", G.pack_cards, nil, nil, true, true, nil, "valk_superplanet_pack")
    end,
    in_pool = function()
        return G.GAME.round_resets.ante > 6
    end
}

SMODS.Booster {
    key = "superplanet_2",
    weight = 0.28,
    kind = "superplanet",
    cost = 16,
    pos = { x = 1, y = 2 },
    atlas = "csm",
    -- group_key = "superplanet_pack",
    config = { extra = 3, choose = 1 },
    loc_txt = {
        name = "Cosmic Pack",
        text = {
            "Choose {C:attention}#1#{} of up to",
            "{C:attention}#2#{} {C:valk_superplanet}Superplanet{} cards to",
            "be used immediately"
        },
        group_name = "Cosmic Booster Pack"
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.choose or self.config.choose, card.ability.extra or self.config.extra }
        }
    end,

    create_card = function(self, card, i)
        return create_card("Superplanet", G.pack_cards, nil, nil, true, true, nil, "valk_superplanet_pack")
    end,
    in_pool = function()
        return G.GAME.round_resets.ante > 6
    end
}
