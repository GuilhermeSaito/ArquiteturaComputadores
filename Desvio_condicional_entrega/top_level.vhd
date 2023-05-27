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
        data_in : in unsigned(15 downto 0);
        -- Determinar qual registrador vai escrever
        reg_escrita : IN UNSIGNED(2 DOWNTO 0);
        wr_en : in std_logic;
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
        jump_cond_flag_ula                  : OUT STD_LOGIC;
        saida_numero                        : OUT UNSIGNED(15 DOWNTO 0)
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

    component reg_instrucao is
    port( 
        saida_rom : IN unsigned(16 downto 0);
        clk : in std_logic;
        saida_reg_instrucao : OUT unsigned(16 downto 0)
    );
    end component;
        

    signal wr_en_banco_reg, wr_en_pc : std_logic;
    signal endereco  : unsigned(23 downto 0);
    signal dado, saida_instrucao : unsigned(16 downto 0);
    
    signal data_in  : unsigned(23 downto 0) := (others => '0');
    signal data_in_banco  : unsigned(15 downto 0) := (others => '0');
	signal data_out : unsigned(23 downto 0) := (others => '0');

    signal estado : unsigned(1 downto 0);

    signal reg1_leitura : UNSIGNED(2 DOWNTO 0);
    signal reg2_leitura : UNSIGNED(2 DOWNTO 0);
    signal reg_escrita : UNSIGNED(2 DOWNTO 0);
    signal reg1_leitura_saida : UNSIGNED(15 DOWNTO 0);
    signal reg2_leitura_saida : UNSIGNED(15 DOWNTO 0);
    signal selecao : STD_LOGIC_VECTOR(1 DOWNTO 0);
    signal saida_numero : UNSIGNED(15 DOWNTO 0);

    signal entrada2_ula : UNSIGNED(15 DOWNTO 0);

    -- --------- Para o acumulador
    signal wr_en_acumulador : std_logic;
    signal data_in_acumulador, data_out_acumulador, data_in_ac : unsigned(15 downto 0) := (others => '0');
    signal jump_flag : std_logic;
    signal jump_address : unsigned(23 downto 0) := (others => '0');
    signal jump_cond_flag : std_logic;
    signal jump_cond_flag_ula : std_logic;

    -- Debug por enquanto
    signal op_code : unsigned(4 downto 0);

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
        reg_escrita        => reg_escrita,
        wr_en              => wr_en_banco_reg,
        clk                => clk,
        rst                => rst ,
        reg1_leitura_saida => reg1_leitura_saida,
        reg2_leitura_saida => reg2_leitura_saida
    );

    ula_calc : ula port map(
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

    instr : reg_instrucao port map(
        saida_rom => dado,
        clk => clk,
        saida_reg_instrucao => saida_instrucao
    );

    wr_en_pc <= '1' when estado = "00" else '0';
    wr_en_banco_reg <= '1' when estado = "10" else '0';

    
    -- --------Somente para ver se cada componente estah funcionando
    -- data_out <= to_unsigned(2, data_out'length);

    -- Pega somente os opcodes necessarios
    op_code <= dado(16 downto 12);

    -- --------------------- MOV
    -- Caso o op_code MOV ou Atribuir o acumulador para algum registrador, entao eh para atribuir um valor para o registrador
    reg_escrita <= 
        saida_instrucao(11 downto 9) when op_code = "00001" else    -- Especifica em qual registrador deve ser escrito quando for atribuir uma constante
        saida_instrucao(2 downto 0) when op_code = "00110" else     -- Especifica em qual registrador deve ser escrito quando for atribuir o acumulador
        (others => '0');
    -- O banco de registradores vai receber os dados quando for
    data_in_banco <= resize(saida_instrucao(8 downto 0), data_in_banco'length) when
        op_code = "00001"                                           -- Atribuir constante para registrador
    else data_out_acumulador when
        op_code = "00110" else                                      -- Atribuir Acumulador para registrador
        (others => '0');

    -- --------------------- LD
    reg1_leitura <= saida_instrucao(2 downto 0) when    -- Precisa atualizar qual registrador sera lido do banco de registradores quando
            op_code = "00010" or    -- For um ld
            op_code = "00011" or    -- soma
            op_code = "00100"       -- Ou subtracao
        else (others => '0');

    data_in_acumulador <= data_in_ac when               -- O Acumulador vai receber o resultado da ULA quando for
        op_code = "00011" or                            -- Soma
        op_code = "00100" or                            -- Subtracao
        op_code = "00111"                               -- Soma com constante
    else reg1_leitura_saida;                            -- Se nao, vai recer o valor do registrador mesmo

    wr_en_acumulador <= '1' when -- Precisa atualizar o acumulador quando for
        (op_code = "00010" or     -- ld
        op_code  = "00011" or     -- soma
        op_code  = "00100" or     -- subtracao
        op_code  = "00111") and    -- ou soma constante
        estado = "10"             -- E estiver no estado de EXECUTE
    else '0';

    entrada2_ula <= resize(saida_instrucao(4 downto 0), entrada2_ula'length) when -- Outra entrada da ULA vai ser
        op_code = "00100" or        -- Uma constante quando for subtracao
        op_code = "00111"           -- Uma constante quando for soma com constante
        else reg1_leitura_saida;    -- Se nao, vai ser o valor do registrador mesmo

    -- --------------------- JUMP (foi alterado o componente pc)
    jump_flag <= '1' when
        op_code = "00101"
    else '0';
    jump_address <= resize(saida_instrucao(11 downto 0), jump_address'length);

    -- --------------------- JUMP CONDICIONAL (foi alterado o componente pc)
    jump_cond_flag <= '1' when
        (op_code = "01000") and jump_cond_flag_ula = '1'
    else '0';

    -- --------------------- Soma ou Subtracao
    selecao <= "00" when op_code = "00011" or op_code = "00111" else -- Soma
               "01" when op_code = "00100" else -- Subtracao
               "10";                            -- Do nothing

    

end architecture;