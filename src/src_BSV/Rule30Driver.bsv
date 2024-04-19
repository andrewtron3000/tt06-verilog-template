// ================================================================
// Project imports

import StmtFSM :: *;
import Rule30 :: *;
import RS232 :: *;
import GetPut :: *;

typedef enum {
   INITIAL,
   IDLE,
   WORKING
} State deriving (Bits, Eq);

typedef enum {
   NORMAL,
   CHRISTMAS_SURPRISE
} OperationMode deriving (Bits, Eq);

interface Rule30Driver_Ifc;
   method Action operation_mode(Bit#(8) arg);
   method Action startup_value(Bit#(8) v);
   interface RS232 txrx;
endinterface

// ================================================================

(* synthesize *)
module mkRule30Driver (Rule30Driver_Ifc);

   Reg#(OperationMode) op_mode <- mkReg(NORMAL);

   Reg#(Bit#(8)) a <- mkReg(8'b00000000);
   Reg#(State) transmit_state <- mkReg(INITIAL);

   /* Assuming a 50MHz clock, divisor for 115200 is 434 / 16 = 27 */
   UART#(3) uart <- mkUART(8, NONE, STOP_1, 27);
   Rule30_Ifc rule30 <- mkRule30();

   Stmt xmas_stmt = ( seq while (op_mode == CHRISTMAS_SURPRISE)
                        seq
                           uart.rx.put(8'h4D); // M                          
                           uart.rx.put(8'h65); // e
                           uart.rx.put(8'h72); // r
                           uart.rx.put(8'h72); // r
                           uart.rx.put(8'h79); // y
                           uart.rx.put(8'h20); // 
                           uart.rx.put(8'h58); // x
                           uart.rx.put(8'h6D); // m
                           uart.rx.put(8'h61); // a
                           uart.rx.put(8'h73); // s
                           uart.rx.put(8'h20); // 
                           uart.rx.put(8'h27); // '
                           uart.rx.put(8'h32); // 2
                           uart.rx.put(8'h34); // 4
                           uart.rx.put(8'h20); // 
                           uart.rx.put(8'h53); // S
                           uart.rx.put(8'h74); // t
                           uart.rx.put(8'h72); // r
                           uart.rx.put(8'h61); // a
                           uart.rx.put(8'h74); // t
                           uart.rx.put(8'h6F); // o
                           uart.rx.put(8'h73); // s
                           uart.rx.put(8'h21); // !
                           uart.rx.put(8'h09); // \t
                           uart.rx.put(8'h09); // \t
                        endseq
                      endseq );
   
   FSM xmas_fsm <- mkFSM(xmas_stmt);

   rule dump_rx;
      let rx_unused <- uart.tx.get();
   endrule

   rule compute if ( (transmit_state == IDLE) && (op_mode == NORMAL) );
      rule30.start(a);
      transmit_state <= WORKING;
   endrule

   rule get_result if ( (transmit_state == WORKING) && (op_mode == NORMAL) && (xmas_fsm.done));
      let x <- rule30.getResult;
      a <= x;
      uart.rx.put(x);
      transmit_state <= IDLE;
   endrule

   method Action operation_mode(Bit#(8) arg) if ( (transmit_state == INITIAL) && (op_mode == NORMAL) );
      if (arg == 8'ha5) begin
         op_mode <= CHRISTMAS_SURPRISE;
         xmas_fsm.start();
      end
   endmethod

   method Action startup_value(Bit#(8) v) if ( (transmit_state == INITIAL) && (op_mode == NORMAL) );
      a <= v;
      transmit_state <= IDLE;
   endmethod

   interface RS232 txrx;
      method sout = uart.rs232.sout();
      method sin = uart.rs232.sin;
   endinterface

endmodule
