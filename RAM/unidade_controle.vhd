library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity unidade_controle is
    port(
        jump_cond_flag_ula                                                              : IN STD_LOGIC;
        dado                                                                            : IN unsigned(16 downto 0);
        estado                                                                          : IN unsigned(1 downto 0);
        data_out_acumulador, reg1_leitura_saida, data_in_ac                             : IN unsigned(15 downto 0);
        dado_out                                                                        : IN unsigned(15 downto 0);
        dado_out_ponteiro                                                               : IN unsigned(6 downto 0);
        contagem_instruction_ROM                                                        : IN unsigned(23 downto 0);
        dado_flag_jump                                                                  : IN std_logic;
        wr_en_pc, wr_en_banco_reg, wr_en_acumulador, wr_en_ula, wr_en_ponteiro          : OUT STD_LOGIC;
        wr_en_flag_jump                                                                 : OUT STD_LOGIC;
        reg_escrita, reg1_leitura                                                       : OUT unsigned(2 DOWNTO 0);
        data_in_banco, data_in_acumulador, entrada2_ula                                 : OUT unsigned(15 downto 0);
        jump_flag                                                                       : OUT STD_LOGIC;
        jump_cond_flag                                                                  : OUT STD_LOGIC;
        jump_address                                                                    : OUT unsigned(23 downto 0);
        selecao                                                                         : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
        endereco                                                                        : OUT unsigned(6 downto 0);
        wr_en                                                                           : OUT std_logic;
        dado_in                                                                         : OUT unsigned(15 downto 0);
        dado_in_flag_jump                                                               : OUT std_logic;
        dado_in_ponteiro                                                                : OUT unsigned(6 downto 0)
    );
end entity unidade_controle;

architecture rtl of unidade_controle is

signal op_code : unsigned(4 downto 0);
signal flag_LD_const_ParaAcumulador : STD_LOGIC;
signal flag_LD_mem_ParaAcumulador : STD_LOGIC;
signal flag_LD_Acumulador_ParaMem : STD_LOGIC;

signal flag_MOV_Mem_ParaAcumulador : std_logic;
signal flag_MOV_Acumulador_ParaMem : std_logic;

signal flag_ADD_Acumulador_Mem : std_logic;
signal flag_SUB_Acumulador_Mem : std_logic;
    
-- signal flag_jump_cond_flag_fico_0_aleluia : std_logic := '0';
begin
    -- Pega somente os opcodes necessarios
    op_code <= dado(16 downto 12);

    wr_en_flag_jump <= '1' when(estado = "11") and
        (flag_ADD_Acumulador_Mem = '1' or
         flag_SUB_Acumulador_Mem = '1')
    else '0';

    wr_en_pc <= '1' when estado = "00" and contagem_instruction_ROM < "111111" else '0';
    wr_en_banco_reg <= '1' when estado = "11" else '0';
    wr_en_acumulador <= '1' when -- Precisa atualizar o acumulador quando for
        (flag_LD_const_ParaAcumulador = '1' or
         flag_LD_mem_ParaAcumulador = '1' or
         flag_MOV_Mem_ParaAcumulador = '1' or
         flag_ADD_Acumulador_Mem = '1' or
         flag_SUB_Acumulador_Mem = '1' or
        -- Alterado a partir daqui

        op_code  = "00011" or     -- soma
        op_code  = "00100" or     -- subtracao
        op_code  = "00111") and    -- ou soma constante
        estado = "11"             -- E estiver no estado de EXECUTE
    else '0';
    wr_en_ula <= '1' when
        (estado = "11") and
        (flag_ADD_Acumulador_Mem = '1' or
         flag_SUB_Acumulador_Mem = '1')
    else '0';
    wr_en <= '1' when
        estado = "11" and
        (flag_LD_mem_ParaAcumulador = '1' or
         flag_LD_Acumulador_ParaMem = '1' or
         flag_MOV_Mem_ParaAcumulador = '1' or
         flag_MOV_Acumulador_ParaMem = '1')
        --  flag_ADD_Acumulador_Mem = '1' or
        --  flag_SUB_Acumulador_Mem = '1')
            
        --  op_code  = "01010" or     -- Escrita de um dado da memoria RAM para o REGISTRADOR
        --  op_code  = "01001" or     -- Escrita de um dado do ACUMULADOR para a memoria RAM
        --  op_code  = "01011")       -- Escrita de um dado do REGISTRADOR para a memoria RAM
    else '0';
    wr_en_ponteiro <= '1' when
    estado = "10" and
        (flag_LD_mem_ParaAcumulador = '1' or
         flag_LD_Acumulador_ParaMem = '1' or
         flag_MOV_Mem_ParaAcumulador = '1' or
         flag_MOV_Acumulador_ParaMem = '1' or
         flag_ADD_Acumulador_Mem = '1' or
         flag_SUB_Acumulador_Mem = '1')
            
        --  op_code  = "01010" or     -- Escrita de um dado da memoria RAM para o REGISTRADOR
        --  op_code  = "01001" or     -- Escrita de um dado do ACUMULADOR para a memoria RAM
        --  op_code  = "01011")       -- Escrita de um dado do REGISTRADOR para a memoria RAM
    else '0';

    -- Verificar o que vai fazer com o LD
    flag_LD_const_ParaAcumulador <= '1' when
        op_code = "00001" and
        dado(11 downto 10) = "00" else
    '0';

    flag_LD_mem_ParaAcumulador <= '1' when
        op_code = "00001" and
        dado(11 downto 10) = "01" else
    '0';

    flag_LD_Acumulador_ParaMem <= '1' when
        op_code = "00001" and
        dado(11 downto 10) = "10" else
    '0';

    flag_MOV_Mem_ParaAcumulador <= '1' when
        op_code = "00010" and
        dado(11 downto 10) = "00" else
    '0';

    flag_MOV_Acumulador_ParaMem <= '1' when
        op_code = "00010" and
        dado(11 downto 10) = "01" else
    '0';

    flag_ADD_Acumulador_Mem <= '1' when
        op_code = "00011" else
    '0';

    flag_SUB_Acumulador_Mem <= '1' when
        op_code = "00100" else
    '0';



    -- --------------------- MOV
    -- Caso o op_code MOV ou Atribuir o acumulador para algum registrador, entao eh para atribuir um valor para o registrador
    -- reg_escrita <= 
    --     dado(11 downto 9) when op_code = "00001" else    -- Especifica em qual registrador deve ser escrito quando for atribuir uma constante
    --     dado(2 downto 0) when op_code = "00110" else     -- Especifica em qual registrador deve ser escrito quando for atribuir o acumulador
    --     dado(11 downto 9) when op_code = "01010" else    -- Reg x deve ser escrito quando for atribuido o valor da RAM nele
    --     (others => '0');
    -- -- O banco de registradores vai receber os dados quando for
    -- data_in_banco <= resize(dado(8 downto 0), data_in_banco'length) when
    --     op_code = "00001"                                           -- Atribuir constante para registrador
    -- else data_out_acumulador when
    --     op_code = "00110"                                           -- Atribuir Acumulador para registrador
    -- else dado_out when
    --     op_code = "01010" else                                      -- Atribuir valor da RAM para registrador
    --     (others => '0');

    -- --------------------- LD
    -- reg1_leitura <= dado(2 downto 0) when    -- Precisa atualizar qual registrador sera lido do banco de registradores quando
    --         op_code = "00011" or    -- soma
    --         op_code = "00100" else  -- Ou subtracao
    --     dado(11 downto 9) when
    --         op_code = "01011"       -- Pegar o valor de um registrador para atribuir na RAM
    --     else (others => '0');

    data_in_acumulador <= data_in_ac when               -- O Acumulador vai receber o resultado da ULA quando for
        flag_ADD_Acumulador_Mem = '1' or
        flag_SUB_Acumulador_Mem = '1'
    else "111111" & dado(9 downto 0) when dado(9) = '1' and flag_LD_const_ParaAcumulador = '1' -- Verificando se o valor eh negativo e adicionando 1 para esquerda
    else resize(dado(9 downto 0), data_in_acumulador'length) when flag_LD_const_ParaAcumulador = '1'
    else dado_out when flag_LD_mem_ParaAcumulador = '1' or flag_MOV_Mem_ParaAcumulador = '1';

    entrada2_ula <= dado_out when flag_ADD_Acumulador_Mem = '1' or flag_SUB_Acumulador_Mem = '1';
    
    -- resize(dado(4 downto 0), entrada2_ula'length) when -- Outra entrada da ULA vai ser
    --     op_code = "00100" or        -- Uma constante quando for subtracao
    --     op_code = "00111"           -- Uma constante quando for soma com constante
    --     else reg1_leitura_saida;    -- Se nao, vai ser o valor do registrador mesmo

    -- --------------------- JUMP (foi alterado o componente pc)
    jump_flag <= '1' when
        op_code = "00101"
    else '0';
    jump_address <= resize(dado(11 downto 0), jump_address'length) when op_code = "00101" else
        "111111111111" & dado(11 downto 0) when dado(11) = '1' and op_code = "00110" else
        resize(dado(11 downto 0), jump_address'length) when dado(11) = '0' and op_code = "00110";

    -- --------------------- JUMP CONDICIONAL (foi alterado o componente pc)
    -- flag_jump_cond_flag_fico_0_aleluia <= '1' when jump_cond_flag_ula = '0' else '0' when op_code = "00110" and estado = "11";
    jump_cond_flag <= dado_flag_jump when op_code = "00110"
    else '0';
    dado_in_flag_jump <= jump_cond_flag_ula;
    -- process(estado)
    -- begin
    --     if jump_cond_flag_ula = '1' then
    --         flag_jump_cond_flag_fico_0_aleluia <= '1';
    --     else flag_jump_cond_flag_fico_0_aleluia <= '0';
    --     end if;
    -- end process;

    --------------------- Soma ou Subtracao
    selecao <= "00" when flag_ADD_Acumulador_Mem = '1' else -- Soma
               "01" when flag_SUB_Acumulador_Mem = '1' else -- Subtracao
               "10";                            -- Do nothing

    -- --------------------- RAM
    endereco <= dado_out_ponteiro when -- Ponteiro apontando para qual endereco da RAM deve ser usado para o processamento
        -- op_code  = "01010" or     -- Escrita de um dado da memoria RAM para o REGISTRADOR
        -- op_code  = "01001" or     -- Escrita de um dado do ACUMULADOR para a memoria RAM
        -- op_code  = "01011";       -- Escrita de um valor do REGISTRADOR para a memoria RAM
        flag_LD_Acumulador_ParaMem  = '1' or
        flag_MOV_Acumulador_ParaMem = '1' or
        flag_ADD_Acumulador_Mem = '1' or
        flag_SUB_Acumulador_Mem = '1';

    
    dado_in_ponteiro <= dado(6 downto 0) when -- <- O ponteiro vai receber em qual memoria deve acessar (por meio do valor especificado da ROM) e vai passar para o endereco da RAM 
        flag_LD_Acumulador_ParaMem  = '1' or
        flag_MOV_Acumulador_ParaMem = '1' or
        flag_ADD_Acumulador_Mem = '1' or
        flag_SUB_Acumulador_Mem = '1';

    -- dado_in_ponteiro <= dado(6 downto 0) when -- <- O ponteiro vai receber em qual memoria deve acessar (por meio do valor especificado da ROM) e vai passar para o endereco da RAM 
    --     op_code  = "01010" or     -- Escrita de um dado da memoria RAM para o REGISTRADOR
    --     op_code  = "01001" or     -- Escrita de um dado do ACUMULADOR para a memoria RAM
    --     op_code  = "01011";       -- Escrita de um valor do REGISTRADOR para a memoria RAM
    

    dado_in <= resize(data_out_acumulador, data_out_acumulador'length) when 
        flag_LD_Acumulador_ParaMem = '1' or
        flag_MOV_Acumulador_ParaMem = '1' or
        flag_ADD_Acumulador_Mem = '1' or
        flag_SUB_Acumulador_Mem = '1';

    
    

end architecture rtl;