module tb_eeg_filter;

    // Sanal sinyaller
    reg clk;
    reg reset;
    wire [7:0] clean_out;
    reg [7:0] eeg_memory [999:0]; // 1000 örnek
    reg [7:0] current_eeg;
    integer i;
    integer file;

    // UUT - Unit Under Test
    eeg_filter uut (
        .clk(clk),
        .reset(reset),
        .raw_eeg_data(current_eeg),
        .filtered_eeg_data(clean_out)
    );

    // 10ns periyot
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        i = 0;
        current_eeg = 0;

        $readmemh("raw_eeg_data.hex",eeg_memory);
        file = $fopen("clean_eeg_data.csv","w");
        $fdisplay(file, "Time, Channel");

        #10 reset = 0; // 10ns sonra sistemi başlat
    end

    // EEG verilerini sırayla gönder
    always @(posedge clk) begin
        if (!reset) begin
            current_eeg = eeg_memory[i];       
            $fdisplay(file, "%0t,%d", $time, clean_out);

            i = i + 1;

            if (i == 1000) begin
                $fclose(file);
                $finish
            end
        end
    end