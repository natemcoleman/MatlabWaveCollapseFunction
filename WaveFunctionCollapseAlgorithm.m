function terrainGrid = WaveFunctionCollapseAlgorithm(gridSize, terrainTypes, possibleNeighbors, probabilities, gifName, rgbColorMap, numPixelsPerSquare, numMountainSeeds, numWaterSeeds)
    % Create a 3D array
    gridPossibilities = zeros(gridSize, gridSize, length(terrainTypes));
    
    numTerrainTypes = size(gridPossibilities);

    % Fill the third dimension with a vector of numbers 1 through 5
    for i = 1:1:length(terrainTypes)
        gridPossibilities(:,:,i) = i;
    end
    
    terrainGrid = zeros(gridSize, gridSize);
    for i = 1:1:gridSize
        for j = 1:1:gridSize
            terrainGrid(i,j) = numTerrainTypes(3)+1;
        end
    end

    hasBeenSet = zeros(gridSize, gridSize);

    previousStartCellsI = [];
    previousStartCellsJ = [];
    for i = 1:1:numMountainSeeds
        startingCell = [randi(gridSize) randi(gridSize)];
        while ismember(startingCell(1), previousStartCellsI) || ismember(startingCell(2), previousStartCellsJ)
            startingCell = [randi(gridSize) randi(gridSize)];
        end
        % startingCell
        previousStartCellsI(end+1) = startingCell(1);
        previousStartCellsJ(end+1) = startingCell(2);
        terrainGrid(startingCell(1), startingCell(2)) = 6;
        hasBeenSet(startingCell(1), startingCell(2)) = 1;
        gridPossibilities(startingCell(1), startingCell(2),:) = fillWithZeros(terrainGrid(startingCell(1), startingCell(2)), numTerrainTypes(3));
        gridPossibilities = updateGridPossibilities(gridPossibilities, startingCell(1), startingCell(2), gridSize, possibleNeighbors, hasBeenSet);
    end

    for i = 1:1:numWaterSeeds
        startingCell = [randi(gridSize) randi(gridSize)];
        while ismember(startingCell(1), previousStartCellsI) || ismember(startingCell(2), previousStartCellsJ)
            startingCell = [randi(gridSize) randi(gridSize)];
        end
        previousStartCellsI(end+1) = startingCell(1);
        previousStartCellsJ(end+1) = startingCell(2);

        terrainGrid(startingCell(1), startingCell(2)) = 2;
        hasBeenSet(startingCell(1), startingCell(2)) = 1;
        gridPossibilities(startingCell(1), startingCell(2),:) = fillWithZeros(terrainGrid(startingCell(1), startingCell(2)), numTerrainTypes(3));
        gridPossibilities = updateGridPossibilities(gridPossibilities, startingCell(1), startingCell(2), gridSize, possibleNeighbors, hasBeenSet);
    end
      
    % r = zeros(gridSize*numPixelsPerSquare);
    % b = r;
    % g = r;
    % 
    % for i = 1:1:gridSize*numPixelsPerSquare
    %     for j = 1:1:gridSize*numPixelsPerSquare
    %         iVal = ceil(i/numPixelsPerSquare);
    %         jVal = ceil(j/numPixelsPerSquare);
    % 
    %         rVals = zeros(length(gridPossibilities(iVal,jVal)),1);
    %         gVals = rVals;
    %         bVals = rVals;
    % 
    %         for k = 1:1:length(gridPossibilities(iVal,jVal,:))
    %             currGridIndex = gridPossibilities(iVal,jVal, k);
    %             if currGridIndex ~= 0
    %                 rVals(k) = rgbColorMap(currGridIndex, 1);
    %                 gVals(k) = rgbColorMap(currGridIndex, 2);
    %                 bVals(k) = rgbColorMap(currGridIndex, 3);
    %             end
    %         end
    %         r(i,j) = mean(rVals);
    %         g(i,j) = mean(gVals);
    %         b(i,j) = mean(bVals);
    %     end
    % end
    % 
    % rgbImgArray = cat(3, r, g, b);
    % figure, imshow(rgbImgArray)


    % f = waitbar(0, 'Generating Terrain');
    n = ((gridSize^2)-numWaterSeeds-numMountainSeeds);

    for l = 1:1:n
        iCell = [];
        jCell = [];
        minSize = length(terrainTypes);
        for i = 1:1:gridSize
            for j = 1:1:gridSize
                currVec = zeros(1, length(terrainTypes));
                for k = 1:1:length(terrainTypes)
                    currVec(k) = gridPossibilities(i,j,k);
                end
                nonZeroCurrVec = currVec(currVec ~= 0);
                if length(nonZeroCurrVec) < minSize && hasBeenSet(i,j) == 0
                    minSize = length(nonZeroCurrVec);
                end
            end
        end
        for i = 1:1:gridSize
            for j = 1:1:gridSize
                currVec = zeros(1, length(terrainTypes));
                for k = 1:1:length(terrainTypes)
                    currVec(k) = gridPossibilities(i,j,k);
                end
                nonZeroCurrVec = currVec(currVec ~= 0);                
                if length(nonZeroCurrVec) == minSize  && hasBeenSet(i,j) == 0
                    iCell(end+1) = i;
                    jCell(end+1) = j;
                end
            end
        end
        
        nextCellIndex = randi(length(iCell));

        i = iCell(nextCellIndex);
        j = jCell(nextCellIndex);

        currVec = zeros(1, length(terrainTypes));
        for k = 1:1:length(terrainTypes)
            currVec(k) = gridPossibilities(i,j,k);
        end
        currVec;

        % Exclude values equal to zero
        nonZeroCurrVec = currVec(currVec ~= 0);

        % Check if the vector is not empty
        if ~isempty(nonZeroCurrVec)
            % Choose a random index from the non-zero vector
            randProb = rand();

            if length(nonZeroCurrVec) == 3
                if randProb < probabilities(1)
                    randomIndex = 1;
                elseif randProb < (probabilities(1) + probabilities(2))
                    randomIndex = 2;
                else
                    randomIndex = 3;
                end
            elseif length(nonZeroCurrVec) == 2
                if randProb < probabilities(1) + probabilities(3)
                    randomIndex = 1;
                else
                    randomIndex = 2;
                end
            else
                randomIndex = 1;
            end

            % randomIndex = randi(length(nonZeroCurrVec));
            randomNumber = nonZeroCurrVec(randomIndex);
        else
            % i
            % j
            % disp("Error: Vector of zeros found")
        end

        terrainGrid(i,j) = randomNumber;
        hasBeenSet(i,j) = 1;
        gridPossibilities(i,j,:) = fillWithZeros(terrainGrid(i,j), numTerrainTypes(3));

        gridPossibilities = updateGridPossibilities(gridPossibilities, i, j, gridSize, possibleNeighbors, hasBeenSet);

        % waitbar(l/n, f, sprintf('Generating Terrain: %d %%', floor(l/n*100)));
                
        % if mod(l, round((gridSize^2)/20)) == 0 
        if false
        r = zeros(gridSize*numPixelsPerSquare);
        b = r;
        g = r;

        for i = 1:1:gridSize*numPixelsPerSquare
            for j = 1:1:gridSize*numPixelsPerSquare
                iVal = ceil(i/numPixelsPerSquare);
                jVal = ceil(j/numPixelsPerSquare);

                rVals = zeros(length(gridPossibilities(iVal,jVal)),1);
                gVals = rVals;
                bVals = rVals;

                for k = 1:1:length(gridPossibilities(iVal,jVal,:))
                    currGridIndex = gridPossibilities(iVal,jVal, k);
                    if currGridIndex ~= 0
                        rVals(k) = rgbColorMap(currGridIndex, 1);
                        gVals(k) = rgbColorMap(currGridIndex, 2);
                        bVals(k) = rgbColorMap(currGridIndex, 3);
                    end
                end
                
                r(i,j) = mean(rVals);
                g(i,j) = mean(gVals);
                b(i,j) = mean(bVals);
            end
        end

        rgbImgArray = cat(3, r, g, b);
        imshow(rgbImgArray)

        exportgraphics(gcf,gifName,'Append',true);
        end
    end
    % close(f)
end

function updatedPossibilities = updateGridPossibilities(gridPossibilities, i, j, gridSize, possibleNeighbors, hasBeenSet)
    updatedPossibilities = gridPossibilities;
    numTerrainTypes = size(gridPossibilities);

    if i < gridSize && hasBeenSet(i+1, j) == 0
            currVec = zeros(1, numTerrainTypes(3));
            for k = 1:1:numTerrainTypes(3)
                currVec(end+1) = gridPossibilities(i+1,j,k);
            end
            tempVector = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
            tempVector = tempVector(tempVector ~= 0);
            updatedPossibilities(i+1, j, :) = fillWithZeros(tempVector, numTerrainTypes(3));
    end
    if j < gridSize && hasBeenSet(i, j+1) == 0
            currVec = zeros(1, numTerrainTypes(3));
            for k = 1:1:numTerrainTypes(3)
                currVec(end+1) = gridPossibilities(i,j+1,k);
            end
            tempVector = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
            tempVector = tempVector(tempVector ~= 0);
            updatedPossibilities(i, j+1, :) = fillWithZeros(tempVector, numTerrainTypes(3));
    end
    if i > 1 && hasBeenSet(i-1, j) == 0
            currVec = zeros(1, numTerrainTypes(3));
            for k = 1:1:numTerrainTypes(3)
                currVec(end+1) = gridPossibilities(i-1,j,k);
            end
            tempVector = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
            tempVector = tempVector(tempVector ~= 0);
            updatedPossibilities(i-1, j, :) = fillWithZeros(tempVector, numTerrainTypes(3));
    end
    if j > 1 && hasBeenSet(i, j-1) == 0
            currVec = zeros(1, numTerrainTypes(3));
            for k = 1:1:numTerrainTypes(3)
                currVec(end+1) = gridPossibilities(i,j-1,k);
            end
            tempVector = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
            tempVector = tempVector(tempVector ~= 0);
            updatedPossibilities(i, j-1, :) = fillWithZeros(tempVector, numTerrainTypes(3));
    end
end

function returnVecOfCorrectLength = fillWithZeros(inputVec, numTerrainTypes)
    returnVecOfCorrectLength = [inputVec, zeros(1, max(0, numTerrainTypes - length(inputVec)))];
end