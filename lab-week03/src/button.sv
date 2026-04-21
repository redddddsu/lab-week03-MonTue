`include "src/div.sv"

module button(
    input wire clk,
    input wire rst,
    input wire[1:0] bt,
    input wire dip,
    output logic[1:0] led,
    output logic[3:0] duty_cycle,
    output logic dot,
    output logic[3:0] seg7
);



typedef enum logic [2:0]{Start, of_press, of_release, of_switch, on_press, on_release, on_switch} state_b;
state_b state = Start;

typedef enum logic [2:0]{Start2, of_press2, of_release2, of_switch2, on_press2, on_release2, on_switch2} state_b2;
state_b2 state2 = Start2;

logic clks_50ms;
clock_dv u_clock_div(
    .clk(clk),
    .rst(rst),
    .out(clks_50ms)
);

logic[3:0] duty_cycle_red;
logic[3:0] duty_cycle_blue;

assign dot = dip;

always_ff @(posedge clks_50ms) begin

    case (state)
        Start: begin
            duty_cycle <= 0;
            state = of_press;
            seg7 <= 0;
        end

        on_press: begin
            if (bt[0])
                state = on_release;
        end

        on_release: begin
            if (!bt[0])
                state = on_switch;
        end

        on_switch: begin            
            state = of_press;
            if (duty_cycle_red != 9)
                duty_cycle_red <= duty_cycle_red + 1;
            else
                duty_cycle_red <= 0;
            
        end

        of_press: begin
            if (bt[0])
                state = of_release;
            
        end

        of_release: begin
            if (!bt[0])
                state = of_switch;
        end

        of_switch: begin
            state = on_press;
            if (duty_cycle_red != 9)
                duty_cycle_red <= duty_cycle_red + 1;
            else
                duty_cycle_red <= 0;
        end
    endcase
    seg7 <= (dip) ? duty_cycle_blue : duty_cycle_red;

end

logic[3:0] counter;
always_ff @ (posedge clk) begin
    if (counter == 9)
        counter <= 0;
    else
        counter <= counter + 1;
end

always_comb begin
    led[0] = (counter < duty_cycle_red);
    led[1] = (counter < duty_cycle_blue);
end

logic switch;

always_ff @(posedge clks_50ms) begin
    case (state2)
        Start2: begin
            state2 = of_press2;
        end

        on_press2: begin
            if (bt[1])
                state2 = on_release2;
        end

        on_release2: begin
            if (!bt[1])
                state2 = on_switch2;
        end

        on_switch2: begin            
            state2 = of_press2;
            if (duty_cycle_blue != 9)
                duty_cycle_blue <= duty_cycle_blue + 1;
            else
                duty_cycle_blue <= 0;
        end

        of_press2: begin
            if (bt[1])
                state2 = of_release2;
        end

        of_release2: begin
            if (!bt[1])
                state2 = of_switch2;
        end

        of_switch2: begin
                state2 = on_press2;
                if (duty_cycle_blue != 9)
                    duty_cycle_blue <= duty_cycle_blue + 1;
                else
                    duty_cycle_blue <= 0;
        end
    endcase
end
endmodule