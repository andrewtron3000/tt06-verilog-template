interface Rule30_Ifc;
   method Action start(Bit#(8) a);
   method ActionValue#(Bit#(8)) getResult;
endinterface

(* synthesize *)
module mkRule30(Rule30_Ifc);
   Reg#(Bit#(56)) x <- mkReg(0);
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
      let b23 = { x[24], x[23], x[22]};
      let b24 = { x[25], x[24], x[23]};
      let b25 = { x[26], x[25], x[24]};
      let b26 = { x[27], x[26], x[25]};
      let b27 = { x[28], x[27], x[26]};
      let b28 = { x[29], x[28], x[27]};
      let b29 = { x[30], x[29], x[28]};
      let b30 = { x[31], x[30], x[29]};
      let b31 = { x[32], x[31], x[30]};
      let b32 = { x[33], x[32], x[31]};
      let b33 = { x[34], x[33], x[32]};
      let b34 = { x[35], x[34], x[33]};
      let b35 = { x[36], x[35], x[34]};
      let b36 = { x[37], x[36], x[35]};
      let b37 = { x[38], x[37], x[36]};
      let b38 = { x[39], x[38], x[37]};
      let b39 = { x[40], x[39], x[38]};
      let b40 = { x[41], x[40], x[39]};
      let b41 = { x[42], x[41], x[40]};
      let b42 = { x[43], x[42], x[41]};
      let b43 = { x[44], x[43], x[42]};
      let b44 = { x[45], x[44], x[43]};
      let b45 = { x[46], x[45], x[44]};
      let b46 = { x[47], x[46], x[45]};
      let b47 = { x[48], x[47], x[46]};
      let b48 = { x[49], x[48], x[47]};
      let b49 = { x[50], x[49], x[48]};
      let b50 = { x[51], x[50], x[49]};
      let b51 = { x[52], x[51], x[50]};
      let b52 = { x[53], x[52], x[51]};
      let b53 = { x[54], x[53], x[52]};
      let b54 = { x[55], x[54], x[53]};
      let b55 = { 1'b0,  x[55], x[54]};
      x <= {r30[b55], r30[b54], r30[b53], r30[b52], r30[b51], r30[b50], r30[b49], r30[b48], 
            r30[b47], r30[b46], r30[b45], r30[b44], r30[b43], r30[b42], r30[b41], r30[b40], 
            r30[b39], r30[b38], r30[b37], r30[b36], r30[b35], r30[b34], r30[b33], r30[b32], 
            r30[b31], r30[b30], r30[b29], r30[b28], r30[b27], r30[b26], r30[b25], r30[b24], 
            r30[b23], r30[b22], r30[b21], r30[b20], r30[b19], r30[b18], r30[b17], r30[b16], 
            r30[b15], r30[b14], r30[b13], r30[b12], r30[b11], r30[b10], r30[b9],  r30[b8], 
            r30[b7],  r30[b6],  r30[b5],  r30[b4],  r30[b3],  r30[b2],  r30[b1],  r30[b0]};
      step_complete <= True;
   endrule

   method Action start(Bit#(8) a) if (!busy_flag);
      x <= {x[55:32], a, x[23:0]};
      busy_flag <= True;
      step_complete <= False;
   endmethod

   method ActionValue#(Bit#(8)) getResult if (busy_flag && step_complete);
      busy_flag <= False;
      return x[31:24];
   endmethod
endmodule