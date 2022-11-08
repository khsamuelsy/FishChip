function FAA_FirstBout_IncidentAngle(cal)
test=[]
for ii=1:6
kk=ii;
    figure(ii)
    
    indx = find(~isnan(cal.all_in_angle(:,kk)));
    paramx = cal.all_in_angle(:,kk).*-1;
    paramy = cal.all_deltad2(:,kk)*-1;
    % need to invert the sign for left = -ve , right = +ve presentation
    scatter(paramx ,paramy,2,'MarkerEdgeColor','k'); hold on
    [R,P]= corrcoef(cal.all_in_angle(indx,kk),cal.all_deltad2(indx,kk)*-1);
    P
    x_vec= -180:60:180;
    p=polyfit(paramx(~isnan(paramx)),paramy(~isnan(paramy)),1);
    [ p, yhat, ci] = polypredci(paramx(~isnan(paramx)), paramy(~isnan(paramy)), 1, 0.95, x_vec);
    
    totalsz = length(paramx(~isnan(paramx)));
    totalsz = length(paramy(~isnan(paramy)));
    por1 = length(intersect(find(paramx(~isnan(paramx))<=0),find(paramy(~isnan(paramy))>0))) ./totalsz;
    por2 = length(intersect(find(paramx(~isnan(paramx))>0),find(paramy(~isnan(paramy))>0))) ./totalsz;
    por3 = length(intersect(find(paramx(~isnan(paramx))<=0),find(paramy(~isnan(paramy))<=0))) ./totalsz;
    por4 = length(intersect(find(paramx(~isnan(paramx))>0),find(paramy(~isnan(paramy))<=0))) ./totalsz;
    test=[test;[por1+por3,por2+por4]];
    p=polyfit(paramx(~isnan(paramx)),paramy(~isnan(paramy)),1);
    y_vec = polyval(p,x_vec);
    plot(x_vec,y_vec,'color','k','linewidth',2); hold on
    
    descrp = ['Corr. coeff. : ',num2str(round(R(1,2).^2,2,'significant'))]

    pgonci = polyshape([x_vec,fliplr(x_vec)],[y_vec+ci',fliplr(y_vec-ci')]);
    pgci= plot(pgonci);
    pgci.FaceAlpha = .1;
    pgci.EdgeColor = 'none';
    pgci.FaceColor = [[0, 0.4470, 0.7410]];
    xticks([-180:60:180]); hold on
    yticks([-180:60:180]); hold on
    xticklabels({});    yticklabels({});
    ylim([-200 200])
    xlim([-200 200])
    ax=gca;
    ax.XAxisLocation = 'origin';
    ax.YAxisLocation = 'origin';
    set(figure(ii), 'Units', 'pixels', 'Position', [500, 500, 400, 400]);
    
end
test
end
