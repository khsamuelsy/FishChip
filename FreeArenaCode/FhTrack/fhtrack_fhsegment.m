function [FhCentroid, FhOrient] = fhtrack_fhsegment(ImIn)

FhMask = bwlabel(1-fhtrack_NormIm(ImIn));
FhMask = bwmorph(FhMask,'spur');
FhMask = bwareaopen(FhMask,14);

stats = regionprops('table',FhMask,'centroid','orientation','pixellist');

FhCentroid = fliplr(stats.Centroid);
FhOrient = zeros(size(stats,1),1);
for k = 1:size(stats,1)
    FhCentRep = repmat(stats.Centroid(k,1:2),size(stats.PixelList{k,1},1),1);
    PixelDiff = FhCentRep - stats.PixelList{k,1};
    PixelDist = PixelDiff(:,1).^2 + PixelDiff(:,2).^2;
    MaxDistPixelIdx = PixelDist==max(PixelDist);
    MaxDistPixel = stats.PixelList{k,1}(MaxDistPixelIdx,1:2);
    vecTemp = MaxDistPixel - stats.Centroid(k,1:2);
    FhOrient(k,1) = mod(360*atan2(vecTemp(1),vecTemp(2))/(2*pi)+180,360);

end
