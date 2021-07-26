// -----------------------------------------------------------------------------------------
// Version | Programmer                                     | Date       | Remark   
// -----------------------------------------------------------------------------------------
// V1      | Dr Kwen-Siong Chong (kschong@ntu.edu.sg)       | 02/08/2013 | Initial version
// -----------------------------------------------------------------------------------------  
//
// The code is a behavioural code for a state machine
// The code is for teaching purpose in the NTU-TUM class, NM6008. 

module StateMachine (
	CLK, NRST, start, rst,
	CIN, A, B, 
	S, COUT);
	//current_state);

// Initial: input and output declaration
input CLK, NRST, start, rst, CIN, A, B;
output S, COUT;//, current_state;

//
parameter S0 = 2'b00;
parameter S1 = 2'b01;
parameter S2 = 2'b10;
parameter S3 = 2'b11;

//
reg [1:0] state, next_state;
reg S, COUT, S_temp, COUT_temp;

// CLK and NRST: Sequential Logic for the current state logic
always @ (posedge CLK or negedge NRST)
	if (!NRST)
		begin
			state <= S0;
		end
	else // CLK pos edge
		begin
			state <= next_state;
		end

always @ (posedge CLK)
	begin
		S <= S_temp;
		COUT <= COUT_temp;
	end

// Combinational Outputs
//assign S = A ^ B ^ CIN;
//assign COUT = (A & B) | (CIN & (A ^ B));

// State Machine
// always @ (posedge state[0] or posedge state[1] or posedge start or posedge rst)
always @ (state or start or rst)
	case (state)
		S0: begin
				S_temp <= 0;
				COUT_temp <= 0;
				if (start) 
					next_state <= S1;
				else
					next_state <= S0;
				end
			
		S1: begin
				S_temp <= A ^ B ^ CIN;
				COUT_temp <= 0;
				if (rst) // 1 effective
					next_state <= S0;
				else
					next_state <= S2;
				
			end
		S2: begin
				S_temp <= 0;
				COUT_temp <= (A & B) | (CIN & (A ^ B));
				if (rst)
					next_state <= S0;
				else
					next_state <= S3;
				
			end
		S3: begin
				S_temp <= A ^ B ^ CIN;
				COUT_temp <= (A & B) | (CIN & (A ^ B));
				if (rst)
					next_state <= S0;
				else
					next_state <= S1;
				
			end
		//default:
			//begin 
				//state = S0;
			//end
	endcase

endmodule
