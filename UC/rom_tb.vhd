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
        dado : out unsigned(16 downto 0)
    );
    end component;

signal clk, rst : std_logic := '0';
signal endereco  : unsigned(23 downto 0);
signal dado : unsigned(16 downto 0);
constant period_time : time      := 100 ns;
signal   finished    : std_logic := '0';

begin
    uut: rom port map(
        clk => clk,
        endereco => endereco,
        dado => dado 
    );

    reset_global: process -- reseta todas as componentes
    begin
        rst <= '1';
        wait for period_time*2;
        rst <= '0';
        wait;
    end process;

    sim_time_proc: process -- Marca o tempo total da simulação
    begin
        wait for 10 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_process: process -- gera sinal de clock
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_process;

    process
	begin
        wait for 100 ns;
		rst <= '1';
		wait for 200 ns;
		rst <= '0';
        endereco <= "000000000000000000000001";
		wait for 100 ns;
        endereco <= "000000000000000000000010";
		wait for 100 ns;
        endereco <= "000000000000000000000011";
        wait for 100 ns;
        endereco <= "000000000000000000000100";
        wait for 100 ns;
        endereco <= "000000000000000000000101";
		wait for 100 ns;
        endereco <= "000000000000000000000110";
		wait for 100 ns;
        endereco <= "000000000000000000000111";
		wait for 100 ns;
        endereco <= "000000000000000000001000";
		wait for 100 ns;
        endereco <= "000000000000000000001001";
		wait for 100 ns;
        endereco <= "000000000000000000001010";
		wait for 100 ns;
        endereco <= "000000000000000000001011";
        wait for 1000 ns;
		wait;	
	end process;

end architecture;