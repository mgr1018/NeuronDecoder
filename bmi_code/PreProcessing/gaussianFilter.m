% Brain Machine Interfaces - Neural Decoder
% Author: Sergio Gosalvez
% Date : 03/2022
% TEAM Prime_Mates
% Imperial College London 2022 

% Data Pre Processing - Gaussian Filter 

function filteredSpike = gaussianFilter(spikes)
    std = 100;
    windowSize = 500;
    filteredSpike = zeros(size(spikes));
    numNeuron = size(spikes,1);
    alfa = (windowSize-1)/(2*std);
  
    for n = 1:numNeuron  
        temp = conv(spikes(n,:),gausswin(windowSize,alfa)/(std*sqrt(2*pi)));
        filteredSpike(n,:) = sqrt(temp((windowSize)/2:end-(windowSize)/2));
    end
end