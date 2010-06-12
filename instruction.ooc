import Register, BinarySeq
import text/Buffer

InstructionBuilder: class {

    SIZE := 1024
    data := BinarySeq new(SIZE) 
    text := Buffer new(SIZE) 
    init: func {}

    insMOV: func ~withRegisters(dest, src: Register) {
        if (dest instanceOf(Reg32)) {
            data append(0x89)
            text append("mov "+dest name)
            data append(dest mod + dest rm + src reg)
            text append(" "+src name)
        }
    }
}

                        
