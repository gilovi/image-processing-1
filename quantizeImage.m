function [imQuant, error] = quantizeImage(imOrig, nQuant, nIter) 
%quantizeImage optimal quantization on an image.

is_rgb = ndims(imOrig) == 3 ;
    
if is_rgb
    YIQ = transformRGB2YIQ(imOrig);
    to_quant = YIQ(:,:,1); % extracting the Y
    
else
    to_quant = imOrig;
end


hist = imhist(to_quant);
cums = cumsum(hist);
% error = zeros(1,nIter);

avrage = numel(to_quant)/nQuant;
x = avrage:avrage:numel(to_quant);

zi = arrayfun(@(t) find(cums >= t , 1) ,x );
zi(end) = 256;

Z = 1:1:256; 
zpz = Z'.* hist;
Sum = cumsum(zpz);
qi = calc_qi(zi);
error = calc_err(qi, zi, nQuant, hist);

for j = 1 : nIter-1

    nxt_zi = round(conv(qi,[1 1],'same')/2);
    %first to 0 and last 256 throw 'same'
    if isequal(zi, nxt_zi)
        break
    end
    zi = nxt_zi;
    zi(isnan(zi)) = 0;
%   zi = round((zi(2:end-1))/2);
    qi = calc_qi(zi);
    error(end+1) = calc_err(qi, zi, nQuant, hist);
    
%     %error:
%     for j=1:nQuant
%     %    error(i)= error(i)+ sum((qi(j)-Xz(zi(j):zi:j+1)).^2.*hist(zi(j):zi:j+1));
%     end
%         if i>2 && error(i) == error(i-1)
%             break;
%         end
end
lut = arrayfun(@(t) find(zi >= imOrig, 1), a);
imQuant = qi(lut);


        function qi = calc_qi(zi)
            
        zi_sft = [1, zi(1:end-1)];
        nom = (Sum(zi) - Sum(zi_sft));
%       nom = nom(2:end); % the first happens to be 0
%       nom(1)= nom(1)+ cums(1); % the first value was lost in the process..
        
        denom = (cums(zi) - cums(zi_sft));
%         denom = denom(2:end); %(here too..)
%         denom(1) = denom(1) + cums(1); 
       
        qi = round(nom./denom)';
        
        end
    
    function error = calc_err(qi, zi, nQuant, hist)
        Z = 1:1:256; 
        q = 0;
        zi_sft = [0,zi(1:end-1)];
        dif = zi - zi_sft;
        
        for j = 1 : nQuant
            q = cat(2,q,repmat(qi(j),1,dif(j)));
        end
        q = q(2:end);
        
        error = (q - Z).^2 * hist;
    end
        
   
if is_rgb
    YIQ (:,:,1) = imQuant; 
    imQuant = transformYIQ2RGB(YIQ);
end
    
end


