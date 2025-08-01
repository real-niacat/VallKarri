to_big = to_big or function(x) return x end
to_number = to_number or function(x) return x end
-- no more talisman requirement!

if (not vallkarri) then
    vallkarri = {}
end

vallkarri = {
    show_options_button = true,
}

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
}

vallkarri = SMODS.current_mod
vallkarri_config = vallkarri.config
vallkarri.enabled = copy_table(vallkarri_config)

vallkarri.path = "" .. SMODS.current_mod.path

vallkarri.librat_vals = {red = 62, blue = 61}
vallkarri.last_message = "Dear player. Please make sure to drink water and get eight hours of sleep, its really important to me that you guys stay healthy and strong, - love vagabond"

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

merge_recipes = {

    {input = {"c_death", "c_hanged_man"}, output = "c_valk_iron_maiden"},
    {input = {"c_hierophant", "c_judgement"}, output = "c_valk_the_pope"},
    {input = {"c_emperor", "c_sun"}, output = "c_valk_the_knight"},
    {input = {"c_justice", "c_fool"}, output = "c_valk_the_killer"},
    {input = {"c_judgement", "c_strength"}, output = "c_valk_gods_finger"},
    {input = {"c_wheel_of_fortune", "c_temperance"}, output = "c_valk_gameshow"},

}

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
Cryptid.pointerblistify( "c_valk_freeway", nil)

Cryptid.mod_whitelist["Vall-karri"] = true
