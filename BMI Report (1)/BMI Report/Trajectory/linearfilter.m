function [x, y] = linearfilter(test_data, modelParameters)

    
        predictedAngle = modelParameters.K;
        maxneuron = modelParameters.maxneurons(predictedAngle);
        
        if length(test_data.spikes(maxneuron,:))>600
                tt = 600;
        else
            tt = size(test_data.spikes,2);
        end
        x = modelParameters.cx(tt,1,predictedAngle)' + modelParameters.cx(tt,2,predictedAngle)'.*smoothdata(test_data.spikes(maxneuron,tt));
        y= modelParameters.cy(tt,1,predictedAngle)' + modelParameters.cy(tt,2,predictedAngle)'.*smoothdata(test_data.spikes(maxneuron,tt));

%           x = filter(modelParameters.cx(tt,2,predictedAngle)',- modelParameters.cx(tt,1,predictedAngle)',smoothdata(test_data.spikes(maxneuron,tt)));
%           y = filter(modelParameters.cy(tt,2,predictedAngle)',-modelParameters.cy(tt,1,predictedAngle)',smoothdata(test_data.spikes(maxneuron,tt)));

end
