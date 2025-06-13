SMODS.Rarity {
    key = 'selfinsert',
    loc_txt = {
        name = 'True Lordess of Chaos'
    },
    badge_colour = G.C.CRY_TWILIGHT,
    pools = { ["Joker"] = true },
}

SMODS.Rarity {
    key = 'quillagod',
    loc_txt = {
        name = 'Quilygean'
    },
    badge_colour = G.C.CRY_DAWN,
    pools = { ["Joker"] = true },
}

SMODS.Rarity {
    key = 'unobtainable',
    loc_txt = {
        name = 'U N O B T A I N A B L E'
    },
    badge_colour = HEX("CE3EA3"),
    pools = { ["Joker"] = true },
}

SMODS.Rarity {
    key = 'unsurpassed',
    loc_txt = {
        name = 'Unsurpassed'
    },
    badge_colour = HEX("C64CFF"),
    pools = { ["Joker"] = true },
}

SMODS.Rarity {
    key = 'tauic',
    loc_txt = {
        name = 'Tauic'
    },
    badge_colour = HEX("B080FF"),
    pools = { ["Joker"] = true },
}

SMODS.Rarity {
    key = 'supercursed',
    loc_txt = {
        name = 'SUPERCURSED'
    },
    badge_colour = HEX("000000"),
    
    pools = { ["Joker"] = true },
}

SMODS.Rarity {
    key = 'equip',
    loc_txt = {
        name = 'Her Lordship\'s Missing Piece'
    },
    badge_colour = HEX("EB4D4D"),
    pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		return 0.03
	end,
}