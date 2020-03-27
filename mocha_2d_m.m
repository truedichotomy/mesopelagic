%%                  INFORMATION

%  Dec 2018; Last revision: 7-Dec-2018
%  Dependencies: nctoolbox.github.io/nctoolbox/
%  Remember to run the command "setup_nctoolbox".
%  The user inputs are on lines 13 (choose variable), 19 (choose month), and 21 (choose depth level).

%%                 1. Load the Data

url = 'http://tds.marine.rutgers.edu/thredds/dodsC/other/climatology/mocha/MOCHA_v3.nc';
nc = ncgeodataset(url); % Assign a ncgeodataset handle.
nc.variables % Print list of available variables. 
sv = nc{'salinity'}; % Assign ncgeovariable handle: 'climatology_bounds' 'temperature' 'salinity' 'time' 'latitude' 'longitude' 'depth'
sv.attributes % Print ncgeovariable attributes. % Print ncgeovariable attributes.
svg = sv.grid_interop(:,:,:,:); % Get standardized (lat,lon,dep,time) coordinates for the ncgeovariable.

%%                2. Choose Month and Depth (to use for 2-D plot)

month = 1; % Choose month [1 12].
depth_options = svg.z; % Create a vector to inspect which INDEX corresponds to which depth.
depth = 1; % Choose a depth INDEX.
lat_mesh = svg.lat;
lon_mesh = svg.lon;
data = squeeze(double(sv.data(month,depth,:,:))); % sv.data(month,depth,lat,lon)

%%                3. Plot of one depth level (2-D) of temperature or salinty

lon_mesh = reshape(lon_mesh,[],1); % Reshape into vectors.
lat_mesh = reshape(lat_mesh,[],1);
data = reshape(data,[],1); 
figure % Plot the elevation data.
scatter(lon_mesh,lat_mesh,[],data,'.')
title({url;sprintf('%s   month: %s   depth: %.0fm',sv.attribute('standard_name'),datestr(svg.time(month),'mmm'),svg.z(depth))},'interpreter','none');
hcb = colorbar; title(hcb,sv.attribute('units'));
