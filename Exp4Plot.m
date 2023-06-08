close all; clear; clc

set(0,'defaultTextInterpreter','latex');

%% Read Data

City = 'Dallas';
Budget = 0:5:150;

Result = table2array(readtable([City,'MaxminDist.xlsx']));

%% Make plot

quants = quantile(Result, [0.25,0.5,0.75]);
q1 = quants(1,:);
q2 = quants(2,:);
q3 = quants(3,:);

figure('Renderer', 'painters', 'Position', [1 1 1150 250])
h = boxplot(Result,'Labels',Budget,'colors','b','widths',0.5);
for j=1:217%length(h) 147 for MIL, 217 for ATL, 140 for DFW
   patch(get(h(j),'XData'),get(h(j),'YData'),[0.9290 0.6940 0.1250],'FaceAlpha',0.3);
end
hold on
plot(q2,'--or','LineWidth',1.5)
hold on
plot(q1,'--o','Color','b','LineWidth',1)
hold on
plot(q3,'--o','Color','b','LineWidth',1)
set(gca, 'FontName', 'Times','FontSize',14);
xlabel('Budget Level', 'FontSize',18)
ylabel('Max. Landing Distance', 'FontSize',18)
% title(City, 'FontSize', 20);
title('Dallas--Fort Worth', 'FontSize', 20);
ylim([0, 17])
% grid on


