%% this script loads GEBCO 2014 2D map for the MAB
%% DG 20101111 20110411 20150302 20170918

loadflag = 0
ncflag = 1

bathydir = ['/Users/gong/Documents/Research/bathy/'];

if loadflag ==1
	load([bathydir 'gebco_MABlarge_30arcsec.mat']);
end %if

if ncflag == 1
	ncCfile = [bathydir 'gebco_MABlarge_30arcsec.grd'];
	matCfile = [bathydir 'gebco_MABlarge_30arcsec.mat'];

	%gridinfo = nc_info(ncfile);
  	%griddump = nc_dump(ncfile);

 	%lon = nc_varget(ncfile,'lon');
  	%lat = nc_varget(ncfile,'lat');
  	%[LON,LAT]=meshgrid(lon,lat');

	ncid = netcdf.open(ncCfile,'NOWRITE');

	lonid = netcdf.inqVarID(ncid,'lon');
	latid = netcdf.inqVarID(ncid,'lat');
	zid = netcdf.inqVarID(ncid,'z');

	lon = netcdf.getVar(ncid,lonid);
	lat = netcdf.getVar(ncid,latid);
	Z = netcdf.getVar(ncid,zid)';

	netcdf.close(ncid);

	[LON,LAT] = meshgrid(lon,lat);

	save(matCfile, 'LON','LAT', 'Z', '-v7.3');
end %if
