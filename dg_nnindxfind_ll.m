function nnindx = dg_nnindxfind_ll(wgs84,h,dModel,searchradius,lat,lon)
    [ex,ey,ez] = geodetic2ecef(wgs84,lat,lon,h);
    nnindx = rangesearch(dModel, [ex,ey,ez], searchradius);
    %nnindxri
end
