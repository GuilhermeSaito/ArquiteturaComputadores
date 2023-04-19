# O que precisa ser feito nesta tarefa

# No arquivo banco_reg_ula_tb.vhd

• ligue a saída da ULA na entrada de dados do banco;

• ligue uma saída do banco direto numa das entradas da ULA;

• ligue a outra saída do banco num MUX, e a saída do MUX na ULA;

• ligue um pino de entrada top level na outra entrada do MUX (será a entrada de uma
constante externa);

• ligue pinos de entrada em clk, rst e write enable;

• ligue um pino de saída extra à saída da ULA para poder debugar no top level.

# Para rodar

- Como tem um Makefile, simplesmente:
```make```

- Para retirar todos os arquivos .cf ou .ghw
```make clean```