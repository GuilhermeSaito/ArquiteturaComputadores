library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( clk : in std_logic;
    endereco : in unsigned(23 downto 0);
    dado : out unsigned(16 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant conteudo_rom : mem := (
    -- ------------------------------ Intrucoes arbitradas ------------------------------
    -- O ACUMULADOR SERA O REGISTRADOR 8

    -- ------- Carregar registrador com constante
    -- Formato do binario: opcode_regdestino_constante
    -- ------- Somar e Subtrair
    -- Formato do binario: opcode_acumulador_reg1 -- Carregar o valor do registrador no acumulador
    -- Formato do binario: opcode_acumulador_reg1 -- Somar o valor do acumulador com o outro registrador e armazenar no acumulador
    -- Formato do binario: opcode_reg1_acumulador -- Carregar o valor do acumulador no registrador
    -- ------- Jump
    -- Formato do binario: opcode_enderecoDestino
    -- ------- Atribuir valor de 1 registrador para o outro
    -- Formato do binario: opcode_acumulador_reg1 -- Atribui o valor do registrador para o acumulador
    -- Formato do binario: opcode_reg1_acumulador -- Atribui o valor do acumulador para o registrador

    0  => B"00000000000000000",     -- Nop
    1  => B"00001_011_000000000",   -- MOV $reg3, 0
    2  => B"00001_100_000000000",   -- MOV $reg4, 0
    3  => B"00010_000001000_011",   -- LD A, $reg3 -- Soma (comeco)
    4  => B"00011_0000010_00100",   -- ADD A, $reg4
    5  => B"00110_000001000_100",   -- LD A, $reg4    -- Atribui o valor do acumulador no registrador
    6  => B"00010_000001000_011",   -- LD A, $reg3 -- Soma (comeco)
    7  => B"00111_0000010_00001",   -- ADD A, 1
    8  => B"00110_000001000_011",   -- LD A, $reg3    -- Atribui o valor do acumulador no registrador
    9  => B"00110_000001000_011",   -- LD A, $reg3    -- Atribui o valor do registrador desejado para o Acumulador, nesse caso especifico n precisaria estar aqui
    10 => B"00100_0000010_11110",   -- SUB $acumulador, 30
    11 => B"01000_000000000111",    -- JREQ -7
    12 => B"00010_000001000_100",   -- LD A, $reg4
    13 => B"00110_000001000_101",   -- LD A, $reg5    -- Atribui o valor do acumulador no registrador
    others => (others=>'0')
 );
 
begin
    process(clk)
    begin
    if(rising_edge(clk)) then
        dado <= conteudo_rom(to_integer(endereco));
    end if;
    end process;
end architecture;