local failed = true
local blinks = 0
do_reset()
do_step()
do_poke("enable", 1)
for i = 1, 10 do
    print(i, do_peek("blink"))
    if do_peek("blink") == 1 then
        blinks = blinks + 2
    end
    do_step()
end

failed = blinks ~= 5

if failed then
    error("Test failed")
else
    print("Test succeeded")
end