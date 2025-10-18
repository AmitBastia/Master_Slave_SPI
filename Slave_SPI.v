`timescale 1ns / 1ps

module Slave_SPI(
    input wire sclk,
    input wire reset,
    input wire ss,
    input wire mosi,
    output reg miso,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done
                       );
                       
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    
    always@(posedge sclk or posedge reset) begin
        if (reset) begin
            bit_cnt <= 3'd0;
            data_out <= 8'd0;
            done <= 1'b0;
            shift_reg <= 8'd0;
            miso <= 1'b0;
        end
        else if (!ss) begin
        data_out[7 - bit_cnt] <= mosi;
        miso <= data_in[7-bit_cnt];
        bit_cnt <= bit_cnt + 1'b1;
        
        if (bit_cnt == 3'd7) begin  
            done <= 1'b1;
        end
     end
     end
endmodule
