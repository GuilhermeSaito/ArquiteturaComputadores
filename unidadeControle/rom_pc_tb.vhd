library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_pc_tb is
end;

architecture a_rom_pc_tb of rom_pc_tb is
	component program_counter is
	port(
		clk, wr_en, rst : in std_logic;
		data_in: in unsigned(23 downto 0);
		data_out: out unsigned(23 downto 0)
	);
	end component;

    component rom is
    port(
        clk : in std_logic;
        endereco : in unsigned(23 downto 0);
        dado : out unsigned(16 downto 0)
    );
    end component;

	component soma1_pc is 
	port (
		pc_now: in unsigned(23 downto 0);
		pc_next: out unsigned(23 downto 0)
	);
	end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    
	signal clk, rst, wr_en : std_logic := '0';
	signal s_data_in  : unsigned(23 downto 0) := (others => '0');
	signal s_data_out : unsigned(23 downto 0) := (others => '0');
    signal saida_dado_rom : unsigned(16 downto 0);

begin 
	pc_soma : soma1_pc port map(
		pc_now => s_data_out,
		pc_next => s_data_in
	);

	pc_test : program_counter port map(
		clk => clk,
		wr_en => wr_en,
		rst => rst,
		data_in => s_data_in,
		data_out => s_data_out
	);

    rom_test : rom port map(
        clk => clk,
        endereco => s_data_out,
        dado => saida_dado_rom
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
		wait for 1000 ns;
		
		wait;	
	end process;
	
end architecture;