%% Analysis of coverage falts with respect to k and TAT %%
close all
clear all
fp = fopen('../reports_v2/fsim_campaign.rpt', "r"); %%change source o folder "reports" for prev result
k=[];
sd=[];
fc=[];

while ~feof(fp)
    line = fgetl(fp);
    if contains(line, "K =")
        k_i =sscanf(line,"K = %f");
        k=[k k_i];
    end
    
    if contains(line, "Simulation duration")
        sd_i =sscanf(line,"Simulation duration: %ds");
        sd =[sd sd_i];
    end
    
    if contains(line, "Fault coverage")
        fc_i =sscanf(line,"Fault coverage: %f%%");
        fc=[fc fc_i];
    end
    
end
fclose(fp);

%% plot figure %%
labelmode="horizontal"; %chane accordili to th desired labebl rotation (horizontal or vertical)
figure
semilogx(k,fc,'o-')
xticks(k)
xlabel("K")
%move labels to see them better
title("Fault Coverage (%)")
ylim([0 100])
movelabels([2 4 6 8 10 27], labelmode)


figure
semilogx(k,sd,'o-')
xticks(k)
xlabel("K")
title("Fault Simulation Time (s)")
movelabels([2 4 6 8 10 27], labelmode)



function movelabels(x, mode)
xtk = xticklabels;

for i = 1:length(x)
    if strcmp(mode, "horizontal")
        xtk(x(i)) = strcat('\newline', xtk(x(i)));
    elseif strcmp(mode, "vertical")
        xtk(x(i)) = strcat(xtk(x(i)), '{       }'); %if different space is needed add it between brackets
    end
    
end
xticklabels(xtk)
if strcmp(mode, "vertical")
    xtickangle(90)
elseif strcmp(mode, "horizontal")
    xtickangle(0)
end
end

