SMODS.Joker {
    key = "tau_canio",
    loc_txt = {
        name = "{C:valk_fire}Tauic Canio{}",
        text = {
            "{X:dark_edition,C:white}+^^#1#{} Mult when any card destroyed",
            "{C:inactive}Currently {X:dark_edition,C:white}^^#2#{C:inactive} Mult){}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { gain = 0.2, cur = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=3, y=9, extra = {x=3, y=8}},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.remove_playing_cards and not context.blueprint then

            card.ability.extra.cur = card.ability.extra.cur + (card.ability.extra.gain * #context.removed)

        end

        if (context.joker_main) then
            return {ee_mult = card.ability.extra.cur}
        end

    end,
    dependencies = {"Talisman"},
    is_tau = true,
}

SMODS.Joker {
    key = "tau_triboulet",
    loc_txt = {
        name = "{C:valk_fire}Tauic Triboulet{}",
        text = {
            "{X:dark_edition,C:white}^^#1#{} Mult when any face card or Ace is scored",
            "Increases by {X:dark_edition,C:white}+^^#2#{} when any face card or Ace is scored",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { gain = 0.05, cur = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cur, card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=9, extra = {x=4, y=8}},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if (context.individual and context.cardarea == G.play and context.other_card:get_id() >= 11) then

            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            return {eemult = card.ability.extra.cur}

        end

    end,
    dependencies = {"Talisman"},
    is_tau = true,
}

SMODS.Joker {
    key = "tau_yorick",
    loc_txt = {
        name = "{C:valk_fire}Tauic Yorick{}",
        text = {
            "{X:dark_edition,C:white}^^#1#{} Mult",
            "Increases by {X:dark_edition,C:white}+^#2#{} when any card discarded",
            "Scales {C:dark_edition,E:1}Quadratically{}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { gainsq = 0.01, gain = 0.01, cur = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cur, card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=9, extra = {x=5, y=8}},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        
        if (context.discard) then

            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            card.ability.extra.gain = card.ability.extra.gain + card.ability.extra.gainsq

        end

        if (context.joker_main) then
            return {eemult = card.ability.extra.cur}
        end

    end,
    dependencies = {"Talisman"},
    is_tau = true,
}

SMODS.Joker {
    key = "tau_chicot",
    loc_txt = {
        name = "{C:valk_fire}Tauic Chicot{}",
        text = {
            "Disables effect of every {C:attention}Boss Blind{}",
            "{X:dark_edition,C:white}^^(1 / #1#){} blind size",
            "{C:attention}+#2#{} to denominator when {C:attention}blind{} selected",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { antitetration = 50, inc = 10} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.antitetration, card.ability.extra.inc } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=9, extra = {x=6, y=8}},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        

        if context.setting_blind then
            card.ability.extra.antitetration = card.ability.extra.antitetration + card.ability.extra.inc

            if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                G.GAME.blind:disable()
                play_sound('timpani')
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            end

            G.GAME.blind.chips = to_big(G.GAME.blind.chips):tetrate(1 / card.ability.extra.antitetration)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.HUD_blind:recalculate()

        end

    end,
    dependencies = {"Talisman"},
    is_tau = true,
}

SMODS.Joker {
    key = "tau_perkeo",
    loc_txt = {
        name = "{C:valk_fire}Tauic Perkeo{}",
        text = {
            "Create {C:attention}#1#{} {C:dark_edition}Negative{} copies of the leftmost consumable when exiting shop",
            "{C:green}#2# in #3#{} chance to make a copy of all used {C:attention}Consumables{}",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { copies = 2, num = 1, den = 4 } },
    loc_vars = function(self, info_queue, card)
        local num,den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den)
        return { vars = { card.ability.extra.copies, num,den } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=9, extra = {x=7, y=8}},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    immutable = true,
    calculate = function(self, card, context)
        

        if context.ending_shop then
            
            
            if (#G.consumeables.cards > 0) then

                for i=1,card.ability.extra.copies do
                    local copy = copy_card(G.consumeables.cards[1])
                    copy:set_edition("e_negative", true)
                    G.consumeables:emplace(copy)
                end

            end
            

        end

        if context.using_consumeable and SMODS.pseudorandom_probability(card, "valk_tau_perkeo", card.ability.extra.num, card.ability.extra.den) then
            SMODS.add_card({key = context.consumeable.config.center_key, edition = context.consumeable.edition and context.consumeable.edition.key})
        end

    end,
    dependencies = {"Talisman"},
    is_tau = true,
}