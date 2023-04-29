module uart_rx (
  input clk, // Clock input
  input rst, // Reset input
  input rx_in, // Received input
  output reg [7:0] data_out, // Received data output
  output reg rx_valid // Receive valid output
);

  reg [3:0] state; // Receive state register
  reg [3:0] bit_cnt; // Bit count register
  reg [7:0] shift_reg; // Shift register
  reg parity_bit; // Parity bit
  reg start_bit; // Start bit
  reg rx_busy; // Reception in progress

  // Define states
  localparam IDLE = 0, START = 1, DATA = 2, PARITY = 3, STOP = 4;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      bit_cnt <= 0;
      shift_reg <= 0;
      parity_bit <= 0;
      start_bit <= 1;
      rx_busy <= 0;
      data_out <= 0;
      rx_valid <= 0;
    end else begin
      case (state)
        IDLE: begin
          if (!rx_in) begin
            state <= START;
            shift_reg <= 0;
            bit_cnt <= 0;
            parity_bit <= 1;
            start_bit <= 0;
            rx_busy <= 1;
          end
        end
        START: begin
          bit_cnt <= bit_cnt + 1;
          if (bit_cnt == 1) begin
            state <= DATA;
          end
        end
        DATA: begin
          shift_reg <= {shift_reg[6:0], rx_in};
          parity_bit <= parity_bit ^ rx_in;
          bit_cnt <= bit_cnt + 1;
          if (bit_cnt == 8) begin
            state <= PARITY;
            bit_cnt <= 0;
          end
        end
        PARITY: begin
          bit_cnt <= bit_cnt + 1;
          if (bit_cnt == 1) begin
            if (parity_bit == rx_in) begin
              state <= STOP;
            end else begin
              state <= IDLE;
              rx_busy <= 0;
              start_bit <= 1;
            end
          end
        end
        STOP: begin
          bit_cnt <= bit_cnt + 1;
          if (bit_cnt == 2) begin
            state <= IDLE;
            rx_valid <= 1;
            rx_busy <= 0;
            start_bit <= 1;
            data_out <= shift_reg;
          end
        end
      endcase
    end
  end
endmodule
