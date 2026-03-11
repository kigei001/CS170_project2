function accuracy = NN(data, subset)     %Nearest Neighbor function
    numCorrectlyClassified = 0;

    for i = 1: size(data,1)  
        objectToClassify = data(i, subset);
        labelObjectToClassify = data(i,1);
        nearestNeighborDistance = inf;
        nearestNeighborLocation = inf;

        for k =1: size(data,1)
            if k ~=i  %not checking its instance
                distance = sqrt(sum((objectToClassify - data(k,subset)).^2));  %calculate the distance of the instance
                if distance < nearestNeighborDistance   %if the distance you just checked is closer update distance, location and label
                    nearestNeighborDistance = distance;
                    nearestNeighborLocation = k;
                    nearestNeighborLabel = data(nearestNeighborLocation, 1);
                end
            end
  
        end
        if labelObjectToClassify == nearestNeighborLabel   %if the label you just checked matches the label count +1
            numCorrectlyClassified = numCorrectlyClassified + 1;
        end
    end
   
    accuracy = (numCorrectlyClassified/size(data,1))*100;  %gives accurecy in %
end


disp('Welcome to Feature Selection Algorithm!');
file = input("Type the file's path that you want to test: ", "s");
data = load(file);
algorithm = input('Type the number of algorithm you want to run (1: Forward Selection, 2: Backward Elimination): ');

[numRow, numColumn] = size(data);
numInstances = numRow;
numFeautures = numColumn-1;

fprintf("Number of Feautures is %d and the number of instances is %d.\n", numFeautures, numInstances);

    accuracy = NN(data, numFeautures); %calling narest negighbor function with all feautures
 
fprintf("Running Nearest Feauture with all %d feautures, using 'leaving-one-out' evaluation, I get an accuracy of %.1f%%.\n", numFeautures, accuracy);




if algorithm == 1 %forward selection
    disp("Beggining search");
    currentFeauture = [];
    remainingFeautures = 2:numColumn;  %all feautures
    bestFeautures = [];
    bestAccurecy = 0;
   
    for feauture = 1:numFeautures  %for each feauture
        bestAccurecyStep = 0;
        bestFeautureStep = 0;
        
        for remainFeauture = remainingFeautures  %for each remaining feautures (1 by 1)
            tempFeautures = [currentFeauture, remainFeauture];   %set temporary array to test if adding a new feauture helps get the best accurecy
            accurecy = NN(data,tempFeautures);   %call Nearest neighbor to get accurecy
            
            fprintf("Using feauture(s) %s, accurecy is %.1f%%.\n",mat2str(tempFeautures-1), accurecy);
            if accurecy >= bestAccurecyStep      %compare the accurecy with best accurecy in that step and update accurecy and feautures
                bestAccurecyStep = accurecy;
                bestFeautureStep = remainFeauture;
            end
        end
        
        currentFeauture = [currentFeauture, bestFeautureStep];  %add currentFeauture with the feauture step
        remainingFeautures(remainingFeautures == bestFeautureStep) = [];    %delete the remaining feautures
        fprintf("Features set %s was best, accurecy is %.1f%%.\n", mat2str(currentFeauture-1), bestAccurecyStep);

        if bestAccurecyStep >= bestAccurecy   %compare and get best accurecy and feautures from overall feautures
            bestAccurecy = bestAccurecyStep; 
            bestFeautures = [bestFeautures, bestFeautureStep]; 
        end
        
        
    end
    fprintf("Finished searching!\n");
    fprintf("The best feautures subset was %s, which has an accurecy of %.1f%%!\n", mat2str(bestFeautures-1), bestAccurecy);
end


if algorithm == 2   %backward elimination
    disp("Beggining search");
    currentFeauture = 2:numColumn;  %All feautures
    bestFeautures = currentFeauture;
    bestAccurecy = NN(data,numFeautures);
   
    for feauture = 1:numFeautures-1  %Each time, remove the feauture 1 by 1
        bestAccurecyStep = 0;
        feautureRemove = 0;
        
        for remainFeauture = currentFeauture   %loop all currentFeauture
            tempFeautures = currentFeauture(currentFeauture ~=remainFeauture);
            accurecy = NN(data,tempFeautures);
            
            fprintf("Using feauture(s) %s, accurecy is %.1f%%.\n",mat2str(tempFeautures-1), accurecy);
            if accurecy >= bestAccurecyStep  
                bestAccurecyStep = accurecy;
                feautureRemove = remainFeauture;
            end
        end
        
        currentFeauture(currentFeauture == feautureRemove) = [];  %remove the feauture that gives the best accurecy
        
        fprintf("Features set %s was best, accurecy is %.1f%%.\n", mat2str(currentFeauture-1), bestAccurecyStep);

        if bestAccurecyStep >= bestAccurecy  %update accurecy with the set that has the best accurecy
            bestAccurecy = bestAccurecyStep; 
            bestFeautures = currentFeauture; 
        end
        
        if length(currentFeauture) <= 1  %stop when currentFeature has only 1 feauture
            break;
        end
        
    end
    fprintf("Finished searching!\n");
    fprintf("The best feautures subset was %s, which has an accurecy of %.1f%%!\n", mat2str(bestFeautures-1), bestAccurecy);
end
   
