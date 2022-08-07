
% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% USE NEAREST TRAJECTORY FOR A GIVEN ANGEL

function [x, y] = nearestTrajectory(test_data, modelParameters)

    predictedAngle = modelParameters.K;
    % Compare initial X and Y position to all trials of chosen direction
    MAETrialX = []; % Mean Absolute Error X Coordinate
    MAETrialY = []; % Mean Absolute Error Y Coordinate

    for trialNum = 1:height(modelParameters.allXtrain{predictedAngle})
        MAETrialX(1,trialNum) = mean(abs(modelParameters.allXtrain{predictedAngle}(trialNum, 1) - test_data.startHandPos(1,1)));  
        MAETrialY(1,trialNum) = mean(abs(modelParameters.allYtrain{predictedAngle}(trialNum, 1) - test_data.startHandPos(2,1)));  
    end
    [~, idxX] = min(MAETrialX);
    [~, idxY] = min(MAETrialY);

    predictedTrial = round(mean([idxX idxY])); % Closest position trial based on initial position
    
    % Predict X and Y position based on test trial time 
    t = length(test_data.spikes); % length of test data
    mX = modelParameters.allXtrain{predictedAngle}(predictedTrial,:); % get trial row X
    mY = modelParameters.allYtrain{predictedAngle}(predictedTrial,:); % get trial row Y
    mX = mX(1:find(mX,1,'last')); % find last non-zero value
    mY = mY(1:find(mY,1,'last')); % find last non-zero value
        
    if t < length(mX)%length(modelParameters.allYtrain{predictedAngle}) 
        x = modelParameters.allXtrain{predictedAngle}(predictedTrial, t);
        y = modelParameters.allYtrain{predictedAngle}(predictedTrial, t);
    else 
        x = mX(1, end); % last val
        y = mY(1, end); % last val
    end
end

     