/*
 * Copyright (c) 2024 andrewtron3000
 * SPDX-License-Identifier: Apache-2.0
 */

`define default_netname none

module tt_um_andrewtron3000 (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // Held in reset while ena is not set
  wire reset_n;
  assign reset_n = rst_n & ena;

  assign uio_oe  = 8'b00000000; // All bidirectional outputs disabled
  assign uio_out = 0;
  
  // Assign output
  assign uo_out[0] = 0;
  assign uo_out[1] = 0;
  assign uo_out[2] = 0;
  assign uo_out[3] = 0;
  assign uo_out[4] = driver_sout;   // uo_out[4] is UART TX
  assign uo_out[5] = 0;
  assign uo_out[6] = 0;
  assign uo_out[7] = 0;

  // ports of submodule driver
  wire driver_sin, driver_sout;
  assign driver_sin = 0;

  wire startup_input_ready;
  wire startup_input_enable;
  wire operation_mode_ready;
  wire operation_mode_enable;

  // submodule rule_30_driver
  mkRule30Driver rule_30_driver(.CLK(clk),
				.RST_N(reset_n),

        .operation_mode_arg(uio_in),
        .EN_operation_mode(operation_mode_enable),
        .RDY_operation_mode(operation_mode_ready),

				.startup_value_v(ui_in),
				.EN_startup_value(startup_input_enable),
				.RDY_startup_value(startup_input_ready),

				.txrx_SIN(driver_sin),
				.txrx_SOUT(driver_sout));

  assign startup_input_enable = startup_input_ready;
  assign operation_mode_enable = operation_mode_ready;

endmodule
