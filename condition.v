module condition(Clk, A, A_pulse);
	input Clk, A;
	output A_pulse;
	// 		 starting	 first press  hold
	parameter ST = 2'b00, PRS = 2'b01, HLD = 2'b10;
	// y tracks the current state
	reg [1:0] y;
	// Update state y at every clock edge
	// No resetting for pulse conditioning
	always @(posedge Clk)
	begin
		case (y)
			// Based on the state of y, assign the next state based on input
			ST:	if (A == 0) y <= ST;
					else			y <= PRS;
			PRS:	if (A == 0) y <= ST;
					else			y <= HLD;
			HLD:	if (A == 0) y <= ST;
					else 			y <= HLD;
			// Don't care
			default:				y <= 2'bxx;
		endcase
	end
	// Pulse output is 1 when current state is PRS
	assign A_pulse = (y == PRS);
endmodule
