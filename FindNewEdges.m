close all; clear; clc

%% Select City
City = 'Atlanta';

%% Import Data
Nodes = readtable([City,'UAMNetwork.xlsx']);
Edges = readtable([City,'UAMNetworkRoutes.xlsx']);

%% Find Alternative Routes
L_Bound = 1.02;
U_Bound = 1.5;

wgs84 = wgs84Ellipsoid("km");

N_Routes = height(Edges);

Regular_Nodes = Nodes(strcmp(Nodes.Type, 'Regular'),:);
Reserve_Nodes = Nodes(strcmp(Nodes.Type, 'Reserve'),:);
N_Points = height(Reserve_Nodes);

Results = [];

for i = 1:N_Routes

    Node_1 = Edges.VNumber1(i);
    Node_2 = Edges.VNumber2(i);

    Node_1_Lat = Nodes(Nodes.Number == Node_1,:).Latitude;
    Node_1_Lon = Nodes(Nodes.Number == Node_1,:).Longitude;
    Node_2_Lat = Nodes(Nodes.Number == Node_2,:).Latitude;
    Node_2_Lon = Nodes(Nodes.Number == Node_2,:).Longitude;

    Dist_Ori = distance(Node_1_Lat,Node_1_Lon,Node_2_Lat,Node_2_Lon,wgs84);

    for j = 1:N_Points

        Point_Number = Reserve_Nodes(j,:).Number;
        Point_Lat = Reserve_Nodes(j,:).Latitude;
        Point_Lon = Reserve_Nodes(j,:).Longitude;

        Total_Dist = distance(Node_1_Lat,Node_1_Lon,Point_Lat,Point_Lon,wgs84)+...
            distance(Node_2_Lat,Node_2_Lon,Point_Lat,Point_Lon,wgs84);

        Ratio = Total_Dist/Dist_Ori;
%         disp(Ratio)

        if Ratio > L_Bound && Ratio < U_Bound

            Results = [Results;[Node_1,Point_Number];[Node_2,Point_Number]];

        end

    end


end

%% Save File
writematrix(Results,[City,'NewEdges.xlsx'],'WriteMode', 'replacefile');







