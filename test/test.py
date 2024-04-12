# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles
from cocotbext.uart import UartSink

@cocotb.test()
async def test_project(dut):
  dut._log.info("Start")

  uart_sink = UartSink(dut.uo_out[4], baud=115200, bits=8)
  
  # Define the clock at 50 MHz
  clock = Clock(dut.clk, 20, units="ns")
  cocotb.start_soon(clock.start())

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

  # Await UART data to come back
  # Input  0x80:  _10000000_
  # Output 0xC0:   11000000           
  data = await uart_sink.recv(1)
  assert data == 0xC0

  # Input  0xC0:  _11000000_
  # Output 0xA0:   10100000           
  data = await uart_sink.recv(1)
  assert data == 0xA0

  # Input  0xA0:  _10100000_
  # Output 0xB0:   10110000           
  data = await uart_sink.recv(1)
  assert data == 0xB0
