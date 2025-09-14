SMODS.Joker {
    key = "whereclick",
    loc_txt = {
        name = "{C:red}Where do I click?{}",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when a card is sold",
            "Loses {X:mult,C:white}X#2#{} Mult when a {C:attention}Consumable{} is used",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult){}",
            "{C:inactive}Where do I click, Drago?{}",
            credit("Lily Felli")
        }
    },
    config = { extra = { cur = 1, gain = 0.2, loss = -0.1 } },
    rarity = 2,
    atlas = "main",
    pos = { x = 4, y = 6 },
    cost = 6,
    pools = { ["Meme"] = true },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, -card.ability.extra.loss, card.ability.extra.cur } }
    end,

    calculate = function(self, card, context)
        if context.using_consumeable then --fucking whatever
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "cur", scalar_value = "loss"})
        end

        if context.selling_card then
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "cur", scalar_value = "gain"})
        end

        if context.joker_main or context.forcetrigger then
            return { xmult = card.ability.extra.cur }
        end
    end
}

SMODS.Joker {
    key = "streetlight",
    loc_txt = {
        name = "Streetlight",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when a {C:attention}Mirrored{} card scores",
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
        info_queue[#info_queue+1] = G.P_CENTERS.m_valk_mirrored
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_valk_mirrored") then
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            quick_card_speak(card, "Upgraded!")
        end

        if context.joker_main then
            return { xmult = card.ability.extra.cur }
        end
    end,
    in_pool = function()
        for i, card in ipairs(G.playing_cards) do
            if SMODS.has_enhancement(card, "m_valk_mirrored") then
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
    key = "rocky",
    loc_txt = {
        name = "Rocky",
        text = {
            "{X:mult,C:white}X#1#{} Mult for each scoring {C:attention}Suitless{} card",
            credit("lord.ruby")
        }
    },
    config = { extra = { per = 0.4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    atlas = "atlas2",
    pos = { x = 1, y = 2 },
    cost = 6,
    rarity = 2,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.joker_main then
            local amount = 0
            for i, pcard in ipairs(context.scoring_hand) do
                if Entropy.true_suitless(pcard) then
                    amount = amount + 1
                end
            end
            return { xmult = 1 + (card.ability.extra.per * amount) }
        end
    end,
    in_pool = function(self, args)
        for i,card in ipairs(G.playing_cards) do
            if Entropy.true_suitless(card) then
                return true
            end
        end
        return false
    end,
    blueprint_compat = true,
    dependencies = {"entr"}
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
    blueprint_compat = true,
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

SMODS.Joker {
    key = "merchantcat",
    rarity = 2,
    atlas = "atlas2",
    pos = { x = 3, y = 1 },
    cost = 8,
    loc_txt = {
        name = "Merchant Cat",
        text = {
            "Create a {C:attention}Kitty Tag{} when a card is bought",
            credit("Lil Mr. Slipstream"),
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    demicoloncompat = true,
    config = { extra = {} },
    calculate = function(self, card, context)
        if context.buying_card then
            add_tag(Tag("tag_valk_kitty"))
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "roundabout",
    rarity = 2,
    atlas = "main",
    pos = { x = 12, y = 8 },
    cost = 8,
    loc_txt = {
        name = "Roundabout",
        text = {
            "{C:attention}-#1#{} to the next change in ante",
            "{C:red,E:1}Self-destructs{}",
            credit("mailingway"),
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.change } }
    end,
    demicoloncompat = true,
    config = { extra = { change = 1 } },
    calculate = function(self, card, context)
        if context.modify_ante then
            card:start_dissolve({ G.C.BLACK }, false)
            return { modify = -card.ability.extra.change }
        end
    end,

}

SMODS.Joker {
    key = "chipless_cookie",
    rarity = 2,
    atlas = "main",
    pos = { x = 13, y = 7 },
    cost = 8,
    loc_txt = {
        name = "Chipless Cookie",
        text = {
            "{C:attention}+#1#{} Joker Slots",
            "{C:red,E:1}Self-destructs{} if played hand is not",
            "most played {C:attention}Poker Hand{}",
            "{C:inactive}(Currently #2#)",
            credit("mailingway"),
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, vallkarri.get_most_played_hand() } }
    end,
    config = { extra = { slots = 2 } },
    calculate = function(self, card, context)
        if context.before then
            if not (context.scoring_name == vallkarri.get_most_played_hand()) then
                card:start_dissolve({G.C.RED})
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        G.jokers:change_size(card.ability.extra.slots)
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.jokers:change_size(-card.ability.extra.slots)
    end,

}
