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
    --  (select(2, next(SMODS.find_card("c_valk_gravitywell")))):destroy()
    add_to_deck = function(self, card, from_debuff)
        if (not from_debuff and #SMODS.find_card("c_valk_gravitywell") == 0) then
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
                (select(2, next(found))):destroy()
            end
        end
    end,


}

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
    key = "niko",
    loc_txt = {
        name = "Niko Gray",
        text = {
            "When blind selected, {C:red}debuff{} a random joker.",
            "This joker's values will be {C:attention}doubled{} and {C:red}un-debuffed{} upon cashing out.",
            quote("niko"),
            credit("Scraptake")
        }
    },
    config = { extra = { saved_joker = nil } },
    loc_vars = function(self, info_queue, card)

    end,
    rarity = 4,
    atlas = "main",
    pos = {x=0,y=4},
    soul_pos = {x=1,y=4},
    cost = 20,
    calculate = function(self, card, context)

        if (context.setting_blind) then 
            
            local allowed = {}
            for i,c in ipairs(G.jokers.cards) do
                if (c.config.center_key ~= "j_valk_niko") then
                    table.insert(allowed, c)
                end
            end
            local jkr = allowed[math.random(#allowed)]

            if (jkr) then
                card.ability.extra.saved_joker = jkr -- to save
                jkr.debuff = true
                Cryptid.misprintize(jkr, {min=2, max=2}, nil, true) --multiply values by 2
            end

        end

        if (context.starting_shop) then
            local jkr = card.ability.extra.saved_joker
            if (jkr) then
                jkr.debuff = false
                card.ability.extra.saved_joker = nil
            end
        end

    end
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
    key = "lily",
    loc_txt = {
        name = "Lily Felli",
        text = {
            "{X:inactive,C:mult,s:1.9}#1#I{C:mult,s:1.9} Mult",
            "Increase {C:attention}[N]{} by {C:attention}1{} if played hand contains {C:attention}9{} scored {C:attention}9s{}.",
            "{C:inactive,s:0.6}Limited at N=100",
            "Increase {C:attention}[I]{} by {C:attention}0.09{} per 9 scored.",
            "{C:inactive,s:0.9}Currently #2##3#{}",
            quote("lily"),
            credit("Scraptake")
        }
    },
    config = { extra = { op = 1, ex = 2 } },
    loc_vars = function(self, info_queue, card)
        local string = "{N}"
        return {vars = {string, "{" .. card.ability.extra.op .. "}", card.ability.extra.ex} }
    end,
    rarity = "valk_selfinsert",
    atlas = "main",
    pos = {x = 0, y = 0},
    soul_pos = {x = 1, y = 0},
    cost = 500,
    immutable = true,
    calculate = function(self, card, context)
        if context.cardarea == G.play then

            if context.individual then

                if context.other_card:get_id() == 9 then
                    card.ability.extra.ex = card.ability.extra.ex + 0.09
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