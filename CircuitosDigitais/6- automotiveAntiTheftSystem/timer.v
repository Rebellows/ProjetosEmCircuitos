module timer (
    input clock, reset,
    input [3:0] value,
    input start_timer,
    output reg one_hz_enable, two_hz_enable, expired,
    output reg [3:0] timer_count
);

    reg [26:0] counter_1hz;  
    reg [25:0] counter_2hz;
    reg aux;  

    parameter ONE_HZ_MAX = 100_000_000;  
    parameter TWO_HZ_MAX = 50_000_000; 

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            counter_1hz <= 0;
            counter_2hz <= 0;
            one_hz_enable <= 0;
            two_hz_enable <= 0;
            expired <= 0;
            timer_count <= 4'b1111;
            aux <= 0;
        end
        else if (start_timer && !aux) begin
            counter_1hz <= 0;
            counter_2hz <= 0;
            one_hz_enable <= 0;
            two_hz_enable <= 0;
            expired <= 0;
            timer_count <= value;    
            aux <= 1;        
        end
        else begin
            if (counter_1hz >= ONE_HZ_MAX - 1) begin
                counter_1hz <= 0;
                one_hz_enable <= 1'b1;
            end
            else begin
                counter_1hz <= counter_1hz + 1;
                one_hz_enable <= 1'b0;
            end
            if (counter_2hz >= TWO_HZ_MAX - 1) begin
                counter_2hz <= 0;
                two_hz_enable <= 1'b1;
            end
            else begin
                counter_2hz <= counter_2hz + 1;
                two_hz_enable <= 1'b0;
            end
            if (aux) begin
                if (one_hz_enable) begin
                    if (timer_count > 0) begin
                        timer_count <= timer_count - 1;
                    end
                end
                else if (timer_count == 0) begin
                    expired <= 1'b1;
                    aux <= 0;
                end
            end            
        end
    end
endmodule
