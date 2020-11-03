function augmentData = augmentData(orgData)
augmentData = cell(size(orgData));
orgImg = orgData{1};
sz = size(orgImg);
if numel(sz)==3 && sz(3) == 3
    % Contrast and brightness adjustment
    orgImg = jitterColorHSV(orgImg,...
        'Contrast',0.2,...
        'Hue',0,...
        'Saturation',0.1,...
        'Brightness',0.2);
end

% Randomly flip and scale image.
flip = randomAffine2d('XReflection',true,'Scale',[1 1.1]);
scale = affineOutputView(sz,flip,'BoundsStyle','CenterOutput');
augmentData{1} = imwarp(orgImg,flip,'OutputView',scale);

% Apply same transform to boxes.
boxEstimate=round(orgData{2});
boxEstimate(:,1)=max(boxEstimate(:,1),1);
boxEstimate(:,2)=max(boxEstimate(:,2),1);
if ismember(0, boxEstimate)
    boxEstimate = boxEstimate + 1;
end
[augmentData{2},indices] = bboxwarp(boxEstimate,flip,scale,'OverlapThreshold',0.25);
augmentData{3} = orgData{3}(indices);
% Return original data only when all boxes are removed by warping.
if isempty(indices)
    augmentData = orgData;
end
end