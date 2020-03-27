%THIS SCRIPT DOES NOT WORK!!! YET 2018-12-12

% loading salinity WOA salinity distribution
%

loadflag = 1
varflag = 'temp' % 'temp', 'salt', 'oxy', 'aou','silicate','nitrate'

%% load WOA data
if loadflag == 1
    workdir = '/Users/gong/Documents/Research/Projects/MesopelagicBiomass/NWAtlantic/';
    std_depths = csvread([workdir 'std_depths.txt']);

    switch varflag
        case 'salt'
            datadir = [workdir 'climatology/'];
            %datafile = 'woa13_decav_s00an01v2.csv';
            datafile = 'nwa_all_s16mn10.csv';
        case 'temp'
            datadir = [workdir 'climatology/'];
            datafile = 'nwa_all_t16mn10.csv';
        case 'oxy'
            datadir = [workdir 'woa13_all_1.00_oxy/'];
            datafile = 'woa13_all_o00an01.csv';
        case 'aou'
            datadir = [workdir 'woa13_all_1.00_aou/'];
            datafile = 'woa13_all_A00an01.csv';
        case 'nitrate'
            datadir = [workdir 'woa13_all_1.00_nitrate/'];
            datafile = 'woa13_all_n00an01.csv';
        case 'silicate'
            datadir = [workdir 'woa13_all_1.00_silicate/'];
            datafile = 'woa13_all_i00an01.csv';
       otherwise
            display('varflag defaulting to annual mean temp.')
            datadir = workdir;
            datafile = 'nwa_all_t00mn10.csv';
    end %switch

    datapath = [datadir datafile];

    %% use textscan to import data into an array of strings
    fid = fopen(datapath);
    datain_ts = textscan(fid,'%s','headerlines',2);
    datain = datain_ts{1};
    %datain = textscan(fid,'%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n,%n','headerlines',2);
    fclose(fid);

    %% move imported data one line at a time into a data matrix
    data = repmat(NaN,[length(datain),length(std_depths)]);
    for ii = 1:length(datain)
        tmpdata = str2num(string(datain{ii}));
        ndata = length(tmpdata);
        data(ii,1:ndata) = tmpdata;
    end %for

    latdata = data(:,1);
    londata = data(:,2);
    data = data(:,3:end);

    %% the code below doesn't work for importing data! should only use readtabel for regularly formated data. the data used here can have different number of fields per location.
    %data = csvread(datapath,3);
    %datatable = readtable(datapath,'Delimiter', ',', 'HeaderLines', 1, 'ReadVariableNames', false,'ReadRowNames',false);
    %data = table2array(datatable);


    %% extract loaded data.
    ulat = unique(latdata);
    ulon = unique(londata);

    %% grid the lon and lat into 0.1 degree grid
    [LON,LAT] = meshgrid(ulon,ulat);
    VAR = repmat(NaN,[size(LON,1), size(LON,2), length(std_depths)]);

    % reshape lon/lat grid into 1-D array
    llon = reshape(LON,[length(ulon)*length(ulat),1]);
    llat = reshape(LAT,[length(ulon)*length(ulat),1]);

    [landcmplx,landind] = setdiff(llon+i*llat, londata+i*latdata);

    save([workdir 'grid0p1deg.mat'],'LON','LAT','llon','llat','landind','ulon','ulat','std_depths');

end %load if
