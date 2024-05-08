% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% 图像重排，CH1为RS反馈电压，CH16为Gvo反馈电压
% D:\LOT\LOT_DATA\2024_5_6\test4.tdms & test5.tdms & test6.tdms
% test4 20Hz正弦波
% test5 10Hz正弦波
% test6 5Hz正弦波
% 取点从RS反馈零点取
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
clear
%% 1、载入数据
rawdata = convertTDMS(1,'D:\LOT\LOT_DATA\2024_5_6\test4.tdms'); 
data1=zeros(size(rawdata.Data.MeasuredData(3).Data,1),16);
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


