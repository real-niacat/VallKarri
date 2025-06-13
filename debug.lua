local v = #G.GAME.tags
for i=1,v do

    local key = G.GAME.tags[1].key
    if key == "tag_entr_ascendant_cat" or key == "tag_cry_cat" or key == "tag_entr_ascendant_dog" or key == "tag_entr_dog" then
        G.GAME.tags[1]:remove()
    end

    if G.GAME.tags[i] then
        key = G.GAME.tags[i].key
        if key == "tag_entr_ascendant_cat" or key == "tag_cry_cat" or key == "tag_entr_ascendant_dog" or key == "tag_entr_dog" then
            G.GAME.tags[i]:remove()
        end
    end 

end