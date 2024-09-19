
%%3 GLM
clear
close all
clc
RT_q2 = load('RT_q2.mat');
list1 = zeros(sum(RT_q2.RT_q2(:,2)==1),1);
list2 = zeros(sum(RT_q2.RT_q2(:,2)==2),1);
j = 1;
k = 1;
for i = 1:length(RT_q2.RT_q2(:,1))
    if RT_q2.RT_q2(i,2) == 1
        list1(j) = RT_q2.RT_q2(i,1);
        j = j + 1;
    elseif RT_q2.RT_q2(i,2) == 2
        list2(k) = RT_q2.RT_q2(i,1);
        k = k + 1;
    end
end
a = list1;
b = list2;
y = [a;b];
x = [zeros(30,1);ones(30,1)];
lm = fitlm(x,y);
disp(lm)
