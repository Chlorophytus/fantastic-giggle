# fantastic-giggle
SystemVerilog soft GPU

## Boot ROM generation
### Generate a blank BootROM
```shell
$ dd if=/dev/zero of=./rtl_memory16/bootrom.hex bs=4k count=1
```
Edit this in a hex editor to get what you want. This is how we generate 4kB BootROM blanks in house.
### Convert the BootROM to a Verilog hex file
```shell
$ python3 ./utilities/genmem.py ./rtl_memory/bootrom.hex > ./rtl_memory/bootrom.mem
```
This can be put into a Verilog Vivado project as a valid hex file for our memory's `$readmemh`. To include the notice for posterity:
```c
// Autogenerated file by `genmem.py`
// Due to the sparse nature of Verilog HEX files, it is recommended to
// use the `genmem.py` script with a hex file to generate hex files.
// . . .
```
## Shader ISA
### Accumulators
There are 32 8-bit ALUs that can carry each other. TODO: What if this fails timing?

### Display list
#### Zero page 
RAM is `000h` - `0FFh`.

#### Stack
RAM is `100h` - `1FFh`.


