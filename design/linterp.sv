
module linterp 
    #(WIDTH=8, PRECISION=16) (
        input logic signed [WIDTH-1:0] i_high_signed,
        input logic signed [WIDTH-1:0] i_low_signed,
        input logic [PRECISION-1:0] i_ctrl,
        output logic signed [WIDTH+PRECISION-1:0] out   
    );

    logic signed [WIDTH:0] diff;
    logic signed [WIDTH+PRECISION-1:0] inner;
    logic [WIDTH-1:0] res;
    logic [PRECISION-1:0] low_bits;

    assign diff = i_high_signed - i_low_signed;
    assign inner = diff * i_ctrl;
    assign low_bits = inner[PRECISION-1:0 ];
    assign res = inner[WIDTH+PRECISION-1:PRECISION] + i_low_signed;
    assign out = {res, low_bits};

endmodule
