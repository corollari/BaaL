from textProcessing import preprocess

text=open("./letter.txt", "r").read()
text=preprocess(text)
asm="text: db "
for c in text:
    asm+=str(ord(c))+','
asm+='0\n'
open("./output/text.asm", 'w').write(asm)
