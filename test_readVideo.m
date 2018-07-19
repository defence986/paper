close all; clear;

fileName = 'example4_car_input_baofeng.wmv';
ourpath = '..\video\input\';
[obj,numFrames] = get_obj(fileName,ourpath);
for k = 1:numFrames
    fprintf('***************************************\n');
    fprintf('test read Video frames the %d frame.\n', k);
    imgB = read(obj,k);
end
% img = read(obj,1);
% figure,imshow(img);
% homo = eye(3);
% homo(3,1) = 0;
% homo(3,2) = -80;
% img2 = imwarp(img,affine2d(homo),'OutputView',imref2d(size(img)));
% figure,imshow(img2);