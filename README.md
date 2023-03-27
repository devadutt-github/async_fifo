# async_fifo

async_fifo.v -> Design File

lcfifo_tb.v -> Testbench File

This is a Verilog RTL of a buffer modeled as a FSM which can detect backpressure.

The buffer operates in FIFO style. It is 8-bit wide with a depth of 8 cells.

THe FSM has two states 

 1. HALT state: No data in/out happens on buffer(remains idle).
 
 2. ACTIVE state: Data in/out operations happens in this state.

Port names and meaning:
 sys_clk : System Clock
 
 spi_clk : SPI Clock
 
 tx_ready: Sender signaling to send data to buffer (active high)
 
 rx_ready: Receiver signaling to receive data from buffer (active high)
 
 tx_data: Line to load data into buffer
 
 rx_data: Line to unload data from buffer
 
 fifo_f: Buffer full signal (active high)
 
 fifo_e :Buffer empty signal (active high)

Variable declarations:

 [7:0]fifo[0:7] : FIFO buffer memory width 8 bits, depth 8 
 
 addr : Address pointer 
 
 spi_state : tate variable
 
