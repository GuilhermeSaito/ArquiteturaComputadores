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

    -- 1  => B"00001_00_1000000011",   -- LD, A, 3 -- Colocar 3 no Acumulador
    -- 2  => B"00001_10_0000000011",   -- LD, ($3), A -- Acolocar o valor do Acumulador para a Memoria
    -- 3  => B"00001_01_0000000011",   -- LD, A, 3 -- Colocar o valor da Memoria para o Acumulador
    -- 3  => B"00010_00_00000_00011",      -- LD, A, ($3) -- Endereco 3 para Acumulador
    -- 4  => B"00010_01_01011_00000",      -- LD, ($?), A -- Acumulador para endereco x
    -- 5  => B"00011_000000000011",      -- ADD, A, ($3) -- Soma o valor do Acumulador com o do endereco 3
    -- 6  => B"00100_000000000011",      -- SUB, A, ($3) -- Subtrai o valor do Acumulador com o do endereco 3
    -- 7  => B"00101_000000000101",       -- JP 5  -- Pula para o endereco 5


    -- 1  => B"00001_00_0000000011",   -- LD, A, 3     -- Colocar 3 no Acumulador
    -- 2  => B"00001_10_0001010011",   -- LD, ($?), A  -- Acolocar o valor do Acumulador para a Memoria
    -- 3  => B"00001_00_1111111111",   -- LD, A, -1     -- Colocar -1 no Acumulador
    -- 4  => B"00011_000001010011",      -- ADD, A, ($?) -- Soma o valor do Acumulador com o do endereco ?
    -- 5  => B"00001_10_0001010111",   -- LD, ($?), A  -- Acolocar o valor do Acumulador para a Memoria
    -- 6  => B"00001_00_1111111101",   -- LD, A, -3     -- Colocar -1 no Acumulador
    -- 7  => B"00011_000001010011",      -- ADD, A, ($?) -- Soma o valor do Acumulador com o do endereco ?
    -- 8  => B"00110_111111111111",      -- JREQ, -1

    1  => B"00001_00_0000000100",   -- LD, A, 4     -- Colocar 4 no Acumulador
    2  => B"00001_10_0000000011",   -- LD, $3, A  -- Acolocar o valor do Acumulador para a Memoria
    3  => B"00001_11_0000000000",   -- LD, $3, ponteiro -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
    4  => B"00111_000000001000",   -- LD, ponteiro_mem, valor  -- Coloca uma constante no endereco da RAM apontado pelo ponteiro
    5  => B"00011_000000000011",      -- ADD, A, $3 -- Soma o valor do Acumulador com o do endereco 3
    6  => B"00001_10_0000000111",   -- LD, $7, A  -- Acolocar o valor 12 do Acumulador para a Memoria 7
    7  => B"00001_11_0000000000",   -- LD, $7, ponteiro -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
    8  => B"00111_000000001000",   -- LD, ponteiro_mem, valor  -- Coloca uma constante no endereco da RAM apontado pelo ponteiro



    -- 4  => B"00011_000001010011",      -- ADD, A, ($?) -- Soma o valor do Acumulador com o do endereco ?
    -- 5  => B"00001_10_0001010111",   -- LD, ($?), A  -- Acolocar o valor do Acumulador para a Memoria
    -- 6  => B"00001_00_1111111101",   -- LD, A, -3     -- Colocar -1 no Acumulador
    -- 7  => B"00011_000001010011",      -- ADD, A, ($?) -- Soma o valor do Acumulador com o do endereco ?
    -- 8  => B"00110_111111111111",      -- JREQ, -1
            





    -- Como o registrador 0 do banco de registrador n faz poha nenhuma, vou deixar o acumulador com esse valor
    -- 1  => B"00001_011_000000001",   -- MOV $reg3, 1
    -- 2  => B"01011_011_000001010",   -- LD $reg3, 0xA -- Atribui o valor do reg3 na memoria 10 da RAM
    -- 3  => B"00010_000_000000011",   -- MOV A, $reg3 -- Soma (comeco)
    -- 4  => B"00011_000_000000011",   -- ADD A, $reg3
    -- 5  => B"01001_000_000000100",   -- LD A, 0x4     -- Atribui o valor do acumulador na memoria 4 da RAM
    -- 6  => B"01010_101_000000100",   -- LD $reg5, 0x4 -- Atribui o valor da memoria 4 da RAM no registrador 5
    -- 7  => B"01010_110_000001010",   -- LD $reg6, 0xA -- Atribui o valor da memoria 10 da RAM no registrador 6
    -- 8  => B"00001_001_110011000",   -- MOV $reg1 408,
    -- 9  => B"00010_000_000000001",   -- MOV A, $reg1  -- Atribui o valor do reg1 para o Acumulador
    -- 10 => B"01001_000_000101110",   -- LD A, 0x3f     -- Atribui o valor do acumulador na memoria 63 da RAM
    -- 11 => B"01010_111_000101110",   -- LD $reg7, 0x3f -- Atribui o valor da memoria 63 da RAM no registrador 7
    -- 12 => B"00001_010_100100011",   -- MOV $reg2 291,
    -- 13 => B"00010_000_000000010",   -- MOV A, $reg2  -- Atribui o valor do reg2 para o Acumulador
    -- 14 => B"01001_000_000011101",   -- LD A, 0x1d     -- Atribui o valor do acumulador na memoria 29 da RAM
    -- 15 => B"01010_100_000011101",   -- LD $reg4, 0x1d -- Atribui o valor da memoria 29 da RAM no registrador 4


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