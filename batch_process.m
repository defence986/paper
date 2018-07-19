clear all;close all; clc;

fl_list = {};
fl_list{1} = 'Inter_IIT.avi';
fl_list{2} = 'SA_1.avi';
fl_list{3} = 'SA_2.avi';
fl_list{4} = 'SA_3.avi';
fl_list{5} = 'SA_4.avi';
fl_list{6} = 'Traffic_Junction.avi';

ourPath = '..\video\input\Robust_Learning_based_Camera_Motion_Characterization_scheme_with_application_to_Video_Stabilization\';

for i = 1:length(fl_list)
    [obj,numFrames] = get_obj(fl_list{i},ourPath);
    for j = 1:numFrames
        fprintf('Test %s the %d frame.\n', fl_list{i},j);
        imgB = read(obj, j);
        %     figure,imshow(imgB);
    end
end
TempName = {};
TempPath = {};
for i = 1:length(fl_list)
    fprintf('Batch process %s.\n', fl_list{i});
    [TempName{i},newPath{i}] = iterate_stabilization(fl_list{i},ourPath);
end