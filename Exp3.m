close all; clear; clc

set(0,'defaultTextInterpreter','latex');

%% Enter City Name

City = 'Dallas'; % Choose between 'Milwaukee', 'Atlanta', Dallas'
Budget = 5:5:150;

%% Read Data

Data_Locations = readtable([City,'UAMNetwork.xlsx']);
Data_Routes = readtable([City,'UAMNetworkRoutes.xlsx']);
New_Edges = unique(table2array(readtable([City,'NewEdges.xlsx'])),"rows");


%% Experiment 3

% Computation 
N_Routes = height(Data_Routes);

Diversity_Result = zeros(N_Routes*2, length(Budget)+1);
Diversity_Result(:,1) = ones(N_Routes*2,1);

for a = 1:length(Budget)

    Budget_Current = Budget(a);

    Result = readtable([City,'_Solution_Budget_',num2str(Budget_Current),'.xlsx']);
    
    Num_Original_Nodes = length(unique(New_Edges(:,1)));
    
    Indicators = table2array(Result(:,1));
    
    Not_Selected = [];
    
    for i = 1:length(Indicators)
    
        if Indicators(i) == 1
            Not_Selected = [Not_Selected;i+Num_Original_Nodes];
        end
    
    end
    
    New_Edges_Selected = [];
    
    for i = 1:height(New_Edges)
    
        if ismember(New_Edges(i,2),Not_Selected) ~= 1
            New_Edges_Selected = [New_Edges_Selected; New_Edges(i,:)];
        end
    
    end
    
    Diversity = zeros(N_Routes,1);
    
    for i = 1:N_Routes
    
        Origin = table2array(Data_Routes(i,3));
        Destination = table2array(Data_Routes(i,5));
    
        Origin_List = New_Edges_Selected(New_Edges_Selected(:,1) == Origin,:);
        Destination_List = New_Edges_Selected(New_Edges_Selected(:,1) == Destination,:);
    
        Common_New_Nodes = intersect(Origin_List(:,2), Destination_List(:,2));
    
        Diversity(i) = length(Common_New_Nodes)+1;
    
    end
    
    Diversity_Total = [Diversity;Diversity];

    Diversity_Result(:,a+1) = Diversity_Total;

end


% Plotting
quants = quantile(Diversity_Result, [0.25,0.5,0.75]);
q1 = quants(1,:);
q2 = quants(2,:);
q3 = quants(3,:);

figure('Renderer', 'painters', 'Position', [1 1 1150 250])
h = boxplot(Diversity_Result,'Labels',[0,Budget],'colors','b','widths',0.5);
for j=1:217%length(h) 147 for MIL, 217 for ATL, 140 for DFW
   patch(get(h(j),'XData'),get(h(j),'YData'),[0.8500 0.3250 0.0980],'FaceAlpha',0.3);
end
hold on
plot(q2,'--or','LineWidth',1.5)
hold on
plot(q1,'--o','Color','b','LineWidth',1)
hold on
plot(q3,'--o','Color','b','LineWidth',1)
set(gca, 'FontName', 'Times','FontSize',14);
xlabel('Budget Level', 'FontSize',18)
ylabel('No. of Effective Paths', 'FontSize',18)
title(City, 'FontSize', 20);
% title('Dallas--Fort Worth', 'FontSize', 20);
ylim([-1, 20])
% grid on
















