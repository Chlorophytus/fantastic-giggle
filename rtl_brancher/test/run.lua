local branch = 0x6969

do_reset()
do_step()
do_poke("rx_enable", 1)
do_step()

do_poke("rx_write_branch", 1)
do_poke("rx_branch", branch)
do_step()
do_poke("rx_write_flags", 1)
do_poke("rx_check_flags", 0x1)
do_step()
do_poke("rx_write_branch", 0)
do_poke("rx_write_flags", 0)
do_poke("rx_strobe", 1)
do_step()
do_poke("rx_strobe", 0)
for i = 1, 4 do
    do_step()
    print(string.format("%04x", do_peek("tx_program_counter")), do_peek("tx_ready"))
end
do_poke("rx_input_flags", 0x1)
do_step()
do_poke("rx_strobe", 1)
do_step()
do_poke("rx_strobe", 0)
for i = 1, 4 do
    do_step()
    print(string.format("%04x", do_peek("tx_program_counter")), do_peek("tx_ready"))
end

print("Test should be checked in output")
