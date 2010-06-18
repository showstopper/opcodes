import instruction, Register, BinarySeq

test: func {}
main: func -> Int {
    cObj := InstructionBuilder new()
    printf("%p\n", test as Func)
    cObj beginFunction()
       cObj insMOV(ebx, exit as Func)
       cObj insPUSH(31)
       cObj insCALL(ebx)
    cObj endFunction()
    cObj codeBuffer print()
    cObj text toString() println()
    f := cObj emitByteCode()
    f()
    "yay" println()
    return -42
}

