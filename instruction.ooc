import Register, BinarySeq
import text/Buffer

InstructionBuilder: class {

    SIZE := 1024
    codeBuffer := BinarySeq new(SIZE) 
    text := Buffer new(SIZE) 
    init: func {}
    
    emitByteCode: func -> Func {
        return codeBuffer data as Func
    }

    beginFunction: func {
        insPUSH(ebp)
        insMOV(ebp, esp)
    }

    endFunction: func {
        insLEAVE()
        insRET()
    }
    
    insCALL: func ~reg(reg: Register) {
        if (reg instanceOf(Reg32)) {
            codeBuffer append(0xff)
            codeBuffer append(0xd0 + reg rm)
            text append("call "+reg name+"\n")
        }
    }

    insCALL: func ~addr(addr: Pointer) {
        codeBuffer append(0xe8)
        codeBuffer append(Pointer, Pointer size)
        text append("call "+"%p\n" format(addr))
    }

    insMOV: func ~reg2reg(dest, src: Register) {
        if (dest instanceOf(Reg32)) {
            codeBuffer append(0x89)
            text append("mov "+dest name)
            codeBuffer append(dest mod + dest rm + src reg)
            text append(" "+src name+'\n')
        }
    }

    insMOV: func ~imm2reg <T> (dest: Register, imm: T) {
        if (dest instanceOf(Reg32)) {
            first: Char = 0xb8 + dest rm
            codeBuffer append(first)
            text append("mov "+dest name)
            codeBuffer append(imm& as T*, T size)
            text append(" value\n")
        }
    }
    
    insNOP: func {
        codeBuffer append(0x90)
        text append("nop\n")
    }

    insLEAVE: func {
        codeBuffer append(0xc9)
        text append("leave\n")
    }

    insRET: func {
        codeBuffer append(0xc3)
        text append("ret\n")
    }
 
    insPUSH: func ~reg(src: Register) {
        if (src instanceOf(Reg32)) {
            first: Char = 0x50 + src rm
            codeBuffer append(first)
            text append("push ")
            text append(src name + "\n")
        }
    }
        
    insPUSH: func ~imm32 <T> (src: T) {
        codeBuffer append(0x68)
        codeBuffer append(src& as T*, T size)
        text append("push value\n")
    }
        
}                        
