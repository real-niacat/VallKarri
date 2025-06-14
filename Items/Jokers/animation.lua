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
    rarity = 3,
    atlas = "main",
    pos = {x=5, y=3},
    soul_pos = {x=6, y=3},
    immutable = true,
    cost = 10,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.end_of_round and context.main_eval) then

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
            "When hand played, return all {C:attention}discarded{} cards back to {C:attention}deck{}"
        }
    },

    loc_vars = function(self, info_queue, card )

    end,
    
    config = { extra = {} },
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=5, y=5},
    soul_pos = {x=6, y=5},
    immutable = true,
    cost = 12,
    calculate = function(self, card, context)

        if context.joker_main and not context.individual and not context.repetition then
            for i,card in ipairs(G.discard.cards) do
                draw_card(G.discard, G.deck, nil, nil, nil, card)
            end
        end

    end
}