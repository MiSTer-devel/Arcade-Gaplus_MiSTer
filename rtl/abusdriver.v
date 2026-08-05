
//------------------------------------------------------------------
// Asynchronous-assert / synchronous-de-assert reset synchroniser.
//
// The whole core is reset by signals that are asynchronous to the clock
// domain they are used in (the top level iRST comes from the HPS in the
// MCLK domain, SUB_RESET is produced by the main CPU on the opposite
// clock edge to its consumers).  Using those directly as asynchronous
// reset inputs violates recovery/removal timing, which is what makes the
// core come up dead - black screen and no audio - on a random subset of
// cold starts.
//
// Reset is still applied immediately and asynchronously; only its
// release is retimed, so start-up becomes deterministic.
//
// The output changes on the RISING edge of clk, so instantiate with the
// clock as-is for negedge-triggered logic, or with the inverted clock
// for posedge-triggered logic, to keep half a clock period of margin.
//------------------------------------------------------------------
module reset_sync
(
    input  clk,
    input  arst,
    output rst_o
);

reg [1:0] q = 2'b11;

always @( posedge clk or posedge arst ) begin
    if ( arst ) q <= 2'b11;
    else        q <= { q[0], 1'b0 };
end

assign rst_o = q[1];

endmodule


module busdriver
(
    input iENABLE,
    input iSELECT,

    input [31:0] iBUS0,
    input [31:0] iBUS1,

    output [31:0] oBUS

);

assign oBUS = iENABLE ? ( iSELECT ? iBUS0 : iBUS1 ) : 0;

endmodule


module dataselector2
(
	output [7:0] oDATA,

	input iSEL0,
	input [7:0] iDATA0,

	input iSEL1,
	input [7:0] iDATA1,

	input [7:0] dData
);

assign oDATA = iSEL0 ? iDATA0 :
					iSEL1 ? iDATA1 :
					dData;

endmodule

module dataselector4
(
	output [7:0] oDATA,

	input iSEL0,
	input [7:0] iDATA0,

	input iSEL1,
	input [7:0] iDATA1,

	input iSEL2,
	input [7:0] iDATA2,

	input iSEL3,
	input [7:0] iDATA3,

	input [7:0] dData
);

assign oDATA = iSEL0 ? iDATA0 :
					iSEL1 ? iDATA1 :
					iSEL2 ? iDATA2 :
					iSEL3 ? iDATA3 :
					dData;

endmodule


