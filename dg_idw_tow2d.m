function towfit = dg_idw_tow2d(llat,llon,towin,nnindx,maxR,powerparam)
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

if ~exist('powerparam')
    powerparam = 2 % 25 km
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
        dataweight = (max(0,maxR - distgrid) ./ (maxR*distgrid)).^powerparam;
        abundfit(ii) = nansum(dot(dataweight(int32(nnindx{ii})),abund(int32(nnindx{ii}))))/nansum(dataweight(int32(nnindx{ii})));
        biomassfit(ii) = nansum(dot(dataweight(int32(nnindx{ii})),biomass(int32(nnindx{ii}))))/nansum(dataweight(int32(nnindx{ii})));
    else
        abundfit(ii) = NaN;
        biomassfit(ii) = NaN;
    end %if
end %for

towfit = [llat,llon,abundfit,biomassfit];
