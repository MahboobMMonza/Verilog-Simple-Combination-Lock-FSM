module matches(inps, comb, match);
	input [3:0] comb, inps;
	// Just check for a match. Should not cause an issue since
	// clock speed is too fast for intermediate change between
	// checks in FSM.
	output match;
	assign match = (inps == combs);
endmodule
