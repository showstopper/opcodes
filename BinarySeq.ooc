import os/mmap
import structs/[ArrayList,HashMap]
include errno

errno: extern Int
strerror: extern func (Int) -> String

BinarySeq: class {
    
    data : UChar*
    size : SizeT
    index := 0
    transTable := HashMap<String, Int> new()
    
    init: func ~withData (=size, d: UChar*) {
        init(size)
        index = size
        memcpy(data, d, size * UChar size)
    }
    
    init: func ~withSize (=size) {
        memsize := size * UChar size
        // at least 4096, and a multiple of 4096 that is bigger than memsize
        realsize := memsize + 4096 - (memsize % 4096)
        data = gc_malloc(realsize)
        result := mprotect(data, realsize, PROT_READ | PROT_WRITE | PROT_EXEC)
        if(result != 0) {
            printf("mprotect(%p, %zd) failed with code %d. Message = %s\n", data, realsize, result, strerror(errno))
        }
        memset(data, 0x90, memsize)
        initTransTable()
        // mmap is leaking (cause we don't know when to free), and apparently not needed, but just in case, here's the correct call
        //data = mmap(null, memsize, PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_LOCKED | MAP_ANONYMOUS, -1, 0)
    }
    
    initTransTable: func {
        transTable["c"] = Char size
        transTable["d"] = Double size
        transTable["f"] = Float size 
        transTable["h"] = Short size 
        transTable["i"] = Int size 
        transTable["l"] = Long size
        transTable["P"] = Pointer size
    }

    append: func ~other (other: BinarySeq) -> BinarySeq {
        append(other data, other size)
    }
    
    append: func ~withLength (ptr: Pointer, ptrLength: SizeT) -> BinarySeq {
        memcpy(data + index, ptr, ptrLength)
        index += ptrLength
        return this
    }
   
    append: func ~plainByte (c: Char) -> BinarySeq {
        memcpy(data + index, c& as UChar*, 1)
        index += 1
        return this
    }
     
    reset: func { index = 0 }
    
    print: func {
        for(i : Int in 0..index)
            printf("%x ", data[i])
        println()    
    }
    
}

operator += (b1, b2 : BinarySeq) -> BinarySeq {
    b1 append(b2)
}

operator += <T> (b1 : BinarySeq, addon: T) -> BinarySeq {
    b1 append(addon& as Pointer, T size)
}
