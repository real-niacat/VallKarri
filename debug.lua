local fakeusesell = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local ref = fakeusesell(card)
    print("we run")

    ref.nodes = {ref.nodes[1], ref.nodes[1]}

    return ref
end