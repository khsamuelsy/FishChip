function FAA_Lineplot(cal,options)

mycolor = FishyChemoBehav_ColorPlate;
close all
figure(1)
for jj=1:6

    if jj==1
        c = mycolor.baseline;
        l = mycolor.linestyle.baseline;
    elseif jj==2
        c = mycolor.mainbi;
        l = mycolor.linestyle.mainbi;
    elseif jj==3
        c = mycolor.mainleft;
        l = mycolor.linestyle.mainleft;
    elseif jj==4
        c = mycolor.mainright;
        l = mycolor.linestyle.mainright;
    elseif jj==5
        c = mycolor.mainnull;
        l = mycolor.linestyle.mainnull;
    elseif jj==6
        c = mycolor.mainnull;
        l = mycolor.linestyle.mainbi;
    end
    
    plot(cal.timevec,cal.meandata(:,jj),l,'color',c,'LineWidth',2.8);
    
    hold on
    fill([cal.timevec'; flipud(cal.timevec')],[cal.meandata(:,jj)-cal.errordata(:,jj);flipud(cal.meandata(:,jj)+cal.errordata(:,jj))],c,'linestyle','none');
    hold on
    alpha(.15)
end

if isfield(options,'set_xticks')
    xticks(options.set_xticks)
    xlim([options.set_xticks(1) options.set_xticks(end)])
end
if isfield(options,'set_yticks')
    if ~options.skiplastyticks
        yticks(options.set_yticks)
    else
        yticks(options.set_yticks(1:end-1))
    end
    ylim([options.set_yticks(1) options.set_yticks(end)])
end



set(figure(1), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);
box off
ax1 = gca;
f2 = figure(2);
ax2 = copyobj(ax1,f2);
set(figure(2), 'Units', 'pixels', 'Position', [1000, 500, 400, 400]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
box off

end
