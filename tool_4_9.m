clear
% close all

% 

%% 1、载入数据
rawdata = convertTDMS(1,'D:\LOT\LOT_DATA\2024_4_13\test2.tdms'); 
for i=1:16
    data1(:,i)=rawdata.Data.MeasuredData(i+2).Data(:);
end
fs=40000;  %采样率
time=length(data1(:,1));
time=(0:time-1)/60/fs;

data_488=data1(:,1:8);
data_520=data1(:,9:16);
data_520=flip(data_520,2);      %翻转使通道对应
mean_488=mean(data_488);
mean_520=mean(data_520);

var_488=var(data_488);
var_520=var(data_520);

std_488=std(data_488);
std_520=std(data_520);

for i=1:8
    filt_488(:,i)=BandpassFilt(data_488(:,i),fs,0,0.1);
    filt_520(:,i)=BandpassFilt(data_520(:,i),fs,0,0.1);
end

figure,
for i=1:8
subplot(8,2,2*i-1);
plot(time,data_488(:,i));
title(sprintf('520\\_CH %d',i))
subplot(8,2,2*i);
plot(time,data_520(:,i));
title(sprintf('488\\_CH %d',i))
end
sgtitle('test3')

figure,
for i=1:8
subplot(8,2,2*i-1);
plot(time,filt_488(:,i));
title(sprintf('520\\_CH %d',i))
subplot(8,2,2*i);
plot(time,filt_520(:,i));
title(sprintf('488\\_CH %d',i))
end
sgtitle('test3')
% time=length(data1(:,1));
% data=data1(:,1:8);
% time=(0:time-1)/60/40;
% figure,
% for i=1:8
% subplot(8,1,i);
% plot(time,data(:,i));
% title(sprintf('CH %d',i))
% end
% sgtitle('test5')
% 
% mean_data=mean(data);
% 
% std_data=std(data);
%% 40kHz采样率每秒均值和方差
t=length(data1(:,1))/fs;
for i=1:t
    mean_488(i,:)=mean(data_488((i-1)*fs+1:i*fs,:));
    mean_520(i,:)=mean(data_520((i-1)*fs+1:i*fs,:));
    var_488(i,:)=var(data_488((i-1)*fs+1:i*fs,:));
    var_520(i,:)=var(data_520((i-1)*fs+1:i*fs,:));
end
time=(0:t-1)/60;
figure,
for i=1:8
subplot(8,2,2*i-1);
plot(time,mean_488(:,i));
title(sprintf('520\\_CH %d',i))
subplot(8,2,2*i);
plot(time,mean_520(:,i));
title(sprintf('488\\_CH %d',i))
end
sgtitle('test1')
figure,
for i=1:8
subplot(8,2,2*i-1);
plot(time,var_488(:,i));
title(sprintf('520\\_CH %d',i))
subplot(8,2,2*i);
plot(time,var_520(:,i));
title(sprintf('488\\_CH %d',i))
end
sgtitle('test1')
