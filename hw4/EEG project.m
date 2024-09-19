clc;
clear;
close all;
%%
load('label_P_T_I.mat')
data_name = strcat('sub11','.mat');
load(data_name);
y = y(:,25*256:end);
t = 0:(1/256):((length(y)-1)/256);
plot(t,y(5,:));
%%
event =  y(2,:);
event(event < 0.8*max(y(2,:))) = 0;
figure();
plot(t,event);
[pks,locs] = findpeaks(event);
hold on;
plot(locs/256,pks,'o');
%%
d = designfilt('bandpassfir','FilterOrder',900, ...
         'CutoffFrequency1',0.5,'CutoffFrequency2',4.5, ...
         'SampleRate',256);
%%
filterd_y = filtfilt(d,y(5:end,:)')';
figure(); plot(t,filterd_y(1,:));
%%
P300 = zeros(256,5*(62-14),8);
Irrelevant = zeros(8,256);
Target = zeros(8,256);
Probe = zeros(8,256);
lable = repmat(label_P_I_T(8:(62-7)),1,5);
t_p300 = 0:1/256:1-1/256;
ind = 1;
for ch =1:8
    for j = 1:5
        for i = 8:(62-7)
            P300(:,ind,ch) = filterd_y(ch,locs((j-1)*62+i):locs((j-1)*62+i)+255)';
            ind = ind+1;
        end
    end
    Irrelevant(ch,:) = mean(P300(:,lable==2|lable==3|lable==4|lable==5,ch),2);
    Target(ch,:) = mean(P300(:,lable==6,ch),2);
    Probe(ch,:) = mean(P300(:,lable==7,ch),2);
    ind =1;
end
%%
figure();
subplot(1,3,1);plot(t_p300,Irrelevant);
subplot(1,3,2);plot(t_p300,Target);
subplot(1,3,3);plot(t_p300,Probe);
%%

tt = {'yes','no'};
corr_Irr_Probe = zeros(8,1);
corr_Target_Probe = zeros(8,1);
for ch = 1:8
    R = corrcoef(Irrelevant(ch,:),Probe(ch,:));
    corr_Irr_Probe(ch,1) = R(2,1);
    R = corrcoef(Target(ch,:),Probe(ch,:));
    corr_Target_Probe(ch,1) = R(2,1);
    culprit(ch) = tt((corr_Irr_Probe(ch,1) > corr_Target_Probe(ch,1)) +1);
end
%%
Chanel = 1:8;
Chanel = Chanel';
mybool = corr_Irr_Probe > corr_Target_Probe;
culprit = culprit';
%%
fprintf(strcat('Resul for subject  ',data_name,':\n\n')); 
tb = table(Chanel,corr_Irr_Probe,corr_Target_Probe,culprit);
disp(tb);
%%
[mypks,mylocs] = max(P300);
for ch =1:8
    Irrelevant_pks(ch,:) = mypks(1,lable==2|lable==3|lable==4|lable==5,ch);
    Irrelevant_locs(ch,:) = mylocs(1,lable==2|lable==3|lable==4|lable==5,ch);
    Target_pks(ch,:) = mypks(1,lable==6,ch);
    Target_locs(ch,:) = mylocs(1,lable==6,ch);
    Probe_pks(ch,:) = mypks(1,lable==7,ch);
    Probe_locs(ch,:) = mylocs(1,lable==7,ch);
    [Irr_p_locs(ch),Irr_h_locs(ch)] = ranksum(Irrelevant_locs(ch,1:35),Probe_locs(ch,:));
    [Target_p_locs(ch),Target_h_locs(ch)] = ranksum(Target_locs(ch,1:35),Probe_locs(ch,:));
    culprit_locs(ch) = tt((Target_p_locs(ch)<Irr_p_locs(ch))+1);
    [Irr_p_pks(ch),Irr_h_pks(ch)] = ranksum(Irrelevant_pks(ch,1:35),Probe_pks(ch,:));
    [Target_p_pks(ch),Target_h_pks(ch)] = ranksum(Target_pks(ch,1:35),Probe_pks(ch,:));
    culprit_pks(ch) = tt((Target_p_pks(ch)<Irr_p_pks(ch))+1);
end
%
% for ch =1:8
%     Irrelevant_pks(ch,:) = mypks(1,lable==2|lable==3|lable==4|lable==5,ch);
%     Irrelevant_locs(ch,:) = mylocs(1,lable==2|lable==3|lable==4|lable==5,ch);
%     Target_pks(ch,:) = mypks(1,lable==6,ch);
%     Target_locs(ch,:) = mylocs(1,lable==6,ch);
%     Probe_pks(ch,:) = mypks(1,lable==7,ch);
%     Probe_locs(ch,:) = mylocs(1,lable==7,ch);
%     [Irr_h_locs(ch),Irr_p_locs(ch)] = ranksum(Irrelevant_locs(ch,1:35),Probe_locs(ch,:));
%     [Target_h_locs(ch),Target_p_locs(ch)] = ranksum(Target_locs(ch,1:35),Probe_locs(ch,:));
%     culprit_locs(ch) = tt((Target_p_locs(ch)<Irr_p_locs(ch))+1);
%     [Irr_h_pks(ch),Irr_p_pks(ch)] = ranksum(Irrelevant_pks(ch,1:35),Probe_pks(ch,:));
%     [Target_h_pks(ch),Target_p_pks(ch)] = ranksum(Target_pks(ch,1:35),Probe_pks(ch,:));
%     culprit_pks(ch) = tt((Target_p_pks(ch)<Irr_p_pks(ch))+1);
% end
%%
culprit_locs = culprit_locs';
culprit_pks = culprit_pks';
p_val_Irr_pks = Irr_p_pks';
p_val_Irr_locs = Irr_p_locs';
p_val_Target_pks = Target_p_pks';
p_val_Target_locs = Target_p_locs';
%%
fprintf(strcat('Resul for subject  ',data_name,':\n\n')); 
tb = table(Chanel,p_val_Irr_pks,p_val_Target_pks,culprit_pks,p_val_Irr_locs,p_val_Target_locs,culprit_locs);
disp(tb);


