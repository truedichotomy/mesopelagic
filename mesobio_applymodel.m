normalflag = 0

mesovar = mesotable(:,{'LAT','LON','TEMP','SALINITY','OXYc','AOU','NITRATE','SILICATE'});
mesovarpred = mesovar;

if normalflag == 1
    mesovarpred.TEMP = mesovar.TEMP;
    mesovarpred.SALINITY = mesovar.SALINITY;
    mesovarpred.OXYc = mesovar.OXYc;
else
    mesovarpred.TEMP = mesovar.TEMP+2;
    mesovarpred.SALINITY = mesovar.SALINITY;
    mesovarpred.OXYc = mesovar.OXYc;
end %if

%mesofit = fineGaussSVM_sanLatLon.predictFcn(mesovarpred);
%mesofit = fineGaussSVM.predictFcn(mesovarpred);
%mesofit = ks1GaussSVM_TS.predictFcn(mesovarpred);
%mesofit = ks1GaussSVM_TSO.predictFcn(mesovarpred);
%mesofit = ks1GaussSVM_TSAUONIT.predictFcn(mesovarpred);
mesofit = ks1GaussSVM.predictFcn(mesovarpred);
%mesofit = fineTree_sanAOUNitrateSilicate.predictFcn(mesovarpred);
%mesofit = fineTree.predictFcn(mesovarpred);
%mesofit = fineTree_TS.predictFcn(mesovarpred);
%mesofit = fineTree_LatLonOnly.predictFcn(mesovarpred);
%mesofit = fineTree_sanLatLon.predictFcn(mesovarpred);
mesofit(bathymask300,:) = NaN;

totalabundance = nansum(10.^mesofit)

fmeso = figure('unit','inches')
set(gcf,'paperposition',[0 0 10 6]);
%hp = pcolor(LON,LAT,mesoNlogF); colormap(jet); shading flat;
%hp = pcolor(LON,LAT,mesoNF); colormap(jet); shading flat;
hs = scatter(mesotable.LON,mesotable.LAT,20,mesofit,'s','filled'); colorbar; colormap(jet);
hx = xlabel('Longitude');
hy = ylabel('Latitude');
switch normalflag
    case 1
        ht = title('Modeled Abundance Present (Log counts)')
    case 0
        ht = title('Modeled Abundance +2C (Log counts)')
end %switch
caxis([0 5]);
xlim([-180 180]);
ylim([-80 90]);
cb = colorbar;
set(gca,'tickdir','out','box','on','fontsize',16,'fontweight','bold')
set(ht,'fontsize',18,'fontweight','bold');
set(hx,'fontsize',16,'fontweight','bold');
set(hy,'fontsize',16,'fontweight','bold');
switch normalflag
    case 1
        eval(['print -dpng -r200 ' workdir 'mesoabundance_present']);
    case 0
        eval(['print -dpng -r200 ' workdir 'mesoabundance_plus2C']);
end %switch
close(fmeso);

%scatter(mesotable.LON,mesotable.LAT,20,mesofit,'s','filled'); colorbar; colormap(jet); caxis([0 5]);
