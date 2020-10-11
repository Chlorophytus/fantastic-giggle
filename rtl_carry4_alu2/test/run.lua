local constant = 0x10

do_reset()
do_step()
do_poke("rx_enable", 1)

local ops = {
    " N ",
    " + ",
    " - ",
    " & ",
    " | ",
    " ^ ",
    " < ",
    " > ",
}

local function determine_flags()
    local carry = "_"
    if do_peek("tx_carryflag") == 1 then carry = "C" end
    local sign = "_"
    if do_peek("tx_signflag") == 1 then sign = "S" end
    local zero = "_"
    if do_peek("tx_zeroflag") == 1 then zero = "Z" end
    return string.format("flags: %s%s%s", carry, sign, zero)
end

local function test(opcode)
    for i = 0, 255, 64 do
        do_poke("rx_opcode", (opcode - 1))
        do_poke("rx_operand0", i)
        for j = 0, 255, 64 do
            do_poke("rx_write", 1)
            do_poke("rx_operand1", j)
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
            print(string.format("%02x%s%02x", i, ops[opcode], j),
                  string.format("%02x %s", do_peek("tx_result"), determine_flags()))
        end
    end
end

for i = 1, 8 do
    test(i)

    print(" . . . ")
end


print("Test should be checked in output")