all:
	ghdl -a reg16bits.vhd
	ghdl -e reg16bits
	ghdl -a banco_reg.vhd
	ghdl -e banco_reg
	ghdl -a ula.vhd
	ghdl -e ula
	ghdl -a banco_reg_ula_tb.vhd
	ghdl -e banco_reg_ula_tb
	ghdl -r banco_reg_ula_tb --wave=banco_reg_ula_tb.ghw
	gtkwave banco_reg_ula_tb.ghw

maq_estados:
	ghdl -a maquina_estados.vhd
	ghdl -e maquina_estados
	ghdl -a maquina_estados_tb.vhd
	ghdl -e maquina_estados_tb
	ghdl -r maquina_estados_tb --wave=maquina_estados_tb.ghw
	gtkwave maquina_estados_tb.ghw

pc:
	ghdl -a program_counter.vhd
	ghdl -e program_counter
	ghdl -a soma1_pc.vhd
	ghdl -e soma1_pc
	ghdl -a program_counter_tb.vhd
	ghdl -e program_counter_tb
	ghdl -r program_counter_tb --wave=program_counter_tb.ghw
	gtkwave program_counter_tb.ghw

rom_pc:
	ghdl -a program_counter.vhd
	ghdl -e program_counter
	ghdl -a soma1_pc.vhd
	ghdl -e soma1_pc
	ghdl -a rom.vhd
	ghdl -e rom
	ghdl -a rom_pc_tb.vhd
	ghdl -e rom_pc_tb
	ghdl -r rom_pc_tb --wave=rom_pc_tb.ghw
	gtkwave rom_pc_tb.ghw

clean:
	rm -f *.cf
	rm -f *.ghw