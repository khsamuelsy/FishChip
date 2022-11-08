function FAA_Cal_FirstBout_AngleChangebyFrame_0


totalframe = 39;
meandata = zeros(totalframe+1,4);
errordata = zeros(totalframe+1,4);
timevec = 0:(1000/240):totalframe*(1000 / 240);
raw = {};

for nframe=1:totalframe
    plotdata=FAA_Cal_FirstBout_AngleChangebyFrame_1(nframe);
    raw{nframe} = plotdata;
    for jj=1:4
        temp = plotdata(:,jj);
        meandata(nframe+1,jj) = nanmean(temp);
        errordata(nframe+1,jj) = nanstd(temp)/sqrt(sum(~isnan(temp)));
    end
    display(['Done frame: ',num2str(nframe)])
end

cal.meandata = meandata;
cal.errordata = errordata;
cal.timevec = timevec;
save('IniAngle.mat','cal')


end