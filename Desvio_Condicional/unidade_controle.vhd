library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unidade_controle is
    port(
        jump_cond_flag_ula                                                              : IN STD_LOGIC;
        dado                                                                            : IN unsigned(16 downto 0);
        estado                                                                          : IN unsigned(1 downto 0);
        data_out_acumulador, reg1_leitura_saida, data_in_ac                             : IN unsigned(15 downto 0);
        wr_en_pc, wr_en_banco_reg, wr_en_acumulador, wr_en_ula                          : OUT STD_LOGIC;
        reg_escrita, reg1_leitura                                                       : OUT unsigned(2 DOWNTO 0);
        data_in_banco, data_in_acumulador, entrada2_ula                                 : OUT unsigned(15 downto 0);
        jump_flag, jump_cond_flag                                                       : OUT STD_LOGIC;
        jump_address                                                                    : OUT unsigned(23 downto 0);
        selecao                                                                         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
end entity unidade_controle;

architecture rtl of unidade_controle is

signal op_code : unsigned(4 downto 0);
    
begin
    -- Pega somente os opcodes necessarios
    op_code <= dado(16 downto 12);

    wr_en_pc <= '1' when estado = "00" else '0';
    wr_en_banco_reg <= '1' when estado = "11" else '0';
    wr_en_acumulador <= '1' when -- Precisa atualizar o acumulador quando for
        (op_code = "00010" or     -- ld
        op_code  = "00011" or     -- soma
        op_code  = "00100" or     -- subtracao
        op_code  = "00111") and    -- ou soma constante
        estado = "11"             -- E estiver no estado de EXECUTE
    else '0';
    wr_en_ula <= '1' when
        estado = "10" and
        (op_code  = "00011" or     -- soma
         op_code  = "00100" or     -- subtracao
         op_code  = "00111")
    else '0';

    -- --------------------- MOV
    -- Caso o op_code MOV ou Atribuir o acumulador para algum registrador, entao eh para atribuir um valor para o registrador
    reg_escrita <= 
        dado(11 downto 9) when op_code = "00001" else    -- Especifica em qual registrador deve ser escrito quando for atribuir uma constante
        dado(2 downto 0) when op_code = "00110" else     -- Especifica em qual registrador deve ser escrito quando for atribuir o acumulador
        (others => '0');
    -- O banco de registradores vai receber os dados quando for
    data_in_banco <= resize(dado(8 downto 0), data_in_banco'length) when
        op_code = "00001"                                           -- Atribuir constante para registrador
    else data_out_acumulador when
        op_code = "00110" else                                      -- Atribuir Acumulador para registrador
        (others => '0');

    -- --------------------- LD
    reg1_leitura <= dado(2 downto 0) when    -- Precisa atualizar qual registrador sera lido do banco de registradores quando
            op_code = "00010" or    -- For um ld
            op_code = "00011" or    -- soma
            op_code = "00100"       -- Ou subtracao
        else (others => '0');

    data_in_acumulador <= data_in_ac when               -- O Acumulador vai receber o resultado da ULA quando for
        op_code = "00011" or                            -- Soma
        op_code = "00100" or                            -- Subtracao
        op_code = "00111"                               -- Soma com constante
    else reg1_leitura_saida;                            -- Se nao, vai recer o valor do registrador mesmo

    entrada2_ula <= resize(dado(4 downto 0), entrada2_ula'length) when -- Outra entrada da ULA vai ser
        op_code = "00100" or        -- Uma constante quando for subtracao
        op_code = "00111"           -- Uma constante quando for soma com constante
        else reg1_leitura_saida;    -- Se nao, vai ser o valor do registrador mesmo

    -- --------------------- JUMP (foi alterado o componente pc)
    jump_flag <= '1' when
        op_code = "00101"
    else '0';
    jump_address <= resize(dado(11 downto 0), jump_address'length);

    -- --------------------- JUMP CONDICIONAL (foi alterado o componente pc)
    jump_cond_flag <= '1' when
        (op_code = "01000") and jump_cond_flag_ula = '1'
    else '0';

    -- --------------------- Soma ou Subtracao
    selecao <= "00" when op_code = "00011" or op_code = "00111" else -- Soma
               "01" when op_code = "00100" else -- Subtracao
               "10";                            -- Do nothing


end architecture rtl;