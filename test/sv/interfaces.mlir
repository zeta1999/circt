// RUN: circt-opt %s | FileCheck %s
// RUN: circt-opt %s | circt-opt | FileCheck %s

// CHECK-LABEL: module {
module {
  // Basic interface smoke test

  sv.interface @myinterface {
    sv.interface.signal @data : i32
    sv.interface.modport @input_port ("input" @data)
    sv.interface.modport @output_port ("output" @data)
  }

  // CHECK-NEXT: sv.interface @myinterface {
  // CHECK-NEXT:   sv.interface.signal @data : i32
  // CHECK-NEXT:   sv.interface.modport @input_port ("input" @data)
  // CHECK-NEXT:   sv.interface.modport @output_port ("output" @data)
  // CHECK-NEXT: }

  // Handshake-like interface smoke test

  sv.interface @handshake_example {
    sv.interface.signal @data : i32
    sv.interface.signal @valid : i1
    sv.interface.signal @ready : i1
    sv.interface.modport @dataflow_in ("input" @data, "input" @valid, "output" @ready)
    sv.interface.modport @dataflow_out ("output" @data, "output" @valid, "input" @ready)
  }

  // CHECK-NEXT: sv.interface @handshake_example {
  // CHECK-NEXT:   sv.interface.signal @data : i32
  // CHECK-NEXT:   sv.interface.signal @valid : i1
  // CHECK-NEXT:   sv.interface.signal @ready : i1
  // CHECK-NEXT:   sv.interface.modport @dataflow_in ("input" @data, "input" @valid, "output" @ready)
  // CHECK-NEXT:   sv.interface.modport @dataflow_out ("output" @data, "output" @valid, "input" @ready)
  // CHECK-NEXT: }

  rtl.externmodule @Rcvr (%m: !sv.modport<@handshake_example::@dataflow_in>)
  // CHECK-LABEL: rtl.externmodule @Rcvr(!sv.modport<@handshake_example::@dataflow_in> {rtl.name = "m"})

  rtl.module @Top () {
    %iface = sv.interface.instance : !sv.interface<@handshake_example>
    %ifaceInPort = sv.modport.get %iface @dataflow_in :
      !sv.interface<@handshake_example> -> !sv.modport<@handshake_example::@dataflow_in>
    rtl.instance "rcvr" @Rcvr(%ifaceInPort) : (!sv.modport<@handshake_example::@dataflow_in>) -> ()
  }
  // CHECK-LABEL: rtl.module @Top() {
  // CHECK-NEXT:    %0 = sv.interface.instance : !sv.interface<@handshake_example>
  // CHECK-NEXT:    %1 = sv.modport.get %0 @dataflow_in : !sv.interface<@handshake_example> -> !sv.modport<@handshake_example::@dataflow_in>
  // CHECK-NEXT:    rtl.instance "rcvr" @Rcvr(%1) : (!sv.modport<@handshake_example::@dataflow_in>) -> ()
}
