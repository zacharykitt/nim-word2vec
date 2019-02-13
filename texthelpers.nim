#[ This module provides basic tools for preparing text for NLP.
 ]#
import sequtils
import strutils
import sugar

proc isNotPunctuation(c: char): bool =
    #[ Return true if the character is not punctuation.

    This logic depends on the assumption that all characters fit within disjoint 
    subsets of:
        1. AlphaNumeric
        2. SpaceAscii
        3. Other (i.e. Punctuation)
    ]#
    result = isAlphaNumeric(c) or isSpaceAscii(c)

proc removePunctuation*(str: string): string =
    # Remove all punctuation from a string.
    var filteredChars: seq[char] = filter(str.mapIt(char, it), isNotPunctuation)
    result = filteredChars.join

proc normalizeAndTokenize*(str: string, lower: bool = true): seq[string] =
    # Convert a string into a sequence of normalized tokens.
    var str: string = str
    if lower: 
        str = str.toLower
    str = str.removePunctuation
    for word in tokenize(str):
        if word.isSep == false:
            result.add(word.token) 
