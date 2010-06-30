import instruction, Register, BinarySeq

main: func -> Int {
    cObj := InstructionBuilder new()
    test: Func(Int, Int) -> Int = func(a, b: Int) -> Int { a+b }     
    cObj beginFunction()
       cObj insPUSH(42) 
       cObj insPUSH([ebp+8])
       cObj insMOV(ebx, test as Func)
       cObj insCALL(ebx)
    cObj endFunction()
    cObj codeBuffer print()
    cObj text toString() println()
    f := cObj emitByteCode() as Func(Int) -> Int
    f(50) toString() println()
    "yay" println()
    return -42
}

