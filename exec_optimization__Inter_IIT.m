close all; clear;

fileName = 'Inter_IIT.avi';
ourpath = '..\video\input\IEEE Transactions on Circuits and Systems for Video Technology\';
% [obj,numFrames] = get_obj(fileName,ourpath);
% for k = 1:numFrames
%     fprintf('***************************************\n');
%     fprintf('test read Video frames the %d frame.\n', k);
%     imgB = read(obj,k);
% end

balance_ang = 9;
balance_S = 8.8;
balance_T1 = 8.8;
balance_T2 = 8.8;
Var = 0.01;
% Balance{1} = balance_ang;
% Balance{2} = balance_S;
% Balance{3} = balance_T1;
% Balance{4} = balance_T2;
% Balance{5} = Var;
Balance = {balance_ang,balance_S,balance_T1,balance_T2,Var};
% [balance_ang,balance_S,balance_T1,balance_T2,Ratio_ang,Ratio_Scale,RatioT1,RatioT2,...
% numFrames] = Optimize_emd(ourpath,fileName,balance_ang,balance_S,balance_T1,balance_T2,Var)
[Balance,Ratio_ang,Ratio_Scale,RatioT1,RatioT2,numFrames,Src,...
    Dest] = Distribute_Optimize_emd(ourpath,fileName,Balance);
balance_ang = Balance{1};
balance_S = Balance{2};
balance_T1 = Balance{3};
balance_T2 = Balance{4};