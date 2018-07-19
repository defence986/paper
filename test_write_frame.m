close all; clear;

fileName = 'Video_Figure_1.mov';
ourpath = '..\video\input\';
[obj,numFrames] = get_obj(fileName,ourpath);

% for k = 1:numFrames
for k = 1:1
    fprintf('***************************************\n');
    fprintf('test read Video frames the %d frame.\n', k);
    imgA = read(obj,k);
    imwrite(imgA, 'temp.jpg');
    CurPath = fileparts(mfilename('temp.jpg'));
    CurPath1 = strcat(CurPath, 'SourceImage');
    movefile('temp.jpg', CurPath1);
end