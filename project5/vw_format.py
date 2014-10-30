
import sys
import json
import re
import string

from nltk.corpus import stopwords
from itertools import groupby

def vw_format():
    stop = stopwords.words('english')
    to_eliminate = "|:\n,.;!'>=?"
    translate_table = dict((ord(char), None) for char in to_eliminate)

    for line in sys.stdin:
        line = line[line.index("{"):]
        obj = json.loads(line)
        for article in obj['response']['docs']:
            output = ''
            if article['news_desk'] == 'Sports':
                output = '1 1.0 1|'
            else:
                output = '-1 1.0 -1|'

            snippet = article['snippet']
            snippet = snippet.translate(translate_table)

            tokens = [i for i in snippet.lower().split() if i not in stop]
            output += "TokenCounts "
            for key, group in groupby(tokens):
                output += key + ":" + str(len(list(group))) + " "
            print output.encode('utf-8')
        

if __name__ == "__main__":
    vw_format()