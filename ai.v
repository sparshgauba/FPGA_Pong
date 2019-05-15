module ai (
input wire ball_y,
input wire 15hzClock,
output wire paddle_location
);

reg [8:0] ai_target;
integer count = 0;

always @(clock)

if (ball_run > 0 )begin  //moving towards computer's side, idk if pos or neg
 if (count == 7 ) begin 
	ai_target <= ball_y; 
	count = 0;
	end 
 else 
	count = count + 1;
	
 if ball_location > paddle_location 
	paddle_rise = 1;
 else if ball_y < paddle_location 
	paddle_rise = -1;
end 
else 
	count = 0;

endmodule
	

