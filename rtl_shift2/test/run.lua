do_reset()
do_step()
do_poke("rx_enable", 1)

for i = 0, 7 do
    do_poke("rx_carryflag", i >> 2)
    do_poke("rx_input", i % 4)
    do_poke("rx_coeff", 1)
    do_step()
    print(tostring(i) .. " >> 1 (CARRY) = ", tostring(do_peek("tx_result") | (do_peek("tx_carryflag") << 2)))
    print(tostring(i) .. " >> 1 (VOIDY) = ", tostring(do_peek("tx_result")))
    do_poke("rx_coeff", 2)
    do_step()
    print(tostring(i) .. " << 1 (CARRY) = ", tostring(do_peek("tx_result") | (do_peek("tx_carryflag") << 2)))
    print(tostring(i) .. " << 1 (VOIDY) = ", tostring(do_peek("tx_result")))
    print()
end
print("Test should be checked in output")