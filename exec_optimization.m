function [balance_ang,balance_S,balance_T1,balance_T2] = exec_optimization(fileName,ourpath)
% close all; clear all;clc;
% 
% %fileName = '20161012T233740.uniform.avi';
% fileName = '20161013T185023.reszied.avi';
% ourpath = '..\video\medium\';
balance_ang = 5;
balance_S = 5;
balance_T1 = 5;
balance_T2 = 5;
Var = 0.005;

Balance = {balance_ang,balance_S,balance_T1,balance_T2,Var};

[Balance,Ratio_ang,Ratio_Scale,RatioT1,RatioT2,numFrames,Src,...
    Dest] = Optimize_emd(ourpath,fileName,Balance);
balance_ang = Balance{1};
balance_S = Balance{2};
balance_T1 = Balance{3};
balance_T2 = Balance{4};