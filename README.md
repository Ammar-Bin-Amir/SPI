# SPI

SPI (Serial Peripheral Interface) is a synchronous serial communication protocol widely used for interfacing microcontrollers, sensors, memory devices, and other peripheral components within embedded systems.

## Verilog Implementation

The RTL design of SPI has been implemented by using verilog. The architecture is divided into three essential modules: the Master, Slave, and the SPI top-level module that acts as the Register Interface (RIF) unit.

## Architecture

The master device initiates communication by generating clock pulses and selecting the slave device. The communication occurs via four essential lines: MOSI (Master Out Slave In) for data transmission from master to slave, MISO (Master In Slave Out) for data transmission from slave to master, SCLK (Serial Clock) for clock synchronization, and CS (Chip Select) for selecting the target slave device.

## Transaction Format

The transaction involves three distinct bit-streams of data. 

### - 8-Bit Command

This segment of the transaction serves as an instruction for the target device or peripheral, indicating the operation to be executed. The 8-bit value signifies commands such as read, write, specific function triggers, or control instructions tailored to the device's functionalities.

### * 24-Bit Command

The 24-bit address field specifies the memory location or register within the target device. This extended addressing range (24 bits) allows for addressing various memory locations or registers, providing flexibility for data access or manipulation.

### + 32-Bit Data

This portion contains a 32-bit value that embodies the actual data payload transmitted or received during the transaction. The data could represent information intended for writing into a designated memory location or the content read from the specified address, carrying crucial information or payload data.
