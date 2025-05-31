SMODS.Joker {
    key = "orivander",
    loc_txt = {
        name = "Orivander",
        text = {
            "Creates an Eternal {C:attention}Gravity Well{} when obtained.",
            "Allows for building up score and releasing it all across multiple hands.",
            quote("orivander"),
            credit("Scraptake")
        },
    },
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)

    end,

    cost = 50,
    rarity = "cry_exotic",
    atlas = "main",
    pos = {x = 0, y = 1},
    soul_pos = {x = 1, y = 1},
    calculate = function(self, card, context)

    end,
    --  (select(2, next(SMODS.find_card("c_valk_gravitywell")))):quick_dissolve()
    add_to_deck = function(self, card, from_debuff)
        if (not from_debuff) then
            local ability = create_card("Consumable", G.consumeables, nil, nil, nil, nil, "c_valk_gravitywell", "orivander")
            ability:add_to_deck()
            
            G.consumeables:emplace(ability)
            ability.ability.eternal = true
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if (not from_debuff) then
            local found = SMODS.find_card("c_valk_gravitywell")
            if #found > 0 then
                (select(2, next(found))):quick_dissolve()
            end
        end
    end,
}

SMODS.Joker {
    key = "illena",
    loc_txt = {
        name = "Illena Vera",
        text = {
            "Multiply playing card values by {C:red}X#1#{} when scored.",
            "Multiply all joker values by {C:red}X#2#{} when any playing card scored.",
            "{C:inactive}Does not include Illena Vera{}",
            quote("illena"),
            credit("Scraptake")
        }
    },
    config = { extra = { strong = 1.4444, mid = 1.04444 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.strong, card.ability.extra.mid} }
    end,
    rarity = "cry_exotic",
    atlas = "main",
    pools = { ["Kitties"] = true },
    pos = {x=0,y=2},
    soul_pos = {x=1, y=2},
    cost = 50,
    immutable = true,

    calculate = function(self, card, context)
        
        if (context.individual and context.cardarea == G.play) then
            Cryptid.misprintize(context.other_card, {min=card.ability.extra.strong, max=card.ability.extra.strong}, nil, true)


            for i,c in ipairs(G.jokers.cards) do
                if not (c.config.center_key == "j_valk_illena") then
                    Cryptid.misprintize(c, {min=card.ability.extra.mid, max=card.ability.extra.mid}, nil, true)
                end
                
            end
        end

    end
}

SMODS.Joker {
    key = "raisingthebar",
    loc_txt = {
        name = "Raising The Bar",
        text = {
            "{X:dark_edition,s:1.3,C:white}^^^1+(1/Log10(Mult){} Mult",
            credit("Scraptake")
        }
    },
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return {vars = {} }
    end,
    rarity = "cry_exotic",
    atlas = "main",
    pos = {x=9,y=1},
    cost = 50,
    immutable = true,

    calculate = function(self, card, context)
        
        if context.joker_main then
            local n = 1 + (1 / math.log10(mult))
            print(n)
            return {eee_mult = n}
        end

    end
}