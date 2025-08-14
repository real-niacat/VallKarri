vallkarri.calculate = function(self, context)
    -- print("we originalled")
    G.GAME.joker_retrigger_bulk = G.GAME.joker_retrigger_bulk or 1
    G.GAME.card_retrigger_bulk = G.GAME.card_retrigger_bulk or 1  
    if context.retrigger_joker_check and G.GAME.joker_retriggers and G.GAME.joker_retriggers >= G.GAME.joker_retrigger_bulk then
        G.GAME.joker_retriggers = G.GAME.joker_retriggers - G.GAME.joker_retrigger_bulk
        return {
            repetitions = G.GAME.joker_retrigger_bulk,
            card = context.other_card
        }
    end

    if context.repetition and context.cardarea == G.play and G.GAME.card_retriggers and G.GAME.card_retriggers >= G.GAME.card_retrigger_bulk then
        G.GAME.card_retriggers = G.GAME.card_retriggers - G.GAME.card_retrigger_bulk
        return {
            repetitions = G.GAME.card_retrigger_bulk,
            card = context.other_card
        }
    end
    --ideally shouldnt affect anything else

    -- HAND BUFF CODE BELOW:
    if not vallkarri.add_hand_buff then
        return
    end


    if context.final_scoring_step and next(G.GAME.applied_buffs) then

        local effects = {}

        for _,buff in ipairs(G.GAME.applied_buffs) do
            effects = SMODS.merge_effects({effects, vallkarri.hand_buff_functions[buff.key](buff.power, G.play.cards) or {}})
        end

        return effects

    end
end
