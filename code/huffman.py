from textProcessing import preprocess

def getFreqs(text):
    freqs={}
    for c in text:
        freqs[c]=freqs.get(c,0)+1
    afreqs=[]
    for c in freqs:
        afreqs.append({'tree':c, 'count':freqs[c]})
    return afreqs

def sortFreqs(freqs):
    return sorted(freqs, key=lambda k:k['count'])

def buildTree(text):
    freqs=getFreqs(text)
    while(len(freqs)>1):
        freqs=sortFreqs(freqs)
        tree={0:freqs[0]['tree'], 1:freqs[1]['tree']}
        freqs=freqs[2:]+[{'tree':tree, 'count': freqs[0]['count']+freqs[1]['count']}]
    return freqs[0]['tree']

def getTreeDepth(tree, depth=0):
    if(isinstance(tree, basestring)):
        return depth
    else:
        return max(getTreeDepth(tree[0], depth+1), getTreeDepth(tree[1], depth+1))

def buildKeys(tree, bi=""):
    if(isinstance(tree, basestring)):
        return {tree: bi}
    else:
        b=buildKeys(tree[0], bi+'0')
        b.update(buildKeys(tree[1], bi+'1'))
        return b


def encode(text, keys):
    encoded=""
    for c in text:
        encoded+=keys[c]
    return encoded

def decode(encoded, tree):
    text=""
    while(encoded):
        t=tree
        while(True):
            if(isinstance(t, basestring)):
                text+=t
                break
            else:
                t=t[int(encoded[0])]
            encoded=encoded[1:]
    return text

import hashlib
def printASM(tree, out, root=True):
    if(isinstance(tree, basestring)):
        return ord(tree)
    else:
        l=printASM(tree[0], out, False)
        r=printASM(tree[1], out, False)
        label='h'+hashlib.sha256(str(l)+str(r)).hexdigest() # len(label)<=4096
        if(root):
            label="root"
        line=label+': db '+str(l)+','+str(r)
        if(isinstance(l, int)):
            if(isinstance(r, int)):
                line+=",0"
            else:
                line+=",1"
        elif(isinstance(r, int)):
            line+=",2"
        out.write(line+"\n")
        return label

def hex2asm(hexCode):
    asm="encoded: db "
    comma=False
    for c in hexCode:
        asm+=c
        if comma:
            asm+=','
        comma = not comma
    return asm

def fullEncode(text):
    tree=buildTree(text)
    open("./output/tree.asm", "w").write('')
    treeFile=open("./output/tree.asm", "a")
    printASM(tree, treeFile)
    keys=buildKeys(tree)
    return encode(text, keys)

if __name__ == "__main__":
    text=open("./letter.txt", "r").read()
    text=preprocess(text)
    encodedHEX=hex(int(fullEncode(text), 2))
    open("./output/encodedLetter.hex", "w").write(encodedHEX)
    open("./output/encoded.asm", "w").write(hex2asm(encodedHEX))
