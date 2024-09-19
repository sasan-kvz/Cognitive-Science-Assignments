%% 1.2 generating neural response
clear
clc
close all
cc=[1 0.1260 -0.0867;0.1260 1 0.6882;-0.0867 0.6882 1];
q=sqrtm(cc);
z1=poissrnd(8,1000,1); 
z2=poissrnd(10,1000,1);
z3=poissrnd(20,1000,1);
z=[z1 z2 z3];
y=z*q;
c1=corr2(y(:,1),y(:,1));
c2=corr2(y(:,1),y(:,2));
c3=corr2(y(:,1),y(:,3));
c4=corr2(y(:,2),y(:,1));
c5=corr2(y(:,2),y(:,2));
c6=corr2(y(:,2),y(:,3));
c7=corr2(y(:,3),y(:,1));
c8=corr2(y(:,3),y(:,2));
c9=corr2(y(:,3),y(:,3));
ccfinal=[c1 c2 c3;c4 c5 c6;c7 c8 c9];
