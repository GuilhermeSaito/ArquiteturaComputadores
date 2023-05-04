library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
    component rom
    port(   
        clk : in std_logic;
        endereco : in unsigned(23 downto 0);
        dado : out unsigned(15 downto 0)
    );
    end component;
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk    : std_logic;Z
begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            dado <= conteudo_rom(to_integer(endereco));
        end if;
    end process;
end architecture;