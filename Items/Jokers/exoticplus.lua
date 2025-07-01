SMODS.Joker {
    key = "vallkarrilua",
    loc_txt = {
        name = "{C:cry_azure}Vall-Karri.lua",
        text = {
            "{X:dark_edition,C:white}^^#1#{} Mult for every piece of content that {B:1,E:2,C:white}Vall-karri{} adds",
            "{C:inactive}(Currently {X:dark_edition,C:white}^^#2#{C:inactive} Mult){}",
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
    rarity = "valk_prestigious",
    atlas = "main",
    pos = {x = 3, y = 6},
    cost = 500,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then

            return {
                ee_mult = valk_additions()*card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "phicer",
    loc_txt = {
        name = "Phicer Rekiniov",
        text = {
            "{X:dark_edition,C:white}#1##2#{} Chips",
            "{C:inactive,s:0.7}Where N is the length of the OmegaNum array, plus one{}",
            quote("phicer"),
            credit("Nerxiana"),
        }
    },
    config = { extra = { nchips = 2 } },
    loc_vars = function(self, info_queue, card)

        

        return {vars = {"{n}", card.ability.extra.nchips}}
    end,
    rarity = "valk_prestigious",
    atlas = "main",
    pos = {x = 2, y = 13},
    soul_pos = {x = 3, y = 13},
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then
            local base = #hand_chips.array + 1

            if hand_chips < to_big(10):tetrate(5) then
                base = 2
            end

            return {
                hyper_chips = {base, card.ability.extra.nchips}
            }

        end
    end,

    lore = {
        "Phicer Rekiniov is a magical casino owner, who's",
        "garnered a somewhat cult-like following over time.",
        "",
        "She is capable of doing highly-complex magic, but prefers to",
        "use simpler magic for things like summoning workers.",
        "",
        "Though, if needed she can summon weaker versions of",
        "monsters like dragons, wyrms or angel-like entities."
    }
}

if MoreFluff then
    SMODS.Atlas {
        key = "triangle",
        path = "triangle_walk_lowered.png",
        px = 71,
        py = 95,
    }

    SMODS.Joker {
        key = "triangle",
        loc_txt = {
            name = "Triangle",
            text = {
                "When blind selected, create {C:attention}#1#{} {C:dark_edition}Negative{} {C:colourcard}colour{} cards",
                "All {C:colourcard}colour{} cards gain {C:attention}+#2#{} rounds when {C:attention}3{} scored",
                credit("notmario"),
            }
        },
        config = { extra = { rounds = 3, cards = 3 }, immutable = {buffer = 0} },
        loc_vars = function(self, info_queue, card)

            

            return {vars = {card.ability.extra.cards, card.ability.extra.rounds}}
        end,
        rarity = "valk_prestigious",
        atlas = "triangle",
        pos = {x = 12, y = 4},
        soul_pos = {x = 0, y = 0},
        cost = 500,
        immutable = true,
        demicoloncompat = true,
        calculate = function(self, card, context)
            
            if context.setting_blind then
                for i=1,card.ability.extra.cards do
                    local colour = create_card("Colour", G.consumeables, nil, nil, nil, nil, nil, "valk_triangle")
                    colour:add_to_deck()
                    colour:set_edition("e_negative")
                    G.consumeables:emplace(colour)
                end
            end

            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 3 then

                for i=1,card.ability.extra.rounds do
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            colour_end_of_round_effects()
                        end
                    }))
                    
                end

            end

        end,

        update = function(self, card, front)
            card.ability.immutable.buffer = card.ability.immutable.buffer + 1
            if card.ability.immutable.buffer >= 2 then 
                card.ability.immutable.buffer = 0
                local pos = card.children.floating_sprite.sprite_pos
                local new = {x=pos.x+1, y=pos.y}
                if new.x > 12 then
                    new.x = 0
                    new.y = new.y + 1
                end
                if new.x >= 12 and new.y >= 4 then
                    new.x = 0
                    new.y = 0
                end
                -- print(new)

                card.children.floating_sprite:set_sprite_pos(new)

            end
        end,
    }
end

SMODS.Joker {
    key = "scraptake",
    loc_txt = {
        name = "Scraptake",
        text = {
            "Gain {C:money}$1{} for every {C:blue}chip{} {C:attention}overscored{} at end of round",
            quote("scraptake"),
            credit("Scraptake")
        }
    },
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)
        return {vars = {} }
    end,
    rarity = "valk_unsurpassed",
    atlas = "main",
    pos = {x = 7, y = 0},
    soul_pos = {x = 9, y = 0, extra = {x = 8, y = 0}},
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)

    end,

    calc_dollar_bonus = function(self, card)
        return G.GAME.chips - G.GAME.blind.chips
    end,
}

SMODS.Joker {
    key = "libratpondere",
    loc_txt = {
        name = "Librat Pondere",
        text = {
            "{X:dark_edition,C:white,s:1.3}#1##2#{} Chips & Mult",
            "{C:inactive,s:0.7}(Index scales with members in the Vall-Karri discord server)",
            "{C:inactive,s:0.7}(Operator is based on the ratio of Red to Blue team members in the Vall-Karri discord server)",
            credit("Scraptake")
        }
    },
    config = { extra = { fallback_red = 34, fallback_blue = 41, max = 10, exponent = 5 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {"{" .. math.ceil(ratiocalc(card.ability.extra.fallback_blue, card.ability.extra.fallback_red, card.ability.extra.exponent, card.ability.extra.max )) .. "}", (card.ability.extra.fallback_blue + card.ability.extra.fallback_red), } }
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
                math.ceil(ratiocalc(card.ability.extra.fallback_blue, card.ability.extra.fallback_red, card.ability.extra.exponent, card.ability.extra.max )),
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
    soul_pos = {x = 4, y = 1},
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
                card.ability.extra.op = card.ability.extra.op + card.ability.extra.opinc
                card.ability.extra.ind = to_big(card.ability.extra.op):tetrate(card.ability.extra.ind)
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
        name = "Quilla",
        text = {
            "{X:dark_edition,C:white}#1#[Blind Size]{} Chips & Mult",
            "{X:blue,C:white}X2{} Hands remaining when triggered",
            quote("quilla"),
            quote("quilla2"),
            credit("Scraptake")
        }
    },
    config = { extra = { state = 1, ctr = 0 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {"{999}"}}
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

        if context.joker_main then
            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left * 2
            return {hyper_mult = {999, G.GAME.blind.chips + G.GAME.chips}, hyper_chips = {999, G.GAME.blind.chips + G.GAME.chips}}

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