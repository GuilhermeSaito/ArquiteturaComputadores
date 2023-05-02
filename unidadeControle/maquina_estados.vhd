library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity maquina_estados is
	port(
		clk, rst: in STD_LOGIC;
		estado: out STD_LOGIC
	);
end entity;

architecture a_maquina_estados of maquina_estados is	

	SIGNAL a_estado : STD_LOGIC := '0';	
begin
	estado <= a_estado;

	process(clk, rst)
	begin
		if rst = '1' then
			a_estado <= '0';
		elsif rising_edge(clk) then
			a_estado <= not a_estado;
		end if;
	end process;

end architecture;
