close all;
clear all;
clc;

fileName = '20161012T002740.uniform.avi';
filePath = 'E:\work\medical_section\code\video\medium\';

balance_T1 = 0.5;
balance_T2 = 0.5;

[obj,numFrames] = get_obj(fileName,filePath);

imgB = read(obj, 1);

k = 2;

Hcumulative = eye(3);
frames = {};
Homo = {};
frames{1} = imgB;

Homo{1} = eye(3);
[optimizer,metric] = imregconfig('multimodal');
for k = 2:numFrames
% for k = 2:2
    imgA = imgB;
    fprintf('***************************************\n');
    fprintf('Request Registering Multimodal Images the %d frame.\n', k);
    imgB = read(obj,k);

    grayA = imgA;
    grayB = imgB;
    if ndims(imgA) == 3
        grayA = rgb2gray(imgA);
    end
    if ndims(imgB) == 3
        grayB = rgb2gray(imgB);
    end

    tformRigid = imregtform(grayB,grayA,'rigid',optimizer,metric);

    Hcumulative = tformRigid.T * Hcumulative;
    Homo{k} = Hcumulative;
end

% save('Homo.mat','Homo');

for k = 1:length(Homo)
    [H,Scale(k),ang(k),tran{k}] = cvexTformToSRT(Homo{k});
    T1(k) = tran{k}(1);
    T2(k) = tran{k}(2);
end


% imfang = emd(ang);
% if (~length(imfang))
%     fprintf('Ang imf failure.\n');
%     return;
% end
% 
% Ratio_ang = cvx_ratio(imfang,ang,balance_ang);
% % while all(Ratio_ang>0.999)
% %     fprintf('******************** balance ang is %f\n', balance_ang);
% %     balance_ang = balance_ang-Var;
% %     Ratio_ang = cvx_ratio(imfang,ang,balance_ang);
% % end
% emdang = ratio_emd(Ratio_ang,imfang);

imfT1 = emd(T1);
imfT2 = emd(T2);
if ( ~length(imfT1) | ~length(imfT2))
    fprintf('T imf failure.\n');
    return;
end

RatioT1 = cvx_ratio(imfT1,T1,balance_T1);
% while all(RatioT1>0.999)
%     fprintf('******************** balance T1 is %f\n', balance_T1);
%     balance_T1 = balance_T1-Var;
%     RatioT1 = cvx_ratio(imfT1,T1,balance_T1);
% end
emdT1 = ratio_emd(RatioT1,imfT1);

RatioT2 = cvx_ratio(imfT2,T2,balance_T2);
% while all(RatioT2>0.999)
%     fprintf('******************** balance T2 is %f\n', balance_T2);
%     balance_T2 = balance_T2-Var;
%     RatioT2 = cvx_ratio(imfT2,T2,balance_T2);
% end
emdT2 = ratio_emd(RatioT2,imfT2);

Cx=1:338;figure,plot(Cx,T2(Cx),'green',Cx,emdT2(Cx),'red','linewidth',2);
Cx=90:140;figure,plot(Cx,T2(Cx),'green',Cx,emdT2(Cx),'red','linewidth',2);
% Cx=90:140;figure,plot(Cx,T2(Cx),'green',Cx,0.45*T2(Cx)+0.55*emdT2(Cx),'red','linewidth',2);
Cx=90:140;figure,plot(Cx,T2(Cx),'green',Cx,0.431*T2(Cx)+0.569*emdT2(Cx),'red','linewidth',2);
% Fs = 30;
Fs = obj.FrameRate;
plot_hht_full(T2,1/Fs);
%exec_hht(Trace,1/Fs);