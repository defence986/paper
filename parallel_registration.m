% function [Balance,Ratio_ang,Ratio_Scale,RatioT1,RatioT2,numFrames,Src,...
%     Dest] = Optimize_emd(ourpath,fileName,Balance)
close all; clear;
% fileName = '20161028T073355.avi';
% ourpath = '..\video\medium\asapWarp\';

fileName = 'Video_Figure_1.mov';
ourpath = '..\video\input\';

[obj,numFrames] = get_obj(fileName,ourpath);
% balance_ang = Balance{1};
% balance_S = Balance{2};
% balance_T1 = Balance{3};
% balance_T2 = Balance{4};
% Var = Balance{5};
imgB = read(obj, 1);

k = 2;
% Hcumulative = affine2d(eye(3));
Hcumulative = eye(3);
frames = {};
Homo = {};
frames{1} = imgB;
% Homo{1} = affine2d(eye(3));
Homo{1} = eye(3);

% R1(1) = 1;
% R2(1) = 0;
% T1(1) = 0;
% T2(1) = 0;

[optimizer,metric] = imregconfig('multimodal');
% optimizer.InitialRadius = optimizer.InitialRadius/10;
% optimizer.MaximumIterations = 300;

CoreNum=4; %设定机器CPU核心数量
startmatlabpool(CoreNum);
parfor k = 2:numFrames
% for k = 2:2
%     imgA = imgB;
    fprintf('***************************************\n');
    fprintf('Parallel Registering Multimodal Images the %d frame.\n', k);
    imgA = read(obj,k-1);
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
%     H = cvexEstStabilizationTform(grayA,grayB);
%     HsRt = cvexTformToSRT(H);

%     tformSimilarity = imregtform(moving,fixed,'similarity',optimizer,metric);
%     tformRigid = imregtform(grayB,grayA,'affine',optimizer,metric);
    tformRigid = imregtform(grayB,grayA,'rigid',optimizer,metric);

%     grayBAdjustedInitialRadius300 = imregister(grayB, grayA, 'affine', optimizer, metric);
%     grayBAdjustedInitialRadius300 = imregister(grayB, grayA, 'rigid', optimizer, metric);
%     figure, imshowpair(grayBAdjustedInitialRadius300, grayA,'montage');
    
%     HsRt = H;
%     Hcumulative = tformRigid.T * Hcumulative;
%     Homo{k} = Hcumulative;
    Homo{k} = tformRigid.T;
end

for k = 2:length(Homo)
    Homo{k} = Homo{k-1} * Homo{k};
end

% save('Homo.mat','Homo');
% 
for k = 1:length(Homo)
    [H,Scale(k),ang(k),tran{k}] = cvexTformToSRT(Homo{k});
    T1(k) = tran{k}(1);
    T2(k) = tran{k}(2);
end
% 
% Balance = {balance_ang,balance_S,balance_T1,balance_T2,Var};
% 
% Src = {ang,Scale,T1,T2};
% Dest = Src;
% Ratio_ang = 1;
% Ratio_Scale = 1;
% RatioT1 = 1;
% RatioT2 = 1;
% 
for k = 1:size(Homo,2)
%     Homo{k} = cvexTformToS(Homo{k},Scale(k)+1-max(Scale));
    Homo{k} = cvexTformToang(Homo{k},ang(k)-mean(ang));
    Homo{k} = cvexTformToT(Homo{k},T1(k)-mean(T1),T2(k)-mean(T2));
end
% 
parfor m = 1:size(Homo,2)
    frame = read(obj, m);
    frames{m} = imwarp(frame,affine2d(Homo{m}),'OutputView',imref2d(size(frame)));
%     movingRegisteredRigid = imwarp(moving,tformSimilarity,'OutputView',Rfixed);
end

closematlabpool;

% figure, imshowpair(frames{2}, imgA);
% title('B: Adjusted InitialRadius, MaximumIterations = 300, Adjusted InitialRadius.')
% 
% 
filename = strcat('..\video\medium\multimodal\',datestr(now,30),'.avi');
myObj = VideoWriter(filename);
% writerObj.FrameRate = 30;
myObj.FrameRate = 30;

open(myObj);
for i=1:size(frames,2)
    writeVideo(myObj,frames{i});
end
close(myObj);

fprintf(strcat(datestr(now,30),'\n'));