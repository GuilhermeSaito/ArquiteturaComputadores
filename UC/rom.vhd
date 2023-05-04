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
    -- caso endereco => conteudo
    0  => "00000000000000010",
    1  => "00000100000000000",
    2  => "11110000000000110", -- jump para 7
    3  => "00000000000000000",
    4  => "00000100000000000",
    5  => "00000000000000010",
    6  => "00000111100000011",
    7  => "11110000000000010", -- jump pra 10
    8  => "00000000000000010",
    9  => "00000000000000000",
    10 => "00000000000000001",
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