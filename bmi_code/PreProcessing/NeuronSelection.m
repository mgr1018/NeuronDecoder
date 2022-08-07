% Brain Machine Interfaces - Neural Decoder
% Author: Sergio Gosalvez
% Date : 03/2022

% Data Pre Processing - Neuron Selection

clc; clear; close all;

load('monkeydata_training.mat');

% Define variables
numTrials = 100; 
numDirections = 8; 
numNeurons = 98;

rng(2013);
ix = randperm(length(trial));

%% AV Firing Rate of every neuron over time 

count = 0;
avFR = zeros(98,1000);
badNeurons = zeros(8,98);
for k = 1:8
    for i = 1:98
        count = count + 1;
        for n = 1:100
            trialLength = length(trial(n,k).spikes);
            avFR(i,1:trialLength) = avFR(i,1:trialLength) + trial(n,k).spikes(i,1:trialLength);
        end
        if (avFR(i,:) < 5) == ones(1,1000)
            badNeurons(k,i) = 1;
        end
    end
end

badNeurons = sum(badNeurons);

reallyBad = badNeurons > 1;

%% Peri-stimulus time histograms (PSTHs) 

windowSize = 20;

% Average across trials


for dir = 1:numDirections
    spikesLength = 320;
    numBins = ceil(spikesLength/windowSize);
    allSpikes = zeros(98,numBins);
    B{dir} = zeros(98,numBins);
    
    for neuronNum = 1:98
        sumSpikes = [];
        count = 1;
        while (count < spikesLength)
            if (count + windowSize > spikesLength)
                sumSpikes = [sumSpikes sum(trial(1,dir).spikes(neuronNum,count:spikesLength))];
                break;
            end 
            sumSpikes = [sumSpikes sum(trial(1,dir).spikes(neuronNum,count:count+windowSize))];
            count = count + windowSize;
        end
        allSpikes(neuronNum,:) = sumSpikes;
        B{dir}(neuronNum,:) = allSpikes(neuronNum,:) > 5;
    end   
end

%% Testing gaussian Filter 

close all;
spikeav = zeros([numDirections 100]);
for k = 1:8
    spikeavt = zeros([numTrials 100]);
    for i = 1:100
        spike = trial(i,k).spikes(90,:);
        filtered = gaussianFilter(spike);        
        half = filtered(1:10:end);
        spikeavt(i,1:length(half)) = filtered(1:10:end); 
    end
    spikeav(k,:) = sum(spikeavt,1);
    plot(spikeav(k,:));hold on;
end
 


