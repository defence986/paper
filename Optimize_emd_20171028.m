function [Balance,Ratio_ang,Ratio_Scale,RatioT1,RatioT2,numFrames,Src,...
    Dest] = Optimize_emd(ourpath,fileName,Balance)
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
    imgA = imgB;
    fprintf('***************************************\n');
    fprintf('Request SRT the %d frame.\n', k);
    imgB = read(obj,k);

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
%     R1(k) = double(Hcumulative(1,1));
%     R2(k) = double(Hcumulative(1,2));
%     T1(k) = double(Hcumulative(3,1));
%     T2(k) = double(Hcumulative(3,2));
    Homo{k} = Hcumulative;
    
%     imgBp = imwarp(imgB,affine2d(Hcumulative),'OutputView',imref2d(size(imgB)));

%     frames{k} = imgBp;
end

save('Homo.mat','Homo');

for k = 1:length(Homo)
    [H,Scale(k),ang(k),tran{k}] = cvexTformToSRT(Homo{k});
    T1(k) = tran{k}(1);
    T2(k) = tran{k}(2);
end

Balance = {balance_ang,balance_S,balance_T1,balance_T2,Var};

Src = {ang,Scale,T1,T2};
Dest = Src;
Ratio_ang = 1;
Ratio_Scale = 1;
RatioT1 = 1;
RatioT2 = 1;

for k = 1:size(Homo,2)
    Homo{k} = cvexTformToS(Homo{k},Scale(k)+1-max(Scale));
    Homo{k} = cvexTformToang(Homo{k},ang(k)-mean(ang));
end

for m = 1:size(Homo,2)
    frame = read(obj, m);
    frames{m} = imwarp(frame,affine2d(Homo{m}),'OutputView',imref2d(size(frame)));
end


filename = strcat('..\video\output\final\',datestr(now,30),'.avi');
myObj = VideoWriter(filename);
% writerObj.FrameRate = 30;
myObj.FrameRate = 30;

open(myObj);
for i=1:size(frames,2)
    writeVideo(myObj,frames{i});
end
close(myObj);

fprintf(strcat(datestr(now,30),'\n'));