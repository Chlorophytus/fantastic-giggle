local constant = 42
local register = 0x5

do_reset()
do_step()
do_poke("rx_enable", 1)
do_step()
do_poke("rx_write", 1)
do_poke("rx_select", register)
do_poke("rx_data", constant)
print(do_peek("tx_data"))
do_step()
do_poke("rx_write", 0)
do_step()
do_step()
print(do_peek("tx_data"))

print("Test should be checked in output")