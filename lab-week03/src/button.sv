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

logic clk_0s25;
clock_dv u_clock_div(
    .clk(clk),
    .rst(rst),
    .out(clk_0s25)
);

logic[3:0] duty_cycle_red;
logic[3:0] duty_cycle_blue;

assign dot = dip;

always_ff @(posedge clk_0s25) begin

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
            else begin
                if (switch == 0) begin
                    if (duty_cycle_red != 9)
                        duty_cycle_red <= duty_cycle_red + 1;
                    else
                        duty_cycle_red <= 0;
                end else begin
                    if (duty_cycle_blue != 9)
                        duty_cycle_blue <= duty_cycle_blue + 1;
                    else
                        duty_cycle_blue <= 0;
                end

            end
            
            
        end

        on_switch: begin            
            state = of_press;
            
        end

        of_press: begin
            if (bt[0])
                state = of_release;
            
        end

        of_release: begin
            if (!bt[0])
                state = of_switch;
            else begin
                if (switch == 0) begin
                    if (duty_cycle_red != 9)
                        duty_cycle_red <= duty_cycle_red + 1;
                    else
                        duty_cycle_red <= 0;
                end else begin
                    if (duty_cycle_blue != 9)
                        duty_cycle_blue <= duty_cycle_blue + 1;
                    else
                        duty_cycle_blue <= 0;
                end

            end
        end

        of_switch: begin
                state = on_press;
        end
    endcase
    duty_cycle <= (switch) ? duty_cycle_blue : duty_cycle_red;
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
    if (switch == 0) begin
        led[0] = (counter < duty_cycle);
        led[1] = 0;
    end else begin
        led[1] = (counter < duty_cycle);
        led[0] = 0;
    end
end

logic switch;

always_ff @(posedge clk_0s25) begin
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
        end
    endcase
end

always_comb begin
    case (state2)
        Start2: switch = 0;
        of_press2: switch = 0;
        of_release2: switch = 0;
        of_switch2: switch = 1;
        on_press2: switch = 1;
        on_release2: switch = 1;
        on_switch2: switch = 0;
        default: switch = 0;
    endcase 
end
endmodule