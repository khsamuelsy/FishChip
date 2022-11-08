function FAA_survivalplot(options)


% data
dtime_cad = [165,120,45,75,90,60,75];
dtime_water = [180,180,180,180,180,180];

tvec = [0:15:180];
sperc_cad = zeros(1,13);
sperc_water = zeros(1,13);
for ii=1:13
    sperc_cad(ii) = sum(dtime_cad>=tvec(ii))./length(dtime_cad);
    sperc_water(ii) = sum(dtime_water>=tvec(ii))./length(dtime_water);
end
figure(1)
plot(tvec,sperc_water,'--','Color',[47 85 151]./256,'LineWidth',2)
hold on
plot(tvec,sperc_cad,'Color',[237 125 49]./256,'LineWidth',2)
% ylim([0 1])

set(figure(1), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);
ylim([options.set_yticks(1) options.set_yticks(end)])
yticks(options.set_yticks)
xlim([options.set_xticks(1) options.set_xticks(end)])
xticks(options.set_xticks)
ax1 = gca;
box off
% a duplicate figure copying only the lines
f2 = figure(2);
ax2 = copyobj(ax1,f2);
set(figure(2), 'Units', 'pixels', 'Position', [1000, 500, 400, 400]);
set(gca,'xticklabel',[])
set(gca,'yticklabel',[])
box off

end