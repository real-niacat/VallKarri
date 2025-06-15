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


merge_recipes = {

    {input = {"c_cry_gateway", "c_cry_pointer", "c_soul"}, output = "c_valk_lordcall"},
    {input = {"j_valk_dormantlordess", "j_valk_keystonefragment"}, output = "j_valk_lily"},
    {input = {"j_valk_keystonefragment", "c_cry_gateway", "c_cry_pointer", "c_soul", "j_valk_lily" }, output = "j_valk_quilla"},
    {input = {"c_valk_tauism", "c_soul", "c_wraith" }, output = "c_valk_absolutetau"}

}

valk_badgetypes = {
    ingredient = {
        text = "Ingredient",
        color = G.C.WHITE,
        text_color = G.C.BLACK
    },
    lore = {
        text = "Has Lore",
        color = G.C.CRY_TWILIGHT,
        text_color = G.C.WHITE,
    }
}

valk_badgecards = {
    -- format:
-- {card=
}




assert(SMODS.load_file("loadfiles.lua", "vallkarri"))()

Cryptid.pointerblistifytype("rarity", "valk_selfinsert", nil)
Cryptid.pointerblistifytype("rarity", "valk_quillagod", nil)
Cryptid.pointerblistifytype("rarity", "valk_unsurpassed", nil)
Cryptid.pointerblistifytype("rarity", "valk_tauic", nil)

Cryptid.mod_whitelist["Vall-karri"] = true