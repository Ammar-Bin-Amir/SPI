# Verilog Files

SRC_MASTER = $(shell pwd)/src/SPI_Master.v
TB_MASTER = $(shell pwd)/tb/SPI_Master_tb.v
VVP_MASTER = $(shell pwd)/temp/SPI_Master_tb.vvp
VCD_MASTER = $(shell pwd)/temp/SPI_Master_tb.vcd

SRC_SLAVE = $(shell pwd)/src/SPI_Slave.v
TB_SLAVE = $(shell pwd)/tb/SPI_Slave_tb.v
VVP_SLAVE = $(shell pwd)/temp/SPI_Slave_tb.vvp
VCD_SLAVE = $(shell pwd)/temp/SPI_Slave_tb.vcd

SRC_SPI = $(shell pwd)/src/SPI.v
TB_SPI = $(shell pwd)/tb/SPI_tb.v
VVP_SPI = $(shell pwd)/temp/SPI_tb.vvp
VCD_SPI = $(shell pwd)/temp/SPI_tb.vcd

# Compilation Settings

COMPILER = iverilog
COMPILER_FLAG = -o

# Simulation Settings

SIMULATION_FLAG = vvp

# Target: MAIN

all: spi

everything: spi master slave

clean: 
	rm -rf temp

# Target: Master Adaptor

master: compile_master
	$(SIMULATION_FLAG) $(VVP_MASTER)

compile_master: 
	mkdir -p temp
	$(COMPILER) $(COMPILER_FLAG) $(VVP_MASTER) $(TB_MASTER) $(SRC_MASTER)

clean_master: 
	rm -rf $(VCD_MASTER)
	rm -rf $(VVP_MASTER)

# Target: Slave Adaptor

slave: compile_slave
	$(SIMULATION_FLAG) $(VVP_SLAVE)

compile_slave: 
	mkdir -p temp
	$(COMPILER) $(COMPILER_FLAG) $(VVP_SLAVE) $(TB_SLAVE) $(SRC_SLAVE)

clean_slave: 
	rm -rf $(VCD_SLAVE)
	rm -rf $(VVP_SLAVE)

# Target: SPI

spi: compile_spi
	$(SIMULATION_FLAG) $(VVP_SPI)

compile_spi: 
	mkdir -p temp
	$(COMPILER) $(COMPILER_FLAG) $(VVP_SPI) $(TB_SPI) $(SRC_SPI) $(SRC_MASTER) $(SRC_SLAVE)

clean_spi: 
	rm -rf $(VCD_SPI)
	rm -rf $(VVP_SPI)

