function [tempbott, saltbott, zz, temp, salt] = dg_idw_casts2d(llon,llat,zdeep,casts,nnindx,maxR,DAflag)
% this function calculates the value of temperature and salinity based on inverse distance weighting.
% DG 2017-09-25
%
% INPUTS:
%   lon: longitude of the point of interest
%   lat: latitude of the point of interest
%   casts: casts data structure containing the relevant hydrographic data to be used for IDW calculation
%   nnindx: nearest neighbor indices for each

dbstop if error
if ~exist('maxR')
    maxR = 25000 % 25 km
end %if

if ~exist('DAflag')
    DAflag = 0;
end %if

% loop through all locations that need temp & salt interpolation
dist = []; zz = []; temp = []; salt = [];
tempbott = []; saltbott = [];

for ii = 1:length(llon)
    % extract the hydrographic cast locations and distance to the point of interest
    clon = [casts(nnindx{ii}).lon]';
    clat = [casts(nnindx{ii}).lat]';

    if ~isempty(clat)
        % define cell array of temperture, salinity, and depth for the nearest neighbors for the POI
        %tempcell = {casts(nnindx{ii}).temp};
        %saltcell = {casts(nnindx{ii}).salt};
        %zcell = {casts(nnindx{ii}).zz};
        tempind = find(~isnan([casts(nnindx{ii}).tempbott]) == 1);
        saltind = find(~isnan([casts(nnindx{ii}).saltbott]) == 1);

        dist{ii} = deg2km(distance([llat(ii),llon(ii)],[clat,clon]))*1000; % distance in meters
        distgrid = dist{ii};

        % perform inverse distance weighting interpolation to the grid points.
        tempweight = (max(0,maxR - distgrid(tempind)) ./ (maxR*distgrid(tempind))).^2;
        saltweight = (max(0,maxR - distgrid(saltind)) ./ (maxR*distgrid(saltind))).^2;

        if length(tempind) == 1
            tempbott(ii) = casts(nnindx{ii}).tempbott;
        elseif length(tempind) >= 2
            ctempbott = [casts(nnindx{ii}).tempbott];
            tempbott(ii) = nansum(dot(tempweight,ctempbott(tempind)))/nansum(tempweight);
        else
            tempbott(ii) = NaN;
        end %if

        if length(saltind) == 1
            saltbott(ii) = casts(nnindx{ii}).saltbott;
        elseif length(saltind) >= 2
            csaltbott = [casts(nnindx{ii}).saltbott];
            saltbott(ii) = nansum(dot(saltweight,csaltbott(saltind)))/nansum(saltweight);
        else
            saltbott(ii) = NaN;
        end %if

        if nargout > 2 % if more than DA temp and salt are requested from the calling function
            % defining the depth profile to interpolate over
            zz{ii} = [-1:-1:zdeep(ii)]';

            if nargout > 3 % if profiles of DA temp and salt are requested
                if length(tempind) == 1
                    temp{ii} = casts(nnindx{ii}).temp;
                elseif length(tempind) >= 2
                    temp{ii} = repmat(tempbott(ii),[length(zz{ii}),1]);
                else
                    temp{ii} = repmat(tempbott(ii),[length(zz{ii}),1]);
                end %if

                if length(saltind) == 1
                    salt{ii} = casts(nnindx{ii}).salt;
                elseif length(saltind) >= 2
                    salt{ii} = repmat(saltbott(ii),[length(zz{ii}),1]);
                else
                    salt{ii} = repmat(saltbott(ii),[length(zz{ii}),1]);
                end %if
                temp{ii} = temp{ii}';
                salt{ii} = salt{ii}';
            end %if nargout > 3
        end %if nargout > 2
    else
        tempbott(ii) = NaN;
        saltbott(ii) = NaN;

        if nargout > 2
            zz{ii} = [];
            if nargout > 3
                dist{ii} = [];
                temp{ii} = [];
                salt{ii} = [];
            end %if
        end %if
    end %if

    % find times when the IDW calculation accidentally involved NaN in the dot product step, which result in the tempda or saltda being 0 when weighted summed
    %if saltda(ii) < 1
    %    dbstop
    %end %if
    %if length(tempind > 1) & tempda(ii) == NaN
    %    dbstop
    %end %if
end %for

% testplotflag = 0;
% if testplotflag == 1
%     casti = 5000
%
%     figure(1)
%     plot(salt{casti},zz{casti},'kx-');
%     hold on;
%
%     for ii = 1:length(nnindx{casti})
%         plot(casts(nnindx{casti}(ii)).salt, casts(nnindx{casti}(ii)).zz,'r-');
%     end %for
%     hold off
% end %if

end %func
