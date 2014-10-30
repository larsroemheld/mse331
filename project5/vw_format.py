
import sys
import json

from nltk.corpus import stopwords
from itertools import groupby

def vw_format():
    stop = stopwords.words('english')
    stop = stop.union(set(["|", ":", "\n"]))

    for line in sys.stdin:
        obj = json.dumps(line)
        for article in obj['docs']:
            output = ''
            if obj['news_desk'] == 'Sports':
                output = '1 1.0 |'
            else:
                output = '-1 1.0 |'

            snippet = obj['snippet']
            tokens = [i for i in snippet.lower().split() if i not in stop]
            output += "TokenCounts "
            for key, group in groupby(tokens):
                output += key + ":" + group + " "
            print output
        

if __name__ == "__main__":
    vw_format()