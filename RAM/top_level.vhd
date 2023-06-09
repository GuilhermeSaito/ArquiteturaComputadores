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
        dado : out unsigned(16 downto 0)
    );
    end component;

    component pc is
    port(
        clk, wr_en, rst : in std_logic;
        jump_flag : in std_logic;
        jump_condicional_flag : in std_logic;
		jump_address : in unsigned(23 downto 0);
        data_in: in unsigned(23 downto 0);
        SAIDA_PC_ENTRADA_ROM: out unsigned(23 downto 0)
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
        reg1_leitura : IN unsigned(2 DOWNTO 0);
        reg2_leitura : IN unsigned(2 DOWNTO 0);
        data_in : in unsigned(15 downto 0);
        -- Determinar qual registrador vai escrever
        reg_escrita : IN unsigned(2 DOWNTO 0);
        wr_en : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        -- Saida do banco de registradores
        reg1_leitura_saida : OUT unsigned(15 DOWNTO 0);
        reg2_leitura_saida : OUT unsigned(15 DOWNTO 0)
    );
    end component;

    component ula is 
    port(
        wr_en                               : IN STD_LOGIC;
        selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        entrada1_numero, entrada2_numero    : IN unsigned(15 DOWNTO 0);
        jump_cond_flag_ula                  : OUT STD_LOGIC;
        saida_numero                        : OUT unsigned(15 DOWNTO 0)
    );
    end component;

    -- ----- Para fazer o acumulador
    component reg16bits is
    port( 
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
    end component;

    -- ----- Para fazer o ponteiro do endereco da RAM
    component reg7bits is
    port( 
        clk : in std_logic;
        rst : in std_logic;
        wr_en_PONTEIRO_RAM : in std_logic;
        data_in_PONTEIRO_RAM : in unsigned(6 downto 0);
        data_out_PONTEIRO_RAM : out unsigned(6 downto 0)
    );
    end component;

    component reg1bits is
    port( 
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in : in std_logic;
        data_out : out std_logic
    );
    end component;

    component reg_instrucao is
    port( 
        saida_rom : IN unsigned(16 downto 0);
        clk : in std_logic;
        saida_reg_instrucao : OUT unsigned(16 downto 0)
    );
    end component;

    component ram is
    port(
        clk             : in std_logic;
        endereco_RAM        : in unsigned(6 downto 0);
        wr_en_RAM           : in std_logic;
        dado_in_RAM         : in unsigned(15 downto 0);
        dado_out_RAM        : out unsigned(15 downto 0)
    );
    end component;

    component unidade_controle is
    port(
        jump_cond_flag_ula                                                              : IN STD_LOGIC;
        dado                                                                            : IN unsigned(16 downto 0);
        estado                                                                          : IN unsigned(1 downto 0);
        data_out_acumulador, reg1_leitura_saida, data_in_ac                             : IN unsigned(15 downto 0);
        dado_out                                                                        : IN unsigned(15 downto 0);
        dado_out_ponteiro                                                               : IN unsigned(6 downto 0);
        contagem_instruction_ROM                                                        : IN unsigned(23 downto 0);
        dado_flag_jump                                                                  : IN std_logic;
        wr_en_pc, wr_en_banco_reg, wr_en_acumulador, wr_en_ula, wr_en_ponteiro          : OUT STD_LOGIC;
        wr_en_flag_jump                                                                 : OUT STD_LOGIC;
        reg_escrita, reg1_leitura                                                       : OUT unsigned(2 DOWNTO 0);
        data_in_banco, data_in_acumulador, entrada2_ula                                 : OUT unsigned(15 downto 0);
        jump_flag                                                                       : OUT STD_LOGIC;
        jump_cond_flag                                                                  : OUT STD_LOGIC;
        jump_address                                                                    : OUT unsigned(23 downto 0);
        selecao                                                                         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        endereco                                                                        : OUT unsigned(6 downto 0);
        wr_en                                                                           : OUT std_logic;
        dado_in                                                                         : OUT unsigned(15 downto 0);
        dado_in_flag_jump                                                               : OUT std_logic;
        dado_in_ponteiro                                                                : OUT unsigned(6 downto 0)
    );
    end component;    

    signal wr_en_banco_reg, wr_en_pc, wr_en_ula, wr_en_ram, wr_en_ponteiro : std_logic;
    signal endereco  : unsigned(23 downto 0);
    signal dado, saida_instrucao : unsigned(16 downto 0);
    signal endereco_ram                     : unsigned(6 downto 0);
    
    signal data_in  : unsigned(23 downto 0) := (others => '0');
    signal data_in_banco  : unsigned(15 downto 0) := (others => '0');
	signal data_out : unsigned(23 downto 0) := (others => '0');

    signal estado : unsigned(1 downto 0);

    signal reg1_leitura : unsigned(2 DOWNTO 0);
    signal reg2_leitura : unsigned(2 DOWNTO 0);
    signal reg_escrita : unsigned(2 DOWNTO 0);
    signal reg1_leitura_saida : unsigned(15 DOWNTO 0);
    signal reg2_leitura_saida : unsigned(15 DOWNTO 0);
    signal selecao : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal saida_numero : unsigned(15 DOWNTO 0);

    signal entrada2_ula : unsigned(15 DOWNTO 0);

    -- --------- Para o acumulador
    signal wr_en_acumulador : std_logic;
    signal data_in_acumulador, data_out_acumulador, data_in_ac : unsigned(15 downto 0) := (others => '0');
    signal jump_flag : std_logic;
    signal jump_address : unsigned(23 downto 0) := (others => '0');
    signal jump_cond_flag : std_logic;
    signal jump_cond_flag_ula : std_logic;

    signal op_code : unsigned(4 downto 0);

    signal dado_in_RAM : unsigned(15 downto 0);
    signal dado_out_RAM : unsigned(15 downto 0);

    signal dado_in_ponteiro : unsigned(6 downto 0);
    signal dado_out_ponteiro : unsigned(6 downto 0);

    signal wr_en_flag : std_logic;
    signal dado_flag_jump : std_logic;
    signal dado_in_flag_jump : std_logic;

begin
    rom_test : rom port map(
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
		wr_en => wr_en_pc,
		rst => rst,
        jump_flag => jump_flag,
        jump_condicional_flag => jump_cond_flag,
		jump_address => jump_address,
		data_in => data_in,
		SAIDA_PC_ENTRADA_ROM => data_out
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
        reg_escrita        => reg_escrita,
        wr_en              => wr_en_banco_reg,
        clk                => clk,
        rst                => rst ,
        reg1_leitura_saida => reg1_leitura_saida,
        reg2_leitura_saida => reg2_leitura_saida
    );

    ula_calc : ula port map(
        wr_en           => wr_en_ula,
        selecao         => selecao,
        entrada1_numero => data_out_acumulador,
        entrada2_numero => entrada2_ula,
        jump_cond_flag_ula => jump_cond_flag_ula,
        saida_numero    => data_in_ac                   
    );

    acumulador : reg16bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_acumulador,
        data_in => data_in_acumulador,
        data_out => data_out_acumulador
    );

    flag_jump : reg1bits port map(
        clk => clk,
        rst => rst,
        wr_en => wr_en_flag,
        data_in => dado_in_flag_jump,
        data_out => dado_flag_jump
    );

    ponteiro_endereco_RAM : reg7bits port map(
        clk => clk,
        rst => rst,
        wr_en_PONTEIRO_RAM => wr_en_ponteiro,
        data_in_PONTEIRO_RAM => dado_in_ponteiro,
        data_out_PONTEIRO_RAM => dado_out_ponteiro
    );

    instr : reg_instrucao port map(
        saida_rom => dado,
        clk => clk,
        saida_reg_instrucao => saida_instrucao
    );

    ranzona : ram port map(
        clk => clk,
        endereco_RAM => endereco_ram,
        wr_en_RAM => wr_en_ram,
        dado_in_RAM => dado_in_RAM,
        dado_out_RAM => dado_out_RAM
    );

    controle : unidade_controle port map(
        dado => dado,
        estado => estado,
        data_out_acumulador => data_out_acumulador,
        reg1_leitura_saida => reg1_leitura_saida,
        data_in_ac => data_in_ac,
        wr_en_pc => wr_en_pc,
        wr_en_banco_reg => wr_en_banco_reg,
        wr_en_acumulador => wr_en_acumulador,
        wr_en_ula => wr_en_ula,
        wr_en_ponteiro => wr_en_ponteiro,
        jump_cond_flag_ula => jump_cond_flag_ula,
        dado_out => dado_out_RAM,
        dado_out_ponteiro => dado_out_ponteiro,
        contagem_instruction_ROM => data_out,
        dado_flag_jump => dado_flag_jump,
        wr_en_flag_jump => wr_en_flag,
        reg_escrita => reg_escrita,
        reg1_leitura => reg1_leitura,
        data_in_banco => data_in_banco,
        data_in_acumulador => data_in_acumulador,
        entrada2_ula => entrada2_ula,
        jump_flag => jump_flag,
        jump_address => jump_address,
        jump_cond_flag => jump_cond_flag,
        selecao => selecao,
        endereco => endereco_ram,
        wr_en => wr_en_ram,
        dado_in => dado_in_RAM,
        dado_in_flag_jump => dado_in_flag_jump,
        dado_in_ponteiro => dado_in_ponteiro
    );

end architecture;