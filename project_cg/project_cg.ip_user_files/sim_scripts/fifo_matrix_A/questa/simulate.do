onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib fifo_matrix_A_opt

do {wave.do}

view wave
view structure
view signals

do {fifo_matrix_A.udo}

run -all

quit -force
