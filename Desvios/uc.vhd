library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity uc is
    port(
        -- Instrução de entrada
        entrada                          : IN unsigned(16 DOWNTO 0); 

        -- Regs a serem processados/movidos
        out_data_1, out_data_2           : OUT UNSIGNED(16 DOWNTO 0);         
        -- Destino (pc ou banco de reg) OBS: para instruções que não "pulam" dest é sempre banco pois o dado ou é movido entre regs ou é armazenado no acumulador
        dest                             : OUT UNSIGNED(2 DOWNTO 0);  
        -- Muxes que definem se o dado vai para a ula (soma/sub) ou para o banco de regs, bem como o destino da instrução      
        mux_out_1  : std_logic;
        mux_out_2  : std_logic;
        mux_out_3  : std_logic;
        --Write enables
        wr_banco_reg : out std_logic;
        -- Output de constante
        cte_out                          : OUT UNSIGNED(16 DOWNTO 0);   
        -- Jump flag
        jump_flag : std_logic                          
    );
    

end entity uc;


architecture a_uc of uc is
    signal op_code : unsigned(4 downto 0);
    signal ac      : unsigned(2 downto 0);
    begin
        
        process(entrada) is
        begin
            op_code <= entrada(16 downto 12);
        
            ac <= "111";
            case op_code is 
                -- LD : A <- CTE (B"xxxxx-xxx-xxxxxxxx)
                when "00001" =>
                    dest         <= ac;
                    out_data_1   <= entrada(8 downto 0) & x"00" ;
                    wr_banco_reg <= '1';
                when others =>
                    dest <= "000";
            end case;

        end process;
    
    end architecture a_uc; 