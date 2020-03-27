workdir = '/Users/gong/Documents/Research/Projects/MesopelagicBiomass/';
load([workdir 'meso_TEMP_1deg.mat']);
load([workdir 'meso_SALT_1deg.mat']);
load([workdir 'meso_OXY_1deg.mat']);
load([workdir 'meso_AOU_1deg.mat']);
load([workdir 'meso_SIL_1deg.mat']);
load([workdir 'meso_NTA_1deg.mat']);
load([workdir 'mesoN_1deg.mat']);

LON1d = reshape(LON,[size(LON,1)*size(LON,2),1]);
LAT1d = reshape(LAT,[size(LAT,1)*size(LAT,2),1]);
mesoTEMP1d = reshape(mesoTEMP,[size(LON,1)*size(LON,2),1]);
mesoSALT1d = reshape(mesoSALT,[size(LON,1)*size(LON,2),1]);
mesoAOU1d = reshape(mesoAOU,[size(LON,1)*size(LON,2),1]);
mesoOXY1d = reshape(mesoOXY,[size(LON,1)*size(LON,2),1]);
mesoSIL1d = reshape(mesoSIL,[size(LON,1)*size(LON,2),1]);
mesoNTA1d = reshape(mesoNTA,[size(LON,1)*size(LON,2),1]);
mesoNF1d = reshape(mesoNF,[size(LON,1)*size(LON,2),1]);
mesoNlogF1d = reshape(mesoNlogF,[size(LON,1)*size(LON,2),1]);

mesoall = [LAT1d,LON1d,mesoTEMP1d,mesoSALT1d,mesoOXY1d,mesoAOU1d,mesoNTA1d,mesoSIL1d,mesoNlogF1d];
mesotable = array2table(mesoall,'VariableNames',{'LAT','LON','TEMP','SALINITY','OXYc', 'AOU','NITRATE','SILICATE','MesopelagicNlogFilter'});

save([workdir 'mesoVARs.mat'],'LON1d','LAT1d','mesoTEMP1d','mesoSALT1d','mesoOXY1d','mesoAOU1d','mesoNTA1d','mesoSIL1d','mesoNF1d','mesoNlogF1d');
save([workdir 'mesotable.mat'],'mesotable');
