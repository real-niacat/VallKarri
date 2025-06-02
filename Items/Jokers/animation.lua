SMODS.Joker {
    key = "animblue",
    loc_txt = {
        name = "{C:blue}Blue{}",
        text = {
            "{C:attention}X#1#{} to values of all {C:attention}food jokers{}",
            "at end of round",
        }
    },

    loc_vars = function(self, info_queue, card )
        return {vars = {card.ability.extra.change}}
    end,
    
    config = { extra = {change = 1.1} },
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=5, y=3},
    soul_pos = {x=6, y=3},
    immutable = true,
    cost = 10,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.end_of_round and not context.individual and not context.repetition) or context.forcetrigger then

            for i,joker in ipairs(G.jokers.cards) do
                
                local res = Cryptid.safe_get(joker.config.center, "pools", "Food")
                for j,pool in pairs(G.P_CENTER_POOLS) do
                    for k,pooljoker in pairs(pool) do
                        res = res or (pooljoker.key == joker.key)
                    end
                end

                if res then
                    Cryptid.misprintize(joker, {min=card.ability.extra.change, max=card.ability.extra.change}, false, true)
                end

            end

        end
    end
}

SMODS.Joker {
    key = "animyellow",
    loc_txt = {
        name = "{C:money}Yellow{}",
        text = {
            "Create a {C:dark_edition}negative{} {C:cry_code}code card{} when any",
            "{C:cry_code}non-code{} card is sold"
        }
    },

    loc_vars = function(self, info_queue, card )
        
    end,
    
    config = { extra = {} },
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=5, y=7},
    soul_pos = {x=6, y=7},
    immutable = true,
    cost = 12,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if (context.selling_card and context.card.ability and context.card.ability.set ~= "Code") or context.forcetrigger then

            local codecard = create_card("Code", G.consumeables, nil, nil, nil, nil, nil, "valk_yellow")
            codecard:set_edition("e_negative", true)
            codecard:add_to_deck()
            G.consumeables:emplace(codecard)
        end

    end
}

SMODS.Joker {
    key = "animorange",
    loc_txt = {
        name = "{C:attention}Orange{}",
        text = {
            "Create a random {V:1}#1#{} joker in {C:attention}#2#{} rounds",
            "When joker created, increase rarity and {C:attention}double{} required rounds"
        }
    },

    loc_vars = function(self, info_queue, card )
        local rarities = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Exotic"}
        local rarity_colors = {G.C.RARITY[1], G.C.RARITY[2], G.C.RARITY[3], G.C.RARITY["cry_epic"], G.C.RARITY[4], G.C.RARITY["cry_exotic"]}

        return {
            vars = {
                rarities[card.ability.extra.rarity], card.ability.extra.round_counter,
                colours = {rarity_colors[card.ability.extra.rarity]}
            }
        }
    end,
    
    config = { extra = {rarity = 1, round_counter = 2, resets = 1} },
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=5, y=5},
    soul_pos = {x=6, y=5},
    immutable = true,
    cost = 12,
    calculate = function(self, card, context)
        local rarities = {1,2,3, "cry_epic", 4, "cry_exotic"}
        if
			context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
		then
            card.ability.extra.round_counter = card.ability.extra.round_counter - 1
            if (card.ability.extra.round_counter <= 0) then
                card.ability.extra.round_counter = math.pow(card.ability.extra.resets, 2)
                card.ability.extra.resets = card.ability.extra.resets + 1

                print("creating one of rarity " .. rarities[card.ability.extra.rarity])
                local newcard = create_card("Joker", G.jokers, nil, rarities[card.ability.extra.rarity], nil, nil, nil, "valk_animorange")
                newcard:add_to_deck()
                G.jokers:emplace(newcard)

                card.ability.extra.rarity = math.min(card.ability.extra.rarity + 1, 6)

            end
        end

    end
}