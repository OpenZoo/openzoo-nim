import ../src/gamevars
import ../src/oop
import unittest

suite "OOP Parser":
    test "readChar/readWord/readValue":
        var data = StatData()
        var parser = newOopParser()
        data.data = cast[seq[char]]("#test 234 A_b")
        var pos = 0.int16
        parser.readChar(data, pos)
        require(parser.oopChar == '#')
        require(pos == 1)
        parser.readWord(data, pos)
        require(parser.oopWord == "TEST")
        parser.readValue(data, pos)
        require(parser.oopValue == 234)
        parser.readWord(data, pos)
        require(parser.oopWord == "A_B")

    test "skipLine":
        var data = StatData()
        var parser = newOopParser()
        data.data = cast[seq[char]]("@object\rword\rother\r")
        var pos = 0'i16
        parser.skipLine(data, pos)
        parser.readWord(data, pos)
        require(parser.oopWord == "WORD")

    test "findString":
        var data = StatData()
        var parser = newOopParser()
        data.data = cast[seq[char]]("@object\r:label\r#go n\r")
        var pos = parser.findString(data, "\r:label\r")
        require(pos == 7)

    test "findString label-preceding-text-line bug reproduction":
        var data = StatData()
        var parser = newOopParser()
        data.data = cast[seq[char]]("@object\r:label\rText line\r")
        var pos = parser.findString(data, "\r:label\r")
        require(pos == -1)

    test "stringToOopToken":
        require("Conveyor Belt #2".toOopToken == "CONVEYORBELT2")

    test "readLineToEnd":
        var data = StatData()
        var parser = newOopParser()
        data.data = cast[seq[char]]("&therest")
        var pos = 0'i16
        parser.readChar(data, pos)
        require(parser.readLineToEnd(data, pos) == "therest")