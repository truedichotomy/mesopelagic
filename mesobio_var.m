% loading salinity WOA salinity distribution
% 
loadflag = 1
varflag = 'nitrate' % 'temp', 'salt', 'oxy', 'aou','silicate','nitrate'

%% load WOA data
if loadflag == 1
    workdir = '/Users/gong/Documents/Research/Projects/MesopelagicBiomass/';
    std_depths = csvread([workdir 'std_depths.txt']);

    switch varflag
        case 'salt'
            datadir = [workdir 'woa13_decav_1.00v2_salt/'];
            datafile = 'woa13_decav_s00an01v2.csv';
        case 'temp'
            datadir = [workdir 'woa13_decav_1.00v2_temp/'];
            datafile = 'woa13_decav_t00an01v2.csv';
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
            display('varflag defaulting to temp.')
            datadir = [workdir 'woa13_decav_1.00v2_temp/'];
            datafile = 'woa13_decav_t00an01v2.csv';
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
        tmpdata = str2num(datain{ii});
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

    %% grid the lon and lat into 1 degree grid
    [LON,LAT] = meshgrid(ulon,ulat);
    VAR = repmat(NaN,[size(LON,1), size(LON,2), length(std_depths)]);
    VARO = repmat(NaN,[size(LON,1), size(LON,2)]);

    % reshape lon/lat grid into 1-D array
    llon = reshape(LON,[length(ulon)*length(ulat),1]);
    llat = reshape(LAT,[length(ulon)*length(ulat),1]);

    [landcmplx,landind] = setdiff(llon+i*llat, londata+i*latdata);

    save([workdir 'grid1deg.mat'],'LON','LAT','llon','llat','landind','ulon','ulat','std_depths','VARO');

end %load if

% Go through each standard depth of the ocean and grid data onto LON/LAT
% grid
for jj = 1:length(std_depths),
    [jj std_depths(jj)]
    VARi = [];
    bathyind = find(isnan(data(:,jj)));
    %waterind = find(~isnan(data(:,2+jj)));
    [bathycmplx, databathy, BATHYind] = intersect(londata(bathyind)+i*latdata(bathyind), llon+i*llat);   
    VARi = griddata(londata,latdata,data(:,jj),LON,LAT,'nearest');
    bathymask = union(landind,BATHYind);
    if std_depths(jj) == 300
        bathymask300 = bathymask;
    end %if
    VARi(bathymask) = NaN;
    VAR(:,:,jj) = VARi;
    %dbstop
end %for

switch lower(varflag)
    case {'temp','salt','oxy','aou'}
        zind = find(std_depths <= 1000 & std_depths >= 200);
    case {'nitrate','silicate','phosphate'}
        zind = find(std_depths <= 200 & std_depths >= 0);
end %switch

mVAR = nanmean(VAR(:,:,zind),3);
mVAR(bathymask300) = NaN;

switch lower(varflag)
    case 'temp'
        mesoTEMP = mVAR;
        save([workdir 'meso_TEMP_1deg.mat'],'bathymask300','mesoTEMP','LON','LAT');
    case 'salt'
        mesoSALT = mVAR;
        save([workdir 'meso_SALT_1deg.mat'],'bathymask300','mesoSALT','LON','LAT');
    case 'aou'
        mesoAOU = mVAR;
        save([workdir 'meso_AOU_1deg.mat'],'bathymask300','mesoAOU','LON','LAT');
    case 'oxy'
        mesoOXY = mVAR;
        save([workdir 'meso_OXY_1deg.mat'],'bathymask300','mesoOXY','LON','LAT');
    case 'silicate'
        mesoSIL = mVAR;
        save([workdir 'meso_SIL_1deg.mat'],'bathymask300','mesoSIL','LON','LAT');
    case 'nitrate'
        mesoNTA = mVAR;
        save([workdir 'meso_NTA_1deg.mat'],'bathymask300','mesoNTA','LON','LAT');
end %switch
        
%pcolor(LON,LAT,mesoTEMP); shading flat; colorbar; 
%caxis([-2,16]);

pcolor(LON,LAT,mesoNTA); shading flat; colorbar; 
%caxis([33.5,36.5]);
