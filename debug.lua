function fnc(x, y)
    return get_old_blind_amount(x) * (1+(0.02 * x))^(1+(0.2*y))
end


local level = 1000
print("blind size diff at level " .. level)
for i=1,32 do
    local ante = i
    
    -- print("Ante " .. tostring(ante) .. ", level " .. tostring(level) .. ": " .. tostring(fnc(ante, level)))
    print("Ante " .. tostring(ante) .. ", Base: " .. tostring(get_old_blind_amount(ante)) .. ", New: " .. tostring(fnc(ante, level)))
end