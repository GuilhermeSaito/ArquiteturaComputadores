library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( clk : in std_logic;
    endereco : in unsigned(23 downto 0);
    dado_rom : out unsigned(16 downto 0)
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
    1  => B"00001_011_000000101",   -- LD $reg3 5
    -- 2  => B"00001_100_000001000",   -- LD $reg4 8
    -- 3  => B"00010_000001000_011",   -- MOV $acumulador, $reg3 -- Soma (comeco)
    -- 4  => B"00011_000001000_100",   -- ADD $acumulador, $reg4
    -- 5  => B"00110_000001000_101",   -- MOV $acumulador, $reg5    -- Atribui o valor do acumulador no registrador
    -- 6  => B"00010_000001000_101",   -- MOV $acumulador, $reg5 -- Subtracao (comeco)
    -- 7  => B"00100_000001000_001",   -- SUB $acumulador, contante1
    -- 8  => B"00110_000001000_101",   -- MOV $acumulador, $reg5    -- Atribui o valor do acumulador no registrador
    -- 9  => B"00101_000000010100",    -- Jump para instrucao 20
    -- 20 => B"00010_000001000_101",   -- MOV $acumulador, $reg5
    -- 21 => B"00110_000001000_011",   -- MOV $acumulador, $reg3    -- Atribui o valor do acumulador no registrador
    -- 22 => B"00101_000000000011",    -- Jump para instrucao 3
    -- abaixo: casos omissos => (zero em todos os bits)
    others => (others=>'0')
 );
 
begin
    process(clk)
    begin
    if(rising_edge(clk)) then
        dado_rom <= conteudo_rom(to_integer(endereco));
    end if;
    end process;
end architecture;