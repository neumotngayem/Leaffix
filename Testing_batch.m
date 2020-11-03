%save('plantTestingData.mat', 'plantTestingData');
load plantTestingData;
load detector;

imgDatastore = imageDatastore(plantTestingData.imageFilename);
boxLabelDatastore = boxLabelDatastore(plantTestingData(:,2:end));

testData = combine(imgDatastore, boxLabelDatastore);

inputSize = [224 224 3];
numClasses = 4;
preprocessedTestData = transform(testData,@(data)preprocessData(data,inputSize));
detectionResults = detect(detector, preprocessedTestData);
[ap,recall,precision] = evaluateDetectionPrecision(detectionResults, preprocessedTestData);
figure
hold on 
subplot(2,2,1)
plot(recall{1,:},precision{1,:})
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('AP:healthy = %.2f',ap(1)))
subplot(2,2,2)
plot(recall{2,:},precision{2,:})
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('AP:multiple diesease = %.2f',ap(2)))
subplot(2,2,3)
plot(recall{3,:},precision{3,:})
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('AP:rust = %.2f',ap(3)))
subplot(2,2,4)
plot(recall{4,:},precision{4,:})
xlabel('Recall')
ylabel('Precision')
grid on
title(sprintf('AP:scrab = %.2f',ap(4)))
hold off 
