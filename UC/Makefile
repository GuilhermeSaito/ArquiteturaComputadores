all:

rom:
	ghdl -a rom.vhd
	ghdl -e rom
	ghdl -a rom_tb.vhd
	ghdl -e rom_tb
	ghdl -r rom_tb --wave=rom_tb.ghw
	gtkwave rom_tb.ghw

maq_estados:
	ghdl -a maquina_estados.vhd
	ghdl -e maquina_estados
	ghdl -a maquina_estados_tb.vhd
	ghdl -e maquina_estados_tb
	ghdl -r maquina_estados_tb --wave=maquina_estados_tb.ghw
	gtkwave maquina_estados_tb.ghw

pc:
	ghdl -a pc.vhd
	ghdl -e pc
	ghdl -a pc_tb.vhd
	ghdl -e pc_tb
	ghdl -r pc_tb --wave=pc_tb.ghw
	gtkwave pc_tb.ghw

pc_mais_um:
	ghdl -a pc.vhd
	ghdl -e pc
	ghdl -a soma1_pc.vhd
	ghdl -e soma1_pc
	ghdl -a pc_mais_um_tb.vhd
	ghdl -e pc_mais_um_tb
	ghdl -r pc_mais_um_tb --wave=pc_tb.ghw
	gtkwave pc_tb.ghw

pc_e_rom:
	ghdl -a pc.vhd
	ghdl -e pc
	ghdl -a soma1_pc.vhd
	ghdl -e soma1_pc
	ghdl -a rom.vhd
	ghdl -e rom
	ghdl -a pc_e_rom.vhd
	ghdl -e pc_e_rom
	ghdl -r pc_e_rom --wave=pc_e_rom.ghw
	gtkwave pc_e_rom.ghw

rom_e_estados:
	ghdl -a pc.vhd
	ghdl -e pc
	ghdl -a soma1_pc.vhd
	ghdl -e soma1_pc
	ghdl -a rom.vhd
	ghdl -e rom
	ghdl -a rom_e_estados.vhd
	ghdl -e rom_e_estados
	ghdl -a maquina_estados.vhd
	ghdl -e maquina_estados
	ghdl -r rom_e_estados --wave=rom_e_estados.ghw
	gtkwave rom_e_estados.ghw

jump:
	ghdl -a pc.vhd
	ghdl -e pc
	ghdl -a soma1_pc.vhd
	ghdl -e soma1_pc
	ghdl -a rom.vhd
	ghdl -e rom
	ghdl -a maquina_estados.vhd
	ghdl -e maquina_estados
	ghdl -a jump.vhd
	ghdl -e jump
	ghdl -r jump --wave=jump.ghw
	gtkwave jump.ghw

clean:
	rm -f *.cf
	rm -f *.ghw