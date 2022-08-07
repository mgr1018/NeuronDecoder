% Brain Machine Interfaces - Neural Decoder
% TEAM Prime_Mates
% Authors: Sergio Gosalvez, Manuela Giraud,Cosima Graef, Leopold Hebert
% Imperial College London 2022 

% SVM

function modelParameters = svm(test_data, modelParameters)
    
    testVect = zeros(modelParameters.numNeurons,1);
    for neuron = 1:modelParameters.numNeurons
        testVect(neuron,1) = sum(test_data.spikes(neuron,1:320));
    end

    % (2) Predict angle class with SVM model
    predictedAngle = predict(modelParameters.svmModel,testVect');

    modelParameters.K = predictedAngle;
    
end