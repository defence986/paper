function [Balance,Ratio_ang,Ratio_Scale,RatioT1,RatioT2,numFrames,Src,...
    Dest] = Distribute_Optimize_emd(ourpath,fileName,Balance)
% close all; clear;
% fileName = 'Video_Figure_1.mov';
% ourpath = 'D:\play\movie\';
% fileName = 'example7_input.avi';
% fileName = 'example3_input2.avi';
% ourpath = '..\video\input\';
[obj,numFrames] = get_obj(fileName,ourpath);
balance_ang = Balance{1};
balance_S = Balance{2};
balance_T1 = Balance{3};
balance_T2 = Balance{4};
Var = Balance{5};
imgB = read(obj, 1);
% imgBp = imgB;

k = 2;
Hcumulative = eye(3);
frames = {};
Homo = {};
frames{1} = imgB;
Homo{1} = eye(3);

R1(1) = 1;
R2(1) = 0;
T1(1) = 0;
T2(1) = 0;
for k = 2:numFrames
% for k = 2:30
    % Read in new frame
    imgA = imgB;
%     imgAp = imgBp;

    fprintf('***************************************\n');
    fprintf('Request SRT the %d frame.\n', k);
    imgB = read(obj,k);
    Height = size(imgB,1);
    Width = size(imgB,2);
    grayA = imgA;
    grayB = imgB;
    if ndims(imgA) == 3
        grayA = rgb2gray(imgA);
    end
    if ndims(imgB) == 3
        grayB = rgb2gray(imgB);
    end
    % Estimate transform from frame A to frame B, and fit as an s-R-t
    H = cvexEstStabilizationTform(grayA,grayB);
    HsRt = cvexTformToSRT(H);
%     HsRt = H;
    Hcumulative = HsRt * Hcumulative;
    Homo{k} = Hcumulative;
end

% save('Homo.mat','Homo');
for k = 1:length(Homo)
    [H,Scale(k),ang(k),tran{k}] = cvexTformToSRT(Homo{k});
    T1(k) = tran{k}(1);
    T2(k) = tran{k}(2);
end

Dist(1) = 0;
for k = 2:length(Homo)
    Dist(k) = (T1(k)-T1(k-1)).^2 + (T2(k)-T2(k-1)).^2;
end
[New_dist, indx] = sort(Dist,'descend');

[Homo,R1,R2,T1,T2] = preserve_feature(obj,numFrames,indx(1));
for k = 1:length(Homo)
    [H,Scale(k),ang(k),tran{k}] = cvexTformToSRT(Homo{k});
    T1(k) = tran{k}(1);
    T2(k) = tran{k}(2);
end

% Section = sort(indx(1:ceil(numFrames/100)));
Section = indx(1);
if Section(1) > 1
    Section = [1,Section];
end
if Section(end) < numFrames
    Section = [Section,numFrames+1];
end
imfS = emd(Scale);
imfang = emd(ang);
if (~length(imfS) | ~length(imfang))
    fprintf('imf failure.\n');
    return;
end

Ratio_ang = cvx_ratio(imfang,ang,balance_ang);
while all(Ratio_ang>0.999)
    fprintf('******************** balance ang is %f\n', balance_ang);
    balance_ang = balance_ang-Var;
    Ratio_ang = cvx_ratio(imfang,ang,balance_ang);
end
emdang = ratio_emd(Ratio_ang,imfang);

Ratio_Scale = cvx_ratio(imfS,Scale,balance_S);
while all(Ratio_Scale>0.999)
    fprintf('******************** balance Scale is %f\n', balance_S);
    balance_S = balance_S-Var;
    Ratio_Scale = cvx_ratio(imfS,Scale,balance_S);
end
emdS = ratio_emd(Ratio_Scale,imfS);

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

Balance = {balance_ang,balance_S,balance_T1,balance_T2,Var};

longitude = 5;
emdang = feature_centric(ang,emdang,longitude);
emdS = feature_centric_scale(Scale,emdS,longitude);
emdT1 = feature_centric(T1,emdT1,longitude);
emdT2 = feature_centric(T2,emdT2,longitude);

[emdang,emdS,emdT1,emdT2] = handle_section(emdang,emdS,emdT1,emdT2,Section,Height,Width);

Src = {ang,Scale,T1,T2};
Dest = {emdang,emdS,emdT1,emdT2};

% T11 = sort(emdT1,'descend');
% T22 = sort(emdT2,'descend');
% MV1 = mean(T11(1:10)) - mean(emdT1);
% MV2 = mean(T22(1:10)) - mean(emdT2);

for k = 1:size(Homo,2)
%     Homo{k} = cvexTformToRT(Homo{k},emdS(k)+1-min(emdS),emdang(k)-mean(emdang));
%     Homo{k} = cvexTformToS(Homo{k},emdS(k)+(1-mean(emdS)));
    Homo{k} = cvexTformToS(Homo{k},emdS(k));
%     Homo{k} = cvexTformToang(Homo{k},emdang(k)-mean(emdang));
    Homo{k} = cvexTformToang(Homo{k},emdang(k));
%     Homo{k} = cvexTformToT(Homo{k},emdT1(k)-MV1,emdT2(k)+MV2);
    Homo{k} = cvexTformToT(Homo{k},emdT1(k),emdT2(k));
end

for m = 1:size(Homo,2)
    frame = read(obj, m);
    frames{m} = imwarp(frame,affine2d(Homo{m}),'OutputView',imref2d(size(frame)));
end


filename = strcat('..\video\output\',datestr(now,30),'.avi');
myObj = VideoWriter(filename);
% writerObj.FrameRate = 30;
myObj.FrameRate = 30;

open(myObj);
for i=1:size(frames,2)
    writeVideo(myObj,frames{i});
end
close(myObj);