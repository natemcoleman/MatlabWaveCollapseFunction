%Adjust to add shallow water and sand, such that water formations mimic
%mountain and snow formations to get more lake-like features

% clc
% Define terrain types
% terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow', 'Shallow Water'};
terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow'};
%Snow, Mountain, Forest, Grass, Sand, Shallow, Water

numTerrainTypes = length(terrainTypes);

gifName = 'WaveCollapse10.gif';

% possibleNeighbors = [1 5 4 0 0 0; 1 2 4 0 0 0; 3 6 5 0 0 0; 2 1 4 0 0 0; 5 3 1 0 0 0; 6 3 3 0 0 0];

possibleNeighbors = [1 5 2 0 0 0; 2 2 1 0 0 0; 3 6 5 0 0 0; 2 1 1 0 0 0; 3 5 1 0 0 0; 6 3 3 0 0 0];
probabilities = [0.6 0.2 0.2 0 0];

% possibleNeighbors = [1 5 7 0 0 0; 2 7 7 0 0 0; 3 5 6 0 0 0; 4 1 7 0 0 0; 5 1 3 0 0 0; 6 3 3 0 0 0; 7 4 2 0 0 0];
% probabilities = [0.5 0.25 0.25 0 0];
% 423332
% Define grid size
gridSize = 2; % Adjust the size as needed

startingCell = [randi(gridSize) randi(gridSize)];
% startingCell = [round(gridSize/2) round(gridSize/2)];
% startingCell = [1 1];

tic
terrainGrid = WaveFunctionCollapseAlgorithm(gridSize, terrainTypes, possibleNeighbors, probabilities, startingCell, gifName);
toc
close 
%Define colormap
% newColorMap = [0.6250 0.7188 0.2578
%                0.1172 0.5039 0.6875
%                0.7000 0.7000 0.7000
%                0.9609 0.8594 0.7383 
%                0.0000 0.4000 0.0000
%                1.0000 1.0000 1.0000];
newColorMap = [0.6250 0.7188 0.2578
               0.1172 0.5039 0.6875
               0.7000 0.7000 0.7000
               0.9609 0.8594 0.7383 
               0.0000 0.4000 0.0000
               0.3125 0.8750 0.9961
               1.0000 1.0000 1.0000];

%Grass
%Water
%Mountains
%Sand
%Forest
%Snow

if ~ismember(6, terrainGrid)
    newColorMap = [0.6250 0.7188 0.2578
                   0.1172 0.5039 0.6875
                   0.7000 0.7000 0.7000
                   0.9609 0.8594 0.7383
                   0.0000 0.4000 0.0000
                   0.3125 0.8750 0.9961];
end

terrainGrid
r = terrainGrid.*0;
b = r;
g = r;

for i = 1:1:gridSize
    for j = 1:1:gridSize
        rVals = zeros(length(terrainGrid(i,j)),1);
        for k = 1:1:length(terrainGrid(i,j))
            
        end
        r(i,j) =
end

% Visualize the terrain
figure;
colormap(newColorMap)
imagesc(terrainGrid);
% colorbar;
title('Generated Terrain');
set(gca,'XTick',[], 'YTick', [])


% for y = 1:1:10
%         exportgraphics(gcf,gifName,'Append',true);
% end
