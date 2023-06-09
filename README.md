# ArquiteturaComputadores
Repositorio para guardar os codigos desenvolvidos na disciplina

## Comandos para rodar
- "Compilando os arquivos .vhdl, tanto do testbench quanto do negocio msm"
```ghdl -a <nomeArquivo>.vhd```
```ghdl -e <nomeArquivo>```

```ghdl -r <nomeArquivo_tb> --wave=<nomeArquivo_tb>.ghw```
```gtkwave <nomeArquivo_tb>.ghw```

# OP CODES que está na ROM
| op_code        |  exemplo op_code no vhdl | exemplo          | descricao                                                                     |
| -------------  |  ---------------         |---------------   | ------                                                                        |
| 00001          |  00001_011_000000000     | MOV $reg3, 0     | Atribui constante para registrador                                            |
| 00010          |  00010_000001000_011     | LD A, $reg3      | Atribui valor do registrador para acumulador (contrario do 00110)             |
| 00011          |  00011_0000010_00100     | ADD A, $reg4     | Faz a adicao de acumulador com registrador, o valor eh gravado no acumulador  |
| 00100          |  00100_0000010_11110     | SUB $A, 30       | Faz a subtracao de acumulador com constante, o valor eh gravado no acumulador |
| 00101          |  00101_000000010100      | JP 20            | Faz o jump para alguma instrucao da ROM                                       |
| 00110          |  00110_000001000_101     | LD A, $reg5      | Atribui valor do acumulador para registrador (contrario do 00010)             |
| 00111          |  00111_0000010_00001     | ADD A, 1         | Faz a adicao de acumulador com constante, o valor eh gravado no acumulador    |
| 01000          |  01000_000000000111      | JREQ -7          | Jump condicional, eh necessario fazer um (00100 (sub com constante) antes para que seja retornar true ou false), ele recebe o valor em que deve somar para ir para a proxima ou anterior instrucao     |
| 01001          |  01001_000_000011101     | LD A, 0x1d       | Atribui o valor do acumulador na memoria x (no exemplo eh 29) da RAM          |
| 01010          |  01010_111_000101110     | LD $reg4, 0x3f   | Atribui o valor da memoria x (no caso eh a 63) da RAM no registrador 4        |
| 01011          |  01011_011_000001010     | LD $reg3, 0xA    | Atribui o valor do reg3 na memoria x (no caso a 10) da RAM                    |