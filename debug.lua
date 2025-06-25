for i=1,100 do
    local c = create_card("Booster", G.shop_booster, nil, nil, nil, nil, nil, "valk_test")
    print(c.config.center.key)
end