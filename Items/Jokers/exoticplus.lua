SMODS.Joker {
    key = "scraptake",
    loc_txt = {
        name = "Scraptake",
        text = {
            "{X:dark_edition,C:white,s:1.3}^^[M]{} Mult",
            "Earn {C:money}$#1#{} per hand played",
            "{C:inactive}(M = Owned jokers from Vall-Karri ^ Enhanced cards in deck)",
            "{C:inactive}(Currently {X:dark_edition,C:white,s:1.3}^^#2#{C:inactive} Mult)",
            quote("scraptake"),
            credit("Scraptake")
        }
    },
    config = { extra = { money = 15 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money, scraptake_calculation()} }
    end,
    rarity = "valk_unsurpassed",
    atlas = "main",
    pos = {x = 7, y = 0},
    soul_pos = {x = 9, y = 0, extra = {x = 8, y = 0}},
    cost = 500,
    immutable = true,
    calculate = function(self, card, context)
        
        if context.joker_main then
            ease_dollars(card.ability.extra.money)
            
            local calced = scraptake_calculation()
            return {
                ee_mult = calced
            }
        end
    end
}

SMODS.Joker {
    key = "dormantlordess",
    loc_txt = {
        name = "{C:cry_azure}The Dormant Lordess",
        text = {
            "{C:mult}+#1#{} Mult",
            quote("dormant"),
            quote("dormant2"),
            credit("Scraptake (Edit by Lily)")
        }
    },
    config = { extra = { mult_bonus = 9 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_bonus} }
    end,
    rarity = "valk_unsurpassed",
    atlas = "main",
    pos = {x = 3, y = 0},
    soul_pos = {x = 4, y = 0, extra = {x = 4, y = 1}},
    cost = 500,
    immutable = true,
    calculate = function(self, card, context)
        
        if context.joker_main then

            return {
                mult = card.ability.extra.mult_bonus
            }
        end
    end
}

SMODS.Joker {
    key = "vallkarrilua",
    loc_txt = {
        name = "{C:cry_azure}Vall-Karri.lua",
        text = {
            "{X:dark_edition,C:white}^^^#1#{} Mult for every piece of content that {B:1,E:2,C:white}Vall-karri{} adds",
            "{C:inactive}(Currently {X:dark_edition,C:white}^^^#2#{C:inactive} Mult){}",
            quote("valklua"),
            credit("Scraptake"),
            concept("Arris"),
        }
    },
    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local total = valk_additions()

        

        return {vars = {card.ability.extra.mult, total*card.ability.extra.mult, colours = {HEX("e5bf3a")}}  }
    end,
    rarity = "valk_unsurpassed",
    atlas = "main",
    pos = {x = 3, y = 6},
    cost = 500,
    immutable = true,
    calculate = function(self, card, context)
        
        if context.joker_main then

            return {
                eee_mult = valk_additions()*card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "lily",
    loc_txt = {
        name = "Lily Felli",
        text = {
            "{X:inactive,C:mult,s:1.9}#1#I{C:mult,s:1.9} Mult",
            "Increase {C:attention}[N]{} by {C:attention}#5#{} if played hand contains {C:attention}9{} scored {C:attention}9s{}.",
            "{C:inactive,s:0.6}Limited at N=1000",
            "Increase {C:attention}[I]{} by {C:attention}#4#{} per 9 scored.",
            "{C:inactive,s:0.9}Currently #2##3#{}",
            quote("lily"),
            quote("lily2"),
            credit("Scraptake")
        }
    },
    config = { extra = { op = 1, ex = 1, inc = 0.09, opinc = 1 } },
    loc_vars = function(self, info_queue, card)
        local string = "{N}"
        return {vars = {string, "{" .. card.ability.extra.op .. "}", card.ability.extra.ex, card.ability.extra.inc, card.ability.extra.opinc} }
    end,
    rarity = "valk_selfinsert",
    atlas = "main",
    pos = {x = 0, y = 0},
    -- soul_pos = {x=short_sprites.halo.x, y=short_sprites.halo.y, extra = {x=1,y=0}},
    soul_pos = {x=3,y=2},
    no_doe = true,
    cost = 500,
    immutable = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play then

            if context.individual then

                if context.other_card:get_id() == 9 then
                    card.ability.extra.ex = card.ability.extra.ex + card.ability.extra.inc
                end
        
            end

        end

        if context.end_of_round and not context.repetition and not context.individual and not context.blueprint then
            local search = SMODS.find_card("j_valk_scraptake")
            if (#search > 0) then
                card_eval_status_text(select(2,next(search)),"extra",nil,nil,nil,{message = "Good kitty!"})
                card_eval_status_text(card,"extra",nil,nil,nil,{message = "meow!"})
                card.ability.extra.op = card.ability.extra.op + (card.ability.extra.opinc * 3)
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
                card.ability.extra.op = card.ability.extra.op + card.ability.extra.opinc
                if card.ability.extra.op > 1000 then
                    card.ability.extra.op = 1000
                end
            end
        end

        if context.joker_main then

            return {
                hyper_mult = {card.ability.extra.op, card.ability.extra.ex}
            }
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.cry_absolute = true
    end
}

-- SMODS.Joker {
quilla = {
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
    rarity = "valk_unobtainable",
    atlas = "main",
    pos = {x=0,y=3},
    soul_pos = {x=1, y=3},
    no_doe = true,
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

        if (context.other_card) then 
            if ((not context.other_card.edition)) then
                context.other_card:set_edition("e_negative", true)
            end
        end

        G.jokers.config.card_limit = G.jokers.config.card_limit + 1

        if context.individual and context.cardarea == G.play then
            local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, nil, 'valk_quilla')
			card2:set_edition("e_negative", true)
			card2:add_to_deck()
			G.jokers:emplace(card2)

            local card3 = create_card('Joker', G.jokers, nil, nil, nil, nil, nil, 'valk_quilla')
			card3:set_edition("e_negative", true)
			card3:add_to_deck()
			G.consumeables:emplace(card3)
        end 

        if context.joker_main then
            return {
                mult = to_big(G.GAME.blind.chips):arrow(66,666)
            }
        end


        

    end,

    calc_dollar_bonus = function(self, card)
        return G.GAME.dollars ^ 2
    end
}