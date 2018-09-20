# BaaL
> Bootloader as a Letter

## Requirements
**[Required]** `python`: Used for processing the input text into data suitable to be embedded into assembly scripts\
**[Required]** `nasm`: Used for building the images from assembly scripts\
**[Optional]** `qemu`: Used for testing the resulting images without having to burn them to some removable media and reboot the computer

## Usage
##### Setup:
```bash
git clone https://github.com/corollari/BaaL.git
cd BaaL
```

##### Write the letter:
Write into the text file `input/letter.txt` the text that should be shown when the bootloader is loaded

##### Generate images:
```bash
bash build.sh
```

##### Test images:
```bash
bash boot.sh
```

##### Burn images to removable media (usb, cd...):
```bash
bash burn.sh
```

## Is this actually a bootloader?
No
