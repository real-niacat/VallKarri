local n = to_big(100):arrow(50,100)
n = n:arrow(100,n)

for i=(1e6-5),(1e6+10) do
    print(tostring(i) .."-ation: " .. tostring(n:arrow(i,n)))
end
