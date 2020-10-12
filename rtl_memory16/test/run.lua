local constant = 0xF0
local address = 0x6969

do_reset()
do_step()
do_poke("rx_enable", 1)
do_step()

print(string.format("%04x -> %02x", address, do_peek("tx_data")), do_peek("tx_ready"))

do_poke("rx_write", 1)
do_poke("rx_data", constant)
do_poke("rx_program_counter", address)
do_step()
do_poke("rx_strobe", 1)
do_step()
do_poke("rx_strobe", 0)
do_step()
do_step()
do_step()
do_step()
print(string.format("%04x -> %02x", address, do_peek("tx_data")), do_peek("tx_ready"))


do_poke("rx_write", 0)
do_poke("rx_data", 0x00)
do_step()
do_poke("rx_strobe", 1)
do_step()
do_poke("rx_strobe", 0)
do_step()
do_step()
do_step()
do_step()
print(string.format("%04x -> %02x", address, do_peek("tx_data")), do_peek("tx_ready"))

print("Test should be checked in output")