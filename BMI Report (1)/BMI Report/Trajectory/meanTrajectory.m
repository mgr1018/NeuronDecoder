% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% USE MEAN TRAJECTORY FOR A GIVEN ANGEL

function [x, y] = meanTrajectory(test_data, modelParameters)

    % Predict X and Y position based on test trial time
    t = length(test_data.spikes);

    if t < 713
        x = modelParameters.meanX{modelParameters.K}(t+1);
        y = modelParameters.meanY{modelParameters.K}(t+1);    
    else
        x = modelParameters.meanX{modelParameters.K}(700);
        y = modelParameters.meanY{modelParameters.K}(700);
    end
end