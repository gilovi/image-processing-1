function [imEq, histOrig, histEq] = histogramEqualize(imOrig)
%histogramEqualize equlizes an image histogram
imOrig = im2double(imOrig);

is_rgb = ndims(imOrig) == 3;
    
if is_rgb
    YIQ = transformRGB2YIQ(imOrig);
    to_eq = YIQ(:,:,1); % extracting the Y
    
else
    to_eq = imOrig;
end
    
histOrig = imhist(to_eq, 256);    
cumulative = cumsum(histOrig);
norm_cum = round(cumulative/numel(imOrig)*255);
imEq = norm_cum(round((to_eq*255)+1));

Max = max(imEq(:));
Min = min(imEq(:));
imEq = (imEq-Min)/Max;
histEq = imhist(imEq);

if is_rgb
    YIQ (:,:,1) = imEq; 
    imEq = transformYIQ2RGB(YIQ);
end


end

