function [newName,newPath,Balance] = Optimize_emd_multimodal(oldPath,oldName,optimizer,metric,AssignPath,Balance)

balance_ang = Balance{1};
balance_T1 = Balance{2};
balance_T2 = Balance{3};
Var = Balance{4};
[obj,numFrames] = get_obj(oldName,oldPath);

imgB = read(obj, 1);

k = 2;

Hcumulative = eye(3);
frames = {};
Homo = {};
frames{1} = imgB;

Homo{1} = eye(3);

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


imfang = emd(ang);
if (~length(imfang))
    fprintf('Ang imf failure.\n');
    return;
end

Ratio_ang = cvx_ratio(imfang,ang,balance_ang);
while all(Ratio_ang>0.999)
    fprintf('******************** balance ang is %f\n', balance_ang);
    balance_ang = balance_ang-Var;
    Ratio_ang = cvx_ratio(imfang,ang,balance_ang);
end
emdang = ratio_emd(Ratio_ang,imfang);

imfT1 = emd(T1);
imfT2 = emd(T2);
if ( ~length(imfT1) | ~length(imfT2))
    fprintf('T imf failure.\n');
    return;
end

RatioT1 = cvx_ratio(imfT1,T1,balance_T1);
while all(RatioT1>0.999)
    fprintf('******************** balance T1 is %f\n', balance_T1);
    balance_T1 = balance_T1-Var;
    RatioT1 = cvx_ratio(imfT1,T1,balance_T1);
end
emdT1 = ratio_emd(RatioT1,imfT1);

RatioT2 = cvx_ratio(imfT2,T2,balance_T2);
while all(RatioT2>0.999)
    fprintf('******************** balance T2 is %f\n', balance_T2);
    balance_T2 = balance_T2-Var;
    RatioT2 = cvx_ratio(imfT2,T2,balance_T2);
end
emdT2 = ratio_emd(RatioT2,imfT2);

Balance = {balance_ang,balance_T1,balance_T2,Var};

% longitude = 5;
% emdang = feature_centric(ang,emdang,longitude);
% emdT1 = feature_centric(T1,emdT1,longitude);
% emdT2 = feature_centric(T2,emdT2,longitude);


for k = 1:size(Homo,2)
%     Homo{k} = cvexTformToS(Homo{k},Scale(k)+1-max(Scale));
%     Homo{k} = cvexTformToang(Homo{k},ang(k)-mean(ang));
    Homo{k} = cvexTformToang(Homo{k},emdang(k)-mean(emdang));
%     Homo{k} = cvexTformToT(Homo{k},T1(k)-mean(T1),T2(k)-mean(T2));
%     Homo{k} = cvexTformToT(Homo{k},emdT1(k)-mean(emdT1),emdT2(k)-mean(emdT2));
end

for m = 1:size(Homo,2)
    frame = read(obj, m);
    frames{m} = imwarp(frame,affine2d(Homo{m}),'OutputView',imref2d(size(frame)));
%     movingRegisteredRigid = imwarp(moving,tformSimilarity,'OutputView',Rfixed);
end

newName = strcat(datestr(now,30),'.avi');
if length(AssignPath)
    newPath = AssignPath;
else
    newPath = '..\video\medium\emd\';
end

myObj = VideoWriter(strcat(newPath, newName));

myObj.FrameRate = 30;

open(myObj);
for i=1:size(frames,2)
    writeVideo(myObj,frames{i});
end
close(myObj);

fprintf(strcat(datestr(now,30),'\n'));
end