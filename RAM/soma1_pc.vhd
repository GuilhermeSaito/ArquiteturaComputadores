library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Codigo que soh vai somar 1 para a saida do pc
entity soma1_pc is 
	port (
		pc_now: in unsigned(23 downto 0);
		pc_next: out unsigned(23 downto 0)
	);
end entity;


architecture a_soma1_pc of soma1_pc is
begin
	pc_next <= pc_now + 1;
end architecture;