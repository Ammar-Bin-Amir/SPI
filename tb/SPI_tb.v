`timescale 1ns/1ns

module spi_tb;
    
    reg clk;
    reg rst;
    reg [2:0] address;
    reg we;
    reg [31:0] write_data;
    reg re;
    wire [31:0] read_data;

    spi uut (
        .clk (clk),
        .rst (rst),
        .addr (address),
        .we (we),
        .write_data (write_data),
        .re (re),
        .read_data (read_data)
    );

    initial clk = 0;
    always #10 clk = ~clk;
    
    initial begin
        #10 rst = 1;
        #50 rst = 0;
        #50 address = 0; we = 0; write_data = 1;
        #20 address = 1; we = 1; write_data = 8'ha5;
        #20 address = 2; we = 1; write_data = 24'h12_34_56;
        #20 address = 3; we = 1; write_data = 32'h78_9a_bc_de;
        #30 address = 0; we = 1; write_data = 1;
        #30 address = 0; we = 1; write_data = 0;
        #3000 address = 1; we = 1; write_data = 8'h00;
        #20 address = 2; we = 1; write_data = 24'hf0_12_34;
        #20 address = 3; we = 1; write_data = 32'h56_78_9a_bc;
        #30 address = 0; we = 1; write_data = 1;
        #30 address = 0; we = 1; write_data = 0;
        #3000 address = 1; we = 1; write_data = 8'hff;
        #20 address = 2; we = 1; write_data = 24'hde_f0_12;
        #20 address = 3; we = 1; write_data = 32'h34_56_78_9a;
        #30 address = 0; we = 1; write_data = 1;
        #30 address = 0; we = 1; write_data = 0;
        #3000 address = 4; re = 0;
        #3000 address = 4; re = 1;
        #20 address = 1; we = 1; write_data = 8'h00;
        #20 address = 2; we = 1; write_data = 24'h12_34_56;
        #20 address = 3; we = 1; write_data = 32'h78_9a_bc_de;
        #30 address = 0; we = 1; write_data = 1;
        #30 address = 0; we = 1; write_data = 0;
        #3000 address = 1; we = 1; write_data = 8'hff;
        #20 address = 2; we = 1; write_data = 24'hf0_12_34;
        #20 address = 3; we = 1; write_data = 32'h56_78_9a_bc;
        #30 address = 0; we = 1; write_data = 1;
        #30 address = 0; we = 1; write_data = 0;
        #3000 address = 4; re = 0;
        #3000 address = 4; re = 1;
        #3000 address = 1; we = 1; write_data = 8'h5a;
        #20 address = 2; we = 1; write_data = 24'hde_f0_12;
        #20 address = 3; we = 1; write_data = 32'h34_56_78_9a;
        #30 address = 0; we = 1; write_data = 1;
        #30 address = 0; we = 1; write_data = 0;
        #3000 $finish;
    end

    initial begin
        $dumpfile("./temp/SPI_tb.vcd");
        $dumpvars(0,spi_tb);
    end

endmodule