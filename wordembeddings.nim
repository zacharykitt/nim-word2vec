#[ This module provides essential functions for building word embeddings.
]#
import sequtils
import sugar
import system
import tables
import texthelpers

proc termFrequency*(str: string): CountTable[string] =
    # Return a dictionary of normalized words and their frequencies.
    let tokens = str.normalizeAndTokenize
    result = tokens.toCountTable

proc unique*(str: string): seq[string] =
    # Return a sequence of unique, normalized tokens.
    result = lc[key | (key <- str.termFrequency.keys), string]

proc oneHotEncode*(uniqueTokens: seq[string], match: string): seq[int] =
    # Return a one-hot encoded vector for a word within a set of words.
    result = uniqueTokens.map(proc(x: string): int = int(x == match))

proc getContext*[T](tokens: seq[T], pos: int, window: int): seq[T] =
    #[ Return the context of a given token within a sequence.

    In this case, the context is defined by the window of words around
    a given position. Words can be represented as strings or vectors.
    ]#
    let floor: int = max(pos-window, 0)
    let ceil: int = min(pos+window, tokens.len-1)
    var left: seq[string] = tokens[floor..pos-1]
    var right: seq[string] = tokens[pos+1..ceil]
    result = concat(left, right)
