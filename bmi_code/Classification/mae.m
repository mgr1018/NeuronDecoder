% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022 

% MAE

function modelParameters = mae(test_data, modelParameters)
    if (modelParameters.dataAv)
        testVect = gaussianFilter(test_data.spikes(:,:));
        % testVect = testVect(:,1:10:end);
    else
        testVect = zeros(modelParameters.numNeurons,1);
        for n = 1:modelParameters.numNeurons
            testVect(n,1) = sum(test_data.spikes(n,:));
        end
    end

    % Compare to each training vector and find closest one
    MAE = zeros(1,8); % Mean Absolute Error (better performance than MSE)
    if (modelParameters.dataAv)
        for k = 1:8
            MAE(1,k) = mean(mean(abs(modelParameters.trainVects{k}(:, 1:320) - testVect)),2);
        end
    else
        for k = 1:8
            MAE(1,k) = mean(abs(modelParameters.trainVects{k}(:, :) - testVect)); 
        end 
    end
    
    [~, idx] = min(MAE);
    modelParameters.K = idx;
    
end


