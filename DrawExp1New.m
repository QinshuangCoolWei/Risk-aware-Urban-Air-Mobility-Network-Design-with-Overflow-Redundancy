close all; clear; clc

set(0,'defaultTextInterpreter','latex');

%% Read Data

Result_TP_MIL = readtable('Milwaukee_TP.xlsx');
Result_TP_ATL = readtable('Atlanta_TP.xlsx');
Result_TP_DFW = readtable('Dallas_TP.xlsx');

%%

Budget = 0:5:150;

figure('Renderer', 'painters', 'Position', [1 1 1150 275])
plot(Budget,table2array(Result_TP_MIL(:,3)),':^','LineWidth',2.5,'MarkerFaceColor', 'w')
hold on
plot(Budget,table2array(Result_TP_ATL(:,3)),':^','LineWidth',2.5,'MarkerFaceColor', 'w')
hold on
plot(Budget,table2array(Result_TP_DFW(:,3)),':^','LineWidth',2.5,'MarkerFaceColor', 'w')
legend('Milwaukee','Atlanta','Dallas-Fort Worth','Location','Northwest', 'FontSize', 16)
grid on
set(gca, 'FontName', 'Times','FontSize',14,'XTick', Budget);
xlabel('Budget Level', 'FontSize',18)
ylabel('$\bar \delta$', 'FontSize',20)
% ylabel({'Expected Network Throughput', 'Enhancement'}, 'FontSize',16.5)
% title('Total Expected Throughput vs. Budget', 'FontSize', 20);
% ylim([table2array(Result_TP(1,1))*0.995, max(table2array(Result_TP))*1.005])
% ylim([0 38])
ylim([0 0.6])