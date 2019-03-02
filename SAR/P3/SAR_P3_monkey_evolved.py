#! -*- encoding: utf8 -*-

"""
3.-El Mono Infinito

Nombre Alumno: Alberto Romero Fernández

Nombre Alumno: David Barbas Rebollo
"""

'''
Recibe un argumento del nombre de fichero de disco
    carga el indice de disco
    generar 10 frases
'''

import sys
import pickle
import random

def load_object(filename):
    with open(filename, "rb") as fh:
        obj = pickle.load(fh)
    return obj

def monkey_evolved(filename, apply_extra=True):
    
    
    indexer = load_object(filename)

    #Print 10 sentences
    for i in range(0, 10):
        sentence = []
        currentWord = "$"
        nextWord = ""
        while (nextWord != "$"):
            #Obtain list of possible nextWords
            l = indexer[currentWord][1]
            wordList = []
            for tup in l:
                #Add a possible word x times, equal to its frequency
                wordList += [tup[1]]*tup[0]

            nextWord = random.choice(wordList)
            if (nextWord != "$"):                
                sentence += [nextWord]
            currentWord = nextWord
            
        print(" ".join(sentence))

if __name__ == "__main__":
    if len(sys.argv) < 1:
        syntax()
    filename = sys.argv[1]
    extra = False
    if len(sys.argv) > 3:
        extra = (sys.argv[2] in ('extra', '1', 'True', 'yes'))

    if not extra: 
        monkey_evolved(filename, apply_extra=extra)
    else:
        monkey_indexer_extra(filename,apply_extra=extra)

    print(extra)