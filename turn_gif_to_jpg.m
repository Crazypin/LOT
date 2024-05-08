% 指定包含 GIF 文件的文件夹路径
folderPath = 'D:\LOT\图像增强\2024_3_6\gif'; % 例如 'C:\Users\YourName\Documents\GIFs'
% 指定保存 JPG 文件的文件夹路径
outputFolderPath = 'D:\LOT\图像增强\2024_3_6 \jpg'; % 例如 'C:\Users\YourName\Documents\JPGs'

% 获取文件夹中所有 GIF 文件
gifFiles = dir(fullfile(folderPath, '*.gif'));

% 遍历所有 GIF 文件
for k = 1:length(gifFiles)
    gifFileName = gifFiles(k).name;
    [filepath,name,ext] = fileparts(gifFileName);
    % 构造完整的 GIF 文件路径
    fullGifPath = fullfile(folderPath, gifFileName);
    
    % 读取 GIF 文件的第一帧
    [img, map] = imread(fullGifPath, 1); % '1' 表示第一帧，可以根据需要更改帧编号
    
    % 如果 GIF 使用颜色映射，将索引图像转换为真彩图像
    if ~isempty(map)
        img = ind2rgb(img, map);
    end
    
    % 构造输出 JPG 文件的完整路径
    outputFileName = sprintf('%s.jpg', name);
    fullOutputPath = fullfile(outputFolderPath, outputFileName);
    
    % 将图像保存为 JPG 格式
    imwrite(img, fullOutputPath, 'jpg');
    
    fprintf('已将 %s 保存为 JPG\n', gifFileName);
end

fprintf('所有 GIF 图像的指定帧已成功保存为 JPG 格式。\n');
