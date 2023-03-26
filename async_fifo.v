// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2023 08:15:51 PM
// Design Name: 
// Module Name: s_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//!fifo_e*rx_ready + fifo_e*!fifo_f*tx_ready + fifo_f*tx_ready*!rx_ready
// !fifo_e*!fifo_f + fifo_e*!fifo_f*!tx_ready + !fifo_e*fifo_f*!rx_ready
//////////////////////////////////////////////////////////////////////////////////


module async_fifo(
    input sys_clk,
    input spi_clk,
    //input  rst,
    input tx_ready,
    input rx_ready,
    input [7:0]tx_data,
    output reg [7:0]rx_data,
    output reg fifo_f,
    output reg fifo_e
    );
    
    reg [7:0]fifo[0:7];
    reg [2:0] addr;
    integer raddr;
    reg spi_state;
    
    
   // Define FSM states
    parameter HALT = 1'b0;
    parameter ACTIVE = 1'b1;

   
        
    initial begin
    fifo_e = 1'b1;
    fifo_f = 1'b0;
    addr =3'b000;
    spi_state = HALT;
    end
    
    always@(*)begin 
     
          case(spi_state) 
      
              HALT:begin
                $display("e: %d, f: %d",fifo_e, fifo_f);
                $display("HALT state");
                $display(tx_ready);
                $display(!fifo_f && tx_ready || !fifo_e && rx_ready);
                //$display("in nclk idle %d",tx_data); !fifo_f && tx_ready || !fifo_e && rx_ready
                  if(!fifo_f && tx_ready || !fifo_e && rx_ready)begin
                      spi_state = ACTIVE;
                      $display("ACTIVE state");
                  end
                  else begin 
                      spi_state = HALT;
                  end
                
              end
              
              ACTIVE:begin 
                
                if((fifo_f && tx_ready && !rx_ready) || (fifo_e && rx_ready && !tx_ready))begin
                      spi_state = HALT;
                  end
                  else begin 
                      spi_state = ACTIVE;
                  end
                
                                    
              end
      
           endcase
         
        
  end
  
  
  always @ (posedge sys_clk) begin 
    if(spi_state == ACTIVE && tx_ready && !fifo_f)begin 
      fifo[addr] = tx_data;
      fifo_e = 1'b0;
      $display("w address : %d, w data : %d",addr, tx_data);
       for(integer i=0; i <= addr; i=i+1)begin
             $write("%d : %d", i, fifo[i]); 
            end
      $display("");
      if(addr==7)begin
       $display("BUFFER FULL!");
       fifo_f <= 1'b1;
        $display(spi_state);
     end
     if(addr < 7)begin
          addr = addr + 1;
     end 
       
    end
       
  end 
  
  
 always @ (posedge spi_clk)begin 
         if(spi_state == ACTIVE && rx_ready && !fifo_e)begin
           rx_data = fifo[0]; 
           $display(" r data : %d ", rx_data);
            for(integer i=0; i <= addr; i=i+1)begin  
             $write("%d : %d", i, fifo[i]);
            end
            $display(" ");
            for(integer i= 0; i < addr; i=i+1)begin
             fifo[i] = fifo[i+1];
            end
            if(!fifo_f || addr<7) begin
            addr = addr -1;
            fifo_f = 1'b0;
            end else begin
                fifo_f = 1'b0;
            end
            if(addr == 0)begin 
             $display("BUFFER EMPTY!");
            fifo_e = 1'b1;
            end
           
         
           
                
         end
         
     end  
    
    
endmodule