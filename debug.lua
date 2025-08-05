
local self = {cost = 25}
for i=0,250,5 do
    local new = to_number(math.ceil(math.min(math.max(self.cost * (i*0.1)^0.25 * 0.5, self.cost), 2^1000)))
    print("$" .. i .. " owned: " .. "$" .. self.cost .. " Buy cost => " .. "$" .. new .. " Buy cost. $" .. new - self.cost .. " difference")
end