# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, Timer, RisingEdge, FallingEdge

# Using the read_packet function from the following project:
# https://github.com/enieman/uart_programmable_rv32i/blob/main/LICENSE
# https://github.com/enieman/uart_programmable_rv32i/blob/main/test/test.py
async def read_packet(dut):
  # Wait for start bit
  while (dut.uo_out.value & 0x10) == 0x10:
    await ClockCycles(dut.clk, 1)
  # Wait out start bit, align with middle of first data bit
  await Timer(13022, units="ns") # 115200 bit/sec, 1.5 bits
  # Read data
  data = 0
  for i in range(0,8):
    if (dut.uo_out.value & 0x10) == 0x10:
      data = data | (1 << i)
    await Timer(8681, units="ns") # 115200 bit/sec, 1 bit
  # Wait out rest of data bit
  await Timer(4341, units="ns") # 115200 bit/sec, 0.5 bit
  return(data)

@cocotb.test()
async def test_project(dut):
  dut._log.info("Start")

  # Define the clock at 50 MHz
  clock = Clock(dut.clk, 20, units="ns")
  cocotb.start_soon(clock.start())

  #
  # Test 1
  #

  # Set some initial values.  Start disabled.
  dut.ena.value = 0
  dut.ui_in.value = 0x80
  dut.uio_in.value = 0

  # Reset
  dut._log.info("Reset")
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 20)
  dut.rst_n.value = 1

  # Set the input values, wait clock cycle, and check the output
  dut._log.info("Test")
  dut.ena.value = 1

  # Read three UART bytes in
  data_list = [0, 0, 0]
  for i in range(0, len(data_list)):
    data_list[i] = await read_packet(dut)

  # Do some asserts
  assert (data_list[0] == 0xC0)
  assert (data_list[1] == 0x20)
  assert (data_list[2] == 0xF0)


  #
  # Test 2
  #

  # Set some initial values.  Start disabled.
  dut.ena.value = 0
  dut.ui_in.value = 0x80
  dut.uio_in.value = 0xa5

  # Reset
  dut._log.info("Reset")
  dut.rst_n.value = 0
  await ClockCycles(dut.clk, 20)
  dut.rst_n.value = 1

  # Set the input values, wait clock cycle, and check the output
  dut._log.info("Test")
  dut.ena.value = 1

  # Read three UART bytes in
  data_list = [0] * 25
  for i in range(0, 25):
    data_list[i] = await read_packet(dut)

  # Do some asserts
  assert (data_list[0] == 0x4D)
  assert (data_list[1] == 0x65)
  assert (data_list[2] == 0x72)
  assert (data_list[3] == 0x72)
  assert (data_list[4] == 0x79)
  assert (data_list[5] == 0x20)
  assert (data_list[6] == 0x58)
  assert (data_list[7] == 0x6D)
  assert (data_list[8] == 0x61)
  assert (data_list[9] == 0x73)
  assert (data_list[10] == 0x20)
  assert (data_list[11] == 0x27)
  assert (data_list[12] == 0x32)
  assert (data_list[13] == 0x34)
  assert (data_list[14] == 0x20)
  assert (data_list[15] == 0x53)
  assert (data_list[16] == 0x74)
  assert (data_list[17] == 0x72)
  assert (data_list[18] == 0x61)
  assert (data_list[19] == 0x74)
  assert (data_list[20] == 0x6F)
  assert (data_list[21] == 0x73)
  assert (data_list[22] == 0x21)
  assert (data_list[23] == 0x09)
  assert (data_list[24] == 0x09)
