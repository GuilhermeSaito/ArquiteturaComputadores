library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity teste is
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
end entity teste;

architecture rtl of teste is
    
begin

    opcao: process(entrada1_numero, entrada2_numero)
    begin
        if selecao = "00" then
            saida_numero <= entrada1_numero + entrada2_numero
        elsif selecao = "01" then
            saida_numero <= entrada1_numero - entrada2_numero
        elsif selecao = "10" then
            saida_maior_igual_bit <= '1' WHEN entrada1_numero >= entrada2_numero else
                                     '0' WHEN entrada1_numero < entrada2_numero else
                                     '0';
        else
            if entrada1_numero = entrada2_numero then
                saida_valor_igual_bit <= '1';
            else
                saida_valor_igual_bit <= '0';
            end if;
        end if;
    end process opcao;
end architecture rtl;
