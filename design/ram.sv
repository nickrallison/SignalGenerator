module ram 
    #(ADDRESS_SIZE=8, DATA_SIZE=8) (
        input logic i_clk,
        input logic i_res,

        input logic [ADDRESS_SIZE-1:0] i_addr1,
        input logic [ADDRESS_SIZE-1:0] i_addr2,

        output logic signed [DATA_SIZE-1:0] o_data1,
        output logic signed [DATA_SIZE-1:0] o_data2
    );
    parameter DATA_LEN = 2**ADDRESS_SIZE;
    parameter signed [DATA_SIZE-1:0] data [DATA_LEN-1:0] = #[data_cell];

    always_ff @(posedge i_clk ) begin
        if (i_res) begin
            o_data1 <= '0;
            o_data2 <= '0;
        end
        else begin
            o_data1 <= data[i_addr1];
            o_data2 <= data[i_addr2];
        end
    end
endmodule
