SMODS.Joker {
    key = "raxd",
    loc_txt = {
        name = "raxdflipnote",
        text = {
            "When {C:attention}Boss Blind{} is defeated, create a {C:dark_edition,T:e_negative}Negative{} {C:attention}Big Cube{}",
            "{C:green}#1# in #2#{} chance to spawn a non-{C:dark_edition}Negative{} {C:attention}Cube{}",
            "{C:inactive}(Must have room for Cube){}",
            quote("raxd"),
            credit("Scraptake")
        }
    },
    config = { extra = { state = 1, ctr = 0 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "raxd")
        return { vars = {(num, den)} }
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

            if SMODS.pseudorandom_probability(card, "valk_raxd", card.ability.extra.num, card.ability.extra.den, "raxd") then
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
            "{X:dark_edition,C:white}^1+(1/Log10(Mult)){} Mult",
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
            credit("Scraptake")
        }
    },
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return {vars = {} }
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=0,y=10},
    cost = 18,
    immutable = true,
}

SMODS.Joker {
    key = "zulu",
    loc_txt = {
        name = "{C:valk_prestigious,s:2}Zulu",
        text = {
            "{X:mult,C:white}X1{} Melt",
            "{C:valk_prestigious,s:3,f:5}+π/10{C:valk_prestigious,s:3} Zulu"
        }
    },
    config = { extra = {zulu = math.pi/10} },
    rarity = "cry_epic",
    atlas = "main",
    pos = {x=4, y=0},
    cost = math.ceil(1000*math.pi),
    pools = { ["Meme"] = true },
    demicoloncompat = true,
    loc_vars = function(self,info_queue, card)
        return {vars = {card.ability.extra.zulu}}
    end,

    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            G.GAME.zulu = (G.GAME.zulu and G.GAME.zulu+card.ability.extra.zulu) or (1+card.ability.extra.zulu)
            return {xmult = 1}
        end
    end
}

SMODS.Joker {
    key = "wokegoe",
    rarity = "cry_epic",
    loc_txt = {
        name = "{C:valk_gay}Wokegoe{}",
        text = {
            "Apply {C:dark_edition}Polychrome{} to a random joker at end of round",
            "{C:dark_edition}Polychrome{} Jokers give {X:mult,C:white}X#2#{} Mult when triggered",
            "{C:inactive}(Does not include self){}",
        }
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.base,
            card.ability.extra.poly
        }}
    end,
    config = { extra = { base = 2, poly = 4 }},
    atlas = "main",
    pos = {x=4, y=10},
    cost = 12,
    pools = { ["Meme"] = true },
    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == "e_polychrome" then
            return {
				xmult = card.ability.extra.poly
			}
        end

        if context.end_of_round and context.main_eval then

            local valid = {}
            for i,jkr in ipairs(G.jokers.cards) do
                if (not jkr.edition) or (jkr.edition and jkr.edition.key ~= "e_polychrome") then
                    valid[#valid+1] = jkr
                end
            end

            if #valid > 0 then
                pseudorandom_element(valid, "valk_woke_finn"):set_edition("e_polychrome")
            end
        end

    end,
}