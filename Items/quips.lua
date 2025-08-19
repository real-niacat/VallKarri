vallkarri.quip_weight = 15
local quips = {
    lose = {
        ["j_valk_lily"] = {
            { "you tried your",              " best, i think" },
            { "you want my halo?",           "...no." },
            { "looks like things are",       "heating u- oh.",    "you died" },
            { "i can't blame you,",          "living is tough" },
            { "you woke me up for this?",    "..come on" },
            { "ugh, i feel weak" },
            { "this is what you",            "wanted to show me?" },
            { "god, give me the controller " },
            { "you need to be killed" },
        },
        ["j_valk_illena"] = {
            { "the magic illena-ball says:", "you lose! maybe next time?" },
            { "it's okay, you", "tried your best" }
        }
    },
    win = {
        ["j_valk_lily"] = {
            { "i believed in you", "from the start"},
            { "that was", "stressful, huh?" },
            { "you alright?" },
            { "can i go", "see Quilla now?" },
            { "well, that was", "entropious" }

        },
        ["j_valk_illena"] = {
            { "the magic illena-ball says:", "you win! congrats!" },
            { "smile, i'll hang", "it up on my wall!" }
        }

    }

}

local iter = 0
for name, character in pairs(quips.lose) do
    
    for i, txt in ipairs(character) do
        iter = iter + 1
        -- print("initializing " .. tostring(txt))
        SMODS.JimboQuip {
            type = "loss",
            key = "lq_" .. name .. iter,
            extra = { center = name },
            loc_txt = txt,
            filter = function(self, quip_type)
                return true, { weight = weight = vallkarri.quip_weight }
            end
        }
    end
end

for name, character in pairs(quips.win) do
    for i, txt in ipairs(character) do
        iter = iter + 1
        -- print("initializing " .. tostring(txt))
        SMODS.JimboQuip {
            type = "win",
            key = "wq_" .. name .. iter,
            extra = { center = name },
            loc_txt = txt,
            weight = vallkarri.quip_weight,
            filter = function(self, quip_type)
                return true, { weight = weight = vallkarri.quip_weight }
            end
        }
    end
end
