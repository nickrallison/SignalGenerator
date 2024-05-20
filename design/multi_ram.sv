module multi_ram 
#(ADDRESS_SIZE=8, DATA_SIZE=8, DATA_LEN=256, ACCESS_NUMBER=2) (
    input logic i_clk,
    input logic i_res,

    input logic [ADDRESS_SIZE-1:0] addr [ACCESS_NUMBER-1:0],
    input logic [DATA_SIZE-1:0] w_data [ACCESS_NUMBER-1:0],

    input logic we [ACCESS_NUMBER-1:0],
    input logic re [ACCESS_NUMBER-1:0],

    output logic [DATA_SIZE-1:0] r_data [ACCESS_NUMBER-1:0]
);

logic [DATA_SIZE-1:0] data [DATA_LEN-1:0];

/* verilator lint_off WIDTH */
always_comb begin
    if (!(2**ADDRESS_SIZE >= DATA_LEN))
        $error ("ram too small");

    for (int i = 0; i < ACCESS_NUMBER; i = i + 1) begin
        if (!(addr[i] < DATA_LEN))
            $error ("address space exceeded");
    end

    for (int i = 0; i < ACCESS_NUMBER; i = i + 1) begin
        for (int j = 0; j < ACCESS_NUMBER; j = j + 1) begin
            if (we[i] == 1 && we[j] == 1 && addr[i] == addr[j] && i != j) begin
                $display("%b, %b\n", addr[i], addr[j]);
                $error ("simultaneous write to same address forbidden\n");
            end
        end 
    end
end
/* verilator lint_on WIDTH */

// assert (addr < DATA_LEN) else $error ("address space exceeded");
// assert (2**ADDRESS_SIZE >= DATA_LEN) else $error ("ram too small");


always_ff @(posedge i_clk ) begin
    if (i_res) begin
        for (int i = 0; i < DATA_LEN; i = i + 1) begin
            data[i] <= '0;
        end
        for (int i = 0; i < ACCESS_NUMBER; i = i + 1) begin
            r_data[i] <= '0;
        end
    end
    else begin
        for (int i = 0; i < ACCESS_NUMBER; i = i + 1) begin
            if (we[i]) begin
                data[addr[i]] <= w_data[i];
            end
            if (re[i]) begin 
                r_data[i] <= data[addr[i]];
            end
        end

    end
end
endmodule
