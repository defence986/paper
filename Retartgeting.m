close all; clear;

fileName = 'Video_Figure_1.mov';
ourpath = '..\video\input\';
[obj,numFrames] = get_obj(fileName,ourpath);
Factor = 0.9;
Factor2 = 0.9;
for k = 1:numFrames
    fprintf('***************************************\n');
    fprintf('test read Video frames the %d frame.\n', k);
    imgA = read(obj,k);
    imwrite(imgA, 'temp.png');
    CurPath = fileparts(mfilename('temp.png'));
    CurPath1 = strcat(CurPath, 'img1');
    movefile('temp.png', CurPath1);
    
    %addpath('E:/work/medical_section/code/retargeting_vs2010/AARetargetingSource/src/Release');
    %path(path,'E:/work/medical_section/code/retargeting_vs2010/AARetargetingSource/src/Release');
    % command = '!Retargeting.exe img1/2.png img1/2.png 0.8';
    %command = [command ' <tmp.pgm >tmp.key'];
    command = horzcat('!Retargeting.exe img1\temp.png img1\temp.png ', num2str(Factor),' ',num2str(Factor2));
    eval(command);
    %CurPath2 = strcat(CurPath, 'resized');
    %Resized = strcat(CurPath1,'temp.png.resized.png');
    movefile('img1/temp.png.resized.png', strcat('resized/',num2str(k),'.png'));
    %CurPath3 = strcat(CurPath, 'uniform');
    movefile('img1/temp.png.uniform.png', strcat('uniform/',num2str(k),'.png'));
end

filename = strcat(datestr(now,30),'.reszied.avi')
filename1 = strcat('..\video\medium\',filename);
myObj = VideoWriter(filename1);
% writerObj.FrameRate = 30;
myObj.FrameRate = 30;

open(myObj);
for i=1:numFrames
    Frame = imread(strcat('resized\',num2str(i),'.png'));
    writeVideo(myObj,Frame);
end
close(myObj);

filename2 = strcat('..\video\medium\',filename);
myObj = VideoWriter(filename2);
% writerObj.FrameRate = 30;
myObj.FrameRate = 30;

open(myObj);
for i=1:numFrames
    Frame = imread(strcat('uniform\',num2str(i),'.png'));
    writeVideo(myObj,Frame);
end
close(myObj);

fileName = filename;
ourpath = '..\video\medium\';
[balance_ang,balance_S,balance_T1,balance_T2] = exec_optimization(fileName,ourpath);