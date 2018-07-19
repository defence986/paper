function plot_hht_full(x,Ts)
% Plot the HHT.
% plot_hht(x,Ts)
% 
% :: Syntax
%    The array x is the input signal and Ts is the sampling period.
%    Example on use: [x,Fs] = wavread('Hum.wav');
%                    plot_hht(x(1:6000),1/Fs);
% Func : emd

% Get HHT.
imf = emd(x);
for k = 1:length(imf)
   %fprintf('*********************\n');
   %imf{k}
   %fprintf('*********************\n');
   b(k) = sum(imf{k}.*imf{k});
   th   = angle(hilbert(imf{k})); % 相位
   d{k} = diff(th)/Ts/(2*pi); % 瞬时频率
   %b(k)
   %th
   %d{k}
end
[u,v] = sort(-b);
b     = 1-b/max(b); % 后面绘图的亮度控制
%b
% Set time-frequency plots.
N = length(x);
c = linspace(0,(N-2)*Ts,N-1);

if 0
for k = v(1:length(imf))
%for k = v(1:2) % 显示能量最大的两个IMF的瞬时频率
   b([k k k])
   figure, plot(c,d{k},'k.','Color',b([k k k]),'MarkerSize',3);
   set(gca,'FontSize',8,'XLim',[0 c(end)],'YLim',[0 1/2/Ts]); xlabel('Time'), ylabel('Frequency');
   title(sprintf('IMF%d', k))
end
end

M = length(imf);
for k1 = 0:4:M-1
    figure
    for k2 = 1:min(4,M-k1)
    %for k = v(1:2) % 显示能量最大的两个IMF的瞬时频率
        k = v(k1+k2);
        %b([k k k])
        subplot(4,1,k2);
        %plot(c,d{k},'k.','Color',b([k k k]),'MarkerSize',3);
        plot(c,d{k},'k.','MarkerSize',3);
        set(gca,'FontSize',8,'XLim',[0 c(end)],'YLim',[0 1/3/Ts]);
        ylabel('Frequency');
        title(sprintf('IMF%d', k))
    end
    xlabel('Time');
end

% Set IMF plots.
M = length(imf);
N = length(x);
c = linspace(0,(N-1)*Ts,N);
% c = linspace(0,N);

Step =6;
for k1 = 0:Step:M-1
   figure
   for k2 = 1:min(Step,M-k1)
       subplot(Step,1,k2);
       plot(c,imf{k1+k2},'linewidth',2);
       set(gca,'FontSize',8,'XLim',[0 c(end)]); 
%        title(sprintf('The %d IMF', k1+k2));
       ylabel(sprintf('IMF%d', k1+k2));
   end
   xlabel('Time');
   
end

% for k1 = 1:M
%     figure
%     plot(c,imf{k1},'linewidth',2);
%     set(gca,'FontSize',8,'XLim',[0 c(end)]);
%     title(sprintf('The %d IMF', k1));
%     ylabel(sprintf('IMF%d', k1));
% end
% xlabel('Time');
% 
% end