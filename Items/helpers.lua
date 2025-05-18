function credit(artist)
	return ('{C:dark_edition,s:0.6,E:2}Art by : ' .. artist .. '{}')
end

function quote(character)
    -- assume character is in quotes because i'm not a fucking idiot
    local quotes = {
        lily = "ehe, i'm not that powerful! go ask Quilla!",
        illena = "i'm here to help, nothing better to do.",
        quilla = "sorry i can't help you directly, i don't want to hurt anything.",
        quilla2 = "and no, lily isn't lying.",
        niko = "sorry im not wearing the twink bowtie :c",
        orivander = "Behold, the absolute force of gravity",
        raxd = "NUCLEAR BOMB!??!?!?",
        femtanyl = "we r online. we r online."
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

function destroy_first_instance(key)
    local found = SMODS.find_card(key)
    if #found > 0 then
        (select(2, next(found))):destroy()
    end
end