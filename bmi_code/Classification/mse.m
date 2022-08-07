% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022 

% MSE

function modelParameters = mse(test_data, modelParameters)
    if (modelParameters.dataAv)
        testVect = sum(gaussianFilter(test_data.spikes(:,:)),2);
        % testVect = testVect(:,1:10:end);
    else
        testVect = zeros(modelParameters.numNeurons,1);
        for n = 1:modelParameters.numNeurons
            testVect(n,1) = sum(test_data.spikes(n,:));
        end
    end

    % Compare to each training vector and find closest one
    MSE = zeros(1,8);
    if (modelParameters.dataAv)
        for k = 1:8
            MSE(1,k) = mean((sum(modelParameters.trainVects{k}(:,1:320),2) - testVect).^2);  % MSE between train and test vector
        end
    else
        for k = 1:8
            MSE(1,k) = mean((modelParameters.trainVects{k}(:,:) - testVect).^2);  % MSE between train and test vector
        end
    end 
    [~, idx] = min(MSE);
    modelParameters.K = idx;
end