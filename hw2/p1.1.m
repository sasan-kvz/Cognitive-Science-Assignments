
clear; close all; clc;
z=load('z_q1.mat');
z=z.z;
zt = z';
pdz = fitdist(zt,'kernel');
r = zeros(1,1000);
r = random(pdz,1,1000);
histogram(r,40);
hold on;
histogram(z,40);
legend ;
title('histogram of generated random numbers and given vector z');
