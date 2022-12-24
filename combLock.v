module combLock(inps, ent, chg, Clk, Resetn, disp);
input [3:0] inps;
input Clk, Resetn, ent, chg;
output [6:0] disp;
wire [3:0] comb;
reg [2:0] curState;
wire epls, cpls, m;
parameter ST = 3'b000, I1C = 3'b001, ALR = 3'b010, CH = 3'b011, OP = 3'b100;
// Condition the enter and change presses
condition eps (.Clk(Clk), .A(ent), .A_pulse(epls));
condition cps (.Clk(Clk), .A(chg), .A_pulse(cpls));
// Check for a match between input and saved password
match mtc (.inps(inps), .comb(comb), .matches(m));
// The input can be checked instantaneously inside of the always block,
// but since the clock speed is much faster than human interactions, there
// is no need to check inside of a statement. Instead, check can be done
// earlier and remembered until next clock edge.

// Update the state of the system
always @(posedge Clk, negedge Resetn)
begin
// Reset condition
if (Resetn == 0)
	curState <= ST;
else
	// Case analysis of current state. Matches conditions
	// determined in FSM diagram
	// An enter press is given priority over change press, as
	// it is assumed in the system that the person presses them
	// exclusively
	case (curState)
		ST:
		begin
			if ((epls || cpls) && !m)	curState <= I1C;
			else if (epls && m)	curState <= OP;
			else if (cpls && m)	curState <= CH;
			else	curState <= ST;
		end
		I1C:
		begin
			if ((epls || cpls) && !m)	curState <= ALR;
			else if (epls && m)	curState <= OP;
			else if (cpls && m)	curState <= CH;
			else	curState <= I1C;
		end
		ALR:
		begin
			curState <= ALR;
		end
		CH:
		begin
			if (epls || cpls) 	curState <= ST;
			else	curState <= CH;
		end
		OP:
		begin
			if (epls)	curState <= ST;
			else	curState <= OP;
		end
	endcase
end

// Update the password if it needs updating
// Update can be done at next clock state because clock frequency is much faster than human
// reaction times.
changePass newPwd (.Clk(Clk), .Resetn(Resetn), .state(curState), .inps(inps), .newPass(comb));
// Update the output based on the current state
hex7seg upd (.state(curState), .disp(disp));
endmodule
