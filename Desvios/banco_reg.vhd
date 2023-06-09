library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity banco_reg is
    port( 
        -- Qual registrador utilizar, considerando do s0 a s7, entao 000 = s0 e 111 = s7
        reg1_leitura : IN unsigned(2 DOWNTO 0);
        reg2_leitura : IN unsigned(2 DOWNTO 0);
        data_in : in unsigned(16 downto 0);
        -- Determinar qual registrador vai escrever
        reg_escrita : IN unsigned(2 DOWNTO 0);
        wr_en : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        -- Saida do banco de registradores
        reg1_leitura_saida : OUT unsigned(16 DOWNTO 0);
        reg2_leitura_saida : OUT unsigned(16 DOWNTO 0)
    );
end entity;

architecture a_banco_reg of banco_reg is

component reg16bits 
    port( 
        clk : in std_logic;
        rst : in std_logic;
        wr_en : in std_logic;
        data_in : in unsigned(16 downto 0);
        data_out : out unsigned(16 downto 0)
    );
end component;

-- Variavel para ver qual registrador sera escrito, por default = 0
SIGNAL write_reg : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";

SIGNAL data_out_regs0 : unsigned(16 DOWNTO 0);
SIGNAL data_out_regs1 : unsigned(16 DOWNTO 0);
SIGNAL data_out_regs2 : unsigned(16 DOWNTO 0);
SIGNAL data_out_regs3 : unsigned(16 DOWNTO 0);
SIGNAL data_out_regs4 : unsigned(16 DOWNTO 0);
SIGNAL data_out_regs5 : unsigned(16 DOWNTO 0);
SIGNAL data_out_regs6 : unsigned(16 DOWNTO 0);
SIGNAL data_out_regs7 : unsigned(16 DOWNTO 0);

begin
    
    -- Verificando em qual registrador sera escrito
    write_reg <= 
        "00000001" when wr_en = '1' and reg_escrita = "000" else
        "00000010" when wr_en = '1' and reg_escrita = "001" else
        "00000100" when wr_en = '1' and reg_escrita = "010" else
        "00001000" when wr_en = '1' and reg_escrita = "011" else
        "00010000" when wr_en = '1' and reg_escrita = "100" else
        "00100000" when wr_en = '1' and reg_escrita = "101" else
        "01000000" when wr_en = '1' and reg_escrita = "110" else
        "10000000" when wr_en = '1' and reg_escrita = "111" else
        "00000000";
    
    -- Instanciando os 8 registradores
    regs0: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(0), data_in => data_in, data_out => data_out_regs0);
    regs1: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(1), data_in => data_in, data_out => data_out_regs1);
    regs2: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(2), data_in => data_in, data_out => data_out_regs2);
    regs3: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(3), data_in => data_in, data_out => data_out_regs3);
    regs4: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(4), data_in => data_in, data_out => data_out_regs4);
    regs5: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(5), data_in => data_in, data_out => data_out_regs5);
    regs6: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(6), data_in => data_in, data_out => data_out_regs6);
    regs7: reg16bits port map(clk => clk, rst => rst, wr_en => write_reg(7), data_in => data_in, data_out => data_out_regs7);

    -- As 2 saidas do banco de registrador vao depender de qual registrador foi escrito, como o s0 sempre vai retornar 0, ele n precisa entrar na condicao
    reg1_leitura_saida <= 
		data_out_regs1 when reg1_leitura = "001" else
		data_out_regs2 when reg1_leitura = "010" else
		data_out_regs3 when reg1_leitura = "011" else
		data_out_regs4 when reg1_leitura = "100" else
		data_out_regs5 when reg1_leitura = "101" else
		data_out_regs6 when reg1_leitura = "110" else
		data_out_regs7 when reg1_leitura = "111" else
		"00000000000000000";

    reg2_leitura_saida <= 
		data_out_regs1 when reg2_leitura = "001" else
		data_out_regs2 when reg2_leitura = "010" else
		data_out_regs3 when reg2_leitura = "011" else
		data_out_regs4 when reg2_leitura = "100" else
		data_out_regs5 when reg2_leitura = "101" else
		data_out_regs6 when reg2_leitura = "110" else
		data_out_regs7 when reg2_leitura = "111" else
		"00000000000000000";

end architecture;