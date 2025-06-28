SMODS.Joker {
    bases = {"j_obelisk"},
    key = "tau_obelisk",
    loc_txt = {
        name = "{C:cry_ember}Tauic Obelisk{}",
        text = {
            "Gains {X:dark_edition,C:white}^#1#{} Mult per scored card if",
            "played hand is not your most played {C:attention}poker hand{}",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
            credit("Scraptake")
        }
    },
    config = { extra = { gain = 0.2, current = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.current}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if (context.before) then
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.gain
                end
            end

        end

        if (context.joker_main) then
            return {emult = card.ability.extra.current}
        end

    end
}

