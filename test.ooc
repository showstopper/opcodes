import instruction, Register

main: func {
    cObj := InstructionBuilder new()
    cObj insMOV(ebx, eax)
    cObj text toString() println()
    cObj data print()
}

