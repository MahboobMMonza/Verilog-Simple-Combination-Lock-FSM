module match(inps, comb, matches);
	input [3:0] comb, inps;
	// Remember the match value for a clock cycle to
	// regulate matching. Should not pose issue since
	// clock cycle is much faster than human speed.
	output reg matches;
	always @(comb, inps)
	begin
		matches = (inps == comb);
	end
endmodule
