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
    pos = {x=4, y=5},
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
    config = { extra = {cur = 0.99, gain = 1e-3} },
    rarity = 2,
    atlas = "main",
    pos = {x=4, y=6},
    cost = 6,
    pools = { ["Meme"] = true },
    demicoloncompat = true,
    loc_vars = function(self,info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.cur}}
    end,

    calculate = function(self, card, context)
        if context.cry_press then
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
        end

        if context.joker_main or context.forcetrigger then
            return {x_mult = card.ability.extra.cur}
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
    config = { extra = {cur = 1, gain = 0.2, cap = 5} },
    rarity = 2,
    atlas = "main",
    pos = {x=5, y=8},
    cost = 6,
    demicoloncompat = true,
    loc_vars = function(self,info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.cur, card.ability.extra.cap}}
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_cry_light") then
            context.other_card.ability.extra.req = math.min(card.ability.extra.cap, context.other_card.ability.extra.req) --cap at 5
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            quick_card_speak(card, "Upgraded!")

        end

        if context.joker_main then
            return {xmult = card.ability.extra.cur}
        end
    end,
    in_pool = function()
        for i,card in ipairs(G.playing_cards) do
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
    config = { extra = { curchips = 1, inc = 1, incsq = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.curchips, card.ability.extra.inc} }
    end,
    rarity = 2,
    atlas = "main",
    pos = {x=5, y=2},
    soul_pos = {x=6, y=2},
    cost = 4,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.joker_main) or context.forcetrigger then
            return {chips = card.ability.extra.curchips}
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
    key = "femtanyl",
    loc_txt = {
        name = "Femtanyl",
        text = {
            "Prevents death at the cost of {C:attention}#1#{} Joker slot",
            "Return lost Joker slot after {C:attention}#2#{} round(s)",
            "Increase round timer by {C:attention}#3#{} and earn {C:money}$#4#{} when death is prevented",
            "{C:inactive}Dying again or removing this Joker while the timer {}",
            "{C:inactive}is active will result in not recovering a Joker slot{}",
            "{C:inactive}(Does not work below 3 Joker slots){}",
            
            quote("femtanyl"),
            credit("Scraptake")
        }
    },
    config = { extra = { cost = 1, increase = 1, timer = 0, timerbase = 2, money = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.cost, card.ability.extra.timerbase, card.ability.extra.increase, card.ability.extra.money}}
    end,
    pools = { ["Kitties"] = true },
    rarity = 3,
    atlas = "main",
    pos = {x=0, y=5},
    soul_pos = {x=1, y=5},
    cost = 6,
    calculate = function(self, card, context)

        if (context.end_of_round and not context.blueprint and not context.individual) then
            card.ability.extra.timer = card.ability.extra.timer - 1

            if (card.ability.extra.timer == 0) then
                G.jokers:change_size(card.ability.extra.cost, false)
            end
        end

        if (context.end_of_round and not context.blueprint and context.game_over) then

            local slots = G.jokers.config.card_limit - card.ability.extra.cost
            G.jokers:change_size(-card.ability.extra.cost, false)
            card.ability.extra.timer = card.ability.extra.timerbase
            card.ability.extra.timerbase = card.ability.extra.timerbase + card.ability.extra.increase
            

            if (slots >= 3) then
                ease_dollars(card.ability.extra.money)
                return {saved = true}
            end

        end

        
    end
}

SMODS.Joker {
    key = "keystonefragment",
    loc_txt = {
        name = "{C:money}Key{C:red}stone {C:money}Frag{C:red}ment",
        text = {
            "Channels the power from the {C:edition,X:dark_edition}Infinite{}",
            "Does nothing, it is better used {C:edition,X:dark_edition}elsewhere...{}",
            credit("Lily")
        }
    },
    config = { extra = {  } },
    rarity = "valk_equip",
    atlas = "main",
    pos = {x=4,y=2},
    soul_pos = {x=2,y=2}, --halo
    cost = 66,

    in_pool = function()
        return (#SMODS.find_card("j_valk_dormantlordess") > 0)
    end
}
-- watcher does NOT always look stupid 

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
        info_queue[#info_queue+1] = G.P_CENTERS.c_fool
        info_queue[#info_queue+1] = G.P_TAGS.tag_charm
    end,
    atlas = "main",
    pos = {x = 5, y = 11},
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_charm"))
            local fool = SMODS.create_card({key = "c_fool"})
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
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
        info_queue[#info_queue+1] = G.P_CENTERS.c_fool
        info_queue[#info_queue+1] = G.P_TAGS.tag_meteor
    end,
    atlas = "main",
    pos = {x = 6, y = 11},
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_meteor"))
            local fool = SMODS.create_card({key = "c_fool"})
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end
    end,
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
        info_queue[#info_queue+1] = G.P_TAGS.tag_ethereal
    end,
    atlas = "main",
    pos = {x = 7, y = 11},
    cost = 6,
    rarity = 2,
    calculate = function(self, card, context)
        if context.selling_self then
            add_tag(Tag("tag_ethereal"))
            add_tag(Tag("tag_ethereal"))
        end
    end,
}

SMODS.Joker {
    key = "planetarium",
    loc_txt = {
        name = "Planetarium",
        text = {
            "When {C:attention}hand{} played, increase {C:chips}chips{} and {C:mult}mult{} per level",
            "of played {C:attention}poker hand{} by {C:attention}#1#{}",
            credit("Pangaea")
        }
    },
    config = { extra = { inc = 1 }},
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.inc
        }}
    end,
    atlas = "phold",
    pos = {x = 0, y = 1},
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
    config = { extra = {cur = 1, gain = 0.3} },
    loc_vars = function(self,info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.cur}}
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=4, y=13},
    cost = 8,
    blueprintcompat = true,


    calculate = function(self, card, context)
 
        -- is a little fucked with The Tax boss blind but idk how to fix, help
        if context.final_scoring_step then     
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
            return {xmult = card.ability.extra.cur}
        end

    end,

}
