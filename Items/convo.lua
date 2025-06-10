local fakecalc = SMODS.calculate_card_areas
function SMODS.calculate_card_areas(_type, context, return_table, args)
    fakecalc(_type, context, return_table, args)

    if not (context.end_of_round and context.main_eval) then
        return
    end

    for i,convo in ipairs(vallkarri.conversations) do

        local valid = true
        for j,key in ipairs(convo.reqs) do
            valid = valid and joker_owned(key)
        end

        if valid and pseudorandom("valk_conversation", 1, convo.prob) == 1 then
            
            for j,message in ipairs(convo.text) do
                local calculated_time = 0.5 + (#message.txt/40)
                quick_card_speak(get_first_instance(message.s), message.txt, G.SETTINGS.GAMESPEED * calculated_time)
                pause_event(0.75)
            end

        end

    end
end

vallkarri.conversations = {
    {prob = 8, reqs = {"j_valk_lily", "j_valk_quilla"}, text = {
        {s="j_valk_quilla", txt="you okay Lily?"},
        {s="j_valk_lily",txt="i'm not great"},
        {s="j_valk_quilla", txt="what's wrong?"},
        {s="j_valk_lily",txt="i'll.. tell you later.."},
    }},

    {prob = 8, reqs = {"j_valk_illena", "j_valk_quilla"}, text = {
        {s="j_valk_illena", txt="you're... pure of mind"},
        {s="j_valk_quilla",txt="i try!"},
        {s="j_valk_illena", txt="seriously, how?"},
        {s="j_valk_quilla",txt="negativity isn't worth it"},
    }},

    {prob = 8, reqs = {"j_valk_illena", "j_valk_lily"}, text = {
        {s="j_valk_illena", txt="you've got something on your mind."},
        {s="j_valk_lily",txt="is it that obvious?"},
        {s="j_valk_illena", txt="i literally read minds..."},
        {s="j_valk_lily",txt="ah right, it's nothing."},
    }}
}

-- Usage:
-- vallkarri.addconvo({"j_joker", 5, "j_jolly_joker"}, {
-- {s="j_joker", txt="Hi Jolly Joker! How's it going?"},
-- {s="j_jolly_joker", txt="Good! thanks for asking!"}
-- })
-- this would result in a 1 in 5 chance at end of round for joker & jolly joker to have a conversation
function vallkarri.addconvo(required_jokers, chance, data) 
    table:insert(vallkarri.conversations, {prob = chance, reqs = required_jokers, text = data})
end