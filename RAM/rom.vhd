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

    -- 1  => B"00001_00_0000000100",   -- LD, A, 4     -- Colocar 4 no Acumulador
    -- 2  => B"00001_10_0000000011",   -- LD, $3, A  -- Acolocar o valor do Acumulador para a Memoria
    -- 3  => B"00001_11_0000000000",   -- LD, $3, ponteiro -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
    -- 4  => B"00111_000000001000",   -- LD, ponteiro_mem, valor  -- Coloca uma constante no endereco da RAM apontado pelo ponteiro
    -- 5  => B"00011_000000000011",      -- ADD, A, $3 -- Soma o valor do Acumulador com o do endereco 3
    -- 6  => B"00001_10_0000000111",   -- LD, $7, A  -- Acolocar o valor 12 do Acumulador para a Memoria 7
    -- 7  => B"00001_11_0000000000",   -- LD, $7, ponteiro -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
    -- 8  => B"00111_000000001000",   -- LD, ponteiro_mem, valor  -- Coloca uma constante no endereco da RAM apontado pelo ponteiro

-----------PREENCHIMENTO DA RAM-----------------------------

    1   => B"00001_00_0000000001",    -- LD, A, 1     -- Colocar 1 no Acumulador 5
    2   => B"00001_10_0000000101",    -- LD, $5, A  -- Acolocar o valor do Acumulador para a Memoria
    
    3   => B"00001_00_1111011111",    -- LD, A, -33     -- Colocar -33 no Acumulador
    4   => B"00001_10_0000000111",    -- LD, $7, A  -- Acolocar o valor do Acumulador para a Memoria

    5   => B"00001_00_0000001010",   -- LD, A, 10     -- Colocar 10 no Acumulador
    6   => B"00001_10_0000000001",   -- LD, $1, A  -- Acolocar o valor do Acumulador para a Memoria
 
    7   => B"00001_00_0000000000",   -- LD, A, 0     -- Colocar 0 no Acumulador
    8   => B"00001_10_0000000010",   -- LD, $2, A  -- Acolocar o valor do Acumulador para a Memoria

    9   => B"00011_000000000111",     -- ADD, A, $7 -- Soma o valor do Acumulador com o do endereco 7

    10  => B"00110_000000001111",     -- JREQ

    11  => B"00001_00_0000000000",    -- LD, A, 0     -- Colocar 0 no Acumulador
    12  => B"00011_000000000001",     -- ADD, A, $1 -- Soma o valor do Acumulador com o do endereco 1
    13  => B"00001_01_0000000001",   -- LD, A, $1     -- Colocar o valor de $1 no Acumulador

    14  => B"00001_11_0000000000",   -- LD, ponteiro, A -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
    15  => B"00111_000000000010",    -- LD, ponteiro_mem, $2  -- Coloca uma constante no endereco da RAM apontado pelo ponteiro

    16  => B"00001_00_0000000000",    -- LD, A, 0     -- Colocar 0 no Acumulador
    17  => B"00011_000000000001",     -- ADD, A, $1 -- Soma o valor do Acumulador com o do endereco 1


    18  => B"00011_000000000101",    -- ADD, A, $5 -- Soma o valor do Acumulador com o do endereco 5
    19  => B"00001_10_0000000001",   -- LD, $1, A  -- Acolocar o valor do Acumulador para a Memoria

    20  => B"00001_00_0000000000",    -- LD, A, 0     -- Colocar 0 no Acumulador
    21  => B"00011_000000000010",     -- ADD, A, $2 -- Soma o valor do Acumulador com o do endereco 2
    22  => B"00011_000000000101",     -- ADD, A, $5 -- Soma o valor do Acumulador com o do endereco 5
    23  => B"00001_10_0000000010",   -- LD, $2, A  -- Acolocar o valor do Acumulador para a Memoria

    24  => B"00101_000000001001",     -- Jump to 9

-----------LOOP PARA REMOÇÃO DE 2-----------------------------

    25  => B"00001_00_0000000010",    -- LD, A, 2     -- Colocar 2 no Acumulador
    26  => B"00001_10_0000000101",    -- LD, $5, A  -- Acolocar o valor do Acumulador para a Memoria'

    27  => B"00001_00_1111010100",    -- LD, A, -44     -- Colocar -44 no Acumulador
    28  => B"00001_10_0000000111",    -- LD, $7, A  -- Acolocar o valor do Acumulador para a Memoria
    
    29  => B"00001_00_0000000000",   -- LD, A, 0     -- Colocar 0 no Acumulador
    30  => B"00001_10_0000000010",   -- LD, $2, A  -- Acolocar o valor do Acumulador para a Memoria

    31  => B"00001_00_0000001110",   -- LD, A, 14     -- Colocar 14 no Acumulador
    32  => B"00001_10_0000000001",   -- LD, $1, A  -- Acolocar o valor do Acumulador para a Memoria

    33  => B"00011_000000000111",     -- ADD, A, $7 -- Soma o valor do Acumulador com o do endereco 7

    34  => B"00110_000000001011",     -- JREQ

    35  => B"00001_00_0000000000",    -- LD, A, 0     -- Colocar 0 no Acumulador
    36  => B"00011_000000000001",     -- ADD, A, $1 -- Soma o valor do Acumulador com o do endereco 1

    37  => B"00001_11_0000000000",    -- LD, ponteiro, A -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
    38  => B"00111_000000000000",     -- LD, ponteiro_mem, $2  -- Coloca uma constante no endereco da RAM apontado pelo ponteiro
   
    39  => B"00001_00_0000000000",    -- LD, A, 0     -- Colocar 0 no Acumulador
    40  => B"00011_000000000001",     -- ADD, A, $1 -- Soma o valor do Acumulador com o do endereco 1
    41  => B"00011_000000000101",     -- ADD, A, $5 -- Soma o valor do Acumulador com o do endereco 5
    42  => B"00001_10_0000000001",    -- LD, $1, A  -- Acolocar o valor do Acumulador para a Memoria
    43  => B"00001_11_0000000000",    -- LD, ponteiro, A -- Coloca o valor do acumulador e aponta para o novo endereco de memoria

    44  => B"00101_000000100001",     -- Jump to 31

---------------------------------------

    45  => B"00001_00_0000000011",    -- LD, A, 2     -- Colocar 2 no Acumulador
    46  => B"00001_10_0000000101",    -- LD, $5, A  -- Acolocar o valor do Acumulador para a Memoria'

    47  => B"00001_00_1111010101",    -- LD, A, -44     -- Colocar -44 no Acumulador
    48  => B"00001_10_0000000111",    -- LD, $7, A  -- Acolocar o valor do Acumulador para a Memoria

    49  => B"00001_00_0000000000",   -- LD, A, 0     -- Colocar 0 no Acumulador
    50  => B"00001_10_0000000010",   -- LD, $2, A  -- Acolocar o valor do Acumulador para a Memoria

    51  => B"00001_00_0000010000",   -- LD, A, 16     -- Colocar 14 no Acumulador
    52  => B"00001_10_0000000001",   -- LD, $1, A  -- Acolocar o valor do Acumulador para a Memoria

    53  => B"00011_000000000111",     -- ADD, A, $7 -- Soma o valor do Acumulador com o do endereco 7

    54  => B"00110_000000001011",     -- JREQ

    55  => B"00001_00_0000000000",    -- LD, A, 0     -- Colocar 0 no Acumulador
    56  => B"00011_000000000001",     -- ADD, A, $1 -- Soma o valor do Acumulador com o do endereco 1

    57  => B"00001_11_0000000000",    -- LD, ponteiro, A -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
    58  => B"00111_000000000000",     -- LD, ponteiro_mem, $2  -- Coloca uma constante no endereco da RAM apontado pelo ponteiro

    59  => B"00001_00_0000000000",    -- LD, A, 0     -- Colocar 0 no Acumulador
    60  => B"00011_000000000001",     -- ADD, A, $1 -- Soma o valor do Acumulador com o do endereco 1
    61  => B"00011_000000000101",     -- ADD, A, $5 -- Soma o valor do Acumulador com o do endereco 5
    62  => B"00001_10_0000000001",    -- LD, $1, A  -- Acolocar o valor do Acumulador para a Memoria
    63  => B"00001_11_0000000000",    -- LD, ponteiro, A -- Coloca o valor do acumulador e aponta para o novo endereco de memoria
                  
    64  => B"00101_000000110101",     -- Jump to 31

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