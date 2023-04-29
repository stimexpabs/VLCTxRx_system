module ram_1024x8 (
  input clk, // Clock input
  input we, // Write enable input
  input [9:0] addr, // Address input
  input [7:0] din, // Data input
  output reg [7:0] dout // Data output
);

  reg [7:0] ram [0:1023]; // RAM array

  always @(posedge clk) begin
    if (we) begin
      ram[addr] <= din; // Write data to RAM
    end else begin
      dout <= ram[addr]; // Read data from RAM
    end
  end
endmodule
