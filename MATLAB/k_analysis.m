%% Analysis of coverage falts with respect to k and TAT %%
close all
clearvars
fp = fopen('../reports_v2/fsim_campaign.rpt', "r"); %%change source o folder "reports" for prev result

% FILEPATH: /c:/Users/loren/OneDrive/POLITO/TFT/Assignment/MATLAB/k_analysis.m
% BEGIN: 2f1g3h4i5j6k
resultFolderPath = '../result'; % Path to the "result" folder
filePaths = dir(fullfile(resultFolderPath, '**/fsim_campaign.rpt'));
legends = cellfun(@(path) extractAfter(path, "test1_"), {filePaths.folder}, 'UniformOutput', false);
filePaths = fullfile({filePaths.folder}, {filePaths.name});
filePaths = cellfun(@(path) extractAfter(path, "Assignment"), filePaths, 'UniformOutput', false);
filePaths = cellfun(@(path) insertBefore(path, 1, ".."), filePaths, 'UniformOutput', false);
% END: 2f1g3h4i5j6k

[k, sd, fc] = cellfun(@(file) analyze_coverage(file), filePaths,  'UniformOutput', false)
fig = figure;
ax = axes(fig);
hold on
p=cellfun(@(X, Y, legend) semilogx(X, Y, 'o-', 'DisplayName', legend), k,fc, legends)
leg=legend(p([2 4 5 3 1]), 'Interpreter','none', 'Location','southeast')
axis([0 40 35 70] )
xticks(k{1})
movelabels([2 4 6 8 10 ], "horizontal")
hold off
ax.XScale="log";
xlabel("K")
ylabel("Fault Coverage (%)")
title("Comparison between different version of the code")
title(leg, "Version:")

[covgs, idx] = cellfun(@ max, fc );
cellfun(@(name, maxfc, kind, idx) fprintf("max %s: %f at %d\n", name, maxfc, kind(idx)), legends, num2cell(covgs,5), k, num2cell(idx,5))




%%

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

