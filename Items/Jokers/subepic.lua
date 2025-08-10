--COMMON BELOW
SMODS.Joker {
    key = "suckit",
    loc_txt = {
        name = "{C:red}Suck It{}",
        text = {
            "Creates itself when removed",
            "{C:inactive}Suck it.{}",
            credit("Lily")
        }
    },
    config = { extra = {} },
    rarity = 1,
    atlas = "main",
    pos = { x = 4, y = 5 },
    cost = 0,
    pools = { ["Meme"] = true },

    remove_from_deck = function(self, card, from_debuff)
        -- simple_create("Joker", G.jokers, "j_valk_suckit")
        if G.jokers and #SMODS.find_card("j_valk_suckit") <= 0 then
            local new = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_valk_suckit", "suckit")
            new.sell_cost = 0
            new:add_to_deck()
            G.jokers:emplace(new)
        end
    end
}

SMODS.Joker {
    key = "antithesis",
    loc_txt = {
        name = "Antithesis",
        text = {
            "{C:mult}+#1#{} Mult for every {C:attention}unscoring{} card",
            credit("mailingway")
        }
    },
    config = { extra = { per = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "main",
    pos = { x = 10, y = 5 },
    cost = 5,
    blueprintcompat = true,


    calculate = function(self, card, context)
        if context.joker_main then
            local amount = (#context.full_hand - #context.scoring_hand)
            return { mult = card.ability.extra.per * amount }
        end
    end,

}


--UNCOMMON BELOW
SMODS.Joker {
    key = "whereclick",
    loc_txt = {
        name = "{C:red}Where do I click?{}",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when mouse clicked",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
            "{C:inactive}Where do I click, Drago?{}",
            credit("Lily")
        }
    },
    config = { extra = { cur = 0.99, gain = 1e-3 } },
    rarity = 2,
    atlas = "main",
    pos = { x = 4, y = 6 },
    cost = 6,
    pools = { ["Meme"] = true },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,

    calculate = function(self, card, context)
        if context.cry_press then
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
        end

        if context.joker_main or context.forcetrigger then
            return { x_mult = card.ability.extra.cur }
        end
    end
}

SMODS.Joker {
    key = "streetlight",
    loc_txt = {
        name = "Streetlight",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when a {C:attention}Light{} card scores",
            "{C:attention}Light{} card requirement is capped at {C:attention}#3#{}",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
            credit("Scraptake")
        }
    },
    config = { extra = { cur = 1, gain = 0.2, cap = 5 } },
    rarity = 2,
    atlas = "main",
    pos = { x = 5, y = 8 },
    cost = 6,
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.cur, card.ability.extra.cap } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_cry_light") then
            context.other_card.ability.extra.req = math.min(card.ability.extra.cap, context.other_card.ability.extra.req) --cap at 5
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            quick_card_speak(card, "Upgraded!")
        end

        if context.joker_main then
            return { xmult = card.ability.extra.cur }
        end
    end,
    in_pool = function()
        for i, card in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(card, "m_cry_light") then
                return true
            end
        end
        return false
    end

}

SMODS.Joker {
    key = "bags",
    loc_txt = {
        name = "Bags",
        text = {
            "{C:chips}+#1#{} chips",
            "Increases by {C:attention}#2#{} at end of round",
            "Scales {C:dark_edition,E:1}quadratically{}",
            credit("Scraptake")
        }
    },
    config = { extra = { curchips = 1, inc = 1, incsq = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.curchips, card.ability.extra.inc } }
    end,
    rarity = 2,
    atlas = "main",
    pos = { x = 5, y = 2 },
    soul_pos = { x = 6, y = 2 },
    cost = 4,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.joker_main) or context.forcetrigger then
            return { chips = card.ability.extra.curchips }
        end

        if
            context.end_of_round
            and not context.blueprint
            and not context.individual
            and not context.repetition
            and not context.retrigger_joker
        then
            -- thank you smg9000..... :sob: i might be geeked
            -- i was really tired when i made this

            card.ability.extra.curchips = card.ability.extra.curchips + card.ability.extra.inc
            card.ability.extra.inc = card.ability.extra.inc + card.ability.extra.incsq
        end
    end
}

SMODS.Joker {
    key = "periapt_beer",
    loc_txt = {
        name = "Periapt Beer",
        text = {
            "Create a {C:tarot}Charm Tag{} and {C:attention}The Fool{} when sold",
            credit("Pangaea")
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        info_queue[#info_queue + 1] = G.P_TAGS.tag_charm
    end,
    atlas = "main",
    pos = { x = 5, y = 11 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_charm"))
            local fool = SMODS.create_card({ key = "c_fool" })
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
    eternal_compat = false,
}

SMODS.Joker {
    key = "stellar_yogurt",
    loc_txt = {
        name = "Stellar Yogurt",
        text = {
            "Create a {C:planet}Meteor Tag{} and {C:attention}The Fool{} when sold",
            credit("Pangaea")
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.c_fool
        info_queue[#info_queue + 1] = G.P_TAGS.tag_meteor
    end,
    atlas = "main",
    pos = { x = 6, y = 11 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_meteor"))
            local fool = SMODS.create_card({ key = "c_fool" })
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
    eternal_compat = false,
}

SMODS.Joker {
    key = "hexed_spirit",
    loc_txt = {
        name = "Hexed Spirit",
        text = {
            "Create two {C:spectral}Ethereal Tags{} when sold",
            credit("Pangaea")
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_TAGS.tag_ethereal
    end,
    atlas = "main",
    pos = { x = 7, y = 11 },
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_ethereal"))
            add_tag(Tag("tag_ethereal"))
        end
    end,
    eternal_compat = false,
}

SMODS.Joker {
    key = "amber",
    loc_txt = {
        name = "Amber",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:diamonds}Diamond{}",
            credit("mailingway")
        }
    },
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 10, y = 6 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Diamonds") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "blackjack",
    loc_txt = {
        name = "Blackjack",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:spades}Spade{}",
            credit("mailingway")
        }
    },
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 11, y = 6 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Spades") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "troupe",
    loc_txt = {
        name = "Troupe",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:spades}Club{}",
            credit("mailingway")
        }
    },
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 10, y = 7 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Clubs") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "valentine",
    loc_txt = {
        name = "Valentine",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:hearts}Heart{}",
            credit("mailingway")
        }
    },
    config = { extra = { per = 0.2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "main",
    pos = { x = 11, y = 7 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if pcard:is_suit("Hearts") then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    blueprint_compat = true,
}

SMODS.Joker {
    key = "utteredchaos",
    loc_txt = {
        name = "Uttered Chaos",
        text = {
            "{C:mult}+#1#{} Mult for every character in the",
            "most recent message sent in the {C:attention}Vallkarri{} discord server",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
            "{C:inactive,s:0.6,E:1}\"#3#\"",
            credit("mailingway")
        }
    },
    config = { extra = { per = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per, #vallkarri.last_message * card.ability.extra.per, vallkarri.last_message } }
    end,
    atlas = "main",
    pos = { x = 12, y = 5 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = (card.ability.extra.per * #vallkarri.last_message) }
        end
    end,

    update = function(self, card, dt)
        if card and card.children and math.random(1, 5) == 1 then
            card.children.center:set_sprite_pos({ x = math.random(12, 13), y = 5 })
        end
    end
}

SMODS.Joker {
    key = "planedolia",
    loc_txt = {
        name = "Planedolia",
        text = {
            "{C:planet}Planet{} cards have a {C:green}#1#%{} chance",
            "to replace any other spawned card",
            credit("triangle_snack")
        }
    },
    config = { extra = { chance = 15 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chance } }
    end,
    atlas = "main",
    pos = { x = 8, y = 12 },
    cost = 6,
    rarity = 2,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.planet_replace = G.GAME.planet_replace and (G.GAME.planet_replace + card.ability.extra.chance) or
        card.ability.extra.chance
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.planet_replace = G.GAME.planet_replace and (G.GAME.planet_replace - card.ability.extra.chance) or 0
    end,
}

SMODS.Joker {
    key = "tarodolia",
    loc_txt = {
        name = "Tarodolia",
        text = {
            "{C:tarot}Tarot{} cards have a {C:green}#1#%{} chance",
            "to replace any other spawned card",
            credit("triangle_snack")
        }
    },
    config = { extra = { chance = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chance } }
    end,
    atlas = "main",
    pos = { x = 10, y = 12 },
    cost = 6,
    rarity = 2,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.tarot_replace = G.GAME.tarot_replace and (G.GAME.tarot_replace + card.ability.extra.chance) or
        card.ability.extra.chance
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.tarot_replace = G.GAME.tarot_replace and (G.GAME.tarot_replace - card.ability.extra.chance) or 0
    end,
}

SMODS.Joker {
    key = "spectradolia",
    loc_txt = {
        name = "Spectradolia",
        text = {
            "{C:spectral}Spectral{} cards have a {C:green}#1#%{} chance",
            "to replace any other spawned card",
            credit("triangle_snack")
        }
    },
    config = { extra = { chance = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chance } }
    end,
    atlas = "main",
    pos = { x = 9, y = 12 },
    cost = 6,
    rarity = 2,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.spectral_replace = G.GAME.spectral_replace and (G.GAME.spectral_replace + card.ability.extra.chance) or
        card.ability.extra.chance
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.spectral_replace = G.GAME.spectral_replace and (G.GAME.spectral_replace - card.ability.extra.chance) or 0
    end,
}

--RARE BELOW

SMODS.Joker {
    key = "femtanyl",
    loc_txt = {
        name = "Femtanyl",
        text = {
            "Prevent death at the cost of {C:attention}#1#{} Joker slot",
            "Restore {C:attention}#1#{} taken joker slot when {C:attention}boss{} defeated on an odd ante",
            "{C:inactive}(Does not work below {C:attention}#2#{C:inactive} Joker slots)",
            quote("femtanyl"),
            credit("Scraptake")
        }
    },
    config = { extra = {cost = 1, req = 4, taken = 0} },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.cost, card.ability.extra.req} }
    end,
    pools = { ["Kitties"] = true },
    rarity = 3,
    atlas = "main",
    pos = { x = 0, y = 5 },
    soul_pos = { x = 1, y = 5 },
    cost = 6,
    immutable = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and G.jokers.config.card_limit >= card.ability.extra.req then
            G.jokers:change_size(-card.ability.extra.cost)
            card.ability.extra.taken = card.ability.extra.taken + card.ability.extra.cost
            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        elseif context.end_of_round and not context.game_over and G.GAME.blind.boss and (G.GAME.round_resets.ante % 2 == 1) and card.ability.extra.taken > 0 then
            G.jokers:change_size(card.ability.extra.cost)
            card.ability.extra.taken = card.ability.extra.taken - card.ability.extra.cost
        end
    end
}

SMODS.Joker {
    key = "planetarium",
    loc_txt = {
        name = "Planetarium",
        text = {
            "When {C:attention}hand{} played, increase {C:chips}chips{} and {C:mult}mult{} per level",
            "of played {C:attention}poker hand{} by {C:attention}#1#{}",
            credit("Grahkon")
        }
    },
    config = { extra = { inc = 1 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.inc
            }
        }
    end,
    atlas = "main",
    pos = { x = 10, y = 4 },
    cost = 7,
    rarity = 3,
    calculate = function(self, card, context)
        if context.before then
            quick_card_speak(card, localize("k_upgrade_ex"))
            local text = G.FUNCS.get_poker_hand_info(context.full_hand)
            G.GAME.hands[text].l_chips = G.GAME.hands[text].l_chips + card.ability.extra.inc
            G.GAME.hands[text].l_mult = G.GAME.hands[text].l_mult + card.ability.extra.inc
        end
    end,
}

SMODS.Joker {
    key = "matchbox",
    loc_txt = {
        name = "Matchbox",
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult per",
            "{C:attention}consecutive{} hand played larger than blind size",
            "{C:inactive}(Does not reset on Boss Blinds){}",
            "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult){}",

            credit("Scraptake")
        }
    },
    config = { extra = { cur = 1, gain = 0.3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 4, y = 13 },
    cost = 8,
    blueprintcompat = true,


    calculate = function(self, card, context)
        -- is a little fucked with The Tax boss blind but idk how to fix, help
        if context.after then
            if hand_chips * mult > G.GAME.blind.chips then
                card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
                quick_card_speak(card, "Upgraded!")
            else
                if not G.GAME.blind.boss then
                    card.ability.extra.cur = 1
                    quick_card_speak(card, "Reset!")
                end
            end
        end

        if context.joker_main or context.forcetrigger then
            return { xmult = card.ability.extra.cur }
        end
    end,

}

SMODS.Joker {
    key = "leopard_print",
    loc_txt = {
        name = "Leopard Print",
        text = {
            "Retrigger all {C:attention}Kitty{} Jokers once",
            "for each {C:attention}Kitty{} Joker owned",
            credit("mailingway")
        }
    },
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 12, y = 4 },
    cost = 8,
    blueprintcompat = true,
    pools = { ["Kitties"] = true },

    calculate = function(self, card, context)
        if context.retrigger_joker_check and Cryptid.safe_get(context.other_card.config.center, "pools", "Kitties") then
            local count = 0
            for _, joker in ipairs(G.jokers.cards) do
                if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                    count = count + 1
                end
            end

            return {
                repetitions = count
            }
        end
    end,
    in_pool = function(self, args)
        for i, joker in ipairs(G.jokers.cards) do
            if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                return true
            end
        end
        return false
    end,

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
    config = { extra = { money = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    rarity = 3,
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
    key = "familiarface",
    loc_txt = {
        name = "Familiar Face",
        text = {
            "Scored {C:attention}9s{} give {X:mult,C:white}X#1#{} Mult",
            "Scored {C:attention}Light{} cards give {X:chips,C:white}X#2#{} Chips",
            "{C:inactive,s:0.7}hm, where have i seen this face before?",
            credit("aduckted")
        }
    },
    config = { extra = { xmult = 1.09, xchips = 2.9 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_cry_light
        return { vars = { card.ability.extra.xmult, card.ability.extra.xchips } }
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=11, y=8},
    cost = 15,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then

            local returntable = {}
            if SMODS.has_enhancement(context.other_card, "m_cry_light") then
                returntable.xchips = card.ability.extra.xchips
            end
            if context.other_card:get_id() == 9 then
                returntable.xmult = card.ability.extra.xmult
            end

            return returntable

        end
    end
}

-- {x=10, y=8}