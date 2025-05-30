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