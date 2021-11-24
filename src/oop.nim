import std/strutils
import gamevars
import util

proc readChar*(parser: var OopParser; data: StatData; position: var int16) =
    if position >= 0 and position < data.length:
        parser.oopChar = data.data[position]
        position += 1
    else:
        parser.oopChar = chr(0)

proc skipSpaces(parser: var OopParser; data: StatData; position: var int16) {.inline.} =
    while true:
        parser.readChar(data, position)
        if parser.oopChar != ' ':
            break

proc readWord*(parser: var OopParser; data: StatData; position: var int16) =
    parser.oopWord = ""

    parser.skipSpaces(data, position)
    parser.oopChar = parser.oopChar.upCase
    if (parser.oopChar < '0') or (parser.oopChar > '9'):
        while ((parser.oopChar >= 'A' and parser.oopChar <= 'Z') or (parser.oopChar == ':') or (parser.oopChar >= '0' and parser.oopChar <= '9') or (parser.oopChar == '_')):
            if parser.oopWord.len < parser.oopTokenLength:
                parser.oopWord.add(parser.oopChar)
            parser.readChar(data, position)
            parser.oopChar = parser.oopChar.upCase
    if position > 0:
        position -= 1

proc readValue*(parser: var OopParser; data: StatData; position: var int16) =
    var s = ""

    parser.skipSpaces(data, position)
    while (parser.oopChar >= '0' and parser.oopChar <= '9'):
        if parser.oopWord.len < parser.oopTokenLength:
            s.add(parser.oopChar)
        parser.readChar(data, position)
    parser.oopChar = parser.oopChar.upCase
    if position > 0:
        position -= 1

    if s.len > 0:
        parser.oopValue = parseInt(s).int16
    else:
        parser.oopValue = -1

proc skipLine*(parser: var OopParser; data: StatData; position: var int16) =
    while true:
        parser.readChar(data, position)
        if parser.oopChar == '\0' or parser.oopChar == '\r':
            break

proc findString*(parser: var OopParser; data: StatData; str: string): int16 =
    var pos = 0'i16

    while pos <= data.length:
        var wordPos = 0'i16
        var cmpPos = pos
        var found = true

        while true:
            parser.readChar(data, cmpPos)
            if upCase(str[wordPos]) != upCase(parser.oopChar):
                found = false
                break
            wordPos += 1
            if wordPos >= str.len:
                break

        if found:
            parser.readChar(data, cmpPos)
            parser.oopChar = upCase(parser.oopChar)

            if (parser.oopChar >= 'A' and parser.oopChar <= 'Z') or (parser.oopChar == '_'):
                discard # word continues, match invalid
            else:
                return pos # word complete, match valid

        pos += 1
    
    return -1

proc toOopToken*(input: string): string =
    result = ""
    for c in input:
        if (c >= 'A' and c <= 'Z') or (c >= '0' and c <= '9'):
            result.add(c)
        elif (c >= 'a' and c <= 'z'):
            result.add(c.upCase)

proc readLineToEnd*(parser: var OopParser; data: StatData; position: var int16): string =
    result = ""
    parser.readChar(data, position)
    while parser.oopChar != '\0' and parser.oopChar != '\r':
        if result.len < 255:
            result.add(parser.oopChar)
        parser.readChar(data, position)