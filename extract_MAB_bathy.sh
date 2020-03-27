#!/bin/bash

#rm -f  .gmtcommands4
#rm -f  .gmtdefaults4
#gmtdefaults -D > .gmtdefaults4

#gmt gmtset LABEL_FONT_SIZE 12 ANOT_FONT_SIZE 10 BASEMAP_AXES WeSn HEADER_FONT_SIZE 15
#gmt gmtset BASEMAP_TYPE plain PLOT_DEGREE_FORMAT D
#gmt gmtset PAPER_MEDIA letter+ N_HEADER_RECS 0

#grdcut IBCAO_ver2_23_GEO_netCDF_1min.grd -R-170/-120/68/74 -fg -Gibcao2_AON.grd
#gmt grdcut IBCAO_V3_500m_RR.grd -R-180/-60/64/85 -fg -Gibcao3_MARES.grd
#gmt grdcut IBCAO_V3_30arcsec_RR.grd -R-180/-130/62/80 -fg -Gibcao3_AON.grd
#gmt grdcut /Users/gong/Documents/Research/Data/NCEI/ETOPO1_Ice_g_gmt4.grd -R-78/-64/33/47 -fg -Getopo1_MAB_1arcmin.grd
#gmt grdcut /Users/gong/Documents/Research/Data/BODC/RN-9861_1505761311377/GEBCO_2014_2D.nc -R-78/-64/33/47 -fg -Ggebco_MAB_30arcsec.grd
gmt grdcut /Users/gong/Documents/Research/Data/BODC/RN-9861_1505761311377/GEBCO_2014_2D.nc -R-81/-60/31/47 -fg -Ggebco_MABlarge_30arcsec.grd


#gmt grdcut /Users/gong/Documents/Research/Data/NGDC/ne_atl_crm_v1.nc -R-78/-64/33/47 -fg -Gcem_MABnorth_3arcsec.grd
#gmt grdcut /Users/gong/Documents/Research/Data/NGDC/se_atl_crm_v1.nc -R-78/-64/33/47 -fg -Gcem_MABsouth_3arcsec.grd

#grdsample GEOGRID -R-157/-148/70/72 -I1m/1m -Gibcao2_nopp.grd
