module clk_divider (
  input clk_in, // 100 MHz clock input
  output reg clk_out_1Hz, // 1 Hz clock output
  output reg clk_out_9600Hz // 9600 Hz clock output
);

  reg [26:0] count_1Hz = 0; // Counter for 1 Hz clock
  reg [10:0] count_9600Hz = 0; // Counter for 9600 Hz clock
  parameter DIV_1HZ = 100000000/1; // Divide 100 MHz by 1 Hz
  parameter DIV_9600HZ = 100000000/9600; // Divide 100 MHz by 9600 Hz

  always @(posedge clk_in) begin
    count_1Hz <= count_1Hz + 1; // Increment 1 Hz counter
    count_9600Hz <= count_9600Hz + 1; // Increment 9600 Hz counter

    if (count_1Hz == DIV_1HZ) begin
      clk_out_1Hz <= ~clk_out_1Hz; // Toggle 1 Hz clock output
      count_1Hz <= 0; // Reset 1 Hz counter
    end

    if (count_9600Hz == DIV_9600HZ) begin
      clk_out_9600Hz <= ~clk_out_9600Hz; // Toggle 9600 Hz clock output
      count_9600Hz <= 0; // Reset 9600 Hz counter
    end
  end

endmodule
