clear
clc
% ��ȡͼƬ
img = imread('D:\ME_big\phs\include-60.png'); % �滻Ϊ���ͼƬ�ļ�·��

% ת��ΪHSV��ɫ�ռ�
hsv_img = rgb2hsv(img);

h1=hsv_img(:,:,1);
s1=hsv_img(:,:,2);
v1=hsv_img(:,:,3);
% ������ֵ��ģ������ɫ��־��ȡ����
red_mask =((h1<=0.04&h1>=0)|(h1>=0.740&h1<=1.0))&s1>=0.169&s1<=1.0&v1>=0.18&v1<=1.0;
figure,imshow(red_mask);title('ԭͼhsv���ͼ��');

% �ҵ���ͨ����
stats = regionprops(red_mask, 'BoundingBox', 'Area', 'Eccentricity');

% ɸѡ���������������򣨺�ɫ����״�ӽ�Բ�εȣ�
threshold_area=300;
threshold_eccentricity=0.8;
valid_regions = [];
for i = 1:length(stats)
    if stats(i).Area > threshold_area && stats(i).Eccentricity < threshold_eccentricity
        valid_regions = [valid_regions; stats(i)];
    end
end

% ��ԭͼ�ϱ�Ǻ�ɫԲ������
marked_img = img;
for i = 1:length(valid_regions)
    boundingBox = valid_regions(i).BoundingBox;
    rectangle('Position', boundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
end

% ��ȡ��ɫԲ�����򲢱���
for i = 1:length(valid_regions)
    boundingBox = valid_regions(i).BoundingBox;
    sub_img = imcrop(img, boundingBox);
    imwrite(sub_img, sprintf('speed_sign_%d.jpg', i));
end







