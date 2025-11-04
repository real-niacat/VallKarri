if not CardSleeves then
    return
end

SMODS.Atlas {
    key = "slev",
    path = "sleeves.png",
    px = 73,
    py = 95,}

CardSleeves.Sleeve {
    key = "s_encore",
    name = "Encore Sleeve",
    atlas = "slev",
    loc_txt = {
        name = "Encore Sleeve",
        text = {
            "After hand scores,",
            "all {C:attention}end-of-round{}",
            "effects are triggered",
        }
    },
    pos = { x = 0, y = 0 },
    unlocked = true,
    loc_vars = function(self, info_queue, card)
    end,
        calculate = function(center, back, context)

        if context.after then
            
            SMODS.calculate_context({end_of_round = true, main_eval = true})

        end

    end,
}

CardSleeves.Sleeve {
    key = "s_tauic",
    name = "Tauic Sleeve",
    atlas = "slev",
    config = {eeante = 1.5},
    loc_txt = {
        name = "Tauic Sleeve",
        text = {
            "{C:cry_ember}Tauic{} Jokers are {C:attention}exponentially{} more common",
            "{X:dark_edition,C:white}^#1#{} Effective Ante",
            -- "{C:attention}X3{} Blind Size",
        }
    },
    pos = { x = 1, y = 0 },
    unlocked = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.eeante
            }
        }
    end,
    apply = function(self, back)
        vallkarri.add_effective_ante_mod(self.config.eeante, "^")
    end,
    calculate = function(self, back, context)
        if context.valk_tau_probability_mod then
            return {
                denominator = context.denominator ^ 0.5
            }
        end
    end
}

if vallkarri.config.hand_buffs then
    CardSleeves.Sleeve {
    key = "s_handbuffdeck",
    loc_txt = {
        name = "Buffed Sleeve",
        text = {
            "All {C:attention}Hand Modifiers{} can be made with {C:attention}#1#{} cards",
            "{C:attention}#2#{} Hand Size",
        }
    },
    valk_artist = nil,
    config = { hand_size = -1, requirement = 2 },
    pos = { x = 2, y = 0 },
    atlas = "slev",
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.requirement, self.config.hand_size } }
    end,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.GAME.buff_power then
                    for key, _ in pairs(G.GAME.buff_power) do
                        G.GAME.buff_power[key] = (5 - self.config.requirement) + G.GAME.buff_power[key]
                    end
                    return true
                end
            end
        }))
    end
}
else
    return
end