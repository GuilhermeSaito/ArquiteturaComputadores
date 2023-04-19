library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula_tb is
end;

architecture a_ula_tb of ula_tb is
    component ula
    port(
        -- 00 = Soma
        -- 01 = Subtracao
        -- 10 = Maior ou igual
        -- 11 = Verificacao de valor do sinal
        selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        entrada1_numero, entrada2_numero    : IN UNSIGNED(15 DOWNTO 0);
        saida_numero                        : OUT UNSIGNED(15 DOWNTO 0);
        saida_maior_igual_bit               : OUT STD_LOGIC;
        saida_valor_igual_bit               : OUT STD_LOGIC
    );
    end component;
signal entrada1_numero, entrada2_numero, saida_numero: UNSIGNED(15 DOWNTO 0);
signal saida_maior_igual_bit, saida_valor_igual_bit: std_logic;
signal selecao: STD_LOGIC_VECTOR(1 DOWNTO 0);

begin
    uut: ula port map(
        entrada1_numero => entrada1_numero,
        entrada2_numero => entrada2_numero,
        saida_numero => saida_numero,
        saida_maior_igual_bit => saida_maior_igual_bit,
        saida_valor_igual_bit => saida_valor_igual_bit,
        selecao => selecao
    );
    process 
    begin
        -- 0 + 0
        entrada1_numero <= "0000000000000000";
        entrada2_numero <= "0000000000000000";
        selecao <= "00";
        wait for 50 ns;
        
        -- 1 + 0
        entrada1_numero <= "0000000000000001";
        entrada2_numero <= "0000000000000000";
        selecao <= "00";
        wait for 50 ns;

        -- 0 + 1
        entrada1_numero <= "0000000000000000";
        entrada2_numero <= "0000000000000001";
        selecao <= "00";
        wait for 50 ns;

        -- max + 1
        entrada1_numero <= "1111111111111111";
        entrada2_numero <= "0000000000000001";
        selecao <= "00";
        wait for 50 ns;

        -- 0 - 1
        entrada1_numero <= "0000000000000000";
        entrada2_numero <= "0000000000000001";
        selecao <= "01";
        wait for 50 ns;

        -- 4 - 1
        entrada1_numero <= "0000000000000100";
        entrada2_numero <= "0000000000000001";
        selecao <= "01";
        wait for 50 ns;

        -- 1 >= 2
        entrada1_numero <= "0000000000000001";
        entrada2_numero <= "0000000000000010";
        selecao <= "10";
        wait for 50 ns;

        -- 2 >= 1
        entrada1_numero <= "0000000000000010";
        entrada2_numero <= "0000000000000001";
        selecao <= "10";
        wait for 50 ns;

        -- 2 = 2 
        entrada1_numero <= "0000000000000010";
        entrada2_numero <= "0000000000000010";
        selecao <= "11";
        wait for 50 ns;

        -- 0 = 0
        entrada1_numero <= "0000000000000000";
        entrada2_numero <= "0000000000000000";
        selecao <= "11";
        wait for 50 ns;
        wait;
    end process;
end architecture;
