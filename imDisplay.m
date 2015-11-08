function imDisplay(filename, representation)
%imDisplay displays a given image file in a given representation.

figure
imshow(imReadAndConvert(filename, representation));
impixelinfo

end

