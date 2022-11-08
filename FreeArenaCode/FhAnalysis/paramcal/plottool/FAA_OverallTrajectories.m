function FAA_Cal_OverallTrajectories(Im_Px1,Im_Px2)


cur_dir = pwd;
path_zonelocate = [cur_dir(1:end-18),'Programs\Stage 4b - Analyze\main_analyzescript\caltool'];
cd(path_zonelocate)
FAA_loadborder
cd(cur_dir)
global zone
for ii=1:2
    figure(ii)
    imagesc(eval(['Im_Px',num2str(ii)]))
    perc_time = sum(sum(eval(['Im_Px',num2str(ii)]).*(zone.BW_zone23w | zone.BW_zone22w)));
    display(['The integrated time in cad zone for arena ',num2str(ii)','/2: ',num2str(perc_time*100),'%'])
    daspect([1 1 1]);    colormap(flip(gray,1));
    caxis([0 0.00002]);    set(gca,'XTickLabel',[]);    set(gca,'YTickLabel',[]);
    yticks([]);    xticks([]);    set(gca, 'visible', 'off')

end

end
