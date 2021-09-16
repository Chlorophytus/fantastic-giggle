do_reset()
do_step()
do_poke("rx_enable", 1)
do_step()

for i = 0, 15 do
    do_poke("rx_data", i)
    do_step()
    print(string.format("%x", i), do_peek("tx_data"), do_peek("tx_hotflag"))
end

print("Test should be checked in output")
