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
        entrada1_numero, entrada2_numero    : IN UNSIGNED(15 DOWNTO 0);
        saida_numero                        : OUT UNSIGNED(15 DOWNTO 0);

    );
end entity ula;

architecture rtl of ula is
    
begin

    saida_numero <= entrada1_numero + entrada2_numero WHEN selecao = "00" else
                    entrada1_numero - entrada2_numero WHEN selecao = "01" else
                    "0000000000000000";


end architecture rtl;