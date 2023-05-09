library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        clk, rst :  in std_logic
    );
end entity;

architecture a_top_level of top_level is
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

    signal wr_en : std_logic := '0';
    signal endereco  : unsigned(23 downto 0);
    signal dado : unsigned(16 downto 0);
    
    signal data_in  : unsigned(23 downto 0) := (others => '0');
	signal data_out : unsigned(23 downto 0) := (others => '0');

    signal estado : std_logic;

begin
    pc_rom: rom port map(
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

    

    wr_en <= '1' when estado = '0' else '0';



end architecture;