//-----------------------------------------------------
// This is simple adder Program
// Design Name : adder_explicit
// File Name   : adder_explicit.v
// Function    : Here the name should match 
// with the leaf module, the order is not important.
// Coder       : Deepak Kumar Tala
//-----------------------------------------------------
module adder_explicit (
result        , // Output of the adder
carry         , // Carry output of adder
r1            , // first input
r2            , // second input
ci              // carry input
);

// Input Port Declarations       
input    [3:0]   r1         ;
input    [3:0]   r2         ;
input            ci         ;

// Output Port Declarations
output   [3:0]  result      ;
output          carry       ;

// Port Wires
wire     [3:0]    r1        ;
wire     [3:0]    r2        ;
wire              ci        ;
wire     [3:0]    result    ;
wire              carry     ;

// Internal variables
wire              c1        ;
wire              c2        ;
wire              c3        ;

// Code Starts Here
addbit u0 (
.a           (r1[0])        ,
.b           (r2[0])        ,
.ci          (ci)           ,
.sum         (result[0])    ,
.co          (c1)
);

addbit u1 (
.a           (r1[1])        ,
.b           (r2[1])        ,
.ci          (c1)           ,
.sum         (result[1])    ,
.co          (c2)
);

addbit u2 (
.a           (r1[2])        ,
.b           (r2[2])        ,
.ci          (c2)           ,
.sum         (result[2])    ,
.co          (c3)
);

addbit u3 (
.a           (r1[3])        ,
.b           (r2[3])        ,
.ci          (c3)           ,
.sum         (result[3])    ,
.co          (carry)
);

endmodule // End Of Module adder
