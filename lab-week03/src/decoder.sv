module decoder (
    /** Input Ports */
    /** Output Ports */
    input wire [3:0] bcd,
    output logic [6:0] seg7
);

/** Logic */


always @ (bcd)
    begin
        if (bcd == 4'b0000) // 0
            seg7 = 7'b1111110;
        else if (bcd == 4'b0001) // 1
            seg7 = 7'b0110000;
        else if (bcd == 4'b0010) // 2
            seg7 = 7'b1101101;
        else if (bcd == 4'b0011) // 3
            seg7 = 7'b1111001;
        else if (bcd == 4'b0100) // 4
            seg7 = 7'b0110011;
        else if (bcd == 4'b0101) // 5
            seg7 = 7'b1011011;
        else if (bcd == 4'b0110) // 6
            seg7 = 7'b1011111;
        else if (bcd == 4'b0111) // 7
            seg7 = 7'b1110000;
        else if (bcd == 4'b1000) // 8
            seg7 = 7'b1111111;
        else if (bcd == 4'b1001) // 9
            seg7 = 7'b1111011;
        else if (bcd == 4'b1010) // A
            seg7 = 7'b1110111;
        else if (bcd == 4'b1011) // B
            seg7 = 7'b0011111;
        else if (bcd == 4'b1100) // C
            seg7 = 7'b1001110;
        else if (bcd == 4'b1101) // D
            seg7 = 7'b0111101;
        else if (bcd == 4'b1110) // E
            seg7 = 7'b1001111;
        else if (bcd == 4'b1111) // F
            seg7 = 7'b1000111;
        else
            seg7 = 7'b0000001;
    end


endmodule