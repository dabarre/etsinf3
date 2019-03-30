#!/usr/bin/env python

"""
5.-Whoosh

Nombre Alumno: Alberto Romero Fernández

Nombre Alumno: David Barbas Rebollo
"""

import sys
import os
from whoosh.index import create_in
from whoosh.fields import Schema, ID, TEXT, KEYWORD, DATETIME
from whoosh.analysis import RegexTokenizer, LowercaseFilter
import json
import time

def load_json(filename):
    with open(filename) as fh:
        obj = json.load(fh)
    return obj

def save_dict_as_json(d, filename):
    with open(filename, 'w') as fh:
        obj = json.dump(d, fh)

def create_indexer(doc_directory, index_directory):
    my_analyzer = RegexTokenizer()|LowercaseFilter()
    schema = Schema(id=ID(stored=True), title=TEXT(stored=True, analyzer=my_analyzer), summary=TEXT,
        article=TEXT(analyzer=my_analyzer), keywords=KEYWORD(stored=True, analyzer=my_analyzer), 
        date=DATETIME(stored=True), path=TEXT(stored=True))
    
    if not os.path.exists(index_directory):
        os.mkdir(index_directory)
    ix = create_in(index_directory, schema)
    writer = ix.writer()

    nt = 0    
    print("==============================")
    t1 = time.clock()
    for dirname, subdirs, files in os.walk(doc_directory):        
        if (files != []):
            n = 0
            for filename in files:
                filename = os.path.join(dirname, filename)
                obj = load_json(filename)
                writer.add_document(id=obj['id'], title=obj['title'], summary=obj['summary'], article=obj['article'], keywords=obj['keywords'], date=obj['date'], path=filename)
                n += 1
            print("{}: {}".format(dirname, n))
            nt += n
    t2 = time.clock()
    print("==============================")
    print("Docs: {}, Time: {:.2f}s".format(nt, (t2-t1)))
    print("Writing index...")
    writer.commit()
    t3 = time.clock()
    print("Total time: {:.2f}s".format(t3-t1))
    print("==============================")

if __name__ == "__main__":

    if len(sys.argv) < 2:
        syntax()
    create_indexer(sys.argv[1], sys.argv[2])


    



