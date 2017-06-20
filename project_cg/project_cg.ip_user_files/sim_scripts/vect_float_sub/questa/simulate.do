onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib vect_float_sub_opt

do {wave.do}

view wave
view structure
view signals

do {vect_float_sub.udo}

run -all

quit -force
