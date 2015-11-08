function imRGB = transformYIQ2RGB(imYIQ)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
load('RGB2YIQ');
Y = im2double(imYIQ(:,:,1));
I = im2double(imYIQ(:,:,2));
Q = im2double(imYIQ(:,:,3));
YIQ = (RGB2YIQ\[Y(:)' ; I(:)' ; Q(:)'])' ;
imRGB = reshape(YIQ, size(imYIQ));

end

