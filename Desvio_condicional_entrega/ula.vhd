library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ula is
    port(
        -- 00 = Soma
        -- 01 = Subtracao
        selecao                             : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        entrada1_numero, entrada2_numero    : IN UNSIGNED(15 DOWNTO 0);
        jump_cond_flag_ula                  : OUT STD_LOGIC;
        saida_numero                        : OUT UNSIGNED(15 DOWNTO 0)
    );
end entity ula;

architecture rtl of ula is

constant zeros : std_logic_vector(15 downto 0) := (others => '0');
    
begin

    saida_numero <= entrada1_numero + entrada2_numero WHEN selecao = "00" else
                    entrada1_numero - entrada2_numero WHEN selecao = "01" else
                    "0000000000000000";

    jump_cond_flag_ula <= '1' WHEN not((to_integer(unsigned((entrada1_numero - entrada2_numero)))) = 0)  and (selecao = "01") else
                          '0' WHEN (to_integer(unsigned((entrada1_numero - entrada2_numero)))) = 0  and (selecao = "01");


end architecture rtl;