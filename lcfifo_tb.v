`include "async_fifo.v"
module lcfifo_tb(

    );

    reg sys_clk;
    reg spi_clk;
    reg tx_ready;
    reg rx_ready;
    reg [7:0]tx_data;
    wire [7:0]rx_data;
    wire fifo_f;
    wire fifo_e;
 
 
 async_fifo uut(.sys_clk(sys_clk), .spi_clk(spi_clk), .tx_ready(tx_ready),
  .rx_ready(rx_ready), .tx_data(tx_data), .rx_data(rx_data), .fifo_f(fifo_f), .fifo_e(fifo_e));
 
 integer SYSTEM_CLK = 5;
 integer SPI_CLK = 10;
 integer sys = 10;   //2*SYSTEM_CLK
 integer spi = 20;   //2*SPI_CLK;
 
 initial begin
 sys_clk = 0;
 forever #SYSTEM_CLK  sys_clk = ~sys_clk;
 end
 
 initial begin
 spi_clk = 0;
 forever #SPI_CLK  spi_clk = ~spi_clk;
 end
 
 initial begin 
  tx_ready = 1'b0;
  #15
  tx_ready = 1'b1;
  #85
  tx_ready = 1'b0;
  #150
  tx_ready = 1'b1;
  #360
  tx_ready = 1'b0;
  #145
  tx_ready = 1'b1;
 end
 
 initial begin 
 @(posedge sys_clk);
 #10
 // tx_ready <= 1'b1;
      for(integer p = 0; p < 8; p=p+1)begin 
        tx_data = p;
        #sys;
      end
 #155 
      for( integer p = 255; p>247 ; p=p-1)begin 
        tx_data = p;
        #sys;
      end 
 #420
      for( integer p = 30; p<101 ; p=p+1)begin 
       tx_data = p;
       #sys;
      end 
 end  
 
 initial begin 
  rx_ready = 1'b0;
  #110
  rx_ready = 1'b1;
  #145
  rx_ready = 1'b0;
  #340
  rx_ready = 1'b1;
 end

 initial begin
  $dumpfile("dump.vcd");
  $dumpvars(1);
end
 
 
endmodule

