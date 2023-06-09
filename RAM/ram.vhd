library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram is
    port(
        clk : in std_logic;
        endereco_RAM : in unsigned(6 downto 0);
        wr_en_RAM : in std_logic;
        dado_in_RAM : in unsigned(15 downto 0);
        dado_out_RAM : out unsigned(15 downto 0)
    );
end entity;

architecture a_ram of ram is

type mem is array (0 to 127) of unsigned(15 downto 0);
signal conteudo_ram : mem;

begin
    process(clk, wr_en_RAM)
    begin
        if rising_edge(clk) then
            if wr_en_RAM='1' then
                conteudo_ram(to_integer(endereco_RAM)) <= dado_in_RAM;
            end if;
        end if;
    end process;
    dado_out_RAM <= conteudo_ram(to_integer(endereco_RAM));
end architecture;