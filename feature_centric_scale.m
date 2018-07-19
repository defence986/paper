function Dest = feature_centric_scale(Src,Dest,Dist)
Len = size(Src,2);
for i = 1:Len-Dist+1
    Temp = Src(i:i+Dist-1);
    Dp1 = norm(Temp .* Temp, 1);
    Temp = Dest(i:i+Dist-1);
    Dp2 = norm(Temp .* Temp, 1);
%     Factor(i) = abs(Dp2-Dp1) / Dp1;
    Factor(i) = abs(Dp2-Dp1);
end
[Temp,indx] = sort(Factor,'descend');
Number = round(Len/Dist/2);

for i = 1:Number
    for j = indx(i):indx(i)+Dest-1
%         Dest(j) = Src(j) * 0.999999;
        Dest(j) = 0.6 * Src(j) + 0.4 * Dest(j);
    end
end
% Dest(Len) = Src(Len);