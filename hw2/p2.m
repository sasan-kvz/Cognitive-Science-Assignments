clc;
clear;
close all;
RT_q2=load('RT_q2.mat');
RT_q2 = RT_q2.RT_q2;

%% 1classifying words
word=RT_q2(RT_q2(:,2)==1);
irrelevantword=RT_q2(RT_q2(:,2)==2);
semiword=RT_q2(RT_q2(:,2)==3);
notword=RT_q2(RT_q2(:,2)==4);

lword=log10(word)
lirrelevantword=log10(irrelevantword)
lsemiword=log10(semiword)
lnotword=log10(notword)
 %boxplot([word, irrelevantword, semiword, notword])
 %title('response time boxplots')
 figure
 boxplot([lword, lirrelevantword, lsemiword, lnotword])
 title('log response time boxplots')
 
 %% 2anova test on data
 rt=[word, irrelevantword, semiword, notword]
groups = {'A' 'B' 'C' 'D'}
p = anova1(rt,groups)
%%f = MSG/MSE , MSG= 7.737  ,  MSE = 1.241

% p value is too small so  reject H0. so at least one couple og groups have meaningfull difference
%% 3 anova on log

lrt=[lword, lirrelevantword,lsemiword, lnotword]
lgroups = {'e' 'f' 'g' 'h' }
lp = anova1(lrt,groups)
% p value is too small so  reject H0. so at least one couple og groups have meaningfull difference

%% 4 t-test
[h_ttest_two_tail,p_ttest_two_tail] = ttest2(word,irrelevantword)
[h_ttest_one_tail,p_ttest_one_tail] = ttest2(word,irrelevantword,'Tail','left')

%%log t-test 
[h_two_tail_log_ttest,p_two_tail_log_ttest] = ttest2(lword,lirrelevantword)
[h_one_tail_log_ttest,p_one_tail_log_ttest] = ttest2(lword,lirrelevantword,'Tail','left')
