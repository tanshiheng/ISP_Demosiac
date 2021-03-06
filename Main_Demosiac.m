%% 程序分享 
% 个人博客 www.aomanhao.top
% Github https://github.com/AomanHao
% CSDN https://blog.csdn.net/Aoman_Hao
%--------------------------------------

%% ISP处理之Demosiac
clear
close all
clc
%% 原始图像采样生成bayer图像
I=imread('kodim19.png');
figure;imshow(I);title("原始图像");
[m,n,p]=size(I);

% 采样 生成bayer图像 GRBG
bayer=zeros(m,n);
for i=1:1:m/2
    for j=1:1:n/2
        bayer(i*2-1,j*2-1)=I(i*2-1,j*2-1,2);
        bayer(i*2,j*2)=I(i*2,j*2,2);
        bayer(i*2,j*2-1)=I(i*2,j*2-1,3);
        bayer(i*2-1,j*2)=I(i*2-1,j*2,1);
    end
end
figure;imshow(uint8(bayer));imwrite(uint8(bayer),'stripes2.png');

%% bayer扩展，0元素补充（默认）或者周边行列赋值
bayerPad = bayerPadding(bayer, m, n);
imwrite(uint8(bayerPad),'bayerPad.png');

%% matlab自带demosaic函数处理
I2=demosaic(uint8(bayer),'grbg');
figure;imshow(I2);title('自带插值');imwrite(I2,'mat.png');

%% 手动插值图像
Simple_out = Simple_Inter(bayer, m, n);
figure;imshow(uint8(Simple_out));title('手动插值');imwrite(uint8(Simple_out),'手动.png');

%% 双线性插值 
OutputTwo = Demosaic_Twointer(I,m, n);
figure;imshow(OutputTwo);imwrite(OutputTwo,'TwoOutput.png');

%% 自适应插值 hamilton adams
OutputAda = Demosaic_Adaptiveinter(bayerPad,m, n);
imshow(uint8(OutputAda));title('自适应插值');imwrite(uint8(OutputAda),'OutputAda.png');
