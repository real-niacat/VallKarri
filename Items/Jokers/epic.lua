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
    config = { extra = { state = 1, ctr = 0, num = 1, den = 10 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "raxd")
        return { vars = { num, den } }
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = { x = 0, y = 6 },
    soul_pos = { x = 1, y = 6 },
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
                card.children.floating_sprite:set_sprite_pos({ x = card.ability.extra.state, y = 6 })
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
        return { vars = { card.ability.extra.money } }
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = { x = 5, y = 1 },
    soul_pos = { x = 6, y = 1 },
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
    key = "cascade",
    loc_txt = {
        name = "Cascading Chain",
        text = {
            "When {X:blue,C:white}XChips{} triggered,",
            "Divide blind size by triggered amount",
            credit("Scraptake")
        }
    },
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    rarity = "cry_epic",
    atlas = "main",
    pos = { x = 0, y = 10 },
    cost = 18,
    immutable = true,
}

SMODS.Joker {
    key = "zulu",
    loc_txt = {
        name = "{C:valk_prestigious,s:2}Zulu",
        text = {
            "{X:mult,C:white}X1{} Mult",
            "{C:valk_prestigious,s:3,f:5}+π/10{C:valk_prestigious,s:3} Zulu",
            "{C:red,s:3.14159265}annihilates{}  a  few other cards",
            credit("Lily")
        }
    },
    config = { extra = { zulu = math.pi / 10 } },
    rarity = "cry_epic",
    atlas = "main",
    pos = { x = 4, y = 0 },
    cost = math.ceil(10 * math.pi),
    pools = { ["Meme"] = true },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.zulu } }
    end,

    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            for i, jkr in ipairs(G.jokers.cards) do
                if jkr ~= card then jkr:start_dissolve() end
            end
            return { zulu = card.ability.extra.zulu, xmult = 1, }
        end

        if context.other_card and context.other_card.area == G.play then
            context.other_card:start_dissolve()
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
            credit("Poker the Poker (Edit by Lily)")
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.base,
                card.ability.extra.poly
            }
        }
    end,
    config = { extra = { base = 2, poly = 4 } },
    atlas = "main",
    pos = { x = 4, y = 10 },
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
            for i, jkr in ipairs(G.jokers.cards) do
                if (not jkr.edition) or (jkr.edition and jkr.edition.key ~= "e_polychrome") then
                    valid[#valid + 1] = jkr
                end
            end

            if #valid > 0 then
                pseudorandom_element(valid, "valk_woke_finn"):set_edition("e_polychrome")
            end
        end
    end,
}

SMODS.Joker {
    key = "imwithstupid",
    rarity = "cry_epic",
    loc_txt = {
        name = "I'm with stupid",
        text = {
            "Retrigger the {C:attention}Joker{} to the left {C:attention}#1#{} time(s)",
            "Increase retrigger amount by {C:attention}#2#{} for",
            "every {C:attention}#3#{} {C:inactive}[#4#]{} played cards",
            credit("mailingway")
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.retrig,
                card.ability.extra.inc,
                card.ability.extra.reset,
                card.ability.extra.req
            }
        }
    end,
    config = { extra = { retrig = 1, inc = 1, req = 20, reset = 20 } },
    atlas = "main",
    pos = { x = 11, y = 5 },
    cost = 12,
    immutable = true,
    pools = { ["Meme"] = true },
    calculate = function(self, card, context)
        if context.retrigger_joker_check then
            local my_index = 0
            for i, joker in ipairs(G.jokers.cards) do
                if joker == card then my_index = i end
            end

            if G.jokers.cards[my_index - 1] and context.other_card == G.jokers.cards[my_index - 1] then
                return {
                    repetitions = card.ability.extra.retrig
                }
            end
        end

        if context.joker_main then
            card.ability.extra.req = card.ability.extra.req - #context.scoring_hand
            if card.ability.extra.req < 0 then
                card.ability.extra.req = card.ability.extra.req + card.ability.extra.reset
                card.ability.extra.retrig = card.ability.extra.retrig + card.ability.extra.inc
            end
        end
    end,
}

SMODS.Joker {
    key = "copycat",
    rarity = "cry_epic",
    loc_txt = {
        name = "Copy Cat",
        text = {
            "When blind selected, add a random",
            "{C:attention}Mirrored{} card to deck",
            credit("Nobody!")
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {

            }
        }
    end,
    config = { extra = {} },
    atlas = "phold",
    pos = { x = 0, y = 1 },
    cost = 12,
    immutable = true,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.setting_blind then
            -- code essentially copied frmo marble joker
            G.E_MANAGER:add_event(Event({
                func = function()
                    local c = SMODS.create_card({key="m_valk_mirrored"})
                    SMODS.calculate_effect({ message = "Created!", colour = G.C.SECONDARY_SET.Enhanced }, context.blueprint_card or card)

                    G.deck:emplace(c)
                    table.insert(G.playing_cards, c)
                    return true
                end
            }))
        end
    end,
}
