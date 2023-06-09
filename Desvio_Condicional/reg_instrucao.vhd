library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_instrucao is
    port( 
        saida_rom : IN unsigned(16 downto 0);
        clk : in std_logic;
        -- Saida do banco de registradores
        saida_reg_instrucao : OUT unsigned(16 downto 0)
    );
end entity;

architecture a_reg_instrucao of reg_instrucao is

    signal dado : unsigned(16 downto 0);

begin
    
    saida_reg_instrucao <= saida_rom;

end architecture;