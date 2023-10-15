 pragma circom  2.0.0;

include "../../node_modules/circomlib/circuits/poseidon.circom";

template RollUp() {
   // Declaration of signals.
   signal input tx;
   signal input c;
   signal output v;
   signal output r;

   // Constraints.
   component hash1 = Poseidon(2);
   component hash2 = Poseidon(2);

   hash1.inputs[0] <== tx;
   hash1.inputs[1] <== 1;
   hash2.inputs[0] <== tx;
   hash2.inputs[1] <== c;

   v <== hash1.out;
   r <== hash2.out;
}

component main {public [c]} = RollUp();