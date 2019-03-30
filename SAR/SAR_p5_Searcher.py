#!/usr/bin/env python

"""
5.-Whoosh

Nombre Alumno: Alberto Romero Fernández

Nombre Alumno: David Barbas Rebollo
"""

import sys
from whoosh.index import open_dir
from whoosh.qparser import QueryParser
import json


def load_json(filename):
    with open(filename) as fh:
        obj = json.load(fh)
    return obj

def printResults(results):
    for r in results:
        print("-> ({}) {} ({})".format(r['date'], r['title'], r['keywords']))

def printExtend(result):
    print("Title: {}".format(result['title']))
    print("Date: {}".format(result['date']))
    print("Keywords: {}".format(result['keywords']))
    
    #Search by id
    obj = load_json(result['path'])
    print("\n {}".format(obj['article']))


def searcher(index_directory, query, extend):
    ix = open_dir(index_directory)
    print()
    with ix.searcher() as searcher:

        while (True):
            #Cmd query or Specific
            text = input("Dime: ") if (query == "") else query[3:]
            #Exit loop
            if len(text) == 0:
                print("=================")
                break
            q = QueryParser("article", ix.schema).parse(text)
            results = searcher.search(q)

            #Apply extend
            if extend:
                printExtend(results[0])
            #Don't apply extend
            else:                    
                printResults(results)            
            print("=================")
            print("{} results\n".format(len(results)))

            #Check if it should loop
            if (query != ""):
                break

if __name__ == "__main__":
    
    if len(sys.argv) < 1:
        syntax()
    dirname = sys.argv[1]
    query = ""
    extend = False
    if (len(sys.argv) > 2 ):
        if sys.argv[2].startswith("-q"):
            query = sys.argv[2]
        elif sys.argv[2].startswith("--extend"):
            extend = True
        else :
            syntax()

        if (len(sys.argv) > 3 ):
            if sys.argv[3].startswith("-q"):
                if not query:
                    query = sys.argv[3]
                else:
                    syntax()
                
            elif sys.argv[3].startswith("--extend"):
                if not extend:
                    extend = True
                else:
                    syntax()    

    searcher(dirname, query, extend)