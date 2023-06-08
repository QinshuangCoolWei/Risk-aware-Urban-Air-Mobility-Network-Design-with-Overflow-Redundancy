close all; clear; clc

set(0,'defaultTextInterpreter','latex');

%% Enter City Name

City = 'Dallas'; % Choose between 'Milwaukee', 'Atlanta', Dallas'
Budget = 0:5:150;

%% Read Data

Data_Locations = readtable([City,'UAMNetwork.xlsx']);
Data_Routes = readtable([City,'UAMNetworkRoutes.xlsx']);


%% Experiment 4

wgs84 = wgs84Ellipsoid("km");

Distribution = zeros(height(Data_Routes),length(Budget));

for a = 1:length(Budget)

    Budget_Current = Budget(a);
    
    if Budget_Current ~= 0

        Result = readtable([City,'_Solution_Budget_',num2str(Budget_Current),'.xlsx']);
        
        Num_Original_Nodes = height(Data_Locations(strcmp(Data_Locations.Type,'Regular'), 1));
        Indicators = table2array(Result(:,1));
        Selected = [];
        
        for i = 1:length(Indicators)
            
            if Indicators(i) ~= 1
                Selected = [Selected;i+Num_Original_Nodes];
            end
            
        end
        
        Original_Set = 1:Num_Original_Nodes;
        Complete_Set = [Original_Set';Selected];

    else

        Complete_Set = 1:height(Data_Locations(strcmp(Data_Locations.Type,'Regular'), 1));

    end
    
    Total_Results = zeros(height(Data_Routes),1);
    
    
    for ii = 1:height(Data_Routes)
    
    Origin = table2array(Data_Routes(ii,3));
    Destination = table2array(Data_Routes(ii,5));
    
    Location_Airport1 = Data_Locations(Origin,:);
    Location_Airport2 = Data_Locations(Destination,:);
    
    Airport1Lat = Location_Airport1.Latitude;
    Airport1Lon = Location_Airport1.Longitude;
    Airport2Lat = Location_Airport2.Latitude;
    Airport2Lon = Location_Airport2.Longitude;
    
    Distance = distance(Airport1Lat,Airport1Lon,Airport2Lat,Airport2Lon,wgs84);
    
    Number_of_Points = round(Distance/0.2);
    
    Results = zeros(Number_of_Points,1);
    
        for i = 1:Number_of_Points
        
            Ratio_1 = i/(Number_of_Points+1);
            Ratio_2 = 1 - i/(Number_of_Points+1);
        
            Point_Lat = Airport1Lat*Ratio_1 + Airport2Lat*Ratio_2;
            Point_Lon = Airport1Lon*Ratio_1 + Airport2Lon*Ratio_2;
        
            Sub_Results = zeros(length(Complete_Set),1);
        
            for j = 1:length(Complete_Set)
        
                Index = Complete_Set(j);
        
                Location_Airport_Sub = Data_Locations(Index,:);
        
                Airport_SubLat = Location_Airport_Sub.Latitude;
                Airport_SubLon = Location_Airport_Sub.Longitude;
        
                Sub_Results(j) = distance(Point_Lat,Point_Lon,Airport_SubLat,Airport_SubLon,wgs84);
        
            end
        
            Results(i) = min(Sub_Results);
        
        end
    
     Total_Results(ii) = max(Results);
    
    end
   
    Distribution(:,a) =  Total_Results;

    fprintf(['Budget Number ',num2str(a),' out of ',num2str(length(Budget)),' is finished.\n'])

end

writematrix(Distribution,[City,'MaxminDist.xlsx'],'WriteMode', 'replacefile');


%% Make Plots

quants = quantile(Distribution, [0.25,0.5,0.75]);
q1 = quants(1,:);
q2 = quants(2,:);
q3 = quants(3,:);

figure('Renderer', 'painters', 'Position', [1 1 1150 250])
h = boxplot(Distribution,'Labels',Budget,'colors','b','widths',0.5);
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
ylim([0, 10])
% grid on





