function [newName,newPath] = bundled_optimization(oldPath,oldName)
%1. As-similar-as-possible warping.
%2. Local homography estimation on mesh quads.

% clear all;
% close all;
% clc;

addpath('mesh');
addpath('RANSAC');

Rnum = 9;
Cnum = 9;
gap = 0;
% k = 2;
% Hcumulative = eye(3);
frames = {};
% Homo = {};
% Homo{1} = eye(3);
Hcumulative = zeros(Rnum,Cnum,3,3);
for i=1:Rnum-1
    for j=1:Cnum-1
        Hcumulative(i,j,:,:) = eye(3);
    end
end

% oldName = '20161013T202354.uniform.avi';
% oldPath = '..\video\medium\';
[obj,numFrames] = get_obj(oldName,oldPath);
imgA = read(obj,1);
% imgB = read(obj,2);

frames{1} = imgA;

% I1 = imread('examples/2/s.png');
% I2 = imread('examples/2/t.png');
% fprintf('detect surf features...');
% [imgA_features,imgB_features]=SURF(imgA,imgB);
% fprintf('[DONE]\n');
% 
% if length(imgB_features) < 20
%     error('not enough matched features');
%     return;
% end

[height,width,~] = size(imgA);
%3x3 mesh
quadWidth = width/(2^3);
quadHeight = height/(2^3);

% %4x4 mesh
% quadWidth = width/(2^4);
% quadHeight = height/(2^4);

lamda = 1; %mesh more rigid if larger value. [0.2~5]
% asap = AsSimilarAsPossibleWarping(height,width,quadWidth,quadHeight,lamda);

for k=2:numFrames
% for k=2:3
%     imgA = read(obj,k-1);
    imgB = read(obj,k);
    fprintf('Bundled_optimization detect the %d frame surf features ...\n',k);
    [imgB_features,imgA_features]=SURF(imgB,imgA);
    fprintf('[DONE]\n');

    if length(imgB_features) < 20
%         error('The %d frame not enough matched features\n',k);
        fprintf('The %d frame not enough matched features\n',k);
        newName = oldName;
        newPath = oldPath;
        return;
    end
    asap = AsSimilarAsPossibleWarping(height,width,quadWidth,quadHeight,lamda);
    asap.SetControlPts(imgB_features,imgA_features);%set matched features
    asap.Solve();            %solve Ax=b for as similar as possible
% homos = asap.CalcHomos();% calc local hommograph transform

% gap = 10;
% I1warp = asap.Warp(I1,gap);                     %warp source image to target image
% I1warpmesh = asap.destin.drawMesh(I1warp,gap);  %draw mesh on the warped source image
% imshow(I1warpmesh);


    [imgBwarp,Homo] = asap.Warp(imgB,gap);
%     [~,Homo] = asap.Warp(imgB,gap);

%     Homo = asap.CalcHomos();% calc local hommograph transform
%     Homo(:,:,3,1:2) = 0;
%     Homo(:,:,3,3) = 1;
%     
%     for i=1:Rnum-1
%         for j=1:Cnum-1
%             Temp1(:,:) = Hcumulative(i,j,:,:);
%             Temp2(:,:) = Homo(i,j,:,:);
%             Hcumulative(i,j,:,:) =Temp1 * Temp2;
%         end
%     end
    
%     imgBwarp = asap.WARP(imgB,gap,Homo);
%     imgBwarp = asap.WARP(imgB,gap,Hcumulative);
%     figure,imshowpair(imgB,imgBwarp,'montage');
%     imgA = imgBwarp;
    frames{k} = imgBwarp;
    imgA = imgB;
end
% figure,imshow(I1warp);
% imwrite(I1warp,'examples/2/warp.png');

Hcumulative = Homo;
[h,w,~,~] = size(Hcumulative);
for i=1:h-1
    for j=1:w-1
       H(:,:) = Hcumulative(i,j,:,:);
       fprintf('Quad=[%d %d]\n',i,j);
       H
    end
end


newName = strcat(datestr(now,30),'.avi');
newPath = '..\video\medium\asapWarp\';
myObj = VideoWriter(strcat(newPath, newName));

% filename = strcat('..\video\medium\asapWarp\',datestr(now,30),'.avi');
% myObj = VideoWriter(filename);
% myObj.FrameRate = 30;
myObj.FrameRate = obj.FrameRate;

open(myObj);
for i=1:size(frames,2)
    writeVideo(myObj,frames{i});
end
close(myObj);
end