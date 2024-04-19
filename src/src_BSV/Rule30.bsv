interface Rule30_Ifc;
   method Action start(Bit#(8) a);
   method ActionValue#(Bit#(8)) getResult;
endinterface

(* synthesize *)
module mkRule30(Rule30_Ifc);
   Reg#(Bit#(24)) x <- mkReg(0);
   Reg#(Bit#(8)) r30 <- mkReg(8'd30);
   Reg#(Bool) busy_flag <- mkReg(False);
   Reg#(Bool) step_complete <- mkReg(False);

   rule stepper if (busy_flag && !step_complete);
      let b0 =  { x[1],  x[0],  1'b0};
      let b1 =  { x[2],  x[1],  x[0]};
      let b2 =  { x[3],  x[2],  x[1]};
      let b3 =  { x[4],  x[3],  x[2]};
      let b4 =  { x[5],  x[4],  x[3]};
      let b5 =  { x[6],  x[5],  x[4]};
      let b6 =  { x[7],  x[6],  x[5]};
      let b7 =  { x[8],  x[7],  x[6]};
      let b8 =  { x[9],  x[8],  x[7]};
      let b9 =  { x[10], x[9],  x[8]};
      let b10 = { x[11], x[10], x[9]};
      let b11 = { x[12], x[11], x[10]};
      let b12 = { x[13], x[12], x[11]};
      let b13 = { x[14], x[13], x[12]};
      let b14 = { x[15], x[14], x[13]};
      let b15 = { x[16], x[15], x[14]};
      let b16 = { x[17], x[16], x[15]};
      let b17 = { x[18], x[17], x[16]};
      let b18 = { x[19], x[18], x[17]};
      let b19 = { x[20], x[19], x[18]};
      let b20 = { x[21], x[20], x[19]};
      let b21 = { x[22], x[21], x[20]};
      let b22 = { x[23], x[22], x[21]};
      let b23 = { 1'b0,  x[23], x[22]};
      x <= {r30[b23], r30[b22], r30[b21], r30[b20], r30[b19], r30[b18], r30[b17], r30[b16], r30[b15], r30[b14], r30[b13], r30[b12], r30[b11], r30[b10], r30[b9], r30[b8], r30[b7], r30[b6], r30[b5], r30[b4], r30[b3], r30[b2], r30[b1], r30[b0]};
      step_complete <= True;
   endrule

   method Action start(Bit#(8) a) if (!busy_flag);
      x <= {8'b0, a, 8'b0};
      busy_flag <= True;
      step_complete <= False;
   endmethod

   method ActionValue#(Bit#(8)) getResult if (busy_flag && step_complete);
      busy_flag <= False;
      return x[15:8];
   endmethod
endmodule