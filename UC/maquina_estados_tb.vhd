library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados_tb is
end;

architecture a_maquina_estados_tb of maquina_estados_tb is
    component maquina_estados is
        port(
            clk, rst: in std_logic;
            estado: out std_logic
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
	
	signal clk, rst, saida: std_logic;
begin 

	a_maquina_estados: maquina_estados port map (
		clk => clk,
		rst => rst,
		estado => saida
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
        wait for 200 ns;
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		wait;
	end process;
	
end architecture;