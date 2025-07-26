if #SMODS.find_mod("entr") > 0 then
    SMODS.Consumable {
        set = "Superplanet",
        key = "lmcx",
        loc_txt = {
            name = "LMC X-1",
            text = {
                "Raise all hand levels to their respective {C:gold}Ascension Power{}",
                credit("mailingway"),
                concept("arris")
            }
        },

        no_doe = true,

        config = { extra = {  } },
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.eechips}}
        end,

        can_use = function(self, card)
            -- currently only returns true need to make it only work when u have the joker.
            return true
        end,

        use = function(self, card, area, copier)

            for i,hand in pairs(G.GAME.hands) do
                local lvl = G.GAME.hands[i].level
                local asc = G.GAME.hands[i].AscensionPower
                if asc and lvl >= 1 then
                    level_up_hand(card, i, false, (lvl^asc)-lvl)
                end
            end
        end,

            
        atlas = "csm",
        pos = {x=2, y=0},
        no_grc = true,
        no_doe = true,
    }

    SMODS.Consumable {
        set = "Superplanet",
        key = "neve",
        loc_txt = {
            name = "NeVe 1",
            text = {
                "Multiply {C:chips}chips{} and {C:mult}mult{} of all hands by a {C:attention}#1#{}",
                "{X:dark_edition,C:white}^^#2#{} {C:chips}chips{} and {C:mult}mult{} {C:attention}per level{} on all hands",
                "{X:gold,C:white}^#3#{} Ascension Power of all hands",
                credit("mailingway"),
                concept("arris")
            }
        },

        no_doe = true,

        config = { extra = { mult = 1000, tet = 1.2, exp = 1.5 } },
        loc_vars = function(self, info_queue, card)
            return {vars = {card.ability.extra.mult, card.ability.extra.tet, card.ability.extra.exp}}
        end,

        can_use = function(self, card)
            -- currently only returns true need to make it only work when u have the joker.
            return true
        end,

        use = function(self, card, area, copier)

            for i,hand in pairs(G.GAME.hands) do
                hand.mult = to_big(hand.mult):mul(card.ability.extra.mult)
                hand.chips = to_big(hand.chips):mul(card.ability.extra.mult)

                hand.l_chips = to_big(hand.l_chips):tetrate(card.ability.extra.tet):add(1)
                hand.l_mult = to_big(hand.l_mult):tetrate(card.ability.extra.tet):add(1)

                if (hand.AscensionPower) then
                    hand.AscensionPower = to_big(hand.AscensionPower):pow(card.ability.extra.exp)
                end
            end 
        end,

            
        atlas = "csm",
        pos = {x=5, y=0},
        no_grc = true,
        no_doe = true,
    }

    SMODS.Joker {
        key = "coronal",
        loc_txt = {
            name = "Coronal Ejection",
            text = {
                "{C:green}#1# in #2#{} chance to increase {C:gold}Ascension Power{} of played {C:attention}poker hand{} by {X:gold,C:white}+#3#{}",
                credit("mailingway")
            }
        },
        config = { extra = {num = 1, den = 10, power = 10 } },
        loc_vars = function(self, info_queue, card)
            local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'coronal')
            return {vars = { num, den, card.ability.extra.power} }
        end,
        rarity = 3,
        atlas = "main",
        pos = {x=4,y=14},
        cost = 8,
        demicoloncompat = true,
        blueprint_compat = true,

        calculate = function(self, card, context)
            if context.before then
                if SMODS.pseudorandom_probability(card, 'coronal', card.ability.extra.num, card.ability.extra.den, 'coronal') then
                    local text = G.FUNCS.get_poker_hand_info(context.full_hand)
                    G.GAME.hands[text].AscensionPower = (G.GAME.hands[text].AscensionPower and G.GAME.hands[text].AscensionPower+card.ability.extra.power) or card.ability.extra.power
                    quick_card_speak(card, "Upgraded!")
                end
            end 
        end,

    }

end

function vallkarri.add_merge(inputs, out)
    table:insert(merge_recipes, {input=inputs, output=out})
end 