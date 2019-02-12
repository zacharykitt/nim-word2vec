#[ This module provides basic tools for preparing text for NLP.
 ]#
import future
import sequtils
import strutils

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
    result = join(filteredChars)

proc normalizeAndTokenize*(str: string): seq[string] =
    # Convert a string into a sequence of normalized tokens.
    var str: string = toLower(str)
    str = removePunctuation(str)
    for word in tokenize(str):
        if word.isSep == false:
            result.add(word.token) 
