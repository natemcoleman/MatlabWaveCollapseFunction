clc

% Define terrain types
terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow', 'Shallow Water'};
% possibleNeighbors = [1 5 4 0 0 0; 2 7 7 0 0 0; 3 5 6 0 0 0; 4 1 7 0 0 0; 5 1 3 0 0 0; 6 3 3 0 0 0; 7 4 2 0 0 0];
possibleNeighbors = [1 5 4 0 0 0; 2 7 4 0 0 0; 3 5 6 0 0 0; 2 1 2 0 0 0; 5 1 3 0 0 0; 6 3 3 0 0 0; 4 7 2 0 0 0];
probabilities = [0.5 0.25 0.25 0 0];

% terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow'};
% possibleNeighbors = [1 5 2 0 0 0; 2 2 1 0 0 0; 3 6 5 0 0 0; 2 1 1 0 0 0; 3 5 1 0 0 0; 6 3 3 0 0 0];
% probabilities = [0.6 0.2 0.2 0 0];
% possibleNeighbors = [1 5 4 0 0 0; 1 2 4 0 0 0; 3 6 5 0 0 0; 2 1 4 0 0 0; 5 3 1 0 0 0; 6 3 3 0 0 0];

gifName = 'WaveCollapse25.gif';
createGIF = true;
plottingFrequency = 20;

% Define grid size
gridSize = 100; % Adjust the size as needed

numPixelsPerSquare = 5;

rgbColorMap = [0.6250 0.7188 0.2578
               0.1172 0.5039 0.6875
               0.7000 0.7000 0.7000
               0.9609 0.8594 0.7383 
               0.0000 0.4000 0.0000
               1.0000 1.0000 1.0000
               0.3125 0.8750 0.9961
               ];

numTerrainTypes = length(terrainTypes);

for numIterationsInGIF = 1:1:5
% numMountainSeeds = 3;
% numWaterSeeds = 8;
numMountainSeeds = randi(8);
numWaterSeeds = randi(8);

% tic
terrainGrid = WaveFunctionCollapseAlgorithm(gridSize, terrainTypes, possibleNeighbors, probabilities, gifName, rgbColorMap, numPixelsPerSquare, numMountainSeeds, numWaterSeeds, createGIF, plottingFrequency);
% toc
close 

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


for y = 1:1:10
        exportgraphics(gcf,gifName,'Append',true);
end
end