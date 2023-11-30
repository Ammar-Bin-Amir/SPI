module spi_slave (
    input wire clk,
    input wire rst,
    // Chip Select
    input wire cs,
    // Serial Clock
    input wire sck,
    // Master Out Slave In
    input wire mosi,
    // Master In Slave Out
    output reg miso
);

    reg [5:0] data_count;
    reg data_end;

    always @(posedge clk) begin
        if (rst) begin
            data_count <= 0;
            data_end <= 0;
        end
        else begin
            if (current_state == DATA) begin
                if (sck == 1) begin
                    if (data_count == 63) begin
                        data_count <= 0;
                        data_end <= 1;
                    end
                    else begin
                        data_count <= data_count + 1;
                        data_end <= 0;
                    end
                end
                else begin
                    data_count <= data_count;
                    data_end <= 0;
                end
            end
            else begin
                data_count <= 0;
                data_end <= 0;
            end
        end
    end

    // Master Out Slave In

    reg [7:0] command_save;
    reg [23:0] address_save;
    reg [31:0] data_save;

    always @(posedge sck) begin
        if (rst) begin
            command_save <= 0;
            address_save <= 0;
            data_save <= 0;
        end
        else begin
            if (current_state == DATA) begin
                // Command, address and data saved from MOSI line from MSB respectively
                if ((data_count >= 0) && (data_count < 8)) begin
                    command_save <= {command_save[6:0],mosi};
                end
                else if ((data_count >= 8) && (data_count < 32)) begin
                    address_save <= {address_save[22:0],mosi};
                end
                else if ((data_count >= 32) && (data_count <= 63)) begin
                    data_save <= {data_save[30:0],mosi};
                end
                else begin
                    command_save <= command_save;
                    address_save <= address_save;
                    data_save <= data_save;
                end        
            end
            else begin
                command_save <= command_save;
                address_save <= address_save;
                data_save <= data_save;
            end
        end
    end

    // Master In Slave Out

    reg [31:0] data_out;

    always @(negedge sck) begin
        if (rst) begin
            data_out <= 0;
        end
        else begin
            if (current_state == DATA) begin
                if ((data_count > 1) && (data_count < 8)) begin
                    data_out <= data_save;
                end
                else if ((data_count >= 8) && (data_count <= 63)) begin
                    // Data shifted serially on MISO line from MSB respectively
                    if ((data_count > 32) && (data_count <= 63)) begin
                        data_out <= {data_out[30:0],1'b0};
                    end
                    else begin
                        data_out <= data_out;
                    end
                end
                else begin
                    data_out <= data_out;
                end
            end
            else begin
                data_out <= data_out;
            end
        end
    end

    // Finite State Machine

    localparam IDLE = 2'b00;
    localparam DATA = 2'b10;
    localparam DISABLE = 2'b11;

    reg [1:0] current_state, next_state;

    always @(posedge clk) begin
        if (rst) begin
            current_state <= 0;
        end
        else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        if (rst) begin
            next_state = 0;
        end
        else begin
            case (next_state)
                IDLE: begin
                    miso = 0;
                    if (cs == 1'b0) begin
                        next_state = DATA;
                    end
                end
                DATA: begin
                    if ((data_count >= 32) && (data_count <= 63)) begin
                        // Data shifted serially on MOSI line from MSB respectively on command ALL ONES
                        if (command_save == 8'hff) begin
                            miso = data_out[31];
                        end
                        else begin
                            miso = 0;
                        end
                        
                    end
                    else begin
                        miso = 0;
                    end            
                    
                    if (data_end == 1'b1) begin
                        next_state = DISABLE;
                    end
                end
                DISABLE: begin
                    miso = 0;
                    if (cs == 1'b1) begin
                        next_state = IDLE;
                    end
                end
                default: next_state = IDLE;
            endcase
        end
    end

endmodule