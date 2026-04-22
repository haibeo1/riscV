module tb_alu;

reg [31:0] a, b;
reg [2:0] alu_control;
wire [31:0] result;
wire zero;

integer errors = 0;

// DUT
alu DUT (
    .operand1(a),
    .operand2(b),
    .alu_control(alu_control),
    .alu_result(result),
    .zero(zero)
);

// task check kết quả
task check;
    input [31:0] expected;
    begin
        #10;
        if (result !== expected) begin
            $display("FAIL: a=%d b=%d control=%b -> result=%d (expected %d)", a, b, alu_control, result, expected);
            errors = errors + 1;
        end else begin
            $display("PASS: a=%d b=%d control=%b -> result=%d", a, b, alu_control, result);
        end
    end
endtask

initial begin

    $display("===== ALU TEST START =====");

    // ADD
    alu_control = 3'b000;
    a = 10; b = 5; check(15);
    a = -10; b = 5; check(-5);

    // SUB
    alu_control = 3'b001;
    a = 10; b = 5; check(5);
    a = 5; b = 10; check(-5);

    // AND
    alu_control = 3'b010;
    a = 6; b = 3; check(6 & 3);

    // OR
    alu_control = 3'b011;
    a = 6; b = 3; check(6 | 3);

    // SLL
    alu_control = 3'b100;
    a = 3; b = 2; check(3 << 2);

    // SRL
    alu_control = 3'b111;
    a = 16; b = 2; check(16 >> 2);

    // SLT
    alu_control = 3'b101;
    a = 3; b = 5; check(1);
    a = 5; b = 3; check(0);

    // ZERO FLAG test
    alu_control = 3'b001; // sub
    a = 5; b = 5;
    #1;
    if (zero != 1)
        $display("FAIL ZERO FLAG");
    else
        $display("PASS ZERO FLAG");

    // Tổng kết
    if (errors == 0)
        $display("===== ALL TEST PASSED =====");
    else
        $display("===== %d TESTS FAILED =====", errors);

    $stop;
end

endmodule