function req(level)
    local arrows = level:log10()
    return 100 * to_big(level):arrow(math.floor(arrows), level)
end

for i=1000,10000 do
    print(req(to_big(i)))
end