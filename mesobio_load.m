% 2018-08-23

dbstop if error

rootdir = '/Users/gong/Documents/Research/Projects/';
datadir = 'MesopelagicBiomass/';
workdir = [rootdir datadir];
gridfile = 'grid1deg.mat';

load([workdir gridfile]);

datafilemeso = 'OBIS_figure_b';

%datapath = [rootdir datadir datafile]
datapathmeso = ['./' datafilemeso];
mesodata = imread(datapathmeso,'png');

% standard deviation of the pixels
mesomask = mesodata;
ccm = std(double(mesodata),0,3);
%landmask0 = find(ccm < 18);
%oceanmask0 = find(ccm >= 18);

% remove land and bord as much as possible
%mesodatagray = rgb2gray(mesodata);
%mesodatagray(landmask0) = NaN;

%borderind = find(mesodatagray < 155);
%mesodatagray(borderind) = NaN;

mx = size(mesodata,2);
my = size(mesodata,1);
mc = size(mesodata,3);

lon1deg = [-180:1:180];
lat1deg = [-90:1:90];
lon1r = lon1deg(1:end-1) + 1/2.;
lat1r = lat1deg(1:end-1) + 1/2.;
nlon1 = length(lon1r);
nlat1 = length(lat1r);
[LON1,LAT1] = meshgrid(lon1r,lat1r);

lon5deg = [-180:5:180];
lat5deg = [-90:5:90]';
lon5r = lon5deg(1:end-1) + 5/2;
lat5r = lat5deg(1:end-1) + 5/2;
nlon5 = length(lon5r);
nlat5 = length(lat5r);
[LON5,LAT5] = meshgrid(lon5r,lat5r);

nlon = nlon1;
nlat = nlat1;

mesodatagll = repmat(NaN,[nlat,nlon]);
mesodatall = repmat(NaN,[nlat,nlon,3]);

dx = mx/nlon;
dy = my/nlat;

for ii = 1:nlon
    for jj = 1:nlat
        xr = [round((ii-1)*dx+1):round(ii*dx)];
        yr = [round((jj-1)*dy+1):round(jj*dy)];
        
        %mesodata1RGB = mesodata(yr,xr,:);
        
        meso1dataR = reshape(mesodata(yr,xr,1),[length(xr)*length(yr),1]);
        meso1dataG = reshape(mesodata(yr,xr,2),[length(xr)*length(yr),1]);
        meso1dataB = reshape(mesodata(yr,xr,3),[length(xr)*length(yr),1]);
        %meso1dataRGB = cat(2,meso1dataR,meso1dataG,meso1dataB);

        meso1dataGr = reshape(rgb2gray(mesodata(yr,xr,:)),[length(xr)*length(yr),1]);
        
        mesodatall(jj,ii,:) = reshape([mode(meso1dataR),mode(meso1dataG),mode(meso1dataB)],[1,1,3]);
        mesodatagll(jj,ii) = mode(meso1dataGr);
        
        %mesogray = mesodatagray(yr,xr);
        %mesodatagll(jj,ii) = mode(mode(mesogray));
    end %for
end %for

if ~exist('bathymask200')
    load([workdir 'meso_temp_1deg.mat']);
end %if

woalatrange = [1:168];
mesodatallR = flipud(mesodatall(woalatrange,:,1));
mesodatallG = flipud(mesodatall(woalatrange,:,2));
mesodatallB = flipud(mesodatall(woalatrange,:,3));
mesodatallGr = flipud(mesodatagll(woalatrange,:));

mesodatallR(bathymask300) = NaN;
mesodatallG(bathymask300) = NaN;
mesodatallB(bathymask300) = NaN;
mesodatallRGB = cat(3,mesodatallR,mesodatallG,mesodatallB);
mesodatallGr(bathymask300) = NaN;

badind = find(mesodatallGr <= 170);
mesodatallGrF = mesodatallGr;
mesodatallGrF(badind) = NaN;
mesodatallGr1d = reshape(mesodatallGrF,[size(mesodatallGrF,1)*size(mesodatallGrF,2),1]);
%pcolor(LON,LAT,mesodatallGrF); shading flat; colorbar; colormap(gray);

ind1 = find(mesodatallGrF <= 255 & mesodatallGrF > 248);
ind2 = find(mesodatallGrF <= 248 & mesodatallGrF > 230);
ind3 = find(mesodatallGrF <= 230 & mesodatallGrF > 213);
ind4 = find(mesodatallGrF <= 213 & mesodatallGrF > 198);
ind5 = find(mesodatallGrF <= 198 & mesodatallGrF > 186);
ind6 = find(mesodatallGrF <= 186 & mesodatallGrF > 170);

mesoN = mesodatallGrF;
mesoN(ind1) = 10;
mesoN(ind2) = 100;
mesoN(ind3) = 1000;
mesoN(ind4) = 10000;
mesoN(ind5) = 100000;
mesoN(ind6) = 1000000;
%mesodatallN(bathymask300) = NaN;

mesoNlog = log10(mesoN);
save([workdir 'mesoN_1deg.mat'],'mesoNlog');

mesoNlogF = mesoNlog; % filtered
mesoNlogE = [mesoNlog(:,end-89:end),mesoNlog,mesoNlog(:,1:90)]; % expanded in longitude to get rid of boundary filtering effect

h = fspecial('average',15); % define filter
mesoNlogEF = nanconv(mesoNlogE,h); % convolve data with filter
mesoNlogF = mesoNlogEF(:,90:90+359); % extract center portion
mesoNlogF(bathymask300) = NaN;
mesoNF = 10.^(mesoNlogF);

totalabundance = nansum(mesoNF)

save([workdir 'mesoN_1deg.mat'],'mesoNlog','mesoNlogF','mesoNF');


fmeso = figure('unit','inches')
set(gcf,'paperposition',[0 0 10 6]);
hp = pcolor(LON,LAT,mesoNlogF); colormap(jet); shading flat;
%pcolor(LON,LAT,mesoNF); colormap(jet); shading flat;
hx = xlabel('Longitude');
hy = ylabel('Latitude');
ht = title('OBIS Mesopelagic Abundance (Smoothed Log counts)')
caxis([0 5]);
cb = colorbar;
xlim([-180 180]);
ylim([-80 90]);
set(gca,'tickdir','out','box','on','fontsize',16,'fontweight','bold')
set(ht,'fontsize',18,'fontweight','bold');
set(hx,'fontsize',16,'fontweight','bold');
set(hy,'fontsize',16,'fontweight','bold');
eval(['print -dpng -r200 ' workdir 'mesoabundance_smoothed']);
close(fmeso);
