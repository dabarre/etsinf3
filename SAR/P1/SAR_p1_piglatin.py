#!/usr/bin/env python
#! -*- encoding: utf8 -*-

import sys

vocal='aeiouyAEIOUY'
punctuation=',.;?!'

def piglatin_word(word):
    """
    Esta función recibe una palabra en inglés y la traduce a Pig Latin

    :param word: la palabra que se debe pasar a Pig Latin
    :return: la palabra traducida
    """
    # COMPLETAR

    isupper = ""

    #Remove punctuation
    p = 0
    for i in range(len(word)-1,-1,-1) :
        if (word[i] in punctuation) :
            p += 1
        else :
            break

    ending = word[(len(word)-p):]
    word = word[:(len(word)-p)]
    
    if (word.isalpha()) :
        if (word.isupper()) :
            isupper = "all"           
        elif (word[0].isupper()) :
            isupper = "first"

        #Traducir
        word = word.lower()
        
        aux = 0
        for i in range(len(word)) :
            if (word[i] in vocal) :
                break
            aux += 1

        if (aux == 0) :
            word += "y"
        word = word[aux:] + word[:aux] + "ay"
        
        if (isupper == "all") :
            word = word.upper()
        if (isupper == "first") :
            word = word[0].upper() + word[1:]

    return word + ending


def piglatin_sentence(sentence):
    """
    Esta función recibe una frase en inglés i la traduce a Pig Latin

    :param sentence: la frase que se debe pasar a Pig Latin
    :return: la frase traducida
    """
    # COMPLETAR
    lista = []    
    for word in sentence.split() :
        lista.append(piglatin_word(word))
    sentence = " ".join(lista)
    return sentence


if __name__ == "__main__":
    if len(sys.argv) > 1:
        # COMPLETAR
        
        # Ampliación implementada
        if (sys.argv[1] != "-f") :
            print(piglatin_sentence(sys.argv[1]))
        else :
            filename = sys.argv[2]
            try:                
                newfilename = filename[:-4] + "_piglatin.txt"
                fr = open(filename, "r")
                fw = open(newfilename, "w")
                lines = fr.read()
                for line in lines.split("\n") :
                    fw.write(piglatin_sentence(line) + "\n")
                fw.close()
                fr.close()
            except FileNotFoundError:
                print("Error! file " + filename + " does not exist.")
    else:
        while True:
            # COMPLETAR
            text = input("English: ")
            if (text == "") :
                print("Exiting script... It was fun to pig latin strings :'(")
                break
            print("Piglatin: " + piglatin_sentence(text) + "\n")
