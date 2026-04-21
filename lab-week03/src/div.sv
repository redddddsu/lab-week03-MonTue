module clock_dv
(
    input wire clk,
    input wire rst,

    output wire out
);

logic [63:0] clk_div_counter;
wire clks_50ms;

assign clks_50ms = clk_div_counter[20]; // assuming 25MHz toggle roughly every 0.25s

assign out = clks_50ms;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        clk_div_counter <= 0;
    end else begin
        clk_div_counter <= clk_div_counter + 1;
    end
end

endmodule
