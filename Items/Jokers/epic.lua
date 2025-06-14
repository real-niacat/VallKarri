SMODS.Joker {
    key = "raxd",
    loc_txt = {
        name = "raxdflipnote",
        text = {
            "When boss blind is defeated, create a {C:dark_edition,T:e_negative}negative{} {C:attention}Big Cube{}",
            "{C:green}#1# in 10{} chance to spawn a {C:edition}non-negative{} {C:attention}Cube{}",
            "{C:inactive}(Must have room for Cube){}",
            quote("raxd"),
            credit("Scraptake")
        }
    },
    config = { extra = { state = 1, ctr = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {(G.GAME.probabilities.normal or 1)} }
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=0,y=6},
    soul_pos = {x=1,y=6},
    cost = 15,
    demicoloncompat = true,
    update = function(self, card, front)
        if card.ability and card.ability.extra.state and card.ability.extra.ctr and card.children and card.children.center and card.children.floating_sprite then
            
            card.ability.extra.ctr = (card.ability.extra.ctr + 1) % 5
            if (card.ability.extra.ctr == 0) then
                card.ability.extra.state = card.ability.extra.state + 1
                if card.ability.extra.state > 2 then
                    card.ability.extra.state = 1
                end
                card.children.floating_sprite:set_sprite_pos({x = card.ability.extra.state, y = 6})
            end

        end
    end,

    calculate = function(self, card, context)

        if (context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss) or context.forcetrigger then

            if pseudorandom("raxd") > (G.GAME.probabilities.normal / 10) then
                local big_cube = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_big_cube")
                big_cube:set_edition("e_negative", true)
                big_cube:add_to_deck()
                G.jokers:emplace(big_cube)
            else

                if not (#G.jokers.cards >= G.jokers.config.card_limit) then
                    local cube = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_cry_cube")
                    cube:add_to_deck()
                    G.jokers:emplace(cube)
                end

            end

        end

    end
}



SMODS.Joker {
    key = "legeater",
    loc_txt = {
        name = "Leg-Eater",
        text = {
            "Creates a copy of the {C:attention}topmost{} tag when blind selected",
            "Lose {C:money}$#1#{} when this happens",
            credit("Scraptake")
        }
    },
    config = { extra = { money = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.money}}
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=5, y=1},
    soul_pos = {x=6, y=1},
    cost = 15,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if (context.setting_blind or context.forcetrigger) and #G.GAME.tags > 0 then
            add_tag(Tag(G.GAME.tags[#G.GAME.tags].key))
            ease_dollars(-card.ability.extra.money)
        end

    end
}

SMODS.Joker {
    key = "raisingthebar",
    loc_txt = {
        name = "Raising The Bar",
        text = {
            "{X:dark_edition,C:white}^1+(1/Log10(Mult){} Mult",
            credit("Scraptake")
        }
    },
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return {vars = {} }
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=9,y=1},
    cost = 50,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then
            local n = 1 + (1 / math.log10(mult))
            -- print(n)
            if (n == math.huge) then
                n = 1
            end
            return {emult = n}
        end

    end
}

SMODS.Joker {
    key = "cascade",
    loc_txt = {
        name = "Cascading Chain",
        text = {
            "When {X:blue,C:white}XChips{} triggered,",
            "Divide blind size by triggered amount",
            credit("Nobody!")
        }
    },
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return {vars = {} }
    end,
    rarity = "cry_epic",
    atlas = "phold",
    pos = {x=0,y=0},
    cost = 18,
    immutable = true,
}