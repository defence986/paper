close all; clear;

fileName = 'example2_input_baofeng.wmv';
ourpath = '..\video\input\';
balance_ang = 8;
balance_S = 5.5;
balance_T1 = 4.8;
balance_T2 = 8.5;
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
    Dest] = Optimize_emd(ourpath,fileName,Balance);
balance_ang = Balance{1};
balance_S = Balance{2};
balance_T1 = Balance{3};
balance_T2 = Balance{4};