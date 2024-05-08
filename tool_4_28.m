% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 图像重排，CH1为RS反馈电压，CH9为Gvo反馈电压
% D:\LOT\LOT_DATA\2024_4_28\test7.tdms & test6.tdms
% test6 20Hz正弦波
% test7 20Hz三角波
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear
%% 1、载入数据
rawdata = convertTDMS(1,'D:\LOT\LOT_DATA\2024_5_6\test5.tdms'); 
for i=1:16
    data1(:,i)=rawdata.Data.MeasuredData(i+2).Data(:);
end
fs=1.6e6;   %采样率
slow_fs=20; %慢轴驱动波形频率
frameline=4000/slow_fs;
result = floor(length(data1) / fs);

data=data1(fs+1:(result-1)*fs,1:16);     %丢弃第一秒和最后一秒数据
Gvo=smoothdata(data(:,16));                  %振镜反馈电压
RS=smoothdata(data(:,1));                  %共振振镜反馈电压
imgdata(:,1:7)=data(:,2:8);
imgdata(:,8:14)=data(:,9:15);
x=1:length(RS);
figure,
plot(x,Gvo,x,RS,'-g');
% plot(x,Gvo);

[RS_pks,RS_locs] = findpeaks(RS, 'MinPeakHeight', 0.2, 'MinPeakDistance', 200);
[Gvo_pks,Gvopks_locs] = findpeaks(Gvo, 'MinPeakHeight', 1, 'MinPeakDistance', (1/slow_fs)*fs);
[Gvo_val,Gvoval_locs] = findpeaks(-Gvo, 'MinPeakHeight', 1, 'MinPeakDistance', (1/slow_fs)*fs);
Gvo_val=-Gvo_val;
figure;
plot(Gvo, 'b'); % 使用蓝色线条绘制Gvo
hold on;

% 在波峰位置绘制红色星号标记
plot(Gvopks_locs, Gvo_pks, 'r*', 'MarkerSize', 8);

% 在波谷位置绘制绿色圆圈标记
plot(Gvoval_locs, Gvo_val, 'go', 'MarkerSize', 8);

% 添加图例
legend('Gvo Data', 'Peaks', 'Valleys');

% 添加标题和轴标签
title('Gvo Data with Peaks and Valleys Marked');
xlabel('Data Points');
ylabel('Gvo Value');

% 显示图形
hold off;

% %% 标注波峰
% figure,
% plot(x(4*fs:5*fs+1), Gvo(4*fs:5*fs+1), 'b', x(4*fs:5*fs+1), RS(4*fs:5*fs+1), '-g');  % 绘制Gvo和RS的数据
% hold on;  % 保持当前图像，以便添加更多的图层
% 
% % 找到并标记Gvo的波峰，只标记位于1:400000区间内的波峰
% Gvo_pks_locs = Gvo_locs((4*fs <= Gvo_locs) & (Gvo_locs <= 5*fs+1));
% plot(x(Gvo_pks_locs), Gvo(Gvo_pks_locs), 'p', 'MarkerFaceColor', 'red', 'MarkerSize', 8);  % 'p'是五角星标记
% 
% % 找到并标记RS的波峰，只标记位于1:400000区间内的波峰
% RS_pks_locs = RS_locs((4*fs <= RS_locs) & (RS_locs <= 5*fs+1));
% plot(x(RS_pks_locs), RS(RS_pks_locs), 'o', 'MarkerFaceColor', 'yellow', 'MarkerSize', 8);  % 'o'是圆圈标记
% 
% hold off;  % 关闭保持状态
% 
% % 添加图例
% legend('Gvo', 'RS', 'Gvo Peaks', 'RS Peaks');

%% 整理单帧数据
% singleframepos=RS_locs(16926:17025); %21:32  52:61
% clear framedata
% for i=1:length(singleframepos)
%     % framedata((i-1)*320+1:320*i-160,1:8)=flip(data(singleframepos(i)+20:singleframepos(i)+179,1:8),1);
%     framedata((i-1)*320+1:320*i-160,1:8)=data(singleframepos(i)+20:singleframepos(i)+179,1:8);
%     framedata(320*i-159:320*i,1:8)=flip(data(singleframepos(i)+220:singleframepos(i)+379,1:8),1);
% end
% 
% framedata=reshape(framedata,160,[],8);
% % framedata=permute(framedata, [2 1 3]);
% figure,
% for i=1:8
%     subplot(2,4,i)
%     imagesc(framedata(:,:,i));
% end
% 
% % singleframepos=RS_locs(16826:16926); %21:32  52:61
singleframepos=RS_locs(RS_locs < Gvoval_locs(3) & RS_locs > Gvopks_locs(3));
clear framedata
for i=1:length(singleframepos)
    % framedata((i-1)*320+1:320*i-160,1:8)=flip(data(singleframepos(i)+20:singleframepos(i)+179,1:8),1);
    % 
    framedata((i-1)*360+1:360*i-180,1:14)=imgdata(singleframepos(i)-89:singleframepos(i)+90,:);
    framedata(360*i-179:360*i,1:14)=flip(imgdata(singleframepos(i)+111+16:singleframepos(i)+290+16,:),1);
    % framedata((i-1)*180+1:180*i,1:14)=imgdata(singleframepos(i)-89:singleframepos(i)+90,:);        %只取一次扫描
    % framedata((i-1)*180+1:180*i,1:14)=flip(imgdata(singleframepos(i)+111+16:singleframepos(i)+290+16,:),1);        %只取一次扫描
end

framedata=reshape(framedata,180,[],14);
% framedata=permute(framedata, [2 1 3]);
framedata=flip(framedata,1);
framedata=flip(framedata,2);
figure,
colormap("gray")
for i=1:7
    subplot(7,2,2*i-1)
    imagesc(framedata(:,:,i));
    subplot(7,2,2*i)
    imagesc(framedata(:,:,7+i));
end
figure('Position', [0, 0, 800*1.5, 400*1.5]),
colormap("gray")
imagesc(framedata(:,:,3));
%% 整理全部数据
% 判断Gvo波峰开始还是波谷开始，波谷开始则波谷数据丢掉第一个
if Gvopks_locs(1) > Gvoval_locs(1)
    Gvoval_locs=Gvoval_locs(2:end);
end

%判断波峰波谷的长短
if length(Gvoval_locs) == length(Gvopks_locs)
    %相等不做改变
elseif length(Gvoval_locs) < length(Gvopks_locs)
    Gvopks_locs=Gvopks_locs(1:length(Gvoval_locs));
elseif length(Gvoval_locs) > length(Gvopks_locs)
    Gvoval_locs=Gvoval_locs(1:length(Gvopks_locs));
end
frame=2*length(Gvopks_locs)-1;
timeSeriesData=zeros(180,frameline,14,frame);
for i=1:length(Gvopks_locs)
    %取RS波峰位置,位于波峰-波谷之间,此步frame图像需要2thDim反转
    singleframepos=RS_locs(RS_locs < Gvoval_locs(i) & RS_locs > Gvopks_locs(i));
    n=1;
    % 只取frameline/2个波峰
    while length(singleframepos) < frameline/2     
        singleframepos=RS_locs(RS_locs < Gvoval_locs(i)+200*n & RS_locs > Gvopks_locs(i));
        n=n+1;
    end
    clear n
    if length(singleframepos) > frameline/2         
        singleframepos=singleframepos(1:frameline/2);
    end
    % 帧数据处理
    clear framedata
    framedata=zeros(180*frameline,14);
    for j=1:length(singleframepos)
        % framedata((i-1)*320+1:320*i-160,1:8)=flip(data(singleframepos(i)+20:singleframepos(i)+179,1:8),1);
        framedata((j-1)*360+1:360*j-180,1:14)=flip(imgdata(singleframepos(j)-89:singleframepos(j)+90,1:14),1);
        framedata(360*j-179:360*j,1:14)=imgdata(singleframepos(j)+111:singleframepos(j)+290,1:14);
    end

    framedata=reshape(framedata,180,[],14);
    framedata=flip(framedata,2);
    timeSeriesData(:,:,:,2*i-1)=framedata;
    clear framedata singleframepos;

    %取RS波峰位置,位于波谷-波峰之间
    if i<length(Gvopks_locs)
    singleframepos=RS_locs(RS_locs > Gvoval_locs(i) & RS_locs < Gvopks_locs(i+1));
    n=1;
    % 只取frameline/2个波峰
    while length(singleframepos) < frameline/2      
        singleframepos=RS_locs(RS_locs > Gvoval_locs(i) & RS_locs < Gvopks_locs(i+1)+450*n);
        n=n+1;
    end
    clear n
    if length(singleframepos) > frameline/2
        singleframepos=singleframepos(1:frameline/2);
    end
    % 帧数据处理
    clear framedata
    framedata=zeros(180*frameline,14);
    for j=1:length(singleframepos)
        % framedata((i-1)*320+1:320*i-160,1:8)=flip(data(singleframepos(i)+20:singleframepos(i)+179,1:8),1);
        framedata((j-1)*360+1:360*j-180,1:14)=flip(imgdata(singleframepos(j)-89:singleframepos(j)+90,1:14),1);
        framedata(360*j-179:360*j,1:14)=imgdata(singleframepos(j)+111:singleframepos(j)+290,1:14);
    end
    framedata=reshape(framedata,180,[],14);
    timeSeriesData(:,:,:,2*i)=framedata;
    end
    disp(i);
end
%% 绘图区
figure,
for i=1:size(timeSeriesData,4)
    imagesc(timeSeriesData(:,:,1,i));
    axis image; % 保持图像的长宽比
    pause(0.025);
    title(sprintf(' Frame %d',  i)); % 为每个子图添加标题
    drawnow;
end

figure('Position', [0, 0, 6400/1.2, 2000/1.2]),
for i=1:7
    subplot(7,2,2*i-1)
    imagesc(timeSeriesData(:,:,i,20));
    % axis image; % 保持图像的长宽比
    title(sprintf(' CH %d',  i)); % 为每个子图添加标题
    subplot(7,2,2*i)
    imagesc(timeSeriesData(:,:,7+i,20));
    % axis image; % 保持图像的长宽比
    title(sprintf(' CH %d',  i)); % 为每个子图添加标题
end
sgtitle(sprintf('slow2'));
figure('Position', [100, 100, 1600/1.2, 1000/1.2]),
imagesc(timeSeriesData(:,:,14,30));
title(sprintf(' CH 1 14'));
figure('Position', [100, 100, 1600/1.2, 1000/1.2]),
imagesc(timeSeriesData(:,:,1,30));
title(sprintf(' CH 1 1'));

% numFrames = 313;
% numChannels = 8;
% pauseTime = 0.025; % 每帧的显示时间间隔
% 
% % 创建一个 figure 窗口用于显示图像
% figure;
% for i = 1:numFrames
%     for j = 1:numChannels
%         subplot(2, 4, j); % 假设我们以 2x4 的网格形式展示 8 个通道
%         imagesc(timeSeriesData(:,:,j,i)); % 显示第 j 通道，第 i 帧的图像
%          axis image; % 保持图像的长宽比
%         colormap gray; % 设置颜色映射，适用于灰度图像
%         colorbar; % 显示颜色条
%         title(sprintf('Channel %d, Frame %d', j, i)); % 为每个子图添加标题
%     end
%     pause(pauseTime); % 暂停一段时间后显示下一帧
%     drawnow; % 立即更新图形窗口
% end
