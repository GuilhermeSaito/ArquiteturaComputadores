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

    -- Como o registrador 0 do banco de registrador n faz poha nenhuma, vou deixar o acumulador com esse valor
    1  => B"00001_011_000000001",   -- MOV $reg3, 1
    2  => B"01011_011_000001010",   -- LD $reg3, 0xA -- Atribui o valor do reg3 na memoria 10 da RAM
    3  => B"00010_000_000000011",   -- MOV A, $reg3 -- Soma (comeco)
    4  => B"00011_000_000000011",   -- ADD A, $reg3
    5  => B"01001_000_000000100",   -- LD A, 0x4     -- Atribui o valor do acumulador na memoria 4 da RAM
    6  => B"01010_101_000000100",   -- LD $reg5, 0x4 -- Atribui o valor da memoria 4 da RAM no registrador 5
    7  => B"01010_110_000001010",   -- LD $reg6, 0xA -- Atribui o valor da memoria 10 da RAM no registrador 6
    8  => B"00001_001_110011000",   -- MOV $reg1 408,
    9  => B"00010_000_000000001",   -- MOV A, $reg1  -- Atribui o valor do reg1 para o Acumulador
    10 => B"01001_000_000101110",   -- LD A, 0x3f     -- Atribui o valor do acumulador na memoria 63 da RAM
    11 => B"01010_111_000101110",   -- LD $reg7, 0x3f -- Atribui o valor da memoria 63 da RAM no registrador 7
    12 => B"00001_010_100100011",   -- MOV $reg2 291,
    13 => B"00010_000_000000010",   -- MOV A, $reg2  -- Atribui o valor do reg2 para o Acumulador
    14 => B"01001_000_000011101",   -- LD A, 0x1d     -- Atribui o valor do acumulador na memoria 29 da RAM
    15 => B"01010_100_000011101",   -- LD $reg4, 0x1d -- Atribui o valor da memoria 29 da RAM no registrador 4
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