all:
	ghdl -a reg16bits.vhd
	ghdl -e reg16bits
	ghdl -a soma1_pc.vhd
	ghdl -e soma1_pc
	ghdl -a reg_instrucao.vhd
	ghdl -e reg_instrucao
	ghdl -a pc.vhd
	ghdl -e pc
	ghdl -a maq_estados.vhd
	ghdl -e maq_estados
	ghdl -a banco_reg.vhd
	ghdl -e banco_reg
	ghdl -a rom.vhd
	ghdl -e rom
	ghdl -a ula.vhd
	ghdl -e ula
	ghdl -a top_level.vhd
	ghdl -e top_level
	ghdl -a top_level_tb.vhd
	ghdl -e top_level_tb
	ghdl -r top_level_tb --wave=top_level_tb.ghw
	gtkwave top_level_tb.ghw

clean:
	rm -f *.cf
	rm -f *.ghw