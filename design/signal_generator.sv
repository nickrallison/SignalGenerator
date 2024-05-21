module signal_generator
    #(ADDRESS_SIZE=8, DATA_SIZE=8, PRECISION=16) (
        input logic i_clk,
        input logic i_res,

        input logic [ADDRESS_SIZE+PRECISION-1:0] step_size,

        output logic signed [DATA_SIZE+PRECISION-1:0] data
    );

    logic [ADDRESS_SIZE+PRECISION-1:0] count;
    logic [ADDRESS_SIZE-1:0] addr1;
    logic [ADDRESS_SIZE-1:0] addr2;
    logic signed [DATA_SIZE-1:0] data1;
    logic signed [DATA_SIZE-1:0] data2;
    logic [PRECISION-1:0] frac;

    always_ff @(posedge i_clk) begin
        if (i_res) begin
            count <= 0;
        end else begin
            count <= count + step_size;
        end 
    end

    always_comb begin
        frac = count[PRECISION-1:0];
        addr1 = count[ADDRESS_SIZE+PRECISION-1:PRECISION];
        
        if (frac == '0) begin
            addr2 = addr1;
        end else begin
            /* verilator lint_off WIDTHEXPAND */
            if (addr1 == 2**ADDRESS_SIZE-1) begin
            /* verilator lint_on WIDTHEXPAND */
                addr2 = 0;
            end else begin
                addr2 = addr1 + 1;
            end
        end
    end

    ram_full #(
        .ADDRESS_SIZE(ADDRESS_SIZE),
        .DATA_SIZE(DATA_SIZE)
    ) u_ram_full (
        .i_clk(i_clk),
        .i_res(i_res),
        .i_addr1(addr1),
        .i_addr2(addr2),
        .o_data1(data1),
        .o_data2(data2)
    );

    linterp #(
        .WIDTH(DATA_SIZE),
        .PRECISION(PRECISION)
    ) u_linterp (
        .i_high_signed(data2),
        .i_low_signed(data1),
        .i_ctrl(frac),
        .out(data)
    );

    
endmodule
