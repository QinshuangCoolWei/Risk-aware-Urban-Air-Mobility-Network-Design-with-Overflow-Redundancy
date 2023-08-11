close all; clear; clc

set(0,'defaultTextInterpreter','latex');

%% Enter City Name

City = 'Dallas'; % Choose between 'Milwaukee', 'Atlanta', 'Dallas'
Budget = 50;

%% Read Data

Data_Locations = readtable([City,'UAMNetwork.xlsx']);
Data_Routes = readtable([City,'UAMNetworkRoutes.xlsx']);

Regular = table2array(Data_Locations(strcmp(Data_Locations.Type,'Regular'), 1));
Reserve = table2array(Data_Locations(strcmp(Data_Locations.Type,'Reserve'), 1));

%% Plot locations

N_Locations = height(Data_Locations);
N_Routes = height(Data_Routes);

figure('Renderer', 'painters', 'Position', [1 1 450 400])

for i = 1:N_Routes

    Sub_Table = Data_Routes(i,:);

    Airport1 = Sub_Table.Vertiport1;
    Airport2 = Sub_Table.Vertiport2;
    Capacity = Sub_Table.Capacity;

    Location_Airport1 = Data_Locations(strcmp(Data_Locations.Name, Airport1),:);
    Location_Airport2 = Data_Locations(strcmp(Data_Locations.Name, Airport2),:);

    Airport1Lat = Location_Airport1.Latitude;
    Airport1Lon = Location_Airport1.Longitude;
    Airport2Lat = Location_Airport2.Latitude;
    Airport2Lon = Location_Airport2.Longitude;

    geoplot([Airport1Lat Airport2Lat],[Airport1Lon Airport2Lon],'Color',[0, 0, 0, 0.35],'LineWidth', Capacity*2);
    % [0.725 0.3 0.754]
    hold on

end

for i = 1:N_Locations

    Sub_Table = Data_Locations(i,:);

    Property = Sub_Table.Type;
    Latitude = Sub_Table.Latitude;
    Longitude = Sub_Table.Longitude;
    Capacity = Sub_Table.Capacity;

    if strcmp(Property, 'Regular') == 1
        geoplot(Latitude,Longitude,'or', 'MarkerFaceColor',[0.9, 0, 0], 'MarkerSize', Capacity*2.5)
    end
    hold on

end

geobasemap topographic
if strcmp(City, 'Milwaukee')
    geolimits([42.86 43.22],[-88.04 -87.95]);
elseif strcmp(City, 'Atlanta')
    geolimits([33.61 34.08],[-84.34 -84.32]);
elseif strcmp(City, 'Dallas')
    geolimits([32.55 33.05],[-97.5 -96.57]);
end
% pbaspect([1.25 1 1])
set(gca, 'FontName', 'Times', 'FontSize', 8);
% title(['Budget = ', num2str(Budget),', $n_r$ = ', num2str(height(Result(:,1))-sum(table2array(Result(:,1))))], 'FontSize', 23);
% title('Network with Reserve Capacity', 'FontSize', 23);
title('Original Network', 'FontSize', 23);
% title('Dallas -- Fort Worth', 'FontSize', 23);
% title('Original Network with Candidates', 'FontSize', 23);






