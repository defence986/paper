function H = read_matrix(img1,img2,optimizer,metric)
gray1 = img1;
gray2 = img2;
if ndims(img1) == 3
    gray1 = rgb2gray(img1);
end
if ndims(img2) == 3
    gray2 = rgb2gray(img2);
end
H = imregtform(gray2,gray1,'rigid',optimizer,metric);
H = H.T;
end