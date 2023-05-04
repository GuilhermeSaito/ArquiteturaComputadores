library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity jump is
end entity;

architecture a_jump of jump is
    component rom is
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
    
    signal next_pc : unsigned(23 downto 0) := (others => '0');

    signal data_in  : unsigned(23 downto 0) := (others => '0');
	signal data_out : unsigned(23 downto 0) := (others => '0');

    signal estado : std_logic;

    signal opcode : unsigned(3 downto 0);
    signal jump_to : unsigned(12 downto 0);

begin
    rom_test: rom port map(
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
		data_in => next_pc,
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

    opcode <= dado(16 downto 13);

    jump_to <= dado(12 downto 0);

    wr_en <= '1' when estado = '0' else '0';

    next_pc <= to_unsigned(to_integer(jump_to), 24) when opcode = "1111" else data_in;


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