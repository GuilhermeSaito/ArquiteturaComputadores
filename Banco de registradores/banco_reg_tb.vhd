-- Code by Luca Nozzoli

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg_tb is
end entity banco_reg_tb;

architecture a_banco_reg_tb of banco_reg_tb is
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

    constant period_time : time      := 100 ns;
    signal   finished    : std_logic := '0';
    signal   clk, rst, wr_en    : std_logic;
    signal   data_in, data_out1, data_out2    : unsigned(15 downto 0);

begin
    uut: banco_reg port map (
        reg1_leitura => "010",
        reg2_leitura => "010",
        data_in => data_in,
        reg_escrita => "010",
        wr_en => wr_en,
        clk => clk,
        rst => rst,
        reg1_leitura_saida => data_out1,
        reg2_leitura_saida => data_out2);
    
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
        data_in <= "0000000000000001";
        wait for 100 ns;
        data_in <= "0000000000000011";
        --adicionar outros casos?
        wait;
    end process;

end architecture a_banco_reg_tb;