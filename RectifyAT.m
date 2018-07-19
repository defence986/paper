function [Homo,ang,T1,T2] = RectifyAT(Homo,ang,T1,T2)

for k = 1:size(Homo,2)
    ang(k) = ang(k)-mean(ang);
    T1(k) = T1(k)-mean(T1);
	T2(k) = T2(k)-mean(T2);
end