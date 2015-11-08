function imYIQ = transformRGB2YIQ(imRGB)
%imYIQ 

load('RGB2YIQ');
red = im2double(imRGB(:,:,1));
green = im2double(imRGB(:,:,2));
blue = im2double(imRGB(:,:,3));
YIQ = (RGB2YIQ * [red(:)' ; green(:)' ; blue(:)'])' ;

 imYIQ = reshape(YIQ, size(imRGB));

end

