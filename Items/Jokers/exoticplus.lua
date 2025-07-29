SMODS.Joker {
    key = "vallkarrilua",
    loc_txt = {
        name = "{C:valk_blue}Vall-Karri.lua",
        text = {
            "{X:dark_edition,C:white}^^#1#{} Mult for every piece of content that {B:1,E:2,C:white}Vall-karri{} adds",
            "{C:inactive}(Currently {X:dark_edition,C:white}^^#2#{C:inactive} Mult){}",
            quote("valklua"),
            credit("Grahkon"),
        }
    },
    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local total = valk_additions()

        

        return {vars = {card.ability.extra.mult, total*card.ability.extra.mult, colours = {HEX("e5bf3a")}}  }
    end,
    rarity = "valk_prestigious",
    atlas = "main",
    pos = {x = 8, y = 11},
    soul_pos = {extra = {x=9, y=11}, x=10, y=11},
    cost = 500,
    immutable = true,
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
            "Increase operator by {C:attention}1{} for each copy of this card owned",
            quote("phicer"),
            credit("Nerxiana"),
        }
    },
    config = { extra = { nchips = 2 } },
    loc_vars = function(self, info_queue, card)

        
        local op = 1+(#SMODS.find_card("j_valk_phicer"))
        return {vars = {"{"..op.."}", card.ability.extra.nchips}}
    end,
    rarity = "valk_prestigious",
    atlas = "main",
    pos = {x = 2, y = 13},
    soul_pos = {x = 3, y = 13},
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then
            return {
                hyper_chips = {1+(#SMODS.find_card("j_valk_phicer")), card.ability.extra.nchips}
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
                "When {C:attention}Blind{} selected, create {C:attention}#1#{} {C:dark_edition}Negative{} {C:colourcard}Colour{} cards",
                "All {C:colourcard}Colour{} cards gain {C:attention}+#2#{} rounds when {C:attention}3{} scored",
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
                    colour_end_of_round_effects()
                    
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
            "Lose all money when hand played",
            "Earn {C:money}Log1.1(Overscore){} dollars at end of round",
            "{C:inactive}(Capped at blind size){}",
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
        if context.before then
            ease_dollars(-G.GAME.dollars)
        end
    end,

    calc_dollar_bonus = function(self, card)
        return math.min(math.log(G.GAME.chips - G.GAME.blind.chips, 1.1), G.GAME.blind.chips)
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
    config = { extra = { max = 10, exponent = 5 } },
    loc_vars = function(self, info_queue, card)
        local ratio = ratiocalc(vallkarri.librat_vals.blue, vallkarri.librat_vals.red, card.ability.extra.exponent, card.ability.extra.max)
        ratio = math.ceil(ratio)
        return {vars = {"{" .. ratio .. "}", (vallkarri.librat_vals.blue + vallkarri.librat_vals.red), } }
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
                math.ceil(ratiocalc(vallkarri.librat_vals.blue, vallkarri.librat_vals.red, card.ability.extra.exponent, card.ability.extra.max)),
                (vallkarri.librat_vals.blue + vallkarri.librat_vals.red)
            }
            return {
                hyper_mult = v,
                hyper_chips = v,
            }
        end
    end
}

-- SMODS.Joker {
quilla = {
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