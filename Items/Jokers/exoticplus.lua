SMODS.Joker {
    key = "lily",
    loc_txt = {
        name = "Lily Felli",
        text = {
            "{X:inactive,C:mult,s:1.9}#1#I{C:mult,s:1.9} Mult",
            "Increase {C:attention}[N]{} by {C:attention}1{} if played hand contains {C:attention}9{} scored {C:attention}9s{}.",
            "{C:inactive,s:0.6}Limited at N=100",
            "Increase {C:attention}[I]{} by {C:attention}#4#{} per 9 scored.",
            "{C:inactive,s:0.9}Currently #2##3#{}",
            quote("lily"),
            credit("Scraptake")
        }
    },
    config = { extra = { op = 1, ex = 2, inc = 0.09 } },
    loc_vars = function(self, info_queue, card)
        local string = "{N}"
        return {vars = {string, "{" .. card.ability.extra.op .. "}", card.ability.extra.ex, card.ability.extra.inc} }
    end,
    rarity = "valk_selfinsert",
    atlas = "main",
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    cost = 500,
    -- immutable = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play then

            if context.individual then

                if context.other_card:get_id() == 9 then
                    card.ability.extra.ex = card.ability.extra.ex + card.ability.extra.inc
                end
        
            end

        end

        if context.cardarea == G.jokers and context.before and not context.blueprint then
            local nines = 0
            for k, v in ipairs(context.scoring_hand) do
                if (v:get_id() == 9) then
                    nines = nines + 1
                end
            end
            if (nines >= 9) then
                card.ability.extra.op = card.ability.extra.op + 1
                if card.ability.extra.op > 100 then
                    card.ability.extra.op = 100
                end
            end
        end

        if context.joker_main then

            return {
                hyper_mult = {card.ability.extra.op, card.ability.extra.ex}
            }
        end
    end
}

SMODS.Joker {
    key = "quilla",
    loc_txt = {
        name = "Aquilegia \"Quilla\" Felli",
        text = {
            "Causes random, chaotic effects in your favor.",
            "{C:inactive,s:0.75}Purely a theory of what could be.{}",
            quote("quilla"),
            quote("quilla2"),
            credit("Scraptake")
        }
    },
    config = { extra = { state = 1, ctr = 0 } },
    loc_vars = function(self, info_queue, card)

    end,
    rarity = "valk_quillagod",
    atlas = "main",
    pos = {x=0,y=3},
    soul_pos = {x=1, y=3},
    cost = 2e100,

    update = function(self, card, front)
        if card.ability and card.ability.extra.state and card.ability.extra.ctr and card.children and card.children.center and card.children.floating_sprite then
            
            card.ability.extra.ctr = (card.ability.extra.ctr + 1) % 60
            if (card.ability.extra.ctr == 0) then
                card.ability.extra.state = card.ability.extra.state + 1
                if card.ability.extra.state > 4 then
                    card.ability.extra.state = 1
                end
                card.children.center:set_sprite_pos({x = 0, y = 3 })
                -- print(card.ability.extra.state)
                card.children.floating_sprite:set_sprite_pos({x = card.ability.extra.state, y = 3})
            end

        end

        local found = SMODS.find_card("j_valk_quilla")
        if (#found > 0) then
            local quilla = (select(2,next(found)))
            quilla.debuff = false
        end

    end,

    calculate = function(self, card, context)


        G.jokers.config.card_limit = G.jokers.config.card_limit + 1

        if context.individual and context.cardarea == G.play then
            local card2 = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'valk_quilla')
			card2:set_edition("e_polychrome", true)
			card2:add_to_deck()
			G.jokers:emplace(card2)
        end 

        if context.joker_main then
            return {
                mult = G.GAME.blind.chips
            }
        end


        

    end
}