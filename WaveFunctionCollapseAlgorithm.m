function terrainGrid = WaveFunctionCollapseAlgorithm(gridSize, terrainTypes, possibleNeighbors, probabilities, startingCell, gifName)
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

    numMountainSeeds = 1;
    numWaterSeeds = 0;

    hasBeenSet = zeros(gridSize, gridSize);
    % terrainGrid(startingCell(1), startingCell(2)) = randi(length(terrainTypes));
    % terrainGrid(startingCell(1), startingCell(2)) = 6;
    % hasBeenSet(startingCell(1), startingCell(2)) = 1;
    % gridPossibilities(startingCell(1), startingCell(2),:) = fillWithZeros(terrainGrid(startingCell(1), startingCell(2)), numTerrainTypes(3));
    % gridPossibilities = updateGridPossibilities(gridPossibilities, startingCell(1), startingCell(2), gridSize, possibleNeighbors, hasBeenSet);

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

        % startingCell
        terrainGrid(startingCell(1), startingCell(2)) = 2;
        hasBeenSet(startingCell(1), startingCell(2)) = 1;
        gridPossibilities(startingCell(1), startingCell(2),:) = fillWithZeros(terrainGrid(startingCell(1), startingCell(2)), numTerrainTypes(3));
        gridPossibilities = updateGridPossibilities(gridPossibilities, startingCell(1), startingCell(2), gridSize, possibleNeighbors, hasBeenSet);
    end
    

    %Define colormap
        newColorMap = [0.6250 0.7188 0.2578
               0.1172 0.5039 0.6875
               0.7000 0.7000 0.7000
               0.9609 0.8594 0.7383 
               0.0000 0.4000 0.0000
               0.3125 0.8750 0.9961
               1.0000 1.0000 1.0000];


    % Visualize the terrain
    figure;
    colormap(newColorMap)
    imagesc(terrainGrid);
    % colorbar;
    title('Generated Terrain');
    set(gca,'XTick',[], 'YTick', [])
    hold on

    f = waitbar(0, 'Generating Terrain');
    n = ((gridSize^2)-1);

    for l = 1:1:((gridSize^2)-numWaterSeeds-numMountainSeeds)
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

        waitbar(l/n, f, sprintf('Generating Terrain: %d %%', floor(l/n*100)));
                
        if mod(l, round((gridSize^2)/10)) == 0 

        %Define colormap
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
        
        % Visualize the terrain
        % figure;
        colormap(newColorMap)
        imagesc(terrainGrid);
        % colorbar;
        % title('Generated Terrain');
        hold on
        set(gca,'XTick',[], 'YTick', [])

        % exportgraphics(gcf,gifName,'Append',true);
        end
    end

    
    close(f)
    % for i = 1:1:gridSize
    %     for j = 1:1:gridSize
    %         if i~= 1 || j ~= 1
    %             currVec = zeros(1, length(terrainTypes));
    % 
    %             for k = 1:1:length(terrainTypes)
    %                 currVec(k) = gridPossibilities(i,j,k);
    %             end
    % 
    %             % Exclude values equal to zero
    %             nonZeroCurrVec = currVec(currVec ~= 0);
    % 
    %             % Check if the vector is not empty
    %             if ~isempty(nonZeroCurrVec)
    %                 % Choose a random index from the non-zero vector
    %                 randProb = rand();
    % 
    %                 if length(nonZeroCurrVec) == 3
    %                     if randProb < probabilities(1)
    %                         randomIndex = 1;
    %                     elseif randProb < (probabilities(1) + probabilities(2))
    %                         randomIndex = 2;
    %                     else
    %                         randomIndex = 3;
    %                     end
    %                 elseif length(nonZeroCurrVec) == 2
    %                     if randProb < probabilities(1) + probabilities(3)
    %                         randomIndex = 1;
    %                     else
    %                         randomIndex = 2;
    %                     end
    %                 else
    %                     randomIndex = 1;
    %                 end
    % 
    %                 % randomIndex = randi(length(nonZeroCurrVec));
    %                 randomNumber = nonZeroCurrVec(randomIndex);
    %             else
    %                 disp("Error: Vector of zeros found")
    %             end
    % 
    %             terrainGrid(i,j) = randomNumber;
    %             hasBeenSet(i,j) = 1;
    %             gridPossibilities(i,j,:) = fillWithZeros(terrainGrid(i,j), numTerrainTypes(3));
    % 
    %             gridPossibilities = updateGridPossibilities(gridPossibilities, i, j, gridSize, possibleNeighbors, hasBeenSet);
    % 
    %         end
    %     end
    % end



    % for i = 1:1:gridSize
    %     for j = 1:1:gridSize
    %         if i~= 1 || j ~= 1
    %             currVec = zeros(1, length(terrainTypes));
    % 
    %             for k = 1:1:length(terrainTypes)
    %                 currVec(k) = gridPossibilities(i,j,k);
    %             end
    % 
    %             % Exclude values equal to zero
    %             nonZeroCurrVec = currVec(currVec ~= 0);
    % 
    %             % Check if the vector is not empty
    %             if ~isempty(nonZeroCurrVec)
    %                 % Choose a random index from the non-zero vector
    %                 randProb = rand();
    % 
    %                 if length(nonZeroCurrVec) == 3
    %                     if randProb < probabilities(1)
    %                         randomIndex = 1;
    %                     elseif randProb < (probabilities(1) + probabilities(2))
    %                         randomIndex = 2;
    %                     else
    %                         randomIndex = 3;
    %                     end
    %                 elseif length(nonZeroCurrVec) == 2
    %                     if randProb < probabilities(1) + probabilities(3)
    %                         randomIndex = 1;
    %                     else
    %                         randomIndex = 2;
    %                     end
    %                 else
    %                     randomIndex = 1;
    %                 end
    % 
    %                 % randomIndex = randi(length(nonZeroCurrVec));
    %                 randomNumber = nonZeroCurrVec(randomIndex);
    %             else
    %                 disp("Error: Vector of zeros found")
    %             end
    % 
    %             terrainGrid(i,j) = randomNumber;
    %             hasBeenSet(i,j) = 1;
    %             gridPossibilities(i,j,:) = fillWithZeros(terrainGrid(i,j), numTerrainTypes(3));
    % 
    %             gridPossibilities = updateGridPossibilities(gridPossibilities, i, j, gridSize, possibleNeighbors, hasBeenSet);
    % 
    %         end
    %     end
    % end

    
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
            updatedPossibilities(i+1, j, :) = fillWithZeros(tempVector, numTerrainTypes(3));

    end
    if j < gridSize && hasBeenSet(i, j+1) == 0
            currVec = zeros(1, numTerrainTypes(3));
            for k = 1:1:numTerrainTypes(3)
                currVec(end+1) = gridPossibilities(i,j+1,k);
            end
            tempVector = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
            updatedPossibilities(i, j+1, :) = fillWithZeros(tempVector, numTerrainTypes(3));
    end
    if i > 1 && hasBeenSet(i-1, j) == 0
            currVec = zeros(1, numTerrainTypes(3));
            for k = 1:1:numTerrainTypes(3)
                currVec(end+1) = gridPossibilities(i-1,j,k);
            end
            tempVector = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
            updatedPossibilities(i-1, j, :) = fillWithZeros(tempVector, numTerrainTypes(3));
    end
    if j > 1 && hasBeenSet(i, j-1) == 0
            currVec = zeros(1, numTerrainTypes(3));
            for k = 1:1:numTerrainTypes(3)
                currVec(end+1) = gridPossibilities(i,j-1,k);
            end
            tempVector = intersect(possibleNeighbors(gridPossibilities(i,j), :), currVec);
            updatedPossibilities(i, j-1, :) = fillWithZeros(tempVector, numTerrainTypes(3));
    end
    
end

function returnVecOfCorrectLength = fillWithZeros(inputVec, numTerrainTypes)
    returnVecOfCorrectLength = [inputVec, zeros(1, max(0, numTerrainTypes - length(inputVec)))];
end