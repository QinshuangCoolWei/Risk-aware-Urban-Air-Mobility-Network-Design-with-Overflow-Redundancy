close all; clear; clc

set(0,'defaultTextInterpreter','latex');

%% Enter City Name

City = 'Dallas'; % Choose between 'Milwaukee', 'Atlanta', Dallas'
Budget_Lim = 95;

%% Read Data

Result_TP = readtable([City,'_TP.xlsx']);
Result_n = readtable([City,'_n.xlsx']);

%% Draw Experiment 1

Budget = 0:5:Budget_Lim;

figure('Renderer', 'painters', 'Position', [1 1 600 400])
plot(Budget,table2array(Result_TP),':^','LineWidth',2.5,'MarkerFaceColor', 'w')
yline(table2array(Result_TP(1,1)),'-.', 'LineWidth', 3,'Color',[0.8500, 0.3250, 0.0980])
legend('New Network','Original Network','Location','Northwest', 'FontSize', 18)
grid on
xlabel('Budget Level', 'FontSize',18)
ylabel('Total Expected Throughput', 'FontSize',18)
set(gca, 'FontName', 'Times','FontSize',15);
title([City,' Total Expected Throughput vs. Budget'], 'FontSize', 20);
% ylim([table2array(Result_TP(1,1))*0.995, max(table2array(Result_TP))*1.005])
ylim([45 47])

%% Draw Experiment 2
n_Table = table2array(Result_n)';

n_Table_New = zeros(size(n_Table,1),size(n_Table,2));
n_Table_New(:,1) = zeros(size(n_Table,1),1);

for i = 1:size(n_Table_New,2)-1
    n_Table_New(:,i+1) = n_Table(:,i+1) - n_Table(:,1);
end

quants = quantile(n_Table_New, [0.25,0.5,0.75]);
q1 = quants(1,:);
q2 = quants(2,:);
q3 = quants(3,:);

figure('Renderer', 'painters', 'Position', [1 1 1400 400])
h = boxplot(n_Table_New,'Labels',Budget,'colors','b','widths',0.5);
for j=1:140%length(h) 147 for MIL, 217 for ATL, 140 for DFW
   patch(get(h(j),'XData'),get(h(j),'YData'),[0.8500 0.3250 0.0980],'FaceAlpha',0.25);
end
hold on
plot(q2,'--or','LineWidth',2)
hold on
plot(q1,'--o','Color','b','LineWidth',1.5)
hold on
plot(q3,'--o','Color','b','LineWidth',1.5)
xlabel('Budget Level', 'FontSize',18)
ylabel('Enhancement', 'FontSize',18)
set(gca, 'FontName', 'Times','FontSize',16);
title([City,' Distribution of O-D Pair-wise $n_l$ Enhancement vs. Budget'], 'FontSize', 22);
% ylim([-0.5, max(max(n_Table_New))*1.05])
grid on




