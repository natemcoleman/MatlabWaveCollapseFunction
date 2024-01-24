clc
tic

% Define terrain types
terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow', 'Shallow Water'};
% possibleNeighbors = [1 5 4 0 0 0; 2 7 7 0 0 0; 3 5 6 0 0 0; 4 1 7 0 0 0; 5 1 3 0 0 0; 6 3 3 0 0 0; 7 4 2 0 0 0];
possibleNeighbors = [1 5 4 0 0 0; 2 7 4 0 0 0; 3 5 6 0 0 0; 2 1 2 0 0 0; 5 1 3 0 0 0; 6 3 3 0 0 0; 4 7 2 0 0 0]; %This one creates very good mountains and rivers at 50-100 x 10-5
probabilities = [0.5 0.25 0.25 0 0];

% terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow'};
% possibleNeighbors = [1 5 2 0 0 0; 2 2 1 0 0 0; 3 6 5 0 0 0; 2 1 1 0 0 0; 3 5 1 0 0 0; 6 3 3 0 0 0];
% probabilities = [0.6 0.2 0.2 0 0];
% possibleNeighbors = [1 5 4 0 0 0; 1 2 4 0 0 0; 3 6 5 0 0 0; 2 1 4 0 0 0; 5 3 1 0 0 0; 6 3 3 0 0 0];

gifName = 'WaveCollapse26.gif';
createGIF = false;
plottingFrequency = 25;

numRuns = 1;

useRandomSeeds = true;
maxPossibleRandomSeeds = 10;
numMountainSeeds = 3;
numWaterSeeds = 8;

% Define grid size
gridSize = 100; % Adjust the size as needed

numPixelsPerSquare = round(720/gridSize); %720p

% 0.6250 0.7188 0.2578 Grass
% 0.1172 0.5039 0.6875 Water
% 0.7000 0.7000 0.7000 Mountains
% 0.9609 0.8594 0.7383 Sand
% 0.0000 0.4000 0.0000 Forest
% 1.0000 1.0000 1.0000 Snow
% 0.3125 0.8750 0.9961 Shallow Water
% 0.2941 0.1765 0.0431 Dark Brown
% 0.4980 0.2745 0.1059 Medium Brown

rgbColorMap = [0.6250 0.7188 0.2578
               0.1172 0.5039 0.6875
               0.7000 0.7000 0.7000
               0.4980 0.2745 0.1059 
               0.0000 0.4000 0.0000
               1.0000 1.0000 1.0000
               0.3125 0.8750 0.9961
               ];

numTerrainTypes = length(terrainTypes);

for numIterationsInGIF = 1:1:numRuns
    if useRandomSeeds
        numMountainSeeds = randi(maxPossibleRandomSeeds);
        numWaterSeeds = randi(maxPossibleRandomSeeds);
    end

terrainGrid = WaveFunctionCollapseAlgorithm(gridSize, terrainTypes, possibleNeighbors, probabilities, gifName, rgbColorMap, numPixelsPerSquare, numMountainSeeds, numWaterSeeds, createGIF, plottingFrequency);
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
toc
