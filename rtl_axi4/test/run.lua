do_reset()
do_step()

local ops = {
    " + ",
    " - ",
    " & ",
    " | ",
    " ^ ",
}

local function determine_flags()
    local carry = "-"
    if do_peek("tx_carryflag") == 1 then carry = "C" end
    local sign = "-"
    if do_peek("tx_signflag") == 1 then sign = "S" end
    local zero = "-"
    if do_peek("tx_zeroflag") == 1 then zero = "Z" end
    return string.format("F:%s%s%s", carry, sign, zero)
end

local function test(opcode)
    for i = 0, 3 do
        do_poke("rx_what_op", 1 << (opcode - 1))
        do_poke("rx_operand0", i)
        for j = 0, 3 do
            do_poke("rx_operand1", j)
            do_step()
            print(string.format("%o%s%o", i, ops[opcode], j),
                  string.format("%o %s", do_peek("tx_result"), determine_flags()))
        end
    end
end

for i = 1, 5 do
    print("Do no carry")
    do_poke("rx_carryflag", 0)
    test(i)
    print("Do carry")
    do_poke("rx_carryflag", 1)
    test(i)

    print(" === ")
end

print("Test should be checked in output")
