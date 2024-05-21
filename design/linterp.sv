
module linterp 
    #(WIDTH=8, PRECISION=16) (
        input logic signed [WIDTH-1:0] i_high_signed,
        input logic signed [WIDTH-1:0] i_low_signed,
        input logic [PRECISION-1:0] i_ctrl,
        output logic signed [WIDTH+PRECISION-1:0] out   
    );

    logic signed [WIDTH:0] diff_temp;
    logic signed [WIDTH:0] diff;
    logic signed [WIDTH+PRECISION-1:0] inner;
    logic [WIDTH-1:0] res;
    logic [PRECISION-1:0] low_bits;
    logic sign;

    assign diff_temp = i_high_signed - i_low_signed;

    always_comb begin
        sign = diff_temp[WIDTH];
        if (sign) begin
            diff = i_low_signed - i_high_signed;
            inner = diff * i_ctrl;
            low_bits = inner[PRECISION-1:0];
            res = i_low_signed - inner[WIDTH+PRECISION-1:PRECISION];
        end else begin
            diff = i_high_signed - i_low_signed;
            inner = diff * i_ctrl;
            low_bits = inner[PRECISION-1:0];
            res = i_low_signed + inner[WIDTH+PRECISION-1:PRECISION];
        end
    end

    assign out = {res, low_bits};

endmodule
