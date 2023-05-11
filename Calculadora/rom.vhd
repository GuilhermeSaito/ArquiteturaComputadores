library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom is
    port( clk : in std_logic;
    endereco : in unsigned(23 downto 0);
    dado : out unsigned(16 downto 0)
    );
end entity;

architecture a_rom of rom is
    type mem is array (0 to 127) of unsigned(16 downto 0);
    constant conteudo_rom : mem := (
    -- ------------------------------ Intrucoes arbitradas ------------------------------
    -- O ACUMULADOR SERA O REGISTRADOR 8

    -- ------- Carregar registrador com constante
    -- Formato do binario: opcode_regdestino_constante
    -- ------- Somar e Subtrair
    -- Formato do binario: opcode_acumulador_reg1 -- Carregar o valor do registrador no acumulador
    -- Formato do binario: opcode_acumulador_reg1 -- Somar o valor do acumulador com o outro registrador e armazenar no acumulador
    -- Formato do binario: opcode_reg1_acumulador -- Carregar o valor do acumulador no registrador
    -- ------- Jump
    -- Formato do binario: opcode_enderecoDestino
    -- ------- Atribuir valor de 1 registrador para o outro
    -- Formato do binario: opcode_acumulador_reg1 -- Atribui o valor do registrador para o acumulador
    -- Formato do binario: opcode_reg1_acumulador -- Atribui o valor do acumulador para o registrador


    -- 00000 = Nop
    -- 00001 = Carregar registrador com constante (MOV $reg constante)
    -- ------- Para somar precisa de 3 instrucoes (pq o processador usa acumulador)
    -- 00010 = Carregar acumulador com o valor de registrador 1 (LD $acumulador, $registrador)
    -- 00011 = Somar aucumulador com o outro registrador e armazenar no acumulador (ADD $acumulador, $registrador)
    -- 00100 = Atribuir o resultado do acumulador para o outro registrador (LD $registrador, $acumulador)
    -- ------- Para subtrair eh a msm coisa da soma, mas subtraindo
    -- 00101 = Carregar acumulador com o valor de registrador 1 (LD $acumulador, $registrador)
    -- 00110 = Subtrair aucumulador com o outro registrador e armazenar no acumulador (SUB $acumulador, $registrador)
    -- 00111 = Atribuir o resultado do acumulador para o outro registrador (LD $registrador, $acumulador)
    -- 01000 = Jump
    -- ------- Para atribuir o valor de um registrador em outro
    -- 01001 = Atribuir o valor de 1 registrador para o acumulador (LD $acumulador, $registrador)
    -- 01010 = Atribuir o valor do acumulador para o outro registrador (LD $registrador, $acumulador)
    -- ------------------------------ Intrucoes arbitradas ------------------------------

    0  => B"00000000000000000",     -- Nop
    1  => B"00001_000_000000101",   -- MOV $reg constante
    2  => B"00010_000001000_000",   -- LD $acumulador, $registrador -- Soma
    3  => B"00011_000001000_000",   -- ADD $acumulador, $registrador
    4  => B"00100_000_000001000",   -- LD $registrador, $acumulador
    5  => B"00101_000001000_000",   -- LD $acumulador, $registrador -- Subtracao
    6  => B"00110_000001000_000",   -- SUB $acumulador, $registrador
    7  => B"00111_000_000001000",   -- LD $registrador, $acumulador
    8  => B"01000_000000010100",    -- Jump para instrucao 20
    20 => B"01001_000001000_000", -- LD $acumulador, $registrador
    21 => B"01010_000_000001000", -- LD $registrador, $acumulador
    22  => B"01000_000000000011",    -- Jump para instrucao 3
    -- abaixo: casos omissos => (zero em todos os bits)
    others => (others=>'0')
 );
begin
    process(clk)
    begin
    if(rising_edge(clk)) then
        dado <= conteudo_rom(to_integer(endereco));
    end if;
    end process;
end architecture;