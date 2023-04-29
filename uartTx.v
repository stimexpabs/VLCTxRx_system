module uart_tx (
  input clk, // Clock input
  input rst, // Reset input
  input [7:0] data_in, // Data input
  input tx_en, // Transmit enable input
  output reg tx_out // Transmitted output
);

  reg [3:0] state; // Transmit state register
  reg [3:0] bit_cnt; // Bit count register
  reg [7:0] shift_reg; // Shift register
  reg parity_bit; // Parity bit
  reg stop_bit; // Stop bit
  reg tx_busy; // Transmission in progress

  // Define states
  localparam IDLE = 0, START = 1, DATA = 2, PARITY = 3, STOP = 4;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      bit_cnt <= 0;
      shift_reg <= 0;
      parity_bit <= 0;
      stop_bit <= 1;
      tx_busy <= 0;
      tx_out <= 1;
    end else begin
      case (state)
        IDLE: begin
          if (tx_en) begin
            state <= START;
            shift_reg <= data_in;
            bit_cnt <= 0;
            parity_bit <= 1;
            stop_bit <= 0;
            tx_busy <= 1;
            tx_out <= 0;
          end
        end
        START: begin
          tx_out <= 0;
          bit_cnt <= bit_cnt + 1;
          state <= DATA;
        end
        DATA: begin
          tx_out <= shift_reg[0];
          shift_reg <= {parity_bit, shift_reg[7:1]};
          parity_bit <= parity_bit ^ shift_reg[7];
          bit_cnt <= bit_cnt + 1;
          if (bit_cnt == 7) begin
            state <= PARITY;
            bit_cnt <= 0;
          end
        end
        PARITY: begin
          tx_out <= parity_bit;
          bit_cnt <= bit_cnt + 1;
          state <= STOP;
        end
        STOP: begin
          tx_out <= 1;
          bit_cnt <= bit_cnt + 1;
          if (bit_cnt == 1) begin
            state <= IDLE;
            tx_busy <= 0;
            stop_bit <= 1;
          end
        end
      endcase
    end
  end
endmodule
