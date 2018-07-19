close all; clear;

fileName = 'RectifyAT_20161102T183926.avi';
ourpath = '..\..\video\medium\multimodal\';
[obj,numFrames] = get_obj(fileName,ourpath);

% for k = 1:numFrames
for k = 1:1
    fprintf('***************************************\n');
    fprintf('test read Video frames the %d frame.\n', k);
    imgA = read(obj,k);
    imwrite(imgA, 'temp2.jpg');
    CurPath = fileparts(mfilename('temp2.jpg'));
    CurPath1 = strcat(CurPath, 'SourceImage');
    movefile('temp2.jpg', CurPath1);
end