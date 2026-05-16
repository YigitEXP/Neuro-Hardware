module eeg_filter(
    input clk,
    input reset,
    input [7:0] raw_eeg_data,
    output reg [7:0] filtered_eeg_data
);

reg [7:0] r1,r2,r3,r4;
reg [9:0] sum; // Nöbet veya diş sıkma gibi anda gelen 220 voltajlı veriler olsun. Bizim 8 bitlik 0-255 kapasitemizi aştığı için 10 bitlik bir toplam kullanıyoruz.

always @(posedge clk) begin
    if(reset) begin
        r1 <= 0; r2 <= 0; r3 <= 0; r4 <= 0;
        filtered_eeg_data <= 0;
    end
    else begin
        r1 <= raw_eeg_data;
        r2 <= r1; 
        r3 <= r2;
        r4 <= r3;

        filtered_eeg_data <= (r1 + r2 + r3 + r4) >> 2; 
    end
end
endmodule