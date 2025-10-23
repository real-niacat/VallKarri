SMODS.ObjectType({
    object_type = "ObjectType",
    key = "aesthetijoker",
    cards = {},
    inject = function(self)
        SMODS.ObjectType.inject(self)
    end,
})

SMODS.Joker {
    key = "analog",
    loc_txt = {
        name = "The Analog",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Noisy{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Noisy{} Jokers additionally give {C:attention}Random Buffs{} when triggered",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_cry_noisy", cap = 50 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 4, y = 0 },
    soul_pos = { x = 4, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                chips = pseudorandom("valk_analog_chips", 1, card.ability.extra.cap),
                mult = pseudorandom("valk_analog_mult", 1, card.ability.extra.cap),
                xchips = pseudorandom("valk_analog_xchips", 1, card.ability.extra.cap ^ 0.5),
                xmult = pseudorandom("valk_analog_xmult", 1, card.ability.extra.cap ^ 0.5),
            }
        end

    end,
    dependencies = {"Cryptid"}

}

SMODS.Joker {
    key = "arkade",
    loc_txt = {
        name = "Arkade",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Glow-in-the-Dark{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Glow-in-the-Dark{} Jokers are retriggered {C:attention}twice{}",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_valk_glow" } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 5, y = 0 },
    soul_pos = { x = 5, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.retrigger_joker_check and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                repetitions = 2
            }
        end

    end,

}

SMODS.Joker {
    key = "chrome",
    loc_txt = {
        name = "Chrome",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Polychrome{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Polychrome{} Jokers are retriggered {C:attention}once{} and",
            "give an additional {X:mult,C:white}X#1#{} Mult",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_polychrome", xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 6, y = 0 },
    soul_pos = { x = 6, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.retrigger_joker_check and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                repetitions = 1
            }
        end
    end,

}

SMODS.Joker {
    key = "frutiger",
    loc_txt = {
        name = "Frutiger",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Foil{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Foil{} Jokers additionally give {X:chips,C:white}X#1#{} Chips",
            "when triggered, and cannot be {C:red}debuffed{}",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_foil", xchips = 1.25 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = { card.ability.extra.xchips } }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 7, y = 0 },
    soul_pos = { x = 7, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                xchips = card.ability.extra.xchips
            }
        end

    end,

}

SMODS.Joker {
    key = "synth",
    loc_txt = {
        name = "Synth",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Holographic{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Holographic{} Jokers additionally give {X:mult,C:white}X#1#{} Mult",
            "when triggered",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_holo", xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 8, y = 0 },
    soul_pos = { x = 8, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

}





SMODS.Joker {
    key = "vapor",
    loc_txt = {
        name = "Vapor",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Negative{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Negative{} Jokers additionally give {X:dark_edition,C:white}X#1#{}",
            "Blind Size when triggered",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_negative", blind_size = 0.9 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = {card.ability.extra.blind_size} }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 9, y = 0 },
    soul_pos = { x = 9, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("timpani")
                    G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.blind_size
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    G.HUD_blind:recalculate()
                    G.hand_text_area.blind_chips:juice_up()
                    context.other_card:juice_up()
                    return true
                end
            }))
        end
    end,

}

SMODS.Joker {
    key = "scene",
    loc_txt = {
        name = "Scene",
        text = {
            "Adjacent Jokers are given {C:dark_edition}R.G.B.{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}R.G.B.{} Jokers additionally give {X:dark_edition,C:white}^#1#{}",
            "Mult when triggered",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_valk_rgb", expo = 1.1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = {card.ability.extra.expo} }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 10, y = 0 },
    soul_pos = { x = 10, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                emult = card.ability.extra.expo
            }
        end
    end,

}

SMODS.Joker {
    key = "what_am_i_supposed_to_put_here",
    loc_txt = {
        name = "{E:valk_censor}hi everypony{}",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Glitched{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Glitched{} Jokers have their values",
            "multiplied between {C:attention}X#1#{} and {C:attention}X#2#{} when triggered",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_cry_glitched", min = 0.9, max = 1.2 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = {card.ability.extra.min, card.ability.extra.max} }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 11, y = 0 },
    soul_pos = { x = 11, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            local rnd = card.ability.extra.min + (pseudorandom("valk_glitched") * (card.ability.extra.max - card.ability.extra.min))
            Cryptid.manipulate(context.other_card, {value = rnd})
        end
    end,
    dependencies = {"Cryptid"}
}

SMODS.Joker {
    key = "memphis",
    loc_txt = {
        name = "Memphis",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Cosmic{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}R.G.B.{} Jokers additionally give {X:dark_edition,C:white}^#1#{}",
            "Chips when triggered",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    config = { extra = { edition = "e_valk_rgb", expo = 1.1 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = {card.ability.extra.expo} }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 12, y = 0 },
    soul_pos = { x = 12, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                echips = card.ability.extra.expo
            }
        end
    end,

}