function [ imgout ] = imMosaic(img1,img2,H)
%[ imgout ] = imMosaic( img1,img2,adjColor )
%	img1 and img2 can (both) be rgb or gray, double or uint8.
%	If you have more than 2 images to do mosaic, call this function several
%	times.
%	If you set adjColor to 1, imMosaic will try to try to adjust the
%	color(for rgb) or grayscale(for gray image) of img1 linearly, so the 2 
%	images can join more naturally.
%	Yan Ke @ THUEE, 20110123, xjed09@gmail.com

% use SIFT to find corresponding points
% [matchLoc1 matchLoc2] = siftMatch(img1, img2);

% use RANSAC to find homography matrix
% [H corrPtIdx] = findHomography(matchLoc2',matchLoc1');

% tform = maketform('projective',H');
% tform = maketform('affine',H');
% img21 = imtransform(img2,tform); % reproject img2
img21 = imwarp(img2,affine2d(H),'OutputView',imref2d(size(img2)));
% img1 incomplete
[M1 N1 dim] = size(img1);
[M2 N2 ~] = size(img2);

% do the mosaic
pt = zeros(3,4);
pt(:,1) = H*[1;1;1];
pt(:,2) = H*[N2;1;1];
pt(:,3) = H*[N2;M2;1];
pt(:,4) = H*[1;M2;1];
x2 = pt(1,:)./pt(3,:);
y2 = pt(2,:)./pt(3,:);

up = round(min(y2));
Yoffset = 0;
if up <= 0
	Yoffset = -up+1;
	up = 1;
end

left = round(min(x2));
Xoffset = 0;
if left<=0
	Xoffset = -left+1;
	left = 1;
end

imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;

[M3 N3 ~] = size(img21);
% imgout = zeros(max(up+M3-1,Yoffset+M1)-min(up,Yoffset+1),max(left+N3-1,Xoffset+N1)-min(left,Xoffset+1),3);

imgout(up:up+M3-1,left:left+N3-1,:) = img21;
% figure,imshow(imgout);
	% img1 is above img21

Margin = M1/2;
for j = 1:N1
    Umargin = 0;
    Dmargin = 0;

    for i = 1:Margin
%         imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;
        if img1(i,j)<=50
            Umargin = i+1;
            continue;
        else
            Umargin = i;
            break;
        end
    end
    for i = M1:Margin
        if img1(i,j)<=50
            Dmargin = i-1;
            continue;
        else
            Dmargin = i;
            break;
        end
    end
    
    if (Umargin >= Dmargin)
        continue;
    end
    
    for k = Umargin:Dmargin
        imgout(Yoffset+k,Xoffset+j,:) = img1(k,j,:);
    end
%     
%     newCol = round(Xoffset+1-left+j);
%     if (newCol<1 || newCol>M3)
%         for k = Umargin:Dmargin
%             imgout(Yoffset+k,Xoffset+j,:) = img1(k,j,:);
%         end
%         continue;
%     end
%     
%     Umargin2 = 0;
%     Dmargin2 = 0;
% 
%     for i = 1:M3
% %         imgout(Yoffset+1:Yoffset+M1,Xoffset+1:Xoffset+N1,:) = img1;
%         if img21(i,newCol)<=50
%             continue;
%         else
%             Umargin2 = i;
%             break;
%         end
%     end
%     for i = M3:1
%         if img1(i,newCol)<=50
%             continue;
%         else
%             Dmargin2 = i;
%             break;
%         end
%     end
%     
%     if (Umargin2 >= Dmargin2)
%         for k = Umargin:Dmargin
%             imgout(Yoffset+k,Xoffset+j,:) = img1(k,j,:);
%         end
%         continue;
%     end
%     
%     if (up+Umargin2 >= Yoffset+1+Umargin || up+M3-1+Dmargin2 <= Yoffset+M1+Dmargin)
%         for k = Umargin:Dmargin
%             imgout(Yoffset+k,Xoffset+j,:) = img1(k,j,:);
%         end
%         continue;
%     end
% 
%     newU = max(max(up,Yoffset+1),Umargin-Margin);
%     newD = min(min(up+M3-1,Yoffset+M1),Dmargin+Margin);
%     
%     for k = newU:newD
%         newRow = Yoffset-up+1+k;
%         imgout(Yoffset+k,Xoffset+j,:) = ((k-newU)*img1(k,j,:)+(newD-k)*img21(newRow,newCol,:))/(newD-newU);
%     end
% %             imgout(Yoffset+i,Xoffset+j,:) = img1(i,j,:);
end

imgout = imcrop(imgout,[Xoffset+1,Yoffset+1,N1-1,M1-1]);
end