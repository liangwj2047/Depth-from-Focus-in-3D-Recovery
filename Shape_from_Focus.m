%   This is the Matlab implementation of the undergraduate thesis
%   "���ڽ�ƽ��ɨ�����ά�ع������о�", ���Ľ�
%   "Research on 3D Reconstruction Technology Based on Scanning of Focal
%   Plane", Wenjiang Liang
%   Function: ����Sum of Modified Laplacian(SML)������ɾ۽���������ά�ع�
%   Code Author: Wenjiang Liang
%   Email: liangwj2047@163.com
%   Date: 2022/04/30


%������������б����ʹ���
clc
clear;
close all;

%% ���ؽ�ջͼ�����ݣ��˴���Ҫ����mat���ݣ�������Դ��Pertuz��2011
%Dataset from https://sites.google.com/view/cvia/home
load Simc.mat
img = Simc;
numframes = size(img,3);
for i = 1:numframes
    imagesc(img(:,:,i));
    colormap(gray);
    %pause(0.5);
end

%��ջ���
delta = 50.50;

%% Sum of Modified Laplacian(SML), which was developed by S.K.Nayar, 1994
%Nayar S K, Nakagawa Y. Shape from focus[J]. 
%IEEE Transactions on Pattern analysis and machine intelligence, 1994, 16(8): 824-831.
rows = size(img,1);
cols = size(img,2);
focus_vals = zeros(rows,cols,numframes);
lap_vert = [0 1 0;
        0 -2 0;
        0  1 0];
lap_hor = [0 0 0;
         1 -2 1;
         0 0 0];
%����Mask��С
 nbd = 2;
 nbd_kernel = ones(2*nbd+1);
for i = 1:numframes     
    image_frame = img(:,:,i);
    sml = abs(convolution_operation(image_frame,lap_vert)) + abs(convolution_operation(image_frame,lap_hor));  % this is actually Modified Laplacian function in Nayar's paper
    focus_vals(:,:,i) = convolution_operation(sml,nbd_kernel);  %this is SML function with no threshold, and in Nayar's paper, a threshold should be added depond on image content
end
%% �������ͼ
depth_map = zeros(rows,cols);
d_vals = 0:delta:(numframes-1)*delta;
for l = 3:rows
    for m = 3:cols
        depth_map(l,m) = gaussian_interp(d_vals,reshape(focus_vals(l,m,:),numframes,1));
    end
end
mesh(depth_map)

