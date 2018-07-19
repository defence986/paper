% close all;clear all;clc;
% load('Homo.mat','Homo');
% % [H,s,ang,t,R] = cvexTformToSRT(Homo{5});
% for k = 1:size(Homo,2)
%     if ((Homo{k}(1,1) ~= Homo{k}(2,2)) | (Homo{k}(1,2) ~= -Homo{k}(2,1)))
%         fprintf('%d unequal\n',k);
%         break;
%     end
%     [H{k},s(k),ang(k),t{k},R{k}] = cvexTformToSRT(Homo{k});
% end
% X = 1:345;
X = 1:numFrames;
% Src = {ang,Scale,T1,T2};
% Dest = {emdang,emdS,emdT1,emdT2};
ang = Src{1};
Scale = Src{2};
T1 = Src{3};
T2 = Src{4};
emdang = Dest{1};
emdS = Dest{2};
emdT1 = Dest{3};
emdT2 = Dest{4};

figure,plot(X,ang,X,emdang,':');
figure,plot(X,Scale,X,emdS,':');
figure,plot(X,T1,X,emdT1,':');
figure,plot(X,T2,X,emdT2,':');