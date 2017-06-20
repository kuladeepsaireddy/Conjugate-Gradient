onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib scalar_float_division_opt

do {wave.do}

view wave
view structure
view signals

do {scalar_float_division.udo}

run -all

quit -force
