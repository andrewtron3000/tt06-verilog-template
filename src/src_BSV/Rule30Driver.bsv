// ================================================================
// Project imports

import Rule30 :: *;
import RS232 :: *;
import GetPut :: *;

typedef enum {
   INITIAL,
   IDLE,
   WORKING
} State deriving (Bits, Eq);

interface Rule30Driver_Ifc;
   method Action startup_value(Bit#(8) v);
   interface RS232 txrx;
endinterface

// ================================================================

(* synthesize *)
module mkRule30Driver (Rule30Driver_Ifc);

   Reg#(Bit#(8)) a <- mkReg(8'b00000000);
   Reg#(State) transmit_state <- mkReg(INITIAL);

   /* Assuming a 50MHz clock, divisor for 115200 is 434 / 16 = 27 */
   UART#(3) uart <- mkUART(8, NONE, STOP_1, 27);
   Rule30_Ifc rule30 <- mkRule30();

   rule dump_rx;
      let rx_unused <- uart.tx.get();
   endrule

   rule compute if (transmit_state == IDLE);
      rule30.start(a);
      transmit_state <= WORKING;
   endrule

   rule get_result if (transmit_state == WORKING);
      let x <- rule30.getResult;
      a <= x;
      uart.rx.put(x);
      transmit_state <= IDLE;
   endrule

   method Action startup_value(Bit#(8) v) if (transmit_state == INITIAL);
      a <= v;
      transmit_state <= IDLE;
   endmethod

   interface RS232 txrx;
      method sout = uart.rs232.sout();
      method sin = uart.rs232.sin;
   endinterface

endmodule
