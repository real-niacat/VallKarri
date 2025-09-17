local cie = SMODS.calculate_individual_effect

function SMODS.calculate_individual_effect(effect,card,key,amount,edition)

    if string.find(key, string.lower("chips")) and G.GAME.chips_exponent then
        amount = amount ^ G.GAME.chips_exponent
    end

    if string.find(key, string.lower("mult")) and G.GAME.mult_exponent then
        amount = amount ^ G.GAME.mult_exponent
    end

    return cie(effect,card,key,amount,edition)
end

local start_run = Game.start_run
function Game:start_run(args)
    start_run(self,args)

    if not args.savetext then
        G.GAME.mult_exponent = G.GAME.mult_exponent or G.GAME.modifiers.valk_mult_expo
        G.GAME.chips_exponent = G.GAME.chips_exponent or G.GAME.modifiers.valk_chips_expo
        G.GAME.money_exponent = G.GAME.money_exponent or G.GAME.modifiers.valk_money_expo
    end
end

local moneyhook = ease_dollars

function ease_dollars(amount, instant)
    amount = amount ^ (G.GAME.money_exponent or 1)
    moneyhook(amount,instant)
end

local emplace = CardArea.emplace
function CardArea:emplace(card, ...)
    if G.GAME.modifiers and G.GAME.modifiers.valk_shop_sucks then

        if self == G.shop_jokers or self == G.shop_booster or self == G.shop_vouchers then
            emplace(self,card,...)
            G.E_MANAGER:add_event(Event({
                delay = 0.5,
                func = function()
                    card:start_dissolve({G.C.VALK_PRESTIGIOUS}, G.SETTINGS.GAMESPEED)
                    return true
                end,
                trigger = "after"
            }))
            
            return
        end

    end
    emplace(self,card,...)
end

SMODS.Challenge {
    key = "c1",
    loc_txt = {
        name = "C1"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_chips_expo", value = 0.85}
        }
    },
}

SMODS.Challenge {
    key = "c2",
    loc_txt = {
        name = "C2"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_mult_expo", value = 0.7}
        }
    },
}

SMODS.Challenge {
    key = "c3",
    loc_txt = {
        name = "C3"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_money_expo", value = 0.8}
        }
    },
}

SMODS.Challenge {
    key = "c4",
    loc_txt = {
        name = "C4"
    },
    button_colour = G.C.VALK_PRESTIGIOUS,
    rules = {
        custom = {
            {id = "valk_shop_sucks"}
            -- cardareas: g.shop_jokers, g.shop_booster, g.shop_vouchers
        }
    },
    jokers = {
        {id = "j_riff_raff", edition = "negative"}
    },
    consumeables = {
        {id = "c_judgement", edition = "negative"},
        {id = "c_judgement", edition = "negative"},
        {id = "c_judgement", edition = "negative"},
    }
}