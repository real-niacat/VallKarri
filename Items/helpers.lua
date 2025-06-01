function credit(artist)
	return ('{C:dark_edition,s:0.6,E:2}Art by : ' .. artist .. '{}')
end

function concept(creator)
	return ('{C:dark_edition,s:0.6,E:2}Idea by : ' .. creator .. '{}')
end

short_sprites = {
    placeholder = {x=0,y=0},

    halo = {x=2, y=2}
}

function days_since(year, month, day)

    local now = os.date("*t")
    local then_time = os.time{year=year, month=month, day=day, hour=0}
    local diff = os.difftime(os.time(now), then_time)
    return math.floor(diff / (60 * 60 * 24))

end



external_joker_data = {
    
}

function quote(character)
    -- assume character is in quotes because i'm not a fucking idiot
    local quotes = {
        lily = "thank you. that feels much better.",
        lily2 = "i'm not all that, go ask Quilla",
        illena = "i'm here to help, nothing better to do.",
        quilla = "sorry i can't help you directly, i don't want to hurt anything.",
        quilla2 = "and no, lily isn't lying.",
        niko = "sorry im not wearing the twink bowtie :c",
        orivander = "Behold, the absolute force of gravity",
        raxd = "NUCLEAR BOMB!??!?!?",
        femtanyl = "we r online. we r online.",
        lilac = "A medium iced cappuccino, p-please.",
        ovilidoth = "NO QUOTE RIGHT NOW PLEASE",
        dormant = "I'm missing something.",
        dormant2 = "Help me find it and I'll make it worth your time.",
        scraptake = "good kitty..",
        hornet = "silksong tommorow",
        valklua = "Thank you for playing <3",
    }

    -- return " " --disable for now

    return ('{C:enhanced,s:0.7,E:1}' .. quotes[character] .. '{}')

end
 
function table:remove_by_function(t, func)
    for i = #t, 1, -1 do
        if func(t[i]) then
            table.remove(t, i)
        end
    end
end

function table:merge(t_a, t_b)
    
    -- add everything from t_b to t_a
    for i, v in ipairs(t_b) do
        table.insert(t_a, v)
    end
    return t_a

end

function table:contains(table, value)
    for i,j in ipairs(table) do
        if (j == value) then return true end
    end
    return false
end

function table:superset(t_a, t_b)
    local valid = true

    for i,j in ipairs(t_b) do
        valid = valid and table:contains(t_a,j)
    end
    return valid
end

function table:random_element(table)
    local keys = {}
    for key in pairs(table) do
        table.insert(keys, key)
    end
    local random_key = keys[math.random(#keys)]
    return table[random_key]
end

function destroy_first_instance(key)
    local found = SMODS.find_card(key)
    if #found > 0 then
        (select(2, next(found))):quick_dissolve()
    end
end

function joker_owned(key) 

    if (G.jokers and G.jokers.cards) then

        for i,card in ipairs(G.jokers.cards) do
        
            if (card.config.center.key == key) then return true end

        end

    end

    return false

end

function get_first_instance(key)
    local found = SMODS.find_card(key)
    if #found > 0 then
        return select(2, next(found))
    end
    return nil
end

function Card:quick_dissolve()
	self.ability.eternal = nil
	self.ignore_incantation_consumable_in_use = true
	self.true_dissolve = true
	self:start_dissolve(nil, nil, nil, nil)
end

function simple_create(type, area, key)
    local card = create_card(type, area, nil, nil, nil, nil, key, "simple_create")
    card:add_to_deck()
    area:emplace(card)
end

function debug_print_antes()

    local ante = 1
    local i = 1
    local i2 = 1
    while ante < 1e300 do
        local blind_amount = tostring(get_blind_amount(ante) or "nil")
        print("Ante " .. ante .. ": " .. blind_amount)
        
        if (ante > 15) then
            ante = ante * 1e10
        else
            ante = ante + i
        end
    end

end

function jokercount()
    if (G.jokers) then
        return #G.jokers.cards
    else
        return 0
    end
end

function totaljokervalues()
    local total = to_big(0)
    if (G.jokers) then
        for i,card in ipairs(G.jokers.cards) do

            if (card.ability.extra and type(card.ability.extra) == "table") then 
                for j,entry in pairs(card.ability.extra) do
                
                    if type(entry) == "number" or (type(entry) == "table" and entry.tetrate) then
                        total = total + entry
                    end

                end 
            end

        end
    end


    return total
end

function reptlog(base, lim, num)

    for i = 1, lim do
        num = math.log(num, base)
    end

    return num

end

function get_first(area) 
    return select(2,next(area))
end

function valk_additions()
    local total = 0
    for _, entry in pairs(G.P_CENTERS) do
        if string.find(entry.key, "valk") then
            total = total + 1
        end
    end

    return total
end

function get_a_somewhat_large_number()
    local largenumber = to_big(10):arrow(10,10)
    return largenumber:arrow(10000,largenumber)
end

function scraptake_calculation()
    local calced, b = 0, 0

    if (not G.jokers or not G.playing_cards) then
        return 0
    end


    for i,jok in ipairs(G.jokers.cards) do
        if (string.find(jok.config.center_key, "valk")) then
            calced = calced + 1
        end
    end

    for _, playing_card in pairs(G.playing_cards) do
        if next(SMODS.get_enhancements(playing_card)) then
            b = b + 1
        end
    end

    calced = calced ^ b
    return calced
end

local gcpov = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append, override_equilibrium_effect)
    if _type == "Joker" and joker_owned("j_valk_jokerofequality") then
        -- print("success")
        local ret = {}

        local generated = 1

        local rarities = {1, 2, 3, "cry_epic", 4, "cry_exotic"}
        local roll = pseudorandom("jokerofequality", 1, 100)

        if _legendary then
            _rarity = 4
        end

        if (roll <= 74) then
            generated = 1
        elseif (roll <= 94) then
            generated = 2
        elseif (roll <= 99) then
            generated = 3 
        else
            generated = "cry_epic"
        end

        for i,inst in pairs(G.P_CENTERS) do

            if (inst.rarity == (_rarity or generated) ) then
                table.insert(ret, inst.key)
            end

        end


        return ret, "Joker"..(_rarity or '')

    end
    local p, pk = gcpov(_type, _rarity, _legendary, _append, override_equilibrium_effect)
    return p, pk

end

function dvi(value)
    for i,joker in ipairs(G.jokers.cards) do
        Cryptid.misprintize(joker, {min=value, max=value}, false, true)
    end
end