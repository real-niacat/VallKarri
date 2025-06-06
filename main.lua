if (not vallkarri) then
    vallkarri = {}
end

vallkarri = {
    show_options_button = true,
}

vallkarri = SMODS.current_mod
vallkarri_config = vallkarri.config
vallkarri.enabled = copy_table(vallkarri_config)

SMODS.Atlas {
    key = "main",
    path = "assets.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "tau",
    path = "tauics.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "phold",
    path = "placeholder.png",
    px = 71,
    py = 95,
}

maxArrow = 1e5
-- lovely patch is used if pwx is installed - as this should override since it's a larger limit anyway lol


merge_recipes = {

    {input = {"c_cry_gateway", "c_cry_pointer", "c_soul"}, output = "c_valk_lordcall"},
    {input = {"j_valk_dormantlordess", "j_valk_keystonefragment"}, output = "j_valk_lily"},
    -- {input = {"j_valk_keystonefragment", "c_cry_gateway", "c_cry_pointer", "c_soul", "j_valk_lily" }, output = "j_valk_quilla"},
    {input = {"c_valk_tauism", "c_soul", "c_wraith" }, output = "c_valk_absolutetau"}

}





SMODS.Rarity {
    key = 'selfinsert',
    loc_txt = {
        name = 'The Obligatory Self-Insert Overpowered Character'
    },
    badge_colour = G.C.CRY_TWILIGHT,
    pools = { ["Joker"] = true },
}

SMODS.Rarity {
    key = 'quillagod',
    loc_txt = {
        name = '???'
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
    badge_colour = HEX("B080FF"),
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
        name = 'Equippable..?'
    },
    badge_colour = HEX("EB4D4D"),
    pools = { ["Joker"] = true },
	get_weight = function(self, weight, object_type)
		return 0.03
	end,
}


assert(SMODS.load_file("Items/helpers.lua"))()
assert(SMODS.load_file("Items/overrides.lua"))()
assert(SMODS.load_file("Items/consumables.lua"))()


if (vallkarri.config.overscoring) then
    assert(SMODS.load_file("Items/ante.lua"))()
end

-- assert(SMODS.load_file("Items/Jokers/minesweeper.lua"))()
-- one day. i will fix minesweeper
-- today is not that day.

assert(SMODS.load_file("Items/Jokers/cursed.lua"))()
assert(SMODS.load_file("Items/Jokers/animation.lua"))()
assert(SMODS.load_file("Items/Jokers/subepic.lua"))()
assert(SMODS.load_file("Items/Jokers/epic.lua"))()
assert(SMODS.load_file("Items/Jokers/legendary.lua"))()
assert(SMODS.load_file("Items/Jokers/exotic.lua"))()
assert(SMODS.load_file("Items/Jokers/tau.lua"))()
assert(SMODS.load_file("Items/Jokers/exoticplus.lua"))()
assert(SMODS.load_file("Items/tags.lua"))()
assert(SMODS.load_file("Items/configui.lua"))()
assert(SMODS.load_file("Items/stakes.lua"))()
assert(SMODS.load_file("Items/superplanets.lua"))()
assert(SMODS.load_file("Items/crossmod.lua"))()
assert(SMODS.load_file("Items/superwin.lua"))()

Cryptid.pointerblistifytype("rarity", "valk_selfinsert", nil)
Cryptid.pointerblistifytype("rarity", "valk_quillagod", nil)
Cryptid.pointerblistifytype("rarity", "valk_unsurpassed", nil)
Cryptid.pointerblistifytype("rarity", "valk_tauic", nil)

Cryptid.mod_whitelist["Vall-karri"] = true