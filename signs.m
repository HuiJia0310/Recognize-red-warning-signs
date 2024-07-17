clear
clc
% 读取图片
img = imread('D:\ME_big\phs\include-60.png'); % 替换为你的图片文件路径

% 转换为HSV颜色空间
hsv_img = rgb2hsv(img);

h1=hsv_img(:,:,1);
s1=hsv_img(:,:,2);
v1=hsv_img(:,:,3);
% 创建二值掩模，将红色标志提取出来
red_mask =((h1<=0.04&h1>=0)|(h1>=0.740&h1<=1.0))&s1>=0.169&s1<=1.0&v1>=0.18&v1<=1.0;
figure,imshow(red_mask);title('原图hsv检测图像');

% 找到连通区域
stats = regionprops(red_mask, 'BoundingBox', 'Area', 'Eccentricity');

% 筛选出满足条件的区域（红色、形状接近圆形等）
threshold_area=300;
threshold_eccentricity=0.8;
valid_regions = [];
for i = 1:length(stats)
    if stats(i).Area > threshold_area && stats(i).Eccentricity < threshold_eccentricity
        valid_regions = [valid_regions; stats(i)];
    end
end

% 在原图上标记红色圆形区域
marked_img = img;
for i = 1:length(valid_regions)
    boundingBox = valid_regions(i).BoundingBox;
    rectangle('Position', boundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end

% 截取红色圆形区域并保存
for i = 1:length(valid_regions)
    boundingBox = valid_regions(i).BoundingBox;
    sub_img = imcrop(img, boundingBox);
    imwrite(sub_img, sprintf('speed_sign_%d.jpg', i));
end







