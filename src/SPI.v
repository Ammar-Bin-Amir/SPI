module spi (
    input wire clk,
    input wire rst,
    input wire [2:0] addr,
    input wire we,
    input wire [31:0] write_data,
    input wire re,
    output reg [31:0] read_data
);
    
    // Register Interface

    localparam ENABLE = 3'b000;
    localparam COMMAND = 3'b001;
    localparam ADDRESS = 3'b010;
    localparam DATA_IN = 3'b011;
    localparam DATA_OUT = 3'b100;
    
    reg enable;
    reg [7:0] command;
    reg [23:0] address;
    reg [31:0] data_in;
    wire [31:0] data_out;

    always @(*) begin
        if (rst) begin
            enable = 0;
            command = 0;
            address = 0;
            data_in = 0;
        end
        else begin
            case (addr)
                ENABLE: begin
                    if (we == 1'b1) begin
                        enable = write_data[0];
                    end
                end
                COMMAND: begin
                    if (we == 1'b1) begin
                        command = write_data[7:0];
                    end
                end
                ADDRESS: begin
                    if (we == 1'b1) begin
                        address = write_data[23:0];
                    end
                end
                DATA_IN: begin
                    if (we == 1'b1) begin
                        data_in = write_data[31:0];
                    end
                end
                DATA_OUT: begin
                    if (re == 1'b1) begin
                        read_data = data_out;
                    end
                end
                // default: 
            endcase
        end
    end

    // Master Slave Interface

    wire cs;
    wire sck;
    wire mosi;
    wire miso;

    spi_master uut_master (
        .clk (clk),
        .rst (rst),
        .en (enable),
        .cs (cs),
        .sck (sck),
        .ext_command_in (command),
        .ext_address_in (address),
        .ext_data_in (data_in),
        .mosi (mosi),
        .miso (miso),
        .ext_data_out (data_out)
    );

    spi_slave uut_slave (
        .clk (clk),
        .rst (rst),
        .cs (cs),
        .sck (sck),
        .mosi (mosi),
        .miso (miso)
    );

endmodule