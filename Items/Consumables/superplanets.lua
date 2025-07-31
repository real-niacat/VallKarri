SMODS.ConsumableType {
    key = "Superplanet",
    collection_rows = {4, 4},
    primary_colour = HEX("1378D6"),
    secondary_colour = HEX("0058A0"),
    shop_rate = 0.01,

    loc_txt = {
        collection = "Superplanet Cards",
        label = "superplanet",
        name = "Super-planet Card",
        undiscovered = {
            name = "go turn on unlock all",
            text = {
                "this mod is intended to be used",
                "with unlock all enabled"
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

G.C.VALK_SUPERPLANET = HEX("50202A")

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
            "All hands gain " .. expochips("#1#") .. " Chips,",
            "plus another " .. expochips("#1#") .. " Chips for every 5 levels on any hand",
            credit("mailingway"),
            concept("arris")
        }
    },

    no_doe = true,

    config = { extra = { echips = 1.2} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.echips}}
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].level) then
                levels = levels + G.GAME.hands[i].level
            end
        end

        
        
        local value = card.ability.extra.emult ^ (card.ability.extra.emult ^ math.floor(levels/5))
        local str = "^" .. tostring(value)
        simple_hand_text("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].chips) then
                G.GAME.hands[i].chips = G.GAME.hands[i].chips ^ value
            end
        end
    end,

        
    atlas = "csm",
    pos = {x=4, y=0},

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
            credit("mailingway"),
            concept("arris")
        }
    },

    no_doe = true,

    config = { extra = { emult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.emult}}
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

        
        
        local value = card.ability.extra.emult ^ (card.ability.extra.emult ^ math.floor(levels/5))
        local str = "^" .. tostring(value)
        simple_hand_text("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {mult = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].mult) then
                G.GAME.hands[i].mult = G.GAME.hands[i].mult ^ value
            end
        end
    end,

        
    atlas = "csm",
    pos = {x=3, y=0},
    no_grc = true,
    no_doe = true,
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
            credit("mailingway"),
            concept("arris")
        }
    },

    no_doe = true,

    config = { extra = { echips = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.echips}}
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
        local value = card.ability.extra.echips ^ (card.ability.extra.echips ^ math.floor(levels/5))
        local str = "^" .. tostring(value)
        simple_hand_text("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].chips) then
                G.GAME.hands[i].chips = G.GAME.hands[i].chips ^ value
            end
        end
    end,

        
    atlas = "csm",
    pos = {x=0, y=0},
    no_grc = true,
    no_doe = true,
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
            credit("mailingway"),
            concept("arris")
        }
    },

    no_doe = true,

    config = { extra = { echips = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.echips}}
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
        local value = card.ability.extra.echips ^ (card.ability.extra.echips ^ math.floor(levels/5))
        local str = "^^" .. tostring(value)
        simple_hand_text("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {mult = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].mult) then
                G.GAME.hands[i].mult = G.GAME.hands[i].mult ^ value
            end
        end
    end,

        
    atlas = "csm",
    pos = {x=1, y=0},
    no_grc = true,
    no_doe = true,
}

SMODS.Consumable {
    set = "Superplanet",
    key = "milkyway",
    loc_txt = {
        name = "Milky Way",
        text = {
            "All hands gain " .. expomult("#1#") .. " Chips & Mult,",
            "plus another " .. expomult("#1#") .. " Chips & Mult for",
            "every {C:attention}M Joker{} or {C:attention}Jolly Joker{} owned",
            credit("mailingway"),
            concept("arris")
        }
    },

    no_doe = true,

    config = { extra = { eeall = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.eeall}}
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local value = card.ability.extra.eeall

        for i,joker in pairs(G.jokers.cards) do 
            if Cryptid.safe_get(joker.config.center, "pools", "M") or joker.config.center.key == "j_jolly" then
                value = value ^ 2
            end
        end

        local str = "^" .. tostring(value)
        simple_hand_text("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {mult = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].mult and G.GAME.hands[i].chips) then
                G.GAME.hands[i].mult = G.GAME.hands[i].mult ^ value
                G.GAME.hands[i].chips = G.GAME.hands[i].chips ^ value
            end
        end
    end,

        
    atlas = "csm",
    pos = {x=6, y=0},
    no_grc = true,
    no_doe = true,
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
            credit("mailingway"),
        }
    },

    no_doe = true,

    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            2 ^ times_used(self.key),
            localize{type = "name_text", set = self.set, key = self.key}
        }}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        level_all_hands(card, 1)
        level_all_hands(card, nil, (2 ^ times_used(self.key))-1)
    end,

        
    atlas = "csm",
    pos = {x=7, y=0},
    no_grc = true,
    no_doe = true,
}

SMODS.Booster {
    key = "superplanet_1",
    weight = 0.5,
    kind = "superplanet",
    cost = 16,
    pos = { x=0, y=2 },
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
        return create_card("Superplanet", G.pack_cards, nil, nil, true, nil, nil, "valk_superplanet_pack")
    end,
}

SMODS.Booster {
    key = "superplanet_2",
    weight = 0.5,
    kind = "superplanet",
    cost = 16,
    pos = { x=1, y=2 },
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
        return create_card("Superplanet", G.pack_cards, nil, nil, true, nil, nil, "valk_superplanet_pack")
    end,
}