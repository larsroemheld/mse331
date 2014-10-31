

import sys
import random

def split_examples():
    random.seed(11)
    training = open('training_data_word.txt', 'wb')
    test = open('test_data_word.txt', 'wb')

    for line in sys.stdin:
        if random.random() > .8:
            test.write(line)
        else:
            training.write(line)

        
        

if __name__ == "__main__":
    split_examples()