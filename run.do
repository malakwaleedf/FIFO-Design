vlib work
vlog dff_sync_2.v binary_gray.v gray_encoded_sync.v rtl.v tb.v
vsim -voptargs=+acc work.fifo_memory_tb
add wave *
add wave -position insertpoint  \
sim:/fifo_memory_tb/dut/mem \
sim:/fifo_memory_tb/dut/rd_ptr \
sim:/fifo_memory_tb/dut/rd_ptr_sync \
sim:/fifo_memory_tb/dut/wrt_ptr \
sim:/fifo_memory_tb/dut/wrt_ptr_sync
run -all
#quit -sim