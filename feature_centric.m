function Dest = feature_centric(Src,Dest,Dist)
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
Number = round(Len/Dist/4);

for i = 1:Number
    for j = indx(i):indx(i)+Dest-1
%         Dest(j) = Src(j) * 0.999999;
        Dest(j) = (Src(j)+Dest(j))/2;
    end
end
% Dest(Len) = Src(Len);