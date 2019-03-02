#! -*- encoding: utf8 -*-

from operator import itemgetter
import re
import sys

clean_re = re.compile('\W+')
def clean_text(text):
    return clean_re.sub(' ', text)

def sort_dic(d):
    for key, value in sorted(d.items(), key=lambda a: (-a[1], a[0])):
        yield key, value

def text_statistics(filename, to_lower=True, remove_stopwords=True, apply_extra=True):
    # COMPLETAR
    stopwords = []
    numLines = 0
    numWords = 0
    numStopWords = 0
    vocabulary = {}
    numCharacters = 0
    characters = {}
    bigrams_vocabulary = {}
    bigrams_characters = {}
    

    #Process lines: read, lower, clean, split and count
    textfile = open(filename, "r")
    if remove_stopwords:
        fr = open("stopwords_en.txt", "r")
        for line in fr.readlines():
            stopwords += clean_text(line).split()
        fr.close()

    #Process text lines
    for line in textfile:
        numLines += 1
        #Lowercase condition
        if to_lower:
            line = line.lower()
        line = clean_text(line)

        #Ampliacion Bigramas Words
        if apply_extra:
            aux = '$ ' + line + ' $'
            aux = aux.split()
            for i in range(0, len(aux)-1):
                bigrams_vocabulary[aux[i] + ' ' + aux[i+1]] = bigrams_vocabulary.get(aux[i] + ' ' + aux[i+1], 0) + 1


        for word in line.split():
            
            #Remove stopwords condition
            if (word in stopwords):
                numStopWords += 1
                if remove_stopwords:
                    continue
            
            #Vocabulary dictionary
            vocabulary[word] = vocabulary.get(word, 0) + 1
            numWords += 1

            #Characters dictionary & Ampliacion Bigrams Characters
            numCharacters += len(word)
            caux = ''
            for char in word :
                characters[char] = characters.get(char, 0) + 1
                if (caux != ''):
                    bigrams_characters[caux+char] = bigrams_characters.get(caux+char, 0) + 1
                caux = char

    textfile.close()

    #Prints
    
    print('Lines:', numLines)
    print('Number words (with stopwords):', (numWords+numStopWords))
    if remove_stopwords :
        print('Number words (without stopwords):', (numWords))
    print('Vocabulary size:', len(vocabulary.keys()))
    print('Number of symbols:', numCharacters)
    print('Number of different symbols:', len(characters.keys()))

    print('Words (alphabetical order):')
    for d in sorted(vocabulary.items()):
        print('\t%s\t%d' % d)
    print('Words (by frequency):')
    for d in sort_dic(vocabulary):
        print('\t%s\t%d' % d)

    print('Symbols (alphabetical order):')
    for c in sorted(characters.items()):
        print('\t%s\t%d' % c)
    print('Symbols (by frequency):')
    for c in sort_dic(characters):
        print('\t%s\t%d' % c)

    if (apply_extra):
        print('Word pairs (alphabetical order):')
        for wp in sorted(bigrams_vocabulary.items()):
            print('\t%s\t%d' % wp)
        print('Word pairs (by frequency):')
        for wp in sort_dic(bigrams_vocabulary):
            print('\t%s\t%d' % wp)

        print('Symbol pairs (alphabetical order):')
        for cp in sorted(bigrams_characters.items()):
            print('\t%s\t%d' % cp)
        print('Symbol pairs (by frequency):')
        for cp in sort_dic(bigrams_characters):
            print('\t%s\t%d' % cp)

def syntax():
    print ("\n%s filename.txt [to_lower?[remove_stopwords?]\n" % sys.argv[0])
    sys.exit()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        syntax()
    name = sys.argv[1]
    lower = False
    stop = False
    extra = False
    if len(sys.argv) > 2:
        lower = (sys.argv[2] in ('1', 'True', 'yes'))
        if len(sys.argv) > 3:
            stop = (sys.argv[3] in ('1', 'True', 'yes'))
            if len(sys.argv) > 4:
                extra = (sys.argv[4] in ('extra', '1', 'True', 'yes'))
    text_statistics(name, to_lower=lower, remove_stopwords=stop, apply_extra=extra)
