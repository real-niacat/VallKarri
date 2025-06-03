SMODS.ConsumableType {
    key = "Superplanet",
    collection_rows = {4, 3},
    primary_colour = HEX("1378D6"),
    secondary_colour = HEX("0058A0"),
    shop_rate = 0.02,

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
}

SMODS.Atlas {
    key = "csm",
    path = "consumables.png",
    px = 71,
    py = 95,
}

SMODS.Consumable {
    set = "Superplanet",
    key = "thornezytkow",
    loc_txt = {
        name = "Thorne-Zytkow Object",
        text = {
            "All hands gain " .. expochips("#1#") .. " Chips",
            "Plus another " .. expochips("#1#") .. " Chips for every 5 levels on any hand",
            credit("Nobody!"),
            concept("arris")
        }
    },

    no_doe = true,

    config = { extra = { echips = 1.1 } },
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

        
        
        local value = to_big(card.ability.extra.echips):pow(to_big(card.ability.extra.echips):pow(math.floor(levels/5)))
        local str = "^" .. tostring(value)
        jl.th("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].chips) then
                G.GAME.hands[i].chips = G.GAME.hands[i].chips:pow(value)
            end
        end
    end,

        
    atlas = "phold",
    pos = {x=0, y=0},
    
}

SMODS.Consumable {
    set = "Superplanet",
    key = "planckstar",
    loc_txt = {
        name = "Planck Star",
        text = {
            "All hands gain " .. expomult("#1#") .. " Mult",
            "Plus another " .. expomult("#1#") .. " Mult for every 5 levels on",
            "{C:attention}High Card{}, {C:attention}Pair{}, and {C:attention}Two Pair{}",
            credit("Nobody!"),
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

        
        
        local value = to_big(card.ability.extra.emult):pow(to_big(card.ability.extra.emult):pow(math.floor(levels/5)))
        local str = "^" .. tostring(value)
        jl.th("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {mult = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].mult) then
                G.GAME.hands[i].mult = G.GAME.hands[i].mult:pow(value)
            end
        end
    end,

        
    atlas = "phold",
    pos = {x=0, y=0},
    
}