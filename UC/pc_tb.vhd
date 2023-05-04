library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc_tb is
end;

architecture a_pc_tb of pc_tb is
	component pc is
	port(
		clk, wr_en, rst : in std_logic;
		data_in: in unsigned(23 downto 0);
		data_out: out unsigned(23 downto 0)
	);
	end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    
	signal clk, rst, wr_en : std_logic := '0';
	signal s_data_in  : unsigned(23 downto 0) := (others => '0');
	signal s_data_out : unsigned(23 downto 0) := (others => '0');

begin 

	pc_test : pc port map(
		clk => clk,
		wr_en => wr_en,
		rst => rst,
		data_in => s_data_in,
		data_out => s_data_out
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
        -- Deixa o write enable como 1 por enquanto
		wr_en <= '1';
		rst <= '1';
		wait for 100 ns;
		
		-- A partir daqui, o PC deve contar +1 por clock
		rst <= '0';
        s_data_in <= "000000000000000000000001";
		wait for 100 ns;
        s_data_in <= "000000000000000000000010";
		wait for 100 ns;
        s_data_in <= "000000000000000000000011";
        wait for 100 ns;
        s_data_in <= "000000000000000000000100";
        wait for 100 ns;
        s_data_in <= "000000000000000000000101";
		wait for 100 ns;
        s_data_in <= "000000000000000000000110";
		wait for 100 ns;
        s_data_in <= "000000000000000000000111";
		wait for 100 ns;
        s_data_in <= "000000000000000000001000";
		wait for 100 ns;
        s_data_in <= "000000000000000000001001";
		wait for 100 ns;
        s_data_in <= "000000000000000000001010";
		wait for 100 ns;
        s_data_in <= "000000000000000000001011";
        wait for 1000 ns;
		
		wait;	
	end process;
	
end architecture;