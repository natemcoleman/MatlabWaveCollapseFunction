clc
clear all
% function [updatedPossibilities, updatedPossibilitiesPerCell] = updateGridPossibilities(gridPossibilities, i, j, gridSize, possibleNeighbors, hasBeenSet, possibilitiesPerCell)
gridSize = 2;
terrainTypes = {'Grass', 'Water', 'Mountains', 'Sand', 'Forest', 'Snow', 'Shallow Water'};
possibleNeighbors = [1 5 4 0 0 0;
    2 2 7 0 0 0;
    3 5 6 0 0 0;
    2 1 2 0 0 0;
    5 1 3 0 0 0;
    6 3 3 0 0 0;
    4 7 1 0 0 0];
% probabilities = [0.5 0.25 0.25 0 0];
probabilities = [0.5 0.25 0.25 0 0;
    0.5 0.25 0.25 0 0;
    0.5 0.25 0.25 0 0;
    0.5 0.25 0.25 0 0;
    0.5 0.25 0.25 0 0;
    0.5 0.25 0.25 0 0;
    0.5 0.25 0.25 0 0];

gridPossibilities = zeros(gridSize, gridSize, length(terrainTypes));

probabilitiesToChange = probabilities;


% Fill the third dimension with a vector of numbers 1 through 5
for i = 1:1:length(terrainTypes)
    gridPossibilities(:,:,i) = i;
end

i = 1;
j = 1;

gridPossibilities(i,j) = 1;

hasBeenSet = 0;
updatedPossibilities = gridPossibilities;
numTerrainTypes = size(gridPossibilities);
updatedPossibilitiesPerCell = probabilities

currVec = zeros(1, numTerrainTypes(3));
currProbVec = currVec;
for k = 1:1:numTerrainTypes(3)
    currVec(end+1) = gridPossibilities(i+1,j,k);
end
currVec

for k = 1:1:length(currVec)
    % updatedPossibilitiesPerCell(gridPossibilities(i,j), :)
    if currVec(k) ~= 0
        gridPossibilities(i,j)
        possibleNeighbors(gridPossibilities(i,j),:)
        currVec(k)
        % possibleNeighbors(currVec(k))
        % for y = 1:1:length(possibleNeighbors(currVec(k)))
        % foundIndicies = find(possibleNeighbors(gridPossibilities(i,j)) == currVec(k));
        foundIndicies = find(possibleNeighbors(gridPossibilities(i,j),:) == currVec(k));
        % end
        % gridPossibilities(i,j)
        foundIndicies
        probabilities(gridPossibilities(i,j), foundIndicies)
        % size(currProbVec)
        % size(fillWithZeros(possibilitiesPerCell(gridPossibilities(i,j), foundIndicies), numTerrainTypes(3)))
        % currProbVec
        currProbVec(end+1) = probabilities(gridPossibilities(i,j), foundIndicies);



        % currProbVec(end+1) = possibilitiesPerCell(gridPossibilities(i,j), foundIndicies);
    end
end
fillWithZeros(probabilities(gridPossibilities(i,j), foundIndicies), numTerrainTypes(3))

% currProbVec(end+1,:) = fillWithZeros(probabilities(gridPossibilities(i,j), foundIndicies), numTerrainTypes(3));
gridPossibilities(i,j)
currVec
currProbVec

[tempVector, iTemp, jTemp] = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
tempProbVec = updatedPossibilities(iTemp,jTemp);
tempProbVec = tempProbVec(tempVector~=0);
tempVector = tempVector(tempVector ~= 0);
updatedPossibilities(i+1, j, :) = fillWithZeros(tempVector, numTerrainTypes(3));
updatedPossibilitiesPerCell(i+1, j,:) = fillWithZeros(tempProbVec, numTerrainTypes(3));


function returnVecOfCorrectLength = fillWithZeros(inputVec, numTerrainTypes)
returnVecOfCorrectLength = [inputVec, zeros(1, max(0, numTerrainTypes - length(inputVec)))];
end