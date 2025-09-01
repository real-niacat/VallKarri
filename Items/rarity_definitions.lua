SMODS.Rarity {
    key = 'prestigious',
    loc_txt = {
        name = 'Prestigious'
    },
    badge_colour = G.C.VALK_PRESTIGIOUS,
    pools = { ["Joker"] = false },
}

SMODS.Rarity {
    key = 'renowned',
    loc_txt = {
        name = 'Renowned'
    },
    badge_colour = G.C.VALK_RENOWNED,
    pools = { ["Joker"] = true },
    default_weight = 0.04,
    --approx 3x more common than a cryptid epic joker
}

SMODS.Rarity {
    key = 'exquisite',
    loc_txt = {
        name = 'Exquisite'
    },
    badge_colour = G.C.VALK_EXQUISITE,
    pools = { ["Joker"] = false },
}

SMODS.Rarity {
    key = 'tauic',
    loc_txt = {
        name = 'Tauic'
    },
    badge_colour = HEX("B080FF"),
    pools = { ["Joker"] = false },
}

SMODS.Rarity {
    key = 'supercursed',
    loc_txt = {
        name = 'SUPERCURSED'
    },
    badge_colour = HEX("000000"),
    
    pools = { ["Joker"] = false },
}