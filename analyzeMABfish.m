calcflag = 0
plotflag = 1
testplotflag = 0

workdir = '/Users/gong/Documents/Research/Projects/MesopelagicBiomass/';

if ~exist('LON')
    load MOCHA_vars.mat
end %if

if ~exist('fishfall')
    fishfall = load('MABfish_fall.mat');
    fishspring = load('MABfish_spring.mat')
end

if ~exist('svmFallModel')
    %save('MLfish_models_v2.mat','svmSpringModelv2','svmFallModelv2');
    load('MLfish_models_v2.mat');
end %if

if calcflag == 1
    zind = find(z1d >= -200 & z1d < 0);

    datafall = [lat1d, z1d, nanmean(tempDA1d(:,9:12),2), nanmean(saltDA1d(:,9:12),2), fishfall.logbiomass1d];
    dataspring = [lat1d, z1d, nanmean(tempDA1d(:,4:6),2), nanmean(saltDA1d(:,4:6),2), fishspring.logbiomass1d];

    datafall2 = [lat1d, z1d, nanmean(tempDA1d(:,9:12),2)+2, nanmean(saltDA1d(:,9:12),2), fishfall.logbiomass1d];
    dataspring2 = [lat1d, z1d, nanmean(tempDA1d(:,4:6),2)+2, nanmean(saltDA1d(:,4:6),2), fishspring.logbiomass1d];

    falllogbiomass1dfit = svmFallModelv2.predictFcn(datafall(zind,1:4));
    springlogbiomass1dfit = svmSpringModelv2.predictFcn(dataspring(zind,1:4));

    falllogbiomass1dfit2 = svmFallModelv2.predictFcn(datafall2(zind,1:4));
    springlogbiomass1dfit2 = svmSpringModelv2.predictFcn(dataspring2(zind,1:4));
end %if

plotflag = 2
seasonflag = 'fall'

if plotflag == 1
    f1 = figure('unit','inches')
    set(gcf,'paperposition',[0 0 10 8]);
    %hp = pcolor(LON,LAT,mesoNlogF); colormap(jet); shading flat;
    %hp = pcolor(LON,LAT,mesoNF); colormap(jet); shading flat;
    switch seasonflag
        case 'spring'
            hs = scatter(lon1d(zind),lat1d(zind),20,springlogbiomass1dfit,'s','filled'); colorbar; colormap(jet);
            ht = title('Modeled Spring Biomass (Log)')
        case 'fall'
            hs = scatter(lon1d(zind),lat1d(zind),20,falllogbiomass1dfit,'s','filled'); colorbar; colormap(jet);
            ht = title('Modeled Fall Biomass (Log)')
    end %switch
    hx = xlabel('Longitude');
    hy = ylabel('Latitude');
    caxis([0 5]);
    xlim([-77 -65]);
    ylim([34 46]);
    cb = colorbar;
    set(gca,'tickdir','out','box','on','fontsize',16,'fontweight','bold')
    set(ht,'fontsize',18,'fontweight','bold');
    set(hx,'fontsize',16,'fontweight','bold');
    set(hy,'fontsize',16,'fontweight','bold');
    switch seasonflag
        case 'spring'
            eval(['print -dpng -r200 ' workdir 'MABbiomass_model_spring']);
        case 'fall'
            eval(['print -dpng -r200 ' workdir 'MABbiomass_model_fall']);
    end %switch
    close(f1);
elseif plotflag == 2
    f2 = figure('unit','inches')
    set(gcf,'paperposition',[0 0 10 8]);
    %hp = pcolor(LON,LAT,mesoNlogF); colormap(jet); shading flat;
    %hp = pcolor(LON,LAT,mesoNF); colormap(jet); shading flat;
    switch seasonflag
        case 'spring'
            hs = scatter(lon1d(zind),lat1d(zind),20,fishspring.logbiomass1d(zind),'s','filled'); colorbar; colormap(jet);
            ht = title('Observed Spring Biomass (Log)')
        case 'fall'
            hs = scatter(lon1d(zind),lat1d(zind),20,fishfall.logbiomass1d(zind),'s','filled'); colorbar; colormap(jet);
            ht = title('Observed Fall Biomass (Log)')
    end %switch
    hx = xlabel('Longitude');
    hy = ylabel('Latitude');
    caxis([0 5]);
    xlim([-77 -65]);
    ylim([34 46]);
    cb = colorbar;
    set(gca,'tickdir','out','box','on','fontsize',16,'fontweight','bold')
    set(ht,'fontsize',18,'fontweight','bold');
    set(hx,'fontsize',16,'fontweight','bold');
    set(hy,'fontsize',16,'fontweight','bold');
    switch seasonflag
        case 'spring'
            eval(['print -dpng -r200 ' workdir 'MABbiomass_obs_spring']);
        case 'fall'
            eval(['print -dpng -r200 ' workdir 'MABbiomass_obs_fall']);
    end %switch
    close(f2);
end %if

if testplotflag == 1
    figure(1)
    subplot(2,1,1)
    hsfallm = scatter(lon1d(zind),lat1d(zind),20,falllogbiomass1dfit,'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htfallm = title('Fall SVM Model')
    colorbar

    subplot(2,1,2)
    hsfalld = scatter(lon1d(zind),lat1d(zind),20,fishfall.logbiomass1d(zind),'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htfalld = title('Fall Interpolated')
    colorbar

    figure(2)
    subplot(2,1,1)
    hsspringm = scatter(lon1d(zind),lat1d(zind),20,springlogbiomass1dfit,'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htspringm = title('Spring SVM Model')
    colorbar

    subplot(2,1,2)
    hsspringd= scatter(lon1d(zind),lat1d(zind),20,fishspring.logbiomass1d(zind),'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htspringd = title('Spring Interpolated')
    colorbar

    figure(3)
    subplot(2,1,1)
    hsfallm = scatter(lon1d(zind),lat1d(zind),20,falllogbiomass1dfit2,'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htfallm = title('Fall SVM Model')

    subplot(2,1,2)
    hsfalld = scatter(lon1d(zind),lat1d(zind),20,fishfall.logbiomass1d(zind),'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htfalld = title('Fall Interpolated')

    figure(4)
    subplot(2,1,1)
    hsspringm = scatter(lon1d(zind),lat1d(zind),20,springlogbiomass1dfit2,'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htspringm = title('Spring SVM Model')

    subplot(2,1,2)
    hsspringd= scatter(lon1d(zind),lat1d(zind),20,fishspring.logbiomass1d(zind),'o','filled');
    set(gca,'box','on','xgrid','on','ygrid','on')
    htspringd = title('Spring Interpolated')
end %if