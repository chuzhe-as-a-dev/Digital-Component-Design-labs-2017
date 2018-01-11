//=============================================
// ? Verilog HDL ????????????????????????????????
// ??????????????????????????????
// ?????????????????????????????????????????????
//
// ??CPU???????????????????????
// ???I/O???????????????
// =============================================

`timescale 1ps/1ps            // ??????/????

// ?1???????/??????????1?10?100
// ?2??????????????????????
// ?3????????????????????????????????????
//     ?????s/??ms/???us/???ns/???ps/???fs/???10?15????

module pl_computer_sim;
    // inputs
    reg clock, mem_clock, resetn;
    reg [12:0] io_in;

    // outputs
    wire [31:0] pc, inst, ealu, malu, walu;
    wire [44:0] io_out;

    pl_computer pl_computer_instance(resetn, clock, mem_clock, pc, inst, ealu, malu, walu, io_in, io_out);

    // IO mapping
    wire [3:0] hex0_num,hex1_num,hex2_num,hex3_num,hex4_num,hex5_num;
    segs2digit hex0(io_out[6:0], hex0_num);
    segs2digit hex1(io_out[13:7], hex1_num);
    segs2digit hex2(io_out[20:14], hex2_num);
    segs2digit hex3(io_out[27:21], hex3_num);
    segs2digit hex4(io_out[34:28], hex4_num);
    segs2digit hex5(io_out[41:35], hex5_num);

    initial begin
        io_in = 0;
        clock = 1;
        while (1) begin
            #2 clock = ~clock;
        end
    end

    always @ ( * ) begin
        mem_clock = ~clock;
    end

    always @ (posedge clock) begin
        io_in[4:0] = io_in[4:0] + 3;
        io_in[9:5] = io_in[9:5] + 2;
        if (io_in[10] == 0)
            io_in[12:10] = 3'b101;
        else if (io_in[11] == 0)
        	io_in[12:10] = 3'b011;
        else
        	io_in[12:10] = 3'b110;
    end

    initial begin
        resetn = 0;            // ?????10??????????1?
        while (1) begin
            #5 resetn = 1;
        end
    end

    initial begin
        $display($time,"resetn=%b clock_50M=%b  mem_clock =%b", resetn, clock, mem_clock);
    end
endmodule

module segs2digit(segs, digit);
    input [6:0] segs;

    output reg [3:0] digit;

    always @ ( * ) begin
        case(segs)
            7'b100_0000: digit = 0;
            7'b111_1001: digit = 1;
            7'b010_0100: digit = 2;
            7'b011_0000: digit = 3;
            7'b001_1001: digit = 4;
            7'b001_0010: digit = 5;
            7'b000_0010: digit = 6;
            7'b111_1000: digit = 7;
            7'b000_0000: digit = 8;
            7'b001_0000: digit = 9;
            7'b000_1000: digit = 10;
            7'b000_0011: digit = 11;
            7'b100_0110: digit = 12;
            7'b010_0001: digit = 13;
            7'b000_0110: digit = 14;
            7'b000_1110: digit = 15;
            default: digit = 0;
        endcase
    end
endmodule // seg2digit
