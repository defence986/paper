function [emdang,emdS,emdT1,emdT2] = handle_section(emdang,emdS,emdT1,emdT2,Section,Height,Width)
% close all; clear;

% [obj,numFrames] = get_obj('','');
% Switch = [239,43,44,10];
for i = 1:size(emdang,2)
    for j=1:size(Section,2)
        if (i>=Section(j) && i<Section(j+1))
            emdang(i) = emdang(i) - mean(emdang(Section(j)+1:Section(j+1)-1));
%             emdT1(i) = emdT1(i) - mean(emdT1(Section(j)+1:Section(j+1)-1)) + Width/2;
%             emdT2(i) = emdT2(i) - mean(emdT2(Section(j)+1:Section(j+1)-1)) + Height/2;
%             if i>=171
%                 emdT1(i) = emdT1(i) + 400;
%             end
            emdT1(i) = emdT1(i) - mean(emdT1(Section(j)+1:Section(j+1)-1));
            emdT2(i) = emdT2(i) - mean(emdT2(Section(j)+1:Section(j+1)-1));
            break;
        end
    end
end