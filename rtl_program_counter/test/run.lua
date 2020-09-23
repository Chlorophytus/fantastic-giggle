do_reset()
do_step()
do_poke("enable", 1)
local testruns = 0
local testtots = 0
for realm = 0, 255 do
    io.write("realm at " .. string.format("%02X", realm))
    do_poke("rjmp", 1)
    do_poke("rx_realm", realm)
    do_step()
    do_poke("rjmp", 0)
    for i = 0, 255 do
        io.write(".")
        if ((realm << 8) | (i & 0xFF)) == do_peek("tx_addr") then
            testruns = testruns + 1
        end
        testtots = testtots + 1
        do_step()
    end
    print(string.format("%04X", do_peek("tx_addr")))
end

print("Test results: " .. tostring(testruns) .. "/" .. tostring(testtots))

if testruns ~= testtots then
    error("Test failed")
else
    print("Test succeeded")
end
