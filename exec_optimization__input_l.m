close all; clear;

fileName = 'input_l.avi';
ourpath = '..\video\input\Joint Bundled Camera Paths for Stereoscopic Video Stabilization\0\';
% [obj,numFrames] = get_obj(fileName,ourpath);
% for k = 1:numFrames
%     fprintf('***************************************\n');
%     fprintf('test read Video frames the %d frame.\n', k);
%     imgB = read(obj,k);
% end

balance_ang = 3;
balance_S = 0.3;
balance_T1 = 2;
balance_T2 = 3.5;
Var = 0.01;
Balance = {balance_ang,balance_S,balance_T1,balance_T2,Var};

[Balance,Ratio_ang,Ratio_Scale,RatioT1,RatioT2,numFrames,Src,...
    Dest] = Distribute_Optimize_emd(ourpath,fileName,Balance);
balance_ang = Balance{1};
balance_S = Balance{2};
balance_T1 = Balance{3};
balance_T2 = Balance{4};