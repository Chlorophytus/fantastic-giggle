local constant = 42

do_reset()
do_step()
do_poke("rx_enable", 1)
do_poke("rx_addend1", constant)
local function test()
    for i = 0, 256, 11 do
        do_poke("rx_addend0", i)
        do_step()
        do_poke("rx_write", 1)
        do_step()
        do_poke("rx_write", 0)
        do_step()
        do_poke("rx_strobe", 1)
        do_step()
        do_poke("rx_strobe", 0)
        do_step()
        do_step()
        do_step()
        do_step()
        print(tostring(i) .. " + " .. tostring(constant) .. " = ", do_peek("tx_sum"), do_peek("tx_carryflag"))
    end
end

print("Do no carry")
do_poke("rx_carryflag", 0)
test()

print("Test should be checked in output")