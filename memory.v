module Memory #(
    parameter MEMORY_FILE = "",
    parameter MEMORY_SIZE = 4096
)(
    input  wire        clk,

    input  wire        rd_en_i,    // Indica uma solicitação de leitura
    input  wire        wr_en_i,    // Indica uma solicitação de escrita

    input  wire [31:0] addr_i,     // Endereço
    input  wire [31:0] data_i,     // Dados de entrada (para escrita)
    output wire [31:0] data_o,     // Dados de saída (para leitura)

    output wire        ack_o       // Confirmação da transação
);

reg [31:0]  mem[0:MEMORY_SIZE];

initial 
begin
    if( MEMORY_FILE != "" )
    begin
        $readmemh( MEMORY_FILE, mem );
    end    
end

always @( posedge clk ) 
begin
    if( wr_en_i == 1 )
    begin
        mem[addr_i[31:2]] <= data_i;
    end    
end

assign data_o   = ( rd_en_i ) ? mem[addr_i[31:2]] : 32'bx;
assign ack_o    = wr_en_i | rd_en_i;

endmodule
