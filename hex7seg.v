module hex7seg(state, disp);
	input [2:0] state;
	output reg [6:0] disp;
	// Update whenever state is updated
	always @(state)
	begin
		case (state)
			// Show binary to visualize better
			// 010 = 2 -> alarm
			// 011 = 3 -> new password
			// 100 = 4 -> open
			3'b010: disp = 7'b0001000;
			3'b011: disp = 7'b0101011;
			3'b100: disp = 7'b0000001;
			default: disp = 7'b1111110;
		endcase
	end
endmodule
