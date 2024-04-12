interface Rule30_Ifc;
   method Action start(Bit#(8) a);
   method ActionValue#(Bit#(8)) getResult;
endinterface

(* synthesize *)
module mkRule30(Rule30_Ifc);
   Reg#(Bit#(8)) x <- mkReg(0);
   Reg#(Bit#(8)) r30 <- mkReg(8'd30);
   Reg#(Bool) busy_flag <- mkReg(False);
   Reg#(Bool) step_complete <- mkReg(False);

   rule stepper if (busy_flag && !step_complete);
      let b0 = { x[1], x[0], 1'b0};
      let b1 = { x[2], x[1], x[0]};
      let b2 = { x[3], x[2], x[1]};
      let b3 = { x[4], x[3], x[2]};
      let b4 = { x[5], x[4], x[3]};
      let b5 = { x[6], x[5], x[4]};
      let b6 = { x[7], x[6], x[5]};
      let b7 = { 1'b0, x[7], x[6]};
      x <= {r30[b7], r30[b6], r30[b5], r30[b4], r30[b3], r30[b2], r30[b1], r30[b0]};
      step_complete <= True;
   endrule

   method Action start(Bit#(8) a) if (!busy_flag);
      x <= a;
      busy_flag <= True;
      step_complete <= False;
   endmethod

   method ActionValue#(Bit#(8)) getResult if (busy_flag && step_complete);
      busy_flag <= False;
      return x;
   endmethod
endmodule