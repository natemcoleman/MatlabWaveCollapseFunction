%Adjust to add shallow water and sand, such that water formations mimic
%mountain and snow formations to get more lake-like features

clc
% Define terrain types
% terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow', 'Shallow Water'};
terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow'};
%Snow, Mountain, Forest, Grass, Sand, Shallow, Water

numTerrainTypes = length(terrainTypes);

gifName = 'WaveCollapse17.gif';

% possibleNeighbors = [1 5 4 0 0 0; 1 2 4 0 0 0; 3 6 5 0 0 0; 2 1 4 0 0 0; 5 3 1 0 0 0; 6 3 3 0 0 0];

possibleNeighbors = [1 5 2 0 0 0; 2 2 1 0 0 0; 3 6 5 0 0 0; 2 1 1 0 0 0; 3 5 1 0 0 0; 6 3 3 0 0 0];
probabilities = [0.6 0.2 0.2 0 0];

% possibleNeighbors = [1 5 7 0 0 0; 2 7 7 0 0 0; 3 5 6 0 0 0; 4 1 7 0 0 0; 5 1 3 0 0 0; 6 3 3 0 0 0; 7 4 2 0 0 0];
% probabilities = [0.5 0.25 0.25 0 0];
% 423332
% Define grid size
gridSize = 50; % Adjust the size as needed

startingCell = [randi(gridSize) randi(gridSize)];
% startingCell = [round(gridSize/2) round(gridSize/2)];
% startingCell = [1 1];

% newColorMap1 = [0.6250 0.7188 0.2578
%                0.1172 0.5039 0.6875
%                0.7000 0.7000 0.7000
%                0.9609 0.8594 0.7383 
%                0.0000 0.4000 0.0000
%                1.0000 1.0000 1.0000];
% newColorMap2 = [0.6250 0.7188 0.2578
%                 0.1172 0.5039 0.6875
%                 0.7000 0.7000 0.7000
%                 0.9609 0.8594 0.7383
%                 0.0000 0.4000 0.0000
%                 0.3125 0.8750 0.9961];

rgbColorMap = [0.6250 0.7188 0.2578
               0.1172 0.5039 0.6875
               0.7000 0.7000 0.7000
               0.9609 0.8594 0.7383 
               0.0000 0.4000 0.0000
               1.0000 1.0000 1.0000
               0.3125 0.8750 0.9961
               ];

tic
terrainGrid = WaveFunctionCollapseAlgorithm(gridSize, terrainTypes, possibleNeighbors, probabilities, startingCell, gifName, rgbColorMap, numPixelsPerSquare);
toc
close 
%Define colormap
% newColorMap = [0.6250 0.7188 0.2578
%                0.1172 0.5039 0.6875
%                0.7000 0.7000 0.7000
%                0.9609 0.8594 0.7383 
%                0.0000 0.4000 0.0000
%                1.0000 1.0000 1.0000];

% newColorMap = [0.6250 0.7188 0.2578
%                0.1172 0.5039 0.6875
%                0.7000 0.7000 0.7000
%                0.9609 0.8594 0.7383 
%                0.0000 0.4000 0.0000
%                0.3125 0.8750 0.9961
%                1.0000 1.0000 1.0000];

%Grass
%Water
%Mountains
%Sand
%Forest
%Snow

if ~ismember(6, terrainGrid)
    % newColorMap = [0.6250 0.7188 0.2578
    %                0.1172 0.5039 0.6875
    %                0.7000 0.7000 0.7000
    %                0.9609 0.8594 0.7383
    %                0.0000 0.4000 0.0000
    %                0.3125 0.8750 0.9961];
    newColorMap = newColorMap2;
else
    newColorMap = newColorMap1;
end

%water
%mountain
%sand
%shallow
%grass
%snow
%forest
% rgbColorMap = [0.1172 0.5039 0.6875
%                0.7000 0.7000 0.7000
%                0.9609 0.8594 0.7383 
%                0.3125 0.8750 0.9961
%                0.6250 0.7188 0.2578
%                1.0000 1.0000 1.0000
%                0.0000 0.4000 0.0000];


% terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow'};
%grass
%water

%mountain
%sand
%forest
%snow
%shallow



numPixelsPerSquare = 10;

r = zeros(gridSize*numPixelsPerSquare);
b = r;
g = r;

for i = 1:1:gridSize*numPixelsPerSquare
    for j = 1:1:gridSize*numPixelsPerSquare
        iVal = ceil(i/numPixelsPerSquare);
        jVal = ceil(j/numPixelsPerSquare);

        rVals = zeros(length(terrainGrid(iVal,jVal)),1);
        gVals = rVals;
        bVals = rVals;

        for k = 1:1:length(terrainGrid(iVal,jVal))
            rVals(k) = rgbColorMap(terrainGrid(iVal,jVal), 1);
            gVals(k) = rgbColorMap(terrainGrid(iVal,jVal), 2);
            bVals(k) = rgbColorMap(terrainGrid(iVal,jVal), 3);
        end
        r(i,j) = mean(rVals);
        g(i,j) = mean(gVals);
        b(i,j) = mean(bVals);
    end
end

rgbImgArray = cat(3, r, g, b);
figure, imshow(rgbImgArray)

% Visualize the terrain
% figure;
% colormap(newColorMap)
% imagesc(terrainGrid);
% title('Generated Terrain');
% set(gca,'XTick',[], 'YTick', [])


for y = 1:1:10
        exportgraphics(gcf,gifName,'Append',true);
end
