SMODS.Sticker {
    key = "melting",
    loc_txt = {
        name = "Melting",
        text = {
            "Loses all enhancements and editions",
            "every {C:attention}#1#{} {C:inactive}[#2#]{} times scored",
        }
    },
    rate = 0.1,
    needs_enabled_flag = true,
    config = {max = 5, left = 5},
    calculate = function(self, card, context)
        if context.main_scoring then
            card.ability[self.key].left = card.ability[self.key].left - 1
            if card.ability[self.key].left <= 0 then
                card.ability[self.key].left = card.ability[self.key].max
                card:set_edition(nil, true)
                if card.ability.set ~= "Joker" then
                    card:set_ability("c_base")
                end
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.ability.valk_melting.max or self.config.max, card and card.ability.valk_melting.left or self.config.left } }
    end,
}