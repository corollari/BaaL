def preprocess(text):
    text=text.replace('\n', '\n\r')
    return text

def getLetter():
    return open("./input/letter.txt", "r").read()
