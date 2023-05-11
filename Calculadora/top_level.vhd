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
            saida_numero                        : OUT UNSIGNED(15 DOWNTO 0)
        );
    end component;

    -- ----- Para fazer o acumulador
    component reg16bits 
    port( 
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
    end component;
        

    signal wr_en_banco_reg, wr_en_pc : std_logic;
    signal endereco  : unsigned(23 downto 0);
    signal dado : unsigned(16 downto 0);
    
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

    -- --------- Para o acumulador
    signal wr_en_acumulador : std_logic;
    signal data_in_acumulador, data_out_acumulador : unsigned(15 downto 0) := (others => '0');
    signal jump_flag : std_logic;
    signal jump_address : unsigned(23 downto 0) := (others => '0');

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
        entrada2_numero => reg1_leitura_saida,
        saida_numero    => data_in_acumulador                   
    );

    acumulador: reg16bits port map(clk => clk, rst => rst, wr_en => wr_en_acumulador, data_in => data_in_acumulador, data_out => data_out_acumulador);

    wr_en_pc <= '1' when estado = "00" else '0';
    wr_en_banco_reg <= '0' when estado = "00" else '1';

    
    -- --------Somente para ver se cada componente estah funcionando
    -- data_out <= to_unsigned(2, data_out'length);

    -- Pega somente os opcodes necessarios
    op_code <= dado(16 downto 12);

    -- --------------------- MOV
    -- Caso o op_code for = "00001" ou "00010", entao eh para atribuir um valor para o registrador
    reg_escrita <= dado(11 downto 9) when op_code = "00001" or op_code = "00010" else (others => '0');
    data_in_banco <= resize(dado(8 downto 0), data_in_banco'length) when op_code = "00001" or op_code = "00010" else (others => '0');

    -- --------------------- LD
    -- Caso o op_code for = "00001" ou "00010", entao eh para atribuir um valor para o registrador
    reg1_leitura <= dado(2 downto 0) when 
            op_code = "00011" or 
            op_code = "00101" or
            op_code = "00110" or 
            op_code = "01000" or
            op_code = "01010" or 
            op_code = "01011"
        else (others => '0');

    data_in_acumulador <= reg1_leitura_saida when 
        op_code = "00011" or 
        op_code = "00101" or
        op_code = "00110" or 
        op_code = "01000" or
        op_code = "01010" or 
        op_code = "01011"
    else data_out_acumulador;

    wr_en_acumulador <= '1' when
        op_code = "00011" or 
        op_code = "00101" or
        op_code = "00110" or 
        op_code = "01000" or
        op_code = "01010" or 
        op_code = "01011"
    else '0';


    -- --------------------- JUMP (foi alterado o componente pc)
    jump_flag <= '1' when
        op_code = "01001" or
        op_code = "01100"
    else '0';
    jump_address <= resize(dado(11 downto 0), jump_address'length);


    -- --------------------- Soma ou Subtracao
    selecao <= "00" when op_code = "00100" else -- Soma
               "01" when op_code = "00111" else -- Subtracao
               "10";                            -- Do nothing

end architecture;