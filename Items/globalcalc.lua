vallkarri.calculate = function(self, context)
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
end
