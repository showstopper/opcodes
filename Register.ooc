import structs/HashMap

Register: abstract class {
    mod: Char
    rm: Char
    reg: Char
    name: String
    memOffset: Int = -42
    
    clone: abstract func -> This
}

Reg32: class extends Register {
    mod = 0xc0
    init: func(=name, =rm) {
        reg = rm << 3
    }

    clone: func -> This {
        toRet := Reg32 new(name, rm)
        toRet mod = mod
        toRet
    }
}

eax := Reg32 new("eax", 0x00)
ecx := Reg32 new("ecx", 0x01)
edx := Reg32 new("edx", 0x02)
ebx := Reg32 new("ebx", 0x03)
esp := Reg32 new("esp", 0x04)
ebp := Reg32 new("ebp", 0x05)
esi := Reg32 new("esi", 0x06)
edi := Reg32 new("edi", 0x07)

operator + (first: Register, second: Int) -> Register{ 
    ret := first clone()
    ret memOffset = second 
    ret
}


