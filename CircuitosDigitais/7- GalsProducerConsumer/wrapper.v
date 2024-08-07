module wrapper (
    input reset, clock_1, clock_2, data_1_en,
    input [15:0] data_1,
    output buffer_empty, buffer_full, 
    output reg data_2_valid,
    output reg [15:0] data_2
); 

reg [15:0] buffer_reg [0:7];
reg [2:0] buffer_wr, buffer_rd;

assign buffer_full = ((buffer_wr + 1 == buffer_rd) || (buffer_wr == 3'b111 && buffer_rd == 3'b000)) ? 1'b1 : 1'b0;
assign buffer_empty = (buffer_rd == buffer_wr) ? 1'b1 : 1'b0;

always @(posedge clock_1 or posedge reset) begin
    if (reset) begin
        buffer_wr <= 3'b0;
    end
    else begin
        if (data_1_en && !buffer_full) begin
            buffer_reg[buffer_wr] <= data_1;
            buffer_wr <= buffer_wr + 1'b1;
        end
    end
end

always @(posedge clock_2 or posedge reset) begin
    if (reset) begin
        buffer_rd <= 3'b0;
        data_2 <= 16'b0;
        data_2_valid <= 1'b0;
    end  
    else begin
        if (!buffer_empty) begin
            data_2 <= buffer_reg[buffer_rd];
            data_2_valid <= 1'b1;
            buffer_rd <= buffer_rd + 1'b1;
        end
        else begin
            data_2_valid <= 1'b0;
        end
    end
end

endmodule