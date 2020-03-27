%%                  INFORMATION

%  Dec 2018; Last revision: 7-Dec-2018
%  Dependencies: nctoolbox.github.io/nctoolbox/
%  Remember to run the command "setup_nctoolbox".
%  The user inputs are on lines 13 (choose variable), 19 (choose month), and 21 (choose depth level).

%%                 1. Load the Data

bathydir = ['/Users/gong/Documents/Research/bathy/'];
% gebco_MABlarge_30arcsec.mat this file is obtained from running extract_MAB_bathy.sh, then dg_load_bathy_MAB_GEBCO.m
bathy = load([bathydir 'gebco_MABlarge_30arcsec.mat']);

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables.
temp = nc{'temperature'}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
salt = nc{'salinity'}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
%depth = nc{'depth'};
salt.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
svg = salt.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.


%%                2. Choose Month and Depth (to use for 2-D plot)

z = svg.z; % Create a vector to inspect which INDEX corresponds to which depth.
zi = 1:26; % Choose a depth INDEX. upper 200 m
LAT = svg.lat;
LON = svg.lon;
Z = interp2(bathy.LON,bathy.LAT,bathy.Z,LON,LAT,'linear');

% define depth-averaged, surface, and bottom temperature data arrays
temperatureDA = repmat(NaN,[size(LON,1), size(LON,2), 12]);
salinityDA = temperatureDA;
temperature = temperatureDA;
salinity = salinityDA;
temperatureB = temperatureDA;
salinityB = salinityDA;

% define 1D version of the data arrays
lon1d = reshape(LON,[],1); % Reshape into vectors.
lat1d = reshape(LAT,[],1);
z1d = reshape(Z,[],1);

tempS1d = repmat(NaN,[size(LON,1)*size(LON,2), 12]);;
saltS1d = tempS1d;
tempDA1d = tempS1d;
saltDA1d = tempS1d;
tempB1d = tempS1d;
saltB1d = tempS1d;

% load data into the data arrays
%month = 6; % Choose month [1 12].
for month = 1:12
    month
    temperatureS(:,:,month) = squeeze(double(temp.data(month,1,:,:))); % sv.data(month,zi,lat,lon)
    temperatureB(:,:,month) = squeeze(double(temp.data(month,end,:,:))); % sv.data(month,zi,lat,lon)
    temperatureDA(:,:,month) = squeeze(nanmean(double(temp.data(month,zi,:,:)),2)); % sv.data(month,zi,lat,lon)
    salinityS(:,:,month) = squeeze(double(salt.data(month,1,:,:))); % sv.data(month,zi,lat,lon)
    salinityB(:,:,month) = squeeze(double(salt.data(month,end,:,:))); % sv.data(month,zi,lat,lon)
    salinityDA(:,:,month) = squeeze(nanmean(double(salt.data(month,zi,:,:)),2)); % sv.data(month,zi,lat,lon)

    tempDA1d(:,month) = reshape(temperatureDA(:,:,month),[],1);
    saltDA1d(:,month) = reshape(salinityDA(:,:,month),[],1);
    tempS1d(:,month) = reshape(temperatureS(:,:,month),[],1);
    saltS1d(:,month) = reshape(salinityS(:,:,month),[],1);
    tempB1d(:,month) = reshape(temperatureB(:,:,month),[],1);
    saltB1d(:,month) = reshape(salinityB(:,:,month),[],1);
end %for

save('MOCHA_vars.mat','LON','LAT','Z','temperatureS','temperatureB','temperatureDA','salinityS','salinityB','salinityDA','lon1d','lat1d','z1d','tempDA1d','tempS1d','tempB1d','saltS1d','saltB1d','saltDA1d');

%%                3. Plot of one depth level (2-D) of temperature or salinty

figure(1)
pcolor(LON,LAT,temperatureDA(:,:,3)); shading flat; colorbar
caxis([0 20])

figure(2)
pcolor(LON,LAT,salinityDA(:,:,3)); shading flat; colorbar
caxis([29 37])

%figure % Plot the elevation data.
%scatter(lon_mesh,lat_mesh,[],data,'.')
%title({url;sprintf('%s   month: %s   depth: %.0fm',sv.attribute('standard_name'),datestr(svg.time(month),'mmm'),svg.z(depth))},'interpreter','none');
%hcb = colorbar; title(hcb,sv.attribute('units'));
