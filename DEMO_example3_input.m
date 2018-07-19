clear all;close all; clc;
% fileName = '20161028T073355.avi';
% ourpath = '..\video\medium\asapWarp\';

fileName = 'example3_input.avi';
ourPath = '..\video\input\';
[optimizer,metric] = imregconfig('multimodal');
optimizer.InitialRadius = optimizer.InitialRadius/100;
optimizer.MaximumIterations = 1000;
AssignPath = '';
[newName1,newPath1] = video_registration(ourPath,fileName,optimizer,metric,AssignPath);

[newName2,newPath2] = bundled_optimization(newPath1,newName1);

balance_ang = 10;
balance_T1 = 10;
balance_T2 = 10;
Var = 0.01;
Balance = {balance_ang,balance_T1,balance_T2,Var};
[newName3,newPath3,Balance] = Optimize_emd_multimodal(newPath2,newName2,optimizer,metric,AssignPath,Balance);

AssignPath = '..\video\output\final\';
% optimizer.InitialRadius = optimizer.InitialRadius/10;
% optimizer.MaximumIterations = 1000;
[newName4,newPath4] = video_registration(newPath3,newName3,optimizer,metric,AssignPath);