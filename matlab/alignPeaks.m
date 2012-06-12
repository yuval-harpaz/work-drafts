function aligned = alignPeaks(x, T, sr, dt)
% align the pieces around T so their peaks coincide


% Dec-2011 MA

%% Initialize
 S = round(T*sr);
 x = x-mean(x);
 lX = length(x);
 ds = round(dt*sr);
 lT = length(T);
 aligned = nan(1, lT);
 
%% find the peaks
for ii = 1:lT
    i0 = S(ii);
    id = i0-ds;
    iu = i0+ds;
    if (id>0)&&(iu<=lX)
        dx = x(id:iu);
        if x(i0)<0 % invert
            dx = -dx;
        end
        i1 = find(dx==max(dx),1) -ds;
        jj = i0 +i1 -1;
        if (jj>0) && (jj<=lX)
            aligned(ii) = jj;
        end
    end
end

%% wrap up
aligned(isnan(aligned))=[];
aligned = unique(aligned);
return
