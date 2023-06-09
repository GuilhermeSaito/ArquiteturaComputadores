library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port(
		clk, wr_en, rst : in std_logic;
		jump_flag : in std_logic;
		jump_condicional_flag : in std_logic;
		jump_address : in unsigned(23 downto 0);
		data_in: in unsigned(23 downto 0);
		SAIDA_PC_ENTRADA_ROM: out unsigned(23 downto 0)
	);
end entity;

architecture a_pc of pc is 

	signal data : unsigned(23 downto 0) := (others => '0');

begin
	SAIDA_PC_ENTRADA_ROM <= data;
	
	process(clk, wr_en, rst)
	begin
        -- Se dar reset, tem que voltar para o comeco
		if (rst = '1') then
			data <= (others => '0');
        -- Como ele nao vai contar internamente, soh verificar se pode escrever e se estah na subida do clock
		elsif (rising_edge(clk) and wr_en = '1') then
			if jump_flag = '1' then
				data <= jump_address;
			elsif jump_condicional_flag = '1' then
				data <= data_in - jump_address;
			else
				data <= data_in;
			end if;
		end if;
	end process;

end architecture;