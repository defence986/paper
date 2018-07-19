clear all;close all; clc;
InFolder = 'Bundled Camera Paths for Video Stabilization/Regular/';

% ourPath = '..\video\input\Robust_Learning_based_Camera_Motion_Characterization_scheme_with_application_to_Video_Stabilization\';
ourPath = strcat('../video/input/', InFolder);
fl_list = dir(ourPath);
fl_list(3).name

CoreNum=4; %设定机器CPU核心数量
startmatlabpool(CoreNum);

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
parfor i = 3:length(fl_list)
    fprintf('Batch process %s.\n', fl_list(i).name);
    [TempName{i},TempPath{i}] = iterate_stabilization2(fl_list(i).name,ourPath);
end

closematlabpool;