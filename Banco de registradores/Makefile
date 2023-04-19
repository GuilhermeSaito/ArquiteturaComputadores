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

clean:
	rm -f *.cf
	rm -f *.ghw