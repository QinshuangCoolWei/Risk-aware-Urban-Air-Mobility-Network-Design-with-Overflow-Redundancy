close all; clear; clc

set(0,'defaultTextInterpreter','latex');

%% Enter City Name
City_arr = {'Milwaukee','Atlanta','Dallas'};
Budget_Lim_arr = [150,150,150];
City_code = 1;
City = City_arr{City_code}; % Choose between 'Milwaukee', 'Atlanta', Dallas'
Budget_Lim = Budget_Lim_arr(City_code);

%% Read Data

Result_TP = readtable([City,'_TP.xlsx']);
Result_n = readtable([City,'_n.xlsx']);

Data_Routes = readtable([City,'UAMNetworkRoutes.xlsx']);
New_Edges = readtable([City,'NewEdges.xlsx']);
Data_Locations = readtable([City,'UAMNetwork.xlsx']);
% Original Network: Nodes and Edges
Node = table2array(Data_Locations(strcmp(Data_Locations.Type,'Regular'), 1));
Edge = table2array(Data_Routes(:,1));
N_V = length(Node);
N_E = length(Edge)*2;

%% Draw Experiment 1

Budget = 0:5:Budget_Lim;

figure('Renderer', 'painters', 'Position', [1 1 600 400])
plot(Budget,table2array(Result_TP),':^','LineWidth',2.5,'MarkerFaceColor', 'w')
yline(table2array(Result_TP(1,1)),'-.', 'LineWidth', 3,'Color',[0.8500, 0.3250, 0.0980])
legend('New Network','Original Network','Location','Northwest', 'FontSize', 18)
grid on
xlabel('Budget Level', 'FontSize',18)
ylabel('Expected Throughput', 'FontSize',18)
set(gca, 'FontName', 'Times','FontSize',15);
title([City,' Expected Throughput vs. Budget'], 'FontSize', 20);
ylim([table2array(Result_TP(1,1))*0.995, max(table2array(Result_TP(:,1)))*1.005])

%% Draw Experiment 1.1

Budget = 0:5:Budget_Lim;

figure('Renderer', 'painters', 'Position', [1 1 600 400])
plot(Budget,table2array(Result_TP)*(N_V+N_E),':^','LineWidth',2.5,'MarkerFaceColor', 'w')
% yline(table2array(Result_TP(1,1))*(N_V+N_E),'-.', 'LineWidth', 3,'Color',[0.8500, 0.3250, 0.0980])
% legend('New Network','Original Network','Location','Northwest', 'FontSize', 18)
grid on
xlabel('Budget Level', 'FontSize',18)
ylabel('Sum of Expected Throughput', 'FontSize',18)
set(gca, 'FontName', 'Times','FontSize',15);
title([City,' Sum of Expected Throughput vs. Budget'], 'FontSize', 20);
ylim([table2array(Result_TP(1,1))*0.995*(N_V+N_E), max(table2array(Result_TP(:,1)))*1.005*(N_V+N_E)])


%% Draw Experiment 2
% n_Table = table2array(Result_n)';
% 
% n_Table_New = zeros(size(n_Table,1),size(n_Table,2));
% n_Table_New(:,1) = zeros(size(n_Table,1),1);
% 
% for i = 1:size(n_Table_New,2)-1
%     n_Table_New(:,i+1) = n_Table(:,i+1) - n_Table(:,1);
% end
% 
% quants = quantile(n_Table_New, [0.25,0.5,0.75]);
% q1 = quants(1,:);
% q2 = quants(2,:);
% q3 = quants(3,:);
% 
% figure('Renderer', 'painters', 'Position', [1 1 1400 400])
% h = boxplot(n_Table_New,'Labels',Budget,'colors','b','widths',0.5);
% for j=1:217%length(h) 147 for MIL, 217 for ATL
%    patch(get(h(j),'XData'),get(h(j),'YData'),[0.8500 0.3250 0.0980],'FaceAlpha',0.25);
% end
% hold on
% plot(q2,'--or','LineWidth',2)
% hold on
% plot(q1,'--o','Color','b','LineWidth',1.5)
% hold on
% plot(q3,'--o','Color','b','LineWidth',1.5)
% xlabel('Budget Level', 'FontSize',18)
% ylabel('Enhancement', 'FontSize',18)
% set(gca, 'FontName', 'Times','FontSize',16);
% title([City,' Distribution of O-D Pair-wise $n_l$ Enhancement vs. Budget'], 'FontSize', 22);
% % ylim([-0.5, max(max(n_Table_New))*1.05])
% grid on


%% Draw Experiment 2.1
% n_Table = table2array(Result_n)';
% 
% n_Table_New = zeros(size(n_Table,1),size(n_Table,2));
% n_Table_New(:,1) = zeros(size(n_Table,1),1);
% 
% for i = 1:size(n_Table_New,2)-1
%     n_Table_New(:,i+1) = n_Table(:,i+1) - n_Table(:,1);
% end
% 
% % quants = quantile(n_Table_New, [0.25,0.5,0.75]);
% % q1 = quants(1,:);
% % q2 = quants(2,:);
% % q3 = quants(3,:);
% 
% figure('Renderer', 'painters', 'Position', [1 1 1400 400])
% n_larger = zeros(size(n_Table,2),1);
% n_larger(1) = 0;
% n_smaller = zeros(size(n_Table,2),1);
% n_smaller(1) = 0;
% for k = 1:size(n_Table,2)-1
%     n_larger(k+1) = sum(n_Table(:,1)<n_Table(:,k+1));
%     n_smaller(k+1) = sum(n_Table(:,1)>n_Table(:,k+1));
% end
% plot(Budget,n_larger,':^','LineWidth',2.5,'MarkerFaceColor', 'w')
% hold on
% plot(Budget,n_smaller,'-^','LineWidth',2.5,'MarkerFaceColor', 'b')
% 
% xlabel('Budget Level', 'FontSize',18)
% ylabel('Enhanced Pairs', 'FontSize',18)
% set(gca, 'FontName', 'Times','FontSize',16);
% title([City,' Distribution of Number of Enhanced O-D Pair $n_l$ vs. Budget'], 'FontSize', 22);
% % ylim([-0.5, max(max(n_Table_New))*1.05])
% grid on







