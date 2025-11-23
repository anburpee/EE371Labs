#!/usr/bin/env python3
'''*****************************************************************************
Original Authors:         Haytham Shaban, Sam Waddell
Modified By:              Timmy Yang, Brenden Page, Justin Hsia
------------------------------------------------------------------------
Project:        image_to_verilog.py
------------------------------------------------------------------------
Description:    Converts an image and outputs the black-and-white
                data to stdout.
                Output can be in the form of MIF file or SystemVerilog array.
                To save the output to a file, use a pipe.
                Only tested with PNG files so far.
------------------------------------------------------------------------
Requires:       The Pillow image processing library.
*****************************************************************************'''
from PIL import Image, ImageOps
import argparse


def img_to_verilog(img_name, arr_name="", invert=False):
  # load image and convert to grayscale
  img = Image.open(img_name, 'r')
  img = ImageOps.grayscale(img)

  # get image data
  width, height = img.size
  pixel_count = width * height
  w_digits = len(str(height-1))
  data = list(img.getdata())

  if not arr_name:
    # print out MIF headers
    print("WIDTH=" + repr(width) + ";")
    print("DEPTH=" + repr(height) + ";\n")
    print("ADDRESS_RADIX=UNS;")
    print("DATA_RADIX=BIN;\n")
    print("CONTENT BEGIN")

  # print out data (0 = black, 1 = white by default unless inverted)
  for i in range(pixel_count):
    # add front formatting if beginning of row
    if (i % width == 0):
      if arr_name:
        print(f"{arr_name}[{repr(int(i/width)).rjust(w_digits)}] = {width}'b", end="")
      else:
        print(f"    {repr(int(i/width))} \t: ", end="")

    # discretize to {0, 1} - min is to avoid value of 2 when data == 255
    pixel = min(1, int((data[i]*2)/255))
    print((1-pixel) if invert else pixel, end="")

    # add back formatting if last pixel of row
    if (i % width == width-1):
      print(";");

  if not arr_name:
    # print out MIF footer
    print("END;")


def main():
  # argument parsing (options -h, -b, image)
  parser = argparse.ArgumentParser(description="Convert image data to black-and-white format for use in SystemVerilog")
  parser.add_argument("-i", "--invert",
                      help="invert output so white is 0 instead of 1",
                      action="store_true")
  parser.add_argument("-a", "--array",
                      type=str,
                      help="array name (converts output to SystemVerilog array instead of MIF)")
  parser.add_argument("image",
                      type=str,
                      help="name of image file")
  args = parser.parse_args()

  # convert image
  img_to_verilog(args.image, args.array, args.invert)


if __name__ == '__main__':
  main()