library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity teste_tb is
    selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
    entrada1_numero, entrada2_numero    : IN UNSIGNED(15 DOWNTO 0);
    saida_numero                        : OUT UNSIGNED(15 DOWNTO 0);
    saida_maior_igual_bit               : OUT STD_LOGIC;
    saida_valor_igual_bit               : OUT STD_LOGIC
end entity teste_tb;

architecture rtl of teste_tb is
    component operacoes_ULA is
        port
        (
            selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            entrada1_numero, entrada2_numero    : IN UNSIGNED(15 DOWNTO 0);
            saida_numero                        : OUT UNSIGNED(15 DOWNTO 0);
            saida_maior_igual_bit               : OUT STD_LOGIC;
            saida_valor_igual_bit               : OUT STD_LOGIC
        );
    end component;
begin

    -- Vai chamar o process do teste.vhd e fazer toda a magica de acordo com os dados inseridos
    uut: operacoes_ULA port map(selecao => selecao, entrada1_numero => entrada1_numero, entrada2_numero => entrada2_numero, saida_numero => saida_numero, saida_maior_igual_bit => saida_maior_igual_bit, saida_valor_igual_bit => saida_valor_igual_bit);

end architecture rtl;