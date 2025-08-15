SMODS.Scoring_Calculation {
    key = "or",
    func = function(self, chips, mult, flames)
        return math.min(chips,mult)
    end,
    colour = G.C.YELLOW,
    text = "OR"
}

SMODS.Scoring_Calculation {
    key = "and",
    func = function(self, chips, mult, flames)
        return to_big(tonumber(number_format(chips) .. number_format(mult)))
    end,
    colour = G.C.YELLOW,
    text = "AND"
}