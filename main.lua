if (not vallkarri) then
    vallkarri = {}
end

vallkarri = {
    show_options_button = true,
}

vallkarri = SMODS.current_mod
vallkarri_config = vallkarri.config
vallkarri.enabled = copy_table(vallkarri_config)

vallkarri.path = "" .. SMODS.current_mod.path

SMODS.Atlas {
    key = "main",
    path = "assets.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "phold",
    path = "placeholder.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "modicon",
    path = "valk_icon.png",
    px = 34,
    py = 34,
}:register()

maxArrow = 1e5


merge_recipes = {

    {input = {"c_cry_gateway", "c_cry_pointer", "c_soul"}, output = "c_valk_lordcall"},
    {input = {"j_valk_dormantlordess", "j_valk_keystonefragment"}, output = "j_valk_lily"},
    -- {input = {"j_valk_keystonefragment", "j_valk_lily", "c_valk_binding_energy" }, output = "j_valk_quilla"},
    {input = {"c_valk_tauism", "c_soul", "c_wraith" }, output = "c_valk_absolutetau"},
    {input = {"c_valk_perfected_gem", "c_valk_socket"}, output = "c_valk_socketed_gem"},
    {input = {"c_valk_socketed_gem", "c_valk_halo_fragment", "c_valk_binding_energy"}, output = "j_valk_keystonefragment"},
    -- {input = {"c_", "c_", "c_valk_binding_energy"}, output = "c_valk"},
    {input = {"c_death", "c_hanged_man"}, output = "c_valk_iron_maiden"},
    {input = {"c_hierophant", "c_judgement"}, output = "c_valk_the_pope"},
    {input = {"c_emperor", "c_sun"}, output = "c_valk_the_knight"},
    {input = {"c_justice", "c_fool"}, output = "c_valk_the_killer"},
    {input = {"c_judgement", "c_strength"}, output = "c_valk_gods_finger"},
    {input = {"c_wheel_of_fortune", "c_temperance"}, output = "c_valk_gameshow"},

}
-- i concede, i don't care anymore. i'm not here to spread hate, that makes me no better than the people i'm fighting against by doing this
-- vallkarri will still not load, but it will not crash either.

-- my own conflicts aren't relevant to the average balatro player, and frankly i'm not in the mental state to maintain this dumb bickering
-- glitchkat, if you're reading this, you haven't won, you'll win only win when you become a good person.
-- anyway, sorry for rambling. i am not doing well
assert(SMODS.load_file("loadfiles.lua", "vallkarri"))()

Cryptid.pointerblistifytype("rarity", "valk_selfinsert", nil)
Cryptid.pointerblistifytype("rarity", "valk_quillagod", nil)
Cryptid.pointerblistifytype("rarity", "valk_unsurpassed", nil)
Cryptid.pointerblistifytype("rarity", "valk_prestigious", nil)
Cryptid.pointerblistifytype("rarity", "valk_tauic", nil)
Cryptid.pointerblistifytype("rarity", "valk_equip", nil)
Cryptid.pointerblistify( "v_valk_alphaboosterator", nil)
Cryptid.pointerblistify( "v_valk_betaboosterator", nil)
Cryptid.pointerblistify( "v_valk_gammaboosterator", nil)

Cryptid.mod_whitelist["Vall-karri"] = true
