import util

type
    Tile* = tuple[element: uint8, color: uint8]
    OopParser* = object
        oopChar*: char
        oopWord*: string
        oopValue*: int16
        oopTokenLength*: int16
    StatData* = object
        data*: seq[char]
    Stat* = object
        x*, y*: uint8
        stepX*, stepY*: int16
        cycle*: int16
        p1*, p2*, p3*: uint8
        follower*, leader*: int16
        under*: Tile
        data*: StatData

proc newOopParser*(): OopParser =
    result = OopParser(oopTokenLength: 20)

proc length*(data: StatData): int = data.data.len