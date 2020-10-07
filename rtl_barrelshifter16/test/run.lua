local constant = 0x0010

do_reset()
do_step()
do_poke("rx_enable", 1)
do_poke("rx_write", 1)

print("Rotate L")
do_poke("rx_write", 1)
for i = 1, 7 do
    do_poke("rx_enable", 1)
    do_poke("rx_input", constant)
    do_poke("rx_coeff", i)
    do_poke("rx_direction", 0x2)
    do_step()
    do_poke("rx_write", 1)
    do_step()
    do_poke("rx_write", 0)
    do_step()
    print(tostring(constant) .. " ROL " .. tostring(i) .. " = ", do_peek("tx_shift"))
end
print("Rotate R")
do_poke("rx_write", 1)
for i = 1, 7 do
    do_poke("rx_enable", 1)
    do_poke("rx_input", constant)
    do_poke("rx_coeff", i)
    do_poke("rx_direction", 0x1)
    do_step()
    do_poke("rx_write", 1)
    do_step()
    do_poke("rx_write", 0)
    do_step()
    print(tostring(constant) .. " ROR " .. tostring(i) .. " = ", do_peek("tx_shift"))
end

print("Test should be checked in output")