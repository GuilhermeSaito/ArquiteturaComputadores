library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instrucao is
    port( 
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in_ac : in unsigned(15 downto 0);
        data_out_ac : out unsigned(15 downto 0)
    );
end entity;

architecture a_instrucao of instrucao is
    signal registro: unsigned(15 downto 0);
begin

    process(clk, rst, wr_en)
    begin
        if rst='1' then
            registro <= "0000000000000000";
        elsif wr_en='1' AND rising_edge(clk) then
            registro <= data_in_ac;
        end if;
    end process;
    
    data_out_ac <= registro;
end architecture;
