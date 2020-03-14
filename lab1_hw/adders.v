`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder
module FA(output C, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(C, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	
// Implement your code here.
// Hint: should be done in 1 line.
// You can use this adder to debug the gate-level implemented adder.
/*B06902100*/
	assign {C3, S} = A+B+C0;
	
endmodule

//  ripple-carry adder, gate level modeling
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	wire[3:0] c;
	assign c[0] = C0;
	assign C3 = c[3];
	FA fa0(c[1], S[0], A[0], B[0], c[0]);
	FA fa1(c[2], S[1], A[1], B[1], c[1]);
	FA fa2(c[3], S[2], A[2], B[2], c[2]);
endmodule

// carry-lookahead adder, gate level modeling
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	
	// Implement your code here.
	/*B06902100*/
	wire[2:0] G, P, C; 
	AND and1(G[0], A[0], B[0]); //generate
	AND and2(G[1], A[1], B[1]);
	AND and3(G[2], A[2], B[2]);
	XOR xor1(P[0], A[0], B[0]); //propagate
	XOR xor2(P[1], A[1], B[1]);
	XOR xor3(P[2], A[2], B[2]);

	assign C[0] = C0;
	wire[6:0] TR; //temp. result
	AND and4(TR[0], P[0], C[0]); //TR[0] = P[0] & C[0]
	AND and5(TR[1], P[1], G[0]); //TR[1] = P[1] & G[0]
	AND and6(TR[2], P[1], TR[0]); //TR[2] = P[1] & P[0] & C[0]
	AND and7(TR[3], P[2], G[1]); //TR[3] = P[2] & G[1]
	AND and8(TR[4], P[2], TR[1]); //TR[4] = P[2] & P[1] & G[0]
	AND and9(TR[5], P[2], TR[2]); //TR[5] = P[2] & P[1] & P[0] & C[0]
	OR or1(TR[6], G[1], TR[1]); //TR[6] = G[1] | (P[1] & G[0])
	OR or2(C[1], G[0], TR[0]); //C[1] = G[0] | (P[0] & C[0])
	OR or3(C[2], TR[6], TR[2]); //C[2] = G[1] | (P[1] & G[0]) | (P[1] & P[0] & C[0])
	OR4 or4(C3, G[2], TR[3], TR[4], TR[5]);
	XOR xor4(S[0], P[0], C[0]);
	XOR xor5(S[1], P[1], C[1]);
	XOR xor6(S[2], P[2], C[2]);
endmodule

`endif

