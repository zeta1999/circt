set(LLVM_LINK_COMPONENTS
  Support
  )

add_llvm_tool(circt-opt
 circt-opt.cpp
)
llvm_update_compile_flags(circt-opt)
target_link_libraries(circt-opt
  PRIVATE
  CIRCTFIRRTLTransforms
  MLIRESI
  MLIRFIRRTL
  MLIRFIRRTLToLLHD
  MLIRFIRRTLToRTL
  MLIRHandshakeOps
  MLIRHandshakeToFIRRTL
  MLIRLLHD
  MLIRLLHDToLLVM
  MLIRLLHDTransforms
  MLIRRTL
  MLIRRTLToLLHD
  MLIRStandardToHandshake
  MLIRStandardToStaticLogic
  MLIRStaticLogicOps
  MLIRSV

  MLIRParser
  MLIRSupport
  MLIRIR
  MLIROptLib
  MLIRStandard
  MLIRTransforms
  MLIRLLVMIR
  )
