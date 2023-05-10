library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( clk : in std_logic;
    endereco : in unsigned(23 downto 0);
    dado : out unsigned(15 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(15 downto 0);
    constant conteudo_rom : mem := (
    -- caso endereco => conteudo
    -- Formato do binario: opcode_reg1_reg2_regdest_shift
    -- Formato do binario: opcode_reg1_constante_regdest
    -- Formato do binario: opcode_enderecoDestino

    -- 0000 = Nop
    -- 0001 = Carregar registrador com constante
    -- 0010 = Somar registrador com registrador
    -- 0011 = Somar registrador com constante
    -- 0100 = Subtrair registrador com registrador
    -- 0101 = Subtrair registrador com constante
    -- 0110 = Jump
    -- 0111 = Atribuicao indireta <-- Como vai fazer
    0  => B"0000_000_000_000_000",
    1  => B"0001_000_000101_011",  -- Carrega R3 com 5
    2  => B"0001_000_001000_100",  -- Carregar R4 com valor 8
    3  => B"0010_011_100_101_000", -- Soma reg r3 e r4 para o r5
    4  => B"0101_000_000001_101",  -- Subtrair 1 de r5
    5  => B"0110_000000010100",    -- Salta para endereco 20
    6  => B"0110_111_100_000_000",
    7  => B"0111_000_000_000_000", 
    8  => B"0000_000_000_000_000",
    9  => B"0000_000_000_000_000",
    10 => B"0000_000_000_000_000",
    -- abaixo: casos omissos => (zero em todos os bits)
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