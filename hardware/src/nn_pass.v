module nn_pass_l1(
    input wire i_clk,
    input i_data_ready,
    input [27:0] i_row, // row pixel input
    output reg [63:0] o_pass_result // result of forward pass
);

reg [27:0] rom [0:1791]; // this will be the 784 -> 64 layer
reg [4:0] BNN_THRESHOLD = 5'd14; 

reg [4:0] row_no = 5'd0; // row number
reg [5:0] neuron_no = 6'd0; // neuron number

reg [10:0] rom_addr = 11'd0;
reg [27:0] current_weights;

reg [9:0] l1_pass_acc [63:0];

reg [4:0] prev_row_no = 5'd0; // row number
reg [5:0] prev_neuron_no = 6'd0; // neuron number
reg prev_proc = 0;

initial begin
    $readmemb("l1_weights.txt", rom); 
end

reg inf_started = 0;
reg processing = 0;

always @(posedge i_clk) begin
    current_weights <= rom[rom_addr];

    prev_neuron_no <= neuron_no;
    prev_row_no <= row_no;
    prev_proc <= processing;

    if(!inf_started && i_data_ready) begin
        inf_started <= 1;
        neuron_no <= 0;
        rom_addr <= row_no;
        processing <= 1;
    end else if(!i_data_ready) begin
        inf_started <= 0;
    end

    if (processing) begin
        if (neuron_no == 63) begin
            processing <= 0;
            if (row_no == 27) begin
                row_no <= 0;
            end else begin
                row_no <= row_no + 1;
            end
        end else begin
            neuron_no <= neuron_no + 1;
            rom_addr <= rom_addr + 28;
        end
    end

    if (prev_proc) begin
        wire [4:0] counted = popcount(~(i_row ^ current_weights));
        wire [9:0] acc_val = (prev_row_no == 0) ? counted : (l1_pass_acc[prev_neuron_no] + counted);
        
        l1_pass_acc[prev_neuron_no] <= acc_val;
        
        if (prev_row_no == 27) begin
            o_pass_result[prev_neuron_no] <= (acc_val > BNN_THRESHOLD);
        end
    end
end

endmodule

function [4:0] popcount;
    input [27:0] i_bits;
    integer i;
    begin
        popcount = 0;
        for (i = 0; i < 28; i = i + 1) begin
            popcount = popcount + i_bits[i];
        end
    end
endfunction