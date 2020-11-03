%save('plantTrainingData.mat', 'plantTrainingData');
load plantTrainingData;
% Shuffle training data
rng(0);
shuffleIdx = randperm(height(plantTrainingData));
trainingData = plantTrainingData(shuffleIdx, :);
% Store images in Image Datastore
imgDatastore = imageDatastore(trainingData.imageFilename);
% Store labels in Box Label Datastore
% For error case
sizeData = size(trainingData);
labels = table;
for idx=1 : sizeData
    labelHealthy = trainingData(idx,2).healthy{1};
    if ~isempty(labelHealthy)
        if ismember(-1, [labelHealthy.Position])
            disp(trainingData(idx,1));
        end          
        newCell = cell(1,1);
        positions = [labelHealthy.Position];
        positions = reshape(positions,[],4);
        sizePosition = size(positions);
        newCell(1,1) = mat2cell(positions, sizePosition(1));
        labelHealthy = newCell;  
    end
    labelMultiple = trainingData(idx,2:end).multiple_diseases{1};
    if ~isempty(labelMultiple)
        if ismember(-1, [labelMultiple.Position])
            disp(trainingData(idx,1));
        end           
        newCell = cell(1,1);
        positions = [labelMultiple.Position];
        positions = reshape(positions,[],4);
        sizePosition = size(positions);
        newCell(1,1) = mat2cell(positions, sizePosition(1));
        labelMultiple = newCell;  
    end
    labelRust = trainingData(idx,2:end).rust{1};
    if ~isempty(labelRust)
        if ismember(-1, [labelRust.Position])
            disp(trainingData(idx,1));
        end       
        newCell = cell(1,1);
        positions = [labelRust.Position];
        positions = reshape(positions,[],4);
        sizePosition = size(positions);
        newCell(1,1) = mat2cell(positions, sizePosition(1));
        labelRust = newCell;    
    end
    labelScab = trainingData(idx,2:end).scab{1};
    if ~isempty(labelScab)
        if ismember(-1, [labelScab.Position])
            disp(trainingData(idx,1));
        end
        newCell = cell(1,1);
        positions = [labelScab.Position];
        positions = reshape(positions,[],4);
        sizePosition = size(positions);
        newCell(1,1) = mat2cell(positions, sizePosition(1));
        labelScab = newCell;    
    end
    label = {labelHealthy, labelMultiple, labelRust, labelScab};
    labels = [labels; label];
end
labels.Properties.VariableNames = ["healthy", "multiple_diseases", "rust", "scab"];
boxLabelDatastore = boxLabelDatastore(labels);
% For no error case
%boxLabelDatastore = boxLabelDatastore(trainingData(:,2:end));
% Combine 2 datastore
ds = combine(imgDatastore, boxLabelDatastore);
% Create YOLOv2 Object Detection Network
inputSize = [224 224 3];
numClasses = 4;
augmentTrainingData = transform(ds, @augmentData);
trainingDataForEstimation = transform(augmentTrainingData,@(data)preprocessData(data,inputSize));
numAnchors = 7;
[anchorBoxes, meanIoU] = estimateAnchorBoxes(trainingDataForEstimation, numAnchors);
featureExtraction = resnet50;
featureLayer = 'activation_40_relu';
lgraph = yolov2Layers(inputSize, numClasses, anchorBoxes, featureExtraction, featureLayer);
% Training
options = trainingOptions('sgdm',...
          'InitialLearnRate',0.001,...
          'Verbose',true,...
          'MiniBatchSize',20,...
          'MaxEpochs',30,...
          'Shuffle','never',...
          'VerboseFrequency',10,...
          'CheckpointPath',tempdir);
 
[detector, info] = trainYOLOv2ObjectDetector(trainingDataForEstimation, lgraph, options);
save('detector.mat', 'detector');
save('info.mat', 'info');

