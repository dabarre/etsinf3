#! -*- encoding: utf8 -*-

"""
3.-El Mono Infinito

Nombre Alumno: Alberto Romero Fernández

Nombre Alumno: David Barbas Rebollo
"""

import sys
import re
import pickle

'''
crear un fichero donde sea un diccionario de las palabras del 
textoy su lista contenga el numero de veces que sale mas 
las palabras posibles siguientes con sus frequencias cada una
'''

'''
    trigramas $ $ para empezar
'''

def save_object(object, filename):
    with open(filename, "wb") as fh:
        pickle.dump(object, fh)

clean_re = re.compile('\W+')
er = re.compile("\.|\;|\n\n|\?|\!")
def clean_text(text):
    return clean_re.sub(' ', text)

def split_sentences(text):    
    return er.split(text)

def monkey_indexer(filename, indexfilename, apply_extra=True):
    
    indexer = {}
    #Read and divide into sentences
    fread = open(filename, "r").read()
    sentences = split_sentences(fread)
    for s in sentences:
        #Clean a sentence and traverse words
        s = ("$ " + clean_text(s).strip() + " $").split()
        #print(s)
        for i in range(0, len(s)-1):
            
            #Already existing word
            if s[i] in indexer:
                tup = indexer[s[i]]
                tcount = tup[0] + 1

                #En vez de iterar hacer .index()?

                #Traverse recorded words
                nextWords = tup[1]
                for t in nextWords:
                    add = True
                    if (s[i+1] in t):
                        nc = t[0] + 1
                        w = t[1]
                        j = nextWords.index(t)
                        nextWords = nextWords[:j] + [(nc, w)] + nextWords[j+1:]
                        add = False
                        break
                if add:
                    nextWords += [(1, s[i+1])]
                #Combine
                indexer[s[i]] = (tcount, nextWords)

            #New word
            else:
                indexer[s[i]] = (1, [(1, s[i+1])])

    print(indexer)    
    save_object(indexer, indexfilename)

def monkey_indexer_extra(a,b,c):
    return 0

if __name__ == "__main__":
    if len(sys.argv) < 2:
        syntax()
    filename = sys.argv[1]
    indexfilename = sys.argv[2]
    extra = False
    if len(sys.argv) > 4:
        extra = (sys.argv[3] in ('extra', '1', 'True', 'yes'))

    if not extra: 
        monkey_indexer(filename, indexfilename, apply_extra=extra)
    else:
        monkey_indexer_extra(filename, indexfilename, apply_extra=extra)

    print(extra)