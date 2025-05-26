SMODS.Seal {
    name = "chaos",
    key = "chaos",
    loc_txt = {
        name = "Chaos Seal",
        label = "Chaos Seal",
        text = {
            "Retrigger this card {C:attention}#1#{} times",
            "Increase by {C:attention}#2#{} every {C:attention}#3#{} {C:inactive}[#4#]{} cards scored"
        }
    },
    badge_colour = HEX("F8A12F"),

    sound = {sound = 'timpani', per = 1, vol = 1},
    config = {triggers = 1, inc = 1, req = 5, reset = 5},
    loc_vars = function(self, info_queue)
        return {vars = {self.config.triggers, self.config.inc, self.config.reset, self.config.req}}
    end,

    atlas = "chaos_seal",
    pos = {x=0, y=0},

    calculate = function(self, card, context)

    end

}

-- unfinished, not doing this rn