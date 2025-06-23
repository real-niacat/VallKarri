SMODS.Joker {
    key = "scraptake",
    loc_txt = {
        name = "Scraptake",
        text = {
            "{X:dark_edition,C:white,s:1.3}^^#2#{} Mult",
            "Earn {C:money}$#1#{} at end of round",
            "{C:inactive,s:0.8}(Index = Owned Vall-Karri Jokers ^ Enhanced cards in deck)",
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
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then
            
            local calced = scraptake_calculation()
            return {
                ee_mult = calced
            }
        end
    end,

    calc_dollar_bonus = function(self, card)
        return card.ability.extra.money
    end,
}

SMODS.Joker {
    key = "libratpondere",
    loc_txt = {
        name = "Librat Pondere",
        text = {
            "{X:dark_edition,C:white,s:1.3}#1##2#{} Chips & Mult",
            "{C:inactive}(Index scales with members in the Vall-Karri discord server)",
            "{C:inactive}(Operator is based on the ratio of Red to Blue team members in the Vall-Karri discord server)",
            credit("Scraptake")
        }
    },
    config = { extra = { fallback_red = 21, fallback_blue = 19, max = 100, exponent = 8 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {"{" .. math.floor(ratiocalc(card.ability.extra.fallback_blue, card.ability.extra.fallback_red, card.ability.extra.exponent, card.ability.extra.max )) .. "}", (card.ability.extra.fallback_blue + card.ability.extra.fallback_red), } }
    end,
    rarity = "valk_unsurpassed",
    atlas = "main",
    pos = {x = 7, y = 5},
    soul_pos = {x = 9, y = 5, extra = {x = 8, y = 5}},
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then
            
            local v = {
                math.floor(ratiocalc(card.ability.extra.fallback_blue, card.ability.extra.fallback_red, card.ability.extra.exponent, card.ability.extra.max )),
                card.ability.extra.fallback_blue + card.ability.extra.fallback_red
            }
            return {
                hyper_mult = v,
                hyper_chips = v,
            }
        end
    end
}

SMODS.Joker {
    key = "dormantlordess",
    loc_txt = {
        name = "{C:cry_azure}The Dormant Lordess",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult",
            quote("dormant"),
            quote("dormant2"),
            credit("Scraptake (Edit by Lily)")
        }
    },
    config = { extra = { mult_bonus = 9 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult_bonus} }
    end,
    rarity = "valk_unobtainable",
    atlas = "main",
    pos = {x = 3, y = 0},
    soul_pos = {x = 4, y = 1, extra = {x = 4, y = 0}},
    cost = 500,
    immutable = true,
    pools = { ["Kitties"] = true },
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then

            return {
                emult = card.ability.extra.mult_bonus
            }
        end
    end,

    lore = {
        "Lily, without the Halo that channels her powers.",
        "In this state, she's still powerful, but can't control",
        "the outcome of her powers very much.",
        "",
        "As such, she tends to limit herself when stuck without the Halo"
    }
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
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then

            return {
                eee_mult = valk_additions()*card.ability.extra.mult
            }
        end
    end
}


-- SMODS.Joker {
-- disabled due to not properly changing pools
local joe = {
    key = "jokerofequality",
    loc_txt = {
        name = "{C:cry_verdant}Joker of Equality",
        text = {
            "At end of round, downgrade the rarity of {C:attention}#1#{} random jokers",
            "{C:inactive}Order:",
            "{C:common}Common{C:inactive} < {C:uncommon}Uncommon{C:inactive} < {C:rare}Rare{C:inactive} < {C:cry_epic}Epic{C:inactive} < {C:legendary}Legendary{C:inactive} < {C:cry_exotic}Exotic{}",
            credit("Scraptake"),
        }
    },
    config = { extra = { downgrades = 3 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.downgrades}}
    end,
    rarity = "valk_unsurpassed",
    atlas = "main",
    pos = {x = 4, y = 8},
    cost = 500,
    immutable = false,
    calculate = function(self, card, context)
        
        if (context.end_of_round and not context.blueprint and not context.individual and not context.repetition) then


            for mostlyuselessiterationvariable = 1, card.ability.extra.downgrades do
                local candidates = {}
                local order = {1, 2, 3, "cry_epic", 4, "cry_exotic"}
                local names = {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Exotic"}
                for i, center in pairs(G.P_CENTERS) do
                    if center.rarity and table:vcontains(order, center.rarity) then
                        table.insert(candidates, {index = i, cen = center})
                    end
                end
                if #candidates > 0 then
                    local chosen = candidates[math.random(#candidates)]
                    -- print("Downgrading " .. chosen.cen.key)
                    -- print("was " .. chosen.cen.rarity)

                    local current_rarity = chosen.cen.rarity
                    
                    local idx = nil
                    for i, v in ipairs(order) do
                        if v == current_rarity then
                            idx = i
                            break
                        end
                    end
                    local new_rarity = order[idx-1]

                    if idx and idx > 1 then
                        local pool = G.P_JOKER_RARITY_POOLS[chosen.cen.rarity]
                        for idx = #pool, 1, -1 do
                            if pool[idx] == chosen.index then
                                table.remove(G.P_JOKER_RARITY_POOLS[chosen.cen.rarity], idx)
                                break
                            end
                        end

                        if not (G.P_CENTERS[chosen.index].oldrarity) then
                            G.P_CENTERS[chosen.index].oldrarity = G.P_CENTERS[chosen.index].rarity
                        end

                        G.P_CENTERS[chosen.index].rarity = order[idx-1]
                        G.P_JOKER_RARITY_POOLS[new_rarity][chosen.index] = chosen.cen
                        
                    end
                
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
            "{X:dark_edition,C:white}#1##2#{} Mult",
            "When a {C:attention}Light{} card is scored, increase this joker's operator by {C:attention}#3#{}",
            "Scored {C:attention}9s{} of {C:spades}spades{} are turned into {C:attention}Light{} cards",
            "Scored {C:spades}non-spade{} {C:attention}9s{} are turned into spades",
            "Scored {C:attention}non-9s{} are turned into {C:attention}9s{}",
            quote("lily"),
            quote("lily2"),
            credit("Scraptake")
        }
    },
    config = { extra = { op = 1, ind = 2, opinc = 1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_cry_light

        return {
            vars = {
                "{" .. card.ability.extra.op .. "}",
                card.ability.extra.ind,
                card.ability.extra.opinc
            }
        }
    end,
    rarity = "valk_selfinsert",
    atlas = "main",
    pos = {x = 0, y = 0},
    -- soul_pos = {x=short_sprites.halo.x, y=short_sprites.halo.y, extra = {x=1,y=0}},
    soul_pos = {x=3,y=2},
    no_doe = true,
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)

        if context.joker_main or context.forcetrigger then

            return {
                hyper_mult = {card.ability.extra.op, card.ability.extra.ind}
            }

        end

        if context.individual and context.cardarea == G.play then

            local enh = SMODS.get_enhancements(context.other_card)
            if enh and enh.m_cry_light then
                card.ability.extra.op = card.ability.extra.op + 1
                context.other_card:juice_up()
                card:juice_up()
                quick_card_speak(card, "Upgraded!")
            end

            if context.other_card.base.id ~= 9 then
                SMODS.change_base(context.other_card, context.other_card.base.suit, "9")
            elseif context.other_card.base.suit ~= "Spades" then
                SMODS.change_base(context.other_card, "Spades")
            else
                context.other_card:set_ability("m_cry_light")
            end

        

        end
        
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.cry_absolute = true
    end,

    lore = {
        "Lily is a Fellinian Entropic Lord, this means",
        "she was exposed to a lot of entropy, and eventually mutating her.",
        "This allowed her to control entropy around her, similar to weak reality bending.",
        "",
        "As a person, Lily tries her best, but is inherently unstable mentally",
        "due to the effects of entropy on a person's mental health.",
        "",
        "Her entropic lord powers allow for heightened senses,",
        "so it doesn't affect her as much, but she can barely see!"
    }
}

SMODS.Joker {
-- quilla = {
    key = "quilla",
    loc_txt = {
        name = "Aquilegia \"Quilla\" Felli",
        text = {
            "Losing is {C:red,E:1,s:1.2}impossible{}",
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

    add_to_deck = function(self, card, from_debuff)

        G.GAME.round_resets.ante = 1500
        card.ability.cry_absolute = true
    end,


    calculate = function(self, card, context)

        if context.individual and (context.cardarea == G.play) then
            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left * 2
            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left * 2

            local copy = copy_card(context.other_card)
            copy:add_to_deck()
            G.hand:emplace(copy)

            context.other_card:quick_dissolve()
        end 

        if context.joker_main then

            return {mult = G.GAME.blind.chips + G.GAME.chips, chips = G.GAME.blind.chips + G.GAME.chips}

        end

    end,

    lore = {
        "Quilla is one of the first Entropic Lords to exist.",
        "She spent over 600 years in outer space, becoming stronger and",
        "achieving further peace with herself.",
        "",
        "Sometime in the year 2999, she came back to the planet",
        "and decided to find another Lord to live with.",
        "After some searching, she found and entered Lily's house,",
        "which she began living in.",
        "Over time, they bonded more and more, and eventually began dating."
    }
}