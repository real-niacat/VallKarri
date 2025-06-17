local counter = {}
for i=1,10000 do 

    local booster = create_card("Booster", G.shop_booster, nil, nil, nil, nil, nil, "valk_datagen")
    local key = booster.config.center.key

    key = key:gsub("_(%d+)$", "")

    if counter[key] then
        counter[key] = counter[key] + 1
    else
        counter[key] = 1
    end

    booster:remove()
end

print(counter)