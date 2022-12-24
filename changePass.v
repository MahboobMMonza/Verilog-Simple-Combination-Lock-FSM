module changePass(Clk, Resetn, state, inps, newPass);
	input Clk, Resetn;
	input [3:0] inps, state;
	parameter CH = 3'b011, dflt = 4'b0110;
	output reg [3:0] newPass;
	// Initialize password to 0110 at beginning
	initial
	begin
		newPass = dflt;
	end
	// Update password to default if reset occurs
	// Otherwise update it to current input when
	// state of system is in change state
	always @(posedge Clk, negedge Resetn)
	begin
		if (Resetn == 0)	newPass <= dflt;
		else if (state == CH) newPass = inps;
	end
endmodule
