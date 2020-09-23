do_reset()
do_step()
do_poke("enable", 1)

local function test()
    for i = 0, 3 do
        do_poke("rx_addend0", i)
        for j = 0, 3 do
            do_poke("rx_addend1", j)
            do_poke("write", 1)
            do_step()
            do_poke("write", 0)
            do_step()
            print(i, j, do_peek("tx_sum"), do_peek("tx_carryflag"))
        end
    end
end

print("Do no carry")
do_poke("rx_carryflag", 0)
test()
print("Do carry")
do_poke("rx_carryflag", 1)
test()

print("Test should be checked in output")