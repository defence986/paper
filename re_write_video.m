
close all; clear;
fileName = '0_20161228T015324.avi';
ourpath = '..\video\output\final\good\';
% fileName = 'example7_input.avi';
% fileName = 'example3_input2.avi';
% ourpath = '..\video\input\';
[obj,numFrames] = get_obj(fileName,ourpath);

filename = strcat('..\video\output\',datestr(now,30),'.avi');
myObj = VideoWriter(filename);
myObj.FrameRate = 29;
% myObj.FrameRate = obj.FrameRate;

open(myObj);
for i=1:numFrames
    frame = read(obj, i);
    writeVideo(myObj,frame);
end
close(myObj);