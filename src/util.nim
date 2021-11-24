type
    ZooRandom* = object
        seed*: uint32

proc upCase*(c: char): char =
    if c >= 'a' and c <= 'z':
        result = chr(ord(c) - 0x20)
    else:
        result = c

proc next*(rand: var ZooRandom; max: uint16): int16 =
    rand.seed = (rand.seed * 134775813) + 1
    return ((rand.seed shr 16) mod max).int16