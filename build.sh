python code/text2asm.py #generate output/text.asm
cat code/start.asm code/display.asm output/text.asm code/end.asm > output/rawTextFinal.asm
nasm -f bin output/rawTextFinal.asm -o output/rawTextBoot.bin
python code/huffman.py #generate output/tree.asm and output/encoded.asm
cat code/start.asm code/decoder.asm output/tree.asm code/display.asm output/encoded.asm code/end.asm > output/final.asm
nasm -f bin output/final.asm -o output/boot.bin
