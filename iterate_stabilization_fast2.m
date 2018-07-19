function [newName,newPath] = iterate_stabilization_fast2(ourName,ourPath)
% clear all;close all; clc;
% % fileName = '20161028T073355.avi';
% % ourpath = '..\video\medium\asapWarp\';
% 
% fileName = 'Video_Figure_1.mov';
% ourPath = '..\video\input\';
[optimizer,metric] = imregconfig('multimodal');
optimizer.InitialRadius = optimizer.InitialRadius/50;
optimizer.MaximumIterations = 600;
AssignPath = '';
% AssignPath = '..\video\output\final\';
% [newName1,newPath1] = video_registration(ourPath,ourName,optimizer,metric,AssignPath);

% [newName2,newPath2] = bundled_optimization(newPath1,newName1);
% 
balance_ang = 0.8;
balance_T1 = 0.8;
balance_T2 = 0.8;
Var = 0.01;
Balance = {balance_ang,balance_T1,balance_T2,Var};
[newName1,newPath1,Balance] = Optimize_EMD(ourPath,ourName,optimizer,metric,AssignPath,Balance);
% [newName3,newPath3,Balance] = Optimize_emd_multimodal(newPath2,newName2,optimizer,metric,AssignPath,Balance);
% 

% [newName4,newPath4] = video_registration(newPath3,newName3,optimizer,metric,AssignPath);

[newName2,newPath2] = video_extrapolation(ourPath,ourName,newPath1,newName1,optimizer,metric,AssignPath);
% [newName5,newPath5] = video_extrapolation(ourPath,ourName,newPath1,newName1,optimizer,metric,AssignPath)

AssignPath = '..\video\output\final\';
[newName3,newPath3,Balance] = Optimize_EMD(newPath2,newName2,optimizer,metric,AssignPath,Balance);
% [newName6,newPath6] = video_registration(newPath5,newName5,optimizer,metric,AssignPath);
% newName = {newName1,newName2,newName3,newName4,newName5,newName6};
% newPath = {newPath1,newPath2,newPath3,newPath4,newPath5,newPath6};

newName = {ourName,newName1,newName2,newName3};
newPath = {ourPath,newPath1,newPath2,newPath3};
end