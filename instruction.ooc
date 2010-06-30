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
    
    insCALL: func <T> (src: T) {
        codeBuffer append(0xff)
        match (T) {
            case Pointer => {
                codeBuffer append(0x15) // CALL /2 -> disp32 = offset
                codeBuffer append(src& as Pointer, Pointer size)
                text append("call %p\n" format(src as Pointer))
            }
            case Reg32 => {
                codeBuffer append(0xd0 + src as Reg32 rm)
                text append("call %s\n" format(src as Reg32 name))
            }
        } 
    }
    
    insMOV: func ~reg2reg(dest, src: Register) {
        if (dest instanceOf(Reg32)) {
            codeBuffer append(0x89)
            codeBuffer append(dest mod + dest rm + src reg)
            text append("mov %s, %s\n" format(dest name, src name))
        }
    }

    insMOV: func ~imm2reg <T> (dest: Register, imm: T) {
        if (dest instanceOf(Reg32)) {
            first: Char = 0xb8 + dest rm
            codeBuffer append(first)
            text append("mov %s, %s\n" format(dest name, T name))
            codeBuffer append(imm& as T*, T size)
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
 
    insPUSH: func ~regOffset(src: Register[]) {    
        if (src[0] instanceOf(Reg32)) {
            codeBuffer append(0xff)
            codeBuffer append(0x70 + src[0] rm)
            codeBuffer append(src[0] memOffset)
            text append("push [%s+%d]\n" format(src[0] name, src[0] memOffset))
        }
    }

    insPUSH: func ~reg(src: Register) {
        if (src instanceOf(Reg32)) {
           codeBuffer append(0x50 + src rm)
           text append("push %s\n"format(src name))
        }
    }
        
    insPUSH: func ~imm32 <T> (src: T) {
        codeBuffer append(0x68)
        codeBuffer append(src& as T*, T size)
        text append("push %s\n" format(T name))
    }
}                        
