library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_e_estados is
end entity;

architecture a_rom_e_estados of rom_e_estados is
    component rom
    port( 
        clk : in std_logic;
        endereco : in unsigned(23 downto 0);
        dado : out unsigned(16 downto 0)
    );
    end component;

    component pc is
    port(
        clk, wr_en, rst : in std_logic;
        data_in: in unsigned(23 downto 0);
        data_out: out unsigned(23 downto 0)
    );
    end component;

    component soma1_pc is 
    port (
        pc_now: in unsigned(23 downto 0);
        pc_next: out unsigned(23 downto 0)
    );
    end component;

    component maquina_estados is
        port(
            clk, rst: in STD_LOGIC;
            estado: out STD_LOGIC
        );
    end component;

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';

    signal clk, rst, wr_en : std_logic := '0';
    signal endereco  : unsigned(23 downto 0);
    signal dado : unsigned(16 downto 0);
    
    signal data_in  : unsigned(23 downto 0) := (others => '0');
	signal data_out : unsigned(23 downto 0) := (others => '0');

    signal estado : std_logic;

begin
    rom: rom port map(
        clk => clk,
        endereco => data_out,
        dado => dado 
    );

    pc_sum : soma1_pc port map(
		pc_now => data_out,
		pc_next => data_in
	);

	pc_test : pc port map(
		clk => clk,
		wr_en => wr_en,
		rst => rst,
		data_in => data_in,
		data_out => data_out
	);

    maq_estados : maquina_estados port map(
        clk => clk,
		rst => rst,
        estado => estado
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

    wr_en <= '1' when estado = '0' else '0';

    process
	begin
        wait for 100 ns;
		rst <= '1';
		wait for 200 ns;
		rst <= '0';


        wait for 1000 ns;
		wait;	
	end process;

end architecture;