SMODS.Joker {
    key = "bags",
    loc_txt = {
        name = "Bags",
        text = {
            "{C:chips}+#1#{} chips",
            "Increases by {C:attention}#2#{} at end of round",
            "Increases the increase by {C:attention}#3#{} at end of round."
        }
    },
    config = { extra = { curchips = 1, inc = 1, incsq = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.curchips, card.ability.extra.inc, card.ability.extra.incsq } }
    end,
    rarity = 2,
    atlas = "main",
    pos = {x=0, y=9},
    soul_pos = {x=6, y=2},
    cost = 4,
    calculate = function(self, card, context)
        if (context.joker_main) then
            return {chips = card.ability.extra.curchips}
        end

        if (context.end_of_round and not context.blueprint) then

            card.ability.extra.curchips = card.ability.extra.curchips + card.ability.extra.inc
            card.ability.extra.inc = card.ability.extra.inc + card.ability.extra.incsq
        end
    end
}