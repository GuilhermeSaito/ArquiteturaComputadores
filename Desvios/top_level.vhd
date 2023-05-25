library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
    port(
        clk, rst :  in std_logic
    );
end entity;

architecture a_top_level of top_level is

    component rom is
    port( 
        clk : in std_logic;
        endereco : in unsigned(23 downto 0);
        dado_rom : out unsigned(16 downto 0)
    );
    end component;

    component pc is
    port(
        clk, wr_en, rst : in std_logic;
        jump_flag_pc : in std_logic;
		jump_address : in unsigned(23 downto 0);
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

    component maq_estados is
    port(
        clk, rst: in STD_LOGIC;
        estado: out unsigned(1 downto 0)
    );
    end component;

    component banco_reg is
    port(
        -- Qual registrador utilizar, considerando do s0 a s7, entao 000 = s0 e 111 = s7
        reg1_leitura : IN UNSIGNED(2 DOWNTO 0);
        reg2_leitura : IN UNSIGNED(2 DOWNTO 0);
        data_in : in unsigned(16 downto 0);
        -- Determinar qual registrador vai escrever
        reg_escrita : IN UNSIGNED(2 DOWNTO 0);
        wr_en : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        -- Saida do banco de registradores
        reg1_leitura_saida : OUT UNSIGNED(16 DOWNTO 0);
        reg2_leitura_saida : OUT UNSIGNED(16 DOWNTO 0)
    );
    end component;

    component ula is 
    port(
        selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        entrada1_numero, entrada2_numero    : IN UNSIGNED(16 DOWNTO 0);
        saida_numero                        : OUT UNSIGNED(16 DOWNTO 0)
    );
    end component;

    component uc is
    port(
        entrada                : IN unsigned(16 DOWNTO 0); 
        out_data_1, out_data_2 : OUT UNSIGNED(16 DOWNTO 0);         
        dest                   : OUT UNSIGNED(2 DOWNTO 0);  
        mux_out_1              : std_logic;
        mux_out_2              : std_logic;
        mux_out_3              : std_logic;
        wr_banco_reg           : OUT std_logic;
        cte_out                : OUT UNSIGNED(16 DOWNTO 0);   
        jump_flag              : std_logic     
    );
    end component;

    component reg_instrucao is
        port( 
            saida_rom : IN unsigned(16 downto 0);
            clk : in std_logic;
            wr_en_inst : in std_logic;
            saida_reg_instrucao : OUT unsigned(16 downto 0)
        );
        end component;
        

    signal wr_en_banco_reg, wr_en_pc, wr_en_inst : std_logic;
    signal endereco  : unsigned(23 downto 0);
    signal dado_rom, saida_instrucao : unsigned(16 downto 0);
    
    signal data_in  : unsigned(23 downto 0) := (others => '0');
    signal data_in_banco  : unsigned(16 downto 0) := (others => '0');
	signal data_out : unsigned(23 downto 0) := (others => '0');

    signal estado : unsigned(1 downto 0);

    signal reg1_leitura : UNSIGNED(2 DOWNTO 0);
    signal reg2_leitura : UNSIGNED(2 DOWNTO 0);
    signal reg_escrita : UNSIGNED(2 DOWNTO 0);
    signal reg1_leitura_saida : UNSIGNED(16 DOWNTO 0);
    signal reg2_leitura_saida : UNSIGNED(16 DOWNTO 0);
    signal selecao : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal saida_numero : UNSIGNED(16 DOWNTO 0);

    signal entrada1_ula, entrada2_ula : UNSIGNED(16 DOWNTO 0);

    -- --------- Para o acumulador
    signal wr_en_acumulador : std_logic;
    signal jump_flag : std_logic;
    signal jump_address : unsigned(23 downto 0) := (others => '0');

    -- Debug por enquanto
    signal op_code : unsigned(4 downto 0);

    signal entrada                : unsigned(16 DOWNTO 0); 
    signal out_data_1, out_data_2 : UNSIGNED(16 DOWNTO 0);         
    signal dest                   : UNSIGNED(2 DOWNTO 0);  
    signal mux_out_1              : std_logic;
    signal mux_out_2              : std_logic;
    signal mux_out_3              : std_logic;
    signal wr_banco_reg           : std_logic;
    signal cte_out                : UNSIGNED(16 DOWNTO 0);   
    signal jump_flag_pc              : std_logic;     

begin
    rom_test : rom port map(
        clk => clk,
        endereco => data_out,
        dado_rom => dado_rom 
    );

    pc_sum : soma1_pc port map(
		pc_now => data_out,
		pc_next => data_in
	);

	pc_test : pc port map(
		clk => clk,
		wr_en => wr_en_pc,
		rst => rst,
        jump_flag_pc => jump_flag_pc,
		jump_address => jump_address,
		data_in => data_in,
		data_out => data_out
	);

    maquina_estados : maq_estados port map(
        clk => clk,
		rst => rst,
        estado => estado
    );
    
    banco_regis : banco_reg port map(
        reg1_leitura       => reg1_leitura,
        reg2_leitura       => reg2_leitura,
        data_in            => data_in_banco,
        reg_escrita        => dest,
        wr_en              => wr_banco_reg,
        clk                => clk,
        rst                => rst ,
        reg1_leitura_saida => reg1_leitura_saida,
        reg2_leitura_saida => reg2_leitura_saida
    );

    ula_calc : ula port map(
        selecao         => selecao,
        entrada1_numero => entrada1_ula,
        entrada2_numero => entrada2_ula,
        saida_numero    => saida_numero                   
    );

    instr : reg_instrucao port map(
        saida_rom => dado_rom,
        clk => clk,
        wr_en_inst => wr_en_inst,
        saida_reg_instrucao => saida_instrucao
    );

    uc_map : uc port map (
        entrada      => saida_instrucao,
        out_data_1   => data_in_banco,
        out_data_2   => out_data_2,
        dest         => dest,
        mux_out_1    => mux_out_1,
        mux_out_2    => mux_out_2,
        mux_out_3    => mux_out_3,
        wr_banco_reg => wr_banco_reg,
        cte_out      => cte_out,
        jump_flag    => jump_flag
    );


    wr_en_pc <= '1' when estado = "00" else '0';
    -- wr_en_banco_reg <= '1' when estado = "10" and estado = "01" else '0';

    

    

end architecture;