loadflag = 0
season = 'fall'

if loadflag == 1
    load('utows_data_all_10yr.mat');
    load('MOCHA_vars.mat');
end %if

fishdata = utows_data_all_10yr;
fisheader = {'cruise','stratum','tow','station','year','season (1fall,2spr)','lat','lon','datanum','depth','surftemp','surfsalin','bottemp','botsalin','abundance','biomass'};

si = find(strcmp(fisheader,'season (1fall,2spr)'));
falli = find(fishdata(:,si) == 1);
springi = find(fishdata(:,si) == 2);

if strcmp(season,'spring')
    seasoni = springi;
elseif strcmp(season,'fall')
    seasoni = falli
end %if

lati = find(strcmp(fisheader,'lat'));
loni = find(strcmp(fisheader,'lon'));
lattrain = fishdata(seasoni,lati);
lontrain = fishdata(seasoni,loni);

abundi = find(strcmp(fisheader,'abundance'));
biomassi = find(strcmp(fisheader,'biomass'));
abundtrain = fishdata(seasoni,abundi);
biomasstrain = fishdata(seasoni,abundi);

h = 0; %meters
searchradius = 50000
wgs84 = wgs84Ellipsoid('meters');
[extrain,eytrain,eztrain] = geodetic2ecef(wgs84,lattrain,lontrain,h);
ECEFxyztrain = [extrain,eytrain,eztrain];
dModel = createns(ECEFxyztrain,'NSMethod','kdtree','Distance','Euclidean');
nnindx = dg_nnindxfind_ll(wgs84,h,dModel,searchradius,lat1d,lon1d);

%zeroind = find(abundtrain == 0);
%abundtrain(zeroind) = NaN;
%biomasstrain(zeroind) = NaN;

towfit = dg_idw_tow2d(lat1d,lon1d,[lattrain,lontrain,log10(abundtrain),log10(biomasstrain)],nnindx,searchradius);
logabund1d = towfit(:,3);
logbiomass1d = towfit(:,4);

zeroind = find(logabund1d <= 0.1);
logabund1d(zeroind) = NaN;
logbiomass1d(zeroind) = NaN;

if strcmp(lower(season(1:3)),'spr')
    save('MABfish_spring.mat','lat1d','lon1d','logabund1d','logbiomass1d');
elseif strcmp(lower(season(1)),'f')
    save('MABfish_fall.mat','lat1d','lon1d','logabund1d','logbiomass1d');
end %if

scatter(lon1d,lat1d,20,logabund1d,'o','filled');
scatter(lon1d,lat1d,20,logbiomass1d,'o','filled');

function nnindx = dg_nnindxfind_ll(wgs84,h,dModel,searchradius,lat,lon)
    [ex,ey,ez] = geodetic2ecef(wgs84,lat,lon,h);
    nnindx = rangesearch(dModel, [ex,ey,ez], searchradius);
    %nnindxri
end

function towfit = dg_idw_tow2d(llat,llon,towin,nnindx,maxR)
    % this function calculates the value of abundance and biomass based on inverse distance weighting.
    % DG 2017-09-25, 2018-12-10
    %
    % INPUTS:
    %   lat: latitude of the point of interest
    %   lon: longitude of the point of interest
    %   towin: [lat,lon,abund,biomass]
    %   nnindx: nearest neighbor indices for each

    dbstop if error
    if ~exist('maxR')
        maxR = 15000 % 25 km
    end %if

    clat = towin(:,1);
    clon = towin(:,2);
    abund = towin(:,3);
    biomass = towin(:,4);
    abundfit = abund;
    biomassfit = biomass;

    for ii = 1:length(llon)
        dist{ii} = deg2km(distance([llat(ii),llon(ii)],[clat,clon]))*1000; % distance in meters
        distgrid = dist{ii};
        %abundind = find(~isnan(nnindx{ii}) == 1);
        %biomassind = find(~isnan(nnindx{ii}) == 1);
        if ~isempty(nnindx{ii})
            dataweight = (max(0,maxR - distgrid) ./ (maxR*distgrid)).^2;
            abundfit(ii) = nansum(dot(dataweight(int32(nnindx{ii})),abund(int32(nnindx{ii}))))/nansum(dataweight(int32(nnindx{ii})));
            biomassfit(ii) = nansum(dot(dataweight(int32(nnindx{ii})),biomass(int32(nnindx{ii}))))/nansum(dataweight(int32(nnindx{ii})));
        else
            abundfit(ii) = NaN;
            biomassfit(ii) = NaN;
        end %if
    end %for
    towfit = [llat,llon,abundfit,biomassfit];
end
