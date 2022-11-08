function [avg,sem]= FAA_Cal_OverallTrajectories_errorbar(Im_Px1,Im_Px2,Im_Px3,Im_Px4,Im_Px5,Im_Px6,Im_Px7,Im_Px8,varargin)


cur_dir = pwd;
path_zonelocate = [cur_dir(1:end-18),'Programs\Stage 4b - Analyze\main_analyzescript\caltool'];
cd(path_zonelocate)
FAA_loadborder
cd(cur_dir)
total_perc_time=[];
global zone
for ii=1:nargin
    figure(ii)
    imagesc(eval(['Im_Px',num2str(ii)]))
    perc_time = sum(sum(eval(['Im_Px',num2str(ii)]).*(zone.BW_zone13w | zone.BW_zone12w)));
    total_perc_time = [total_perc_time;perc_time];
    
    display(['The integrated time in cad zone for arena ',num2str(ii)',': ',num2str(perc_time*100),'%'])
    daspect([1 1 1]);    
    colormap(flip(pink,1));
    caxis([0 0.00002]);    set(gca,'XTickLabel',[]);    set(gca,'YTickLabel',[]);
    yticks([]);    xticks([]);    set(gca, 'visible', 'off')

end
sem = std(total_perc_time)./sqrt(length(total_perc_time))
avg = mean(total_perc_time)
end
