function im = imReadAndConvert(filename, representation )
%imReadAndConvert reads a given image file and converts it into a given representation
%   Parameters:
%   filename - string containing the image filename to read.
%   representation - representation code, either 1 or 2 defining if the output should be either a grayscale
inf = imfinfo(filename);
color_type = inf.ColorType;
im = im2double(imread(filename));

if (representation == 1 && strcmp('truecolor', color_type)) 
    im = rgb2gray(im);

elseif representation == 2
    if ~strcmp('truecolor', color_type)
        error( 'cant change image to color image')
    end
    
end

end
