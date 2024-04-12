# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: MIT

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, FallingEdge

@cocotb.test()
async def test_project(dut):
  dut._log.info("Start")

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

  # Test that the UART toggles.
  assert RisingEdge(dut.uo_out[4])
  assert FallingEdge(dut.uo_out[4])
