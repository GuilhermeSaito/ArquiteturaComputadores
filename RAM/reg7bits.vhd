library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg7bits is
    port( 
        clk : in std_logic;
        rst : in std_logic;
        wr_en_PONTEIRO_RAM : in std_logic;
        data_in_PONTEIRO_RAM : in unsigned(6 downto 0);
        data_out_PONTEIRO_RAM : out unsigned(6 downto 0)
    );
end entity;

architecture a_reg7bits of reg7bits is
    signal registro: unsigned(6 downto 0);
begin

    process(clk, rst, wr_en_PONTEIRO_RAM)
    begin
        if rst='1' then
            registro <= "0000000";
        elsif wr_en_PONTEIRO_RAM='1' AND rising_edge(clk) then
            registro <= data_in_PONTEIRO_RAM;
        end if;
    end process;
    
    data_out_PONTEIRO_RAM <= registro;
end architecture;
