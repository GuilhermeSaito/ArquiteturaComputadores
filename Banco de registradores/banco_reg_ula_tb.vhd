library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg_ula_tb is
end entity banco_reg_ula_tb;

architecture a_banco_reg_ula_tb of banco_reg_ula_tb is
    -- ---------------- Componente do Banco de Registradores
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

    -- ---------------- Componente da ULA
    component ula
    port(
        -- 00 = Soma
        -- 01 = Subtracao
        -- 10 = Maior ou igual
        -- 11 = Verificacao de valor do sinal
        selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        entrada1_numero, entrada2_numero    : IN unsigned(15 DOWNTO 0);
        saida_numero                        : OUT unsigned(15 DOWNTO 0);
        saida_maior_igual_bit               : OUT STD_LOGIC;
        saida_valor_igual_bit               : OUT STD_LOGIC
    );
    end component;

    -- ---------------- Variaveis do Banco
    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, rst, wr_en    : std_logic;

    -- ---------------- Variaveis
    SIGNAL saida_ula_entrada_banco : unsigned(15 DOWNTO 0);
    SIGNAL saida1_banco_entrada_ula : unsigned(15 DOWNTO 0);
    SIGNAL selecao_mux_saida_banco_constante : STD_LOGIC;
    SIGNAL entrada_ula_mux : unsigned(15 DOWNTO 0);
    SIGNAL saida2_banco_mux_entrada_ula : unsigned(15 DOWNTO 0);
    SIGNAL constante : unsigned(15 DOWNTO 0) := "0000000000000011";

begin
    -- ---------------- Instancia do Banco
    uut_banco: banco_reg port map (
        reg1_leitura => "010",
        reg2_leitura => "010",
        data_in => saida_ula_entrada_banco,
        reg_escrita => "010",
        wr_en => wr_en,
        clk => clk,
        rst => rst,
        reg1_leitura_saida => saida1_banco_entrada_ula,
        reg2_leitura_saida => saida2_banco_mux_entrada_ula);

    -- ---------------- Instancia da ULA
    uut_ula: ula port map(
        entrada1_numero => saida1_banco_entrada_ula,
        entrada2_numero => entrada_ula_mux,
        saida_numero => saida_ula_entrada_banco,
        selecao => "00"
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
        wr_en <= '1';

        selecao_mux_saida_banco_constante <= '1';

        -- ------------------- SAIDA DO BANCO PARA UM MUX
        if selecao_mux_saida_banco_constante = '0' THEN
            entrada_ula_mux <= saida2_banco_mux_entrada_ula;
        else
            entrada_ula_mux <= constante;
        end if;
        
        wait for 100 ns;
        --adicionar outros casos?
        wait;
    end process;

end architecture a_banco_reg_ula_tb;