`timescale 1ns / 1ps

module Master_SPI(
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg done,
    output reg sclk,
    output reg mosi,
    input wire miso,
    output reg ss
                       );
                       
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    
    always@(posedge clk or posedge reset) begin
        if (reset) begin
            ss        <= 1'b1;
            sclk      <= 1'b0;
            mosi      <= 1'b0;
            data_out  <= 8'd0;
            done      <= 1'b0;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
        end
        else begin
            if(start && !done) begin
                ss   <=1'b0;
                sclk <= ~sclk;
                
                if (sclk == 1'b0)
                begin
                    mosi <= data_in[7 - bit_cnt];
                end 
                else 
                begin
                    shift_reg[7 - bit_cnt] <= miso;
                    bit_cnt <= bit_cnt + 1'b1;
                end
                
                if(bit_cnt == 3'd7 && sclk == 1'b1) begin
                    data_out <= shift_reg;
                    done <= 1'b1;
                    ss <= 1'b1;
                end
                else if (done) begin
                    sclk <= 1'b0;
                end
         end
      end
   end         
endmodule
