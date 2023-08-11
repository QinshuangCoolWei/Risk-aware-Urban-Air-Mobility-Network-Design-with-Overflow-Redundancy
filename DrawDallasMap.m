close all; clear all; clc

set(0,'defaultTextInterpreter','latex');

%% Read Data
Data_Locations = readtable('Dallas2UAMNetwork.xlsx');
Data_Routes = readtable('Dallas2UAMNetworkRoutes.xlsx');

%% Plot locations
N_Locations = height(Data_Locations);
N_Routes = height(Data_Routes);

figure('Renderer', 'painters', 'Position', [1 1 620 520])

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

    geoplot([Airport1Lat Airport2Lat],[Airport1Lon Airport2Lon],'Color',[0, 0, 0, 0.3],'LineWidth', Capacity*1.5);
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
        geoplot(Latitude,Longitude,'or', 'MarkerFaceColor',[0.9, 0, 0], 'MarkerSize', Capacity*2)
    elseif strcmp(Property, 'Reserve') == 1
        geoplot(Latitude,Longitude,'hexagramb', 'MarkerFaceColor','b', 'MarkerSize', Capacity*6)
    end
    hold on
end

geobasemap topographic
geolimits([32.45 33.15],[-97.4  -96.65])
% pbaspect([1.25 1 1])
title('Dallas-Fort Worth Metropolitan Area UAM Network');
set(gca, 'FontName', 'Times', 'FontSize', 18);






