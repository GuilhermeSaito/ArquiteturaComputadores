library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
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
end entity ula;

architecture rtl of ula is
    
begin

    saida_numero <= entrada1_numero + entrada2_numero WHEN selecao = "00" else
                    entrada1_numero - entrada2_numero WHEN selecao = "01" else
                    "0000000000000000";

    saida_maior_igual_bit <= '1' WHEN (entrada1_numero >= entrada2_numero) and (selecao = "10") else
                             '0';

    saida_valor_igual_bit <= '1' WHEN (entrada1_numero = entrada2_numero) and (selecao = "11") else
                             '0';

end architecture rtl;