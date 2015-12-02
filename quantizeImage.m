function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter) 
%quantizeImage optimal quantization on an image.
imOrig = im2double(imOrig);
%imOrig = imOrig*255;

is_rgb = ndims(imOrig) == 3 ;
    
if is_rgb
    YIQ = transformRGB2YIQ(imOrig);
    to_quant = YIQ(:,:,1); % extracting the Y
    
else
    to_quant = imOrig;
end

%to_quant = to_quant * 255;
hist = imhist(to_quant);
cums = cumsum(hist);
%cHist = round((cums ./ max(cums) .* (nQuant - 1)));
%zi = [1; find(diff(cHist)); 256]';

% error = zeros(1,nIter);

 avrage = numel(to_quant)/nQuant;
 x = 1:avrage:numel(to_quant);
 
 zi = arrayfun(@(t) find(cums >= t , 1) ,x );
 zi=[1, zi];
 zi(end) = 256;

Z = 1:1:256;
zpz = Z'.* hist;
Sum = cumsum(zpz);
qi = calc_qi(zi, Sum);

[q, error] = calc_err(qi, zi, nQuant, hist);

for j = 1 : nIter-1

    nxt_zi = round(conv(qi,[1 1]) / 2);
    nxt_zi = [1, nxt_zi(2:end-1), 256];
    
    %first to 0 and last 256 throw 'same'
    if isequal(zi, nxt_zi)
        break
    end
    zi = nxt_zi;
    %zi(isnan(zi)) = 0;
%   zi = round((zi(2:end-1))/2);
    qi = calc_qi(zi, Sum);
    [q,error(end + 1)] = calc_err(qi, zi, nQuant, hist);
    
%      for j = 1 : nQuant
%     %    error(i)= error(i)+ sum((qi(j)-Xz(zi(j):zi:j+1)).^2.*hist(zi(j):zi:j+1));
%     end
%         if i>2 && error(i) == error(i-1)
%             break;
%      end
end

% lut = arrayfun(@(t) find(zi >= imOrig, 1), a);
imQuant = (q(round((to_quant*255)+1)))/255;


        function qi = calc_qi(zi, Sum)
            
        zi_sft = [1, zi(1:end-1)];
        nom = (Sum(zi) - Sum(zi_sft));
        nom = nom(2:end); % the first happens to be 0
        nom(1)= nom(1)+ cums(1); % the first value was lost in the process..
        
        denom = (cums(zi) - cums(zi_sft));
        denom = denom(2:end); %(here too..)
        denom(1) = denom(1) + cums(1); 
       
        qi = round(nom./denom)';
        
        end
    
    function [q,error] = calc_err(qi, zi, nQuant, hist)
        Z = 1:1:256; 
        q = qi(1);
%         zi_sft = [0,zi(1:end-1)];
         dif = diff([zi]);
        
        for j = 1 : nQuant
            q = cat(2,q,repmat(qi(j),1,dif(j)));
        end
        
        error = (q - Z).^2 * hist;
    end
        
   
if is_rgb
    YIQ (:,:,1) = imQuant; 
    imQuant = transformYIQ2RGB(YIQ);
end
error = error';
plot (error)
    
end


