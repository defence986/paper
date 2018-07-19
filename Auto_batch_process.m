clear all;close all; clc;
InFolder = 'Subspace Video Stabilization';

% ourPath = '..\video\input\Robust_Learning_based_Camera_Motion_Characterization_scheme_with_application_to_Video_Stabilization\';
ourPath = strcat('../video/input/', InFolder, '/input/');
fl_list = dir(ourPath);
fl_list(3).name
% 
for i = 3:length(fl_list)
    [obj,numFrames] = get_obj(fl_list(i).name,ourPath);
    for j = 1:numFrames
        fprintf('Test %s the %d frame.\n', fl_list(i).name,j);
        imgB = read(obj, j);
        %     figure,imshow(imgB);
    end
end
TempName = {};
TempPath = {};
for i = 3:length(fl_list)
    fprintf('Batch process %s.\n', fl_list(i).name);
    [TempName{i},newPath{i}] = iterate_stabilization(fl_list(i).name,ourPath);
end