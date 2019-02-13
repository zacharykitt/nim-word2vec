import tables
import unittest
import texthelpers
import wordembeddings

let TestText: string = "And she's buying the stairway to heaven Heaven"

suite "texthelpers":
    test "removePunctuation":
        check:
            '\'' notin TestText.removePunctuation

    test "normalizeAndTokenize":
        check:
            TestText.normalizeAndTokenize == @[
                "and",
                "shes",
                "buying",
                "the",
                "stairway",
                "to",
                "heaven",
                "heaven",
            ]
            TestText.normalizeAndTokenize(false) == @[
                "And",
                "shes",
                "buying",
                "the",
                "stairway",
                "to",
                "heaven",
                "Heaven",
            ]

suite "wordembeddings":
    setup:
        let tokens: seq[string] = TestText.normalizeAndTokenize

    test "getContext":
        check:
            tokens.getContext(3, 1) == @[
                "buying",
                "stairway",
            ]
            tokens.getContext(0, 3) == @[
                "shes",
                "buying",
                "the",
            ]
            tokens.getContext(7, 2) == @[
                "to",
                "heaven",
            ]

    test "unique":
        check:
            "Heaven" notin TestText.unique

    test "oneHotEncode":
        check:
            tokens.oneHotEncode("buying") == @[0, 0, 1, 0, 0, 0, 0, 0]

    test "termFrequency":
        let frequencies: CountTable[string] = TestText.termFrequency

        check:
            frequencies["buying"] == 1
            frequencies["heaven"] == 2            
