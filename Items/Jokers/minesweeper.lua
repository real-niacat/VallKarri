--[[
hi, lily here
i would like to say this is coded incredibly badly
i'm so sorry. if you are a developer of another mod, feel free to delete this card and all related cards in your mod.
it's all for the bit, isn't it? bad code is worth the fun, but i don't blame you if you don't want this at all
]]--

local board_size_x = 7
local board_size_y = 5

local function generate_pos()
    return {x=math.random(1,board_size_x ), y=math.random(1,board_size_y )}
end

local function check(pos, p, board)
    if (board[pos.x+p.x] and board[pos.x+p.x][pos.y+p.y] and board[pos.x+p.x][pos.y+p.y] ~= 9) then board[pos.x+p.x][pos.y+p.y] = 1 + board[pos.x+p.x][pos.y+p.y] end
end

local function reveal(board, mask, pos, r)

    if (mask[pos.y][pos.x] == 1) then
        return {status=1,mask,lose = false}
    end

    if (board[pos.y][pos.x] == 9) then
        return {status=0, mask, lose = not r}
    end

    mask[pos.y][pos.x] = 1

    if (board[pos.y][pos.x] ~= 0) then
        return {status=1, mask, lose = false}
    end

    

    if (board[pos.y-1] and board[pos.y-1][pos.x] and mask[pos.y-1][pos.x] == 0) then reveal(board, mask, {x=pos.x-1, y=pos.y}, true) end
    if (board[pos.y+1] and board[pos.y+1][pos.x] and mask[pos.y+1][pos.x] == 0) then reveal(board, mask, {x=pos.x+1, y=pos.y}, true) end
    if (board[pos.y] and board[pos.y][pos.x-1] and mask[pos.y][pos.x-1] == 0) then reveal(board, mask, {x=pos.x, y=pos.y-1}, true) end
    if (board[pos.y] and board[pos.y][pos.x+1] and mask[pos.y][pos.x+1] == 0) then reveal(board, mask, {x=pos.x, y=pos.y+1}, true) end
    
    return {status=1,mask,lose = false}

end

local function resolve_board(pos, board)
    local p = nil

    if (board[pos.y][pos.x] ~= 9) then
        return
    end

    p = {x= -1, y= -1}
    check(pos, p, board)
    p = {x= 0, y= -1}
    check(pos, p, board)
    p = {x= 1, y= -1}
    check(pos, p, board)
    p = {x= -1, y= 0}
    check(pos, p, board)
    p = {x= 1, y= 0}
    check(pos, p, board)
    p = {x= -1, y= 1}
    check(pos, p, board)
    p = {x= 0, y= 1}
    check(pos, p, board)
    p = {x= 1, y= 1}
    check(pos, p, board)
end

local function full_resolve(board)
    for x = 1, board_size_x do
        for y = 1, board_size_y do
            if board[y][x] ~= 9 then
                board[y][x] = 0
            end
        end
    end

    for x = 1, board_size_x do
        for y = 1, board_size_y do
            resolve_board({x = x, y = y}, board)
        end
    end
end



local selected_pos = {x=3, y=3}

function set_selected(pos)
    selected_pos = pos
end

local function stringline(ta, rev, loc)
    local t = {}

    for i,j in pairs(ta) do
        if (j == 9) then
            j = "X"
        end

        if (rev[i] == 0) then
            j = "?"
        end

        if (rev[i] == 2) then
            j = "S"
        end

        -- j = j .. "," .. rev[i]
        --debug line

        if (selected_pos.x == i and selected_pos.y == loc) then
            j = ">" .. j .. "<"
        else
            j = "[" .. j .. "]"
        end

        table.insert(t, j)
    end

    return table.concat(t, " ")
end

SMODS.Joker {
    key = "unsweptminefield",
    loc_txt = {
        name = "Unswept Minefield",
        text = {
            "Play a game of minesweeper",
            "If you win, create a {C:attention}Gateway{}, else, lose {C:attention}2{} {C:red}discards{}",
            "#1#",
            "#2#",
            "#3#",
            "#4#",
            "#5#",
            "{C:inactive,s:0.6}S means safe, it spawns when you hit a mine on the first move.{}",
            "{C:inactive,s:0.6}Treat it as a mine for counting.{}"
        }
    },
    config = { extra = { 
        board = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}},
        revealed = {{0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 0, 0, 0}},
        -- 0-8 = safe, 9=mine
        mines = 1,
        unplayed = true,
     } },
    rarity = 3,
    atlas = "phold",
    pos = {x=0,y=0},
    cost = 7,

    loc_vars = function(self, info_queue, card)

        return {vars = {
            stringline(card.ability.extra.board[1], card.ability.extra.revealed[1], 1),
            stringline(card.ability.extra.board[2], card.ability.extra.revealed[2], 2),
            stringline(card.ability.extra.board[3], card.ability.extra.revealed[3], 3),
            stringline(card.ability.extra.board[4], card.ability.extra.revealed[4], 4),
            stringline(card.ability.extra.board[5], card.ability.extra.revealed[5], 5),
        }}

    end,

    add_to_deck = function(self, card, from_debuff)

        simple_create("Consumable", G.consumeables, "c_valk_minesweeperdig")
        simple_create("Consumable", G.consumeables, "c_valk_minesweeperleft")
        simple_create("Consumable", G.consumeables, "c_valk_minesweeperright")
        simple_create("Consumable", G.consumeables, "c_valk_minesweeperup")
        simple_create("Consumable", G.consumeables, "c_valk_minesweeperdown")

        for i=1,card.ability.extra.mines do

            local pos = generate_pos()
            while (card.ability.extra.board[pos.y][pos.x] == 9) do
                pos = generate_pos()
            end
            card.ability.extra.board[pos.y][pos.x] = 9

            resolve_board(pos, card.ability.extra.board)
            

        end

    end,
}

SMODS.Consumable {
    set = "SpecialCards",
    loc_txt = {
        name = "Dig for mines",
        text = {

        }
    },

    no_doe = true,

    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local minesweeper = get_first_instance("j_valk_unsweptminefield")

        if (minesweeper.ability.extra.unplayed and minesweeper.ability.extra.board[selected_pos.y][selected_pos.x] == 9) then
            minesweeper.ability.extra.board[selected_pos.y][selected_pos.x] = 0
        end

        

        local revealData = reveal(minesweeper.ability.extra.board, minesweeper.ability.extra.revealed, selected_pos)
        -- full_resolve(minesweeper.ability.extra.board)

        print(revealData.lose, revealData.status)
        if (minesweeper.ability.extra.unplayed) then
            minesweeper.ability.extra.unplayed = false
        end

        if (revealData.lose) then
            card_eval_status_text(minesweeper,"extra",nil,nil,nil,{message = "You lose!"})
            minesweeper:quick_dissolve()

            return
        end

        card_eval_status_text(minesweeper,"extra",nil,nil,nil,{message = "Safe!"})


        local won = true
        for y = 1, board_size_y do
            for x = 1, board_size_x do
                
                if minesweeper.ability.extra.board[y][x] ~= 9 and minesweeper.ability.extra.revealed[y][x] == 0 then
                    won = false
                end
                if minesweeper.ability.extra.board[y][x] == 9 and minesweeper.ability.extra.revealed[y][x] ~= 0 then -- we use not 0 because 1 and 2 are valid reveals
                    won = false
                end

            end
        end

        if (won) then
            card_eval_status_text(minesweeper,"extra",nil,nil,nil,{message = "You win!"})
            minesweeper:quick_dissolve()
            simple_create("Consumable", G.consumeables, "c_cry_gateway")
        end
    end,

    keep_on_use = function(self, card)
        return true
    end,

    key = "minesweeperdig",
    pos = {x=0, y=0},
    atlas = "phold",
}

SMODS.Consumable {
    set = "SpecialCards",
    key = "minesweeperleft",
    loc_txt = {
        name = "Left",
        text = {
            "Move left on the existing minesweeper board."
        }
    },

    no_doe = true,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        set_selected({x=selected_pos.x - 1, y=selected_pos.y})

        if (selected_pos.x > board_size_x) then selected_pos.x = 1 end
        if (selected_pos.x < 1) then selected_pos.x = board_size_x end

        card_eval_status_text(get_first_instance("j_valk_unsweptminefield"),"extra",nil,nil,nil,{message = "<"})
    end,

    keep_on_use = function(self, card)
        return true
    end,
    pos = {x=0, y=0},
    atlas = "phold",
}

SMODS.Consumable {
    set = "SpecialCards",
    key = "minesweeperright",
    loc_txt = {
        name = "Right",
        text = {
            "Move right on the existing minesweeper board."
        }
    },

    no_doe = true,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        set_selected({x=selected_pos.x + 1, y=selected_pos.y})

        if (selected_pos.x > board_size_x) then selected_pos.x = 1 end
        if (selected_pos.x < 1) then selected_pos.x = board_size_x end

        card_eval_status_text(get_first_instance("j_valk_unsweptminefield"),"extra",nil,nil,nil,{message = ">"})
    end,

    keep_on_use = function(self, card)
        return true
    end,
    pos = {x=0, y=0},
    atlas = "phold",
}

SMODS.Consumable {
    set = "SpecialCards",
    key = "minesweeperup",
    loc_txt = {
        name = "Up",
        text = {
            "Move up on the existing minesweeper board."
        }
    },

    no_doe = true,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        set_selected({x=selected_pos.x , y=selected_pos.y - 1})

        if (selected_pos.y > board_size_y) then selected_pos.y = 1 end
        if (selected_pos.y < 1) then selected_pos.y = board_size_y end

        card_eval_status_text(get_first_instance("j_valk_unsweptminefield"),"extra",nil,nil,nil,{message = "^"})
    end,

    keep_on_use = function(self, card)
        return true
    end,
    pos = {x=0, y=0},
    atlas = "phold",
}

SMODS.Consumable {
    set = "SpecialCards",
    key = "minesweeperdown",
    loc_txt = {
        name = "Down",
        text = {
            "Move down on the existing minesweeper board."
        }
    },

    no_doe = true,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        set_selected({x=selected_pos.x , y=selected_pos.y + 1})

        if (selected_pos.y > board_size_y) then selected_pos.y = 1 end
        if (selected_pos.y < 1) then selected_pos.y = board_size_y end

        card_eval_status_text(get_first_instance("j_valk_unsweptminefield"),"extra",nil,nil,nil,{message = "v"})
    end,

    keep_on_use = function(self, card)
        return true
    end,
    pos = {x=0, y=0},
    atlas = "phold",
}