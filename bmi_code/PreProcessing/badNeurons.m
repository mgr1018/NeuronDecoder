% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022

% AVERAGE DATA OVER TRIALS: 98*1000

function [data, modelParameters] = badNeurons(data, modelParameters)
if size(data,1) == 1
    data.spikes([38,49,76,8,10,52,73],:) = [];
else 
    for i = 1:size(data,1)
        for k = 1:modelParameters.numDir
            data(i,k).spikes([38,49,76,8,10,52,73],:) = [];
        end
    end
end


modelParameters.numNeurons = 91;

end