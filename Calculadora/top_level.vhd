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
        dado : out unsigned(15 downto 0)
    );
    end component;

    component pc is
    port(
        clk, wr_en_pc, rst : in std_logic;
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

    component banco_reg is
        port(
        -- Qual registrador utilizar, considerando do s0 a s7, entao 000 = s0 e 111 = s7
        reg1_leitura : IN UNSIGNED(2 DOWNTO 0);
        reg2_leitura : IN UNSIGNED(2 DOWNTO 0);
        data_in : in unsigned(15 downto 0);
        -- Determinar qual registrador vai escrever
        reg_escrita : IN UNSIGNED(2 DOWNTO 0);
        wr_en_banco_reg : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        -- Saida do banco de registradores
        reg1_leitura_saida : OUT UNSIGNED(15 DOWNTO 0);
        reg2_leitura_saida : OUT UNSIGNED(15 DOWNTO 0)
        );
    end component;

    component ula is 
        port(
            selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            entrada1_numero, entrada2_numero    : IN UNSIGNED(15 DOWNTO 0);
            saida_numero                        : OUT UNSIGNED(15 DOWNTO 0);
        );
    end component;
        

    signal wr_en_banco_reg, wr_en_pc : std_logic;
    signal endereco  : unsigned(23 downto 0);
    signal dado : unsigned(15 downto 0);
    
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
		wr_en_pc => wr_en_pc,
		rst => rst,
		data_in => data_in,
		data_out => data_out
	);

    maquina_estados : maq_estados port map(
        clk => clk,
		rst => rst,
        estado => estado
    );

    banco_regis : banco_reg port map(
        reg1_leitura       => reg1_leitura
        reg2_leitura       => reg2_leitura
        data_in            => data_in
        reg_escrita        => reg_escrita
        wr_en_banco_reg    => wr_en_banco_reg
        clk                => clk
        rst                => rst 
        reg1_leitura_saida => reg1_leitura_saida
        reg2_leitura_saida => reg2_leitura_saida
    );

    ula_calc : ula port map(
        selecao         => selecao                    
        entrada1_numero => reg1_leitura_saida
        entrada2_numero => reg2_leitura_saida 
        saida_numero    => saida_numero                    
    );

    wr_en_pc <= '1' when estado = "00" else '0';
    wr_en_banco_reg <= '0' when estado = "00" else '1';



end architecture;