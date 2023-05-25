library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Fetch = 00 = Atualiza o PC => Le o dado da ROM => Armazena no reg de instrucao
-- Decode = 01 = Prepara o op code e deixa os dados tudo na boquinha
-- Execute = 10 = Da o write enable em tudo o que for necessario para executar

entity maq_estados is
    port( 
        clk,rst: in std_logic;
        estado: out unsigned(1 downto 0)
    );
end entity;

architecture a_maq_estados of maq_estados is
    signal estado_s: unsigned(1 downto 0);
begin
    process(clk,rst)
    begin
        if rst='1' then
            estado_s <= "00";
        elsif rising_edge(clk) then
            if estado_s="10" then -- se agora esta em 2
                estado_s <= "00"; -- o prox vai voltar ao zero
            else
                estado_s <= estado_s+1; -- senao avanca
            end if;
        end if;
    end process;
    estado <= estado_s;
end architecture;