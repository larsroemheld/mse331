
import sys
import json


def vw_format():
    for line in sys.stdin:
        obj = json.dumps(line)
        output = ''
        if obj['news_desk'] == 'Sports':
            output = '1 1.0 '
        else:
            output = '-1 1.0 '

        snippet = obj['snippet']
        lead_paragraph = obj['lead_paragraph']
        abstract = obj['abstract']
        


if __name__ == "__main__":
    vw_format()