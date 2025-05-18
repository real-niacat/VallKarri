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

        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss then

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
    key = "femtanyl",
    loc_txt = {
        name = "Femtanyl",
        text = {
            "Prevents death at the cost of {C:attention}-#1#{} joker slot.",
            "Cost increases by {C:attention}+#2#{} Joker slots when death is prevented.",
            "{C:inactive}Does not prevent death if you end up below 3 joker slots.{}",
            "{C:inactive}When death is prevented, earn {C:money}$8{}",
            quote("femtanyl"),
            credit("Scraptake")
        }
    },
    config = { extra = { cost = 1, increase = 1, activations = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.cost, card.ability.extra.increase}}
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=0, y=9},
    soul_pos = {x=1, y=5},
    cost = 15,
    calculate = function(self, card, context)
        if (context.end_of_round and not context.blueprint and context.game_over) then

            local slots = G.jokers.config.card_limit - card.ability.extra.cost
            G.jokers:change_size(-card.ability.extra.cost, false)
            card.ability.extra.cost = card.ability.extra.cost + card.ability.extra.increase
            

            if (slots >= 3) then
                card.ability.extra.activations = card.ability.extra.activations + 1
                ease_dollars(8)
                if (card.ability.extra.activations % 3) == 0 then
                    card.ability.extra.increase = card.ability.extra.increase + 1
                end
                return {saved = true}
            end

        end
    end
}