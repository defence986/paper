function [newName,newPath] = video_extrapolation(oldPath1,oldName1,oldPath2,oldName2,optimizer,metric,AssignPath)
% clear all;close all;clc;
% fileName1 = 'Video_Figure_1.mov';
% ourpath1 = '..\video\input\';
[obj1,numFrames1] = get_obj(oldName1,oldPath1);

% fileName2 = 'RectifyAT_20161102T183926.avi';
% ourpath2 = '..\video\medium\multimodal\';
[obj2,numFrames2] = get_obj(oldName2,oldPath2);

% [optimizer,metric] = imregconfig('multimodal');
% optimizer.InitialRadius = optimizer.InitialRadius/10;
% optimizer.MaximumIterations = 300;
frames = {};

% CoreNum=4; %设定机器CPU核心数量
% startmatlabpool(CoreNum);

for i = 1:numFrames2
% for i = 1:5
    fprintf('Video extrapolate the %d frame.\n', i);
    Haccumulate = eye(3);
    % img2 incomplete
    img2 = read(obj2,i);
    for j = max(1,i-6):min(i+6,numFrames1)
        % img1 complete
        if (j==i)
            continue;
        end
        img1 = read(obj1,j);
        Haccumulate = read_matrix(img2,img1,optimizer,metric);
%         Haccumulate
        img2 = imMosaic(img2,img1,Haccumulate);
    end
    frames{i} = img2;
end

% closematlabpool;

newName = strcat(datestr(now,30),'.avi');
if length(AssignPath)
    newPath = AssignPath;
else
    newPath = '..\video\medium\extrapolation\';
end
% newName = strcat('..\video\medium\multimodal\',datestr(now,30),'.avi');
myObj = VideoWriter(strcat(newPath, newName));
% writerObj.FrameRate = 30;
myObj.FrameRate = obj2.FrameRate;

open(myObj);
for i=1:size(frames,2)
    writeVideo(myObj,frames{i});
end
close(myObj);

fprintf(strcat(datestr(now,30),'\n'));
end