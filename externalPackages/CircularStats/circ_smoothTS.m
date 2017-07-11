function [ts_smooth] = circ_smoothTS(varargin)
% USAGE
% [ts_smooth] = circ_smoothTS(varargin)
%
% Given a timeseries input of circular data, this function smooths over the
% desired number of bins and returns a circularly smooth timeseries
%
% INPUTS
%   
%   ts         a time series of circular data
%   nBins      integer number of bins you would like to smooth over
%   method     string argument that determines the smoothing method,
%              options are 'median', 'mean' [default: 'median']
%   exclude    vector of values in ts to exclude from smoothing (can be
%              used to exclude 0 values)
%
% OUTPUTS
%
%   ts_smooth  a time series vector of smoothed circular data
%
% HELP
%
% Written by David Tingley, 2017
% TODO error handling when nBins > 1/2 ts

p = inputParser;
addRequired(p,'ts',@isvector);
addRequired(p,'nBins',@isnumeric);
addParameter(p,'method','median',@isstr)
addParameter(p,'exclude',[],@isvector);

parse(p,varargin{:});

ts = p.Results.ts;
<<<<<<< HEAD
=======
if size(ts,1) == 1;
    ts = ts';
end

>>>>>>> master
nBins = p.Results.nBins;
method = p.Results.method;
exclude = p.Results.exclude;

<<<<<<< HEAD
=======
if length(exclude) == length(ts)
   ts_smooth = ts;
   return
end
if nBins == 1
    ts_smooth = ts;
    return
end

>>>>>>> master
if ~isempty(exclude)
    list = find(ts==exclude);
    ts(list) = nan;
end

exclude = find(isnan(ts));
<<<<<<< HEAD
if length(exclude) == length(ts)
   ts_smooth = ts;
   return
end
if nBins == 1
=======
keep = find(~isnan(ts));

f = find(diff(keep)<nBins);
ff = find(diff(keep)>=nBins);
if ~isempty(ff)
    ff(end+1) = length(keep);  % include last ts 
end
if length(keep) == 0
    ts(isnan(ts))=0;
>>>>>>> master
    ts_smooth = ts;
    return
end

<<<<<<< HEAD
for i = 1:length(ts)
    if i <= nBins
        ind = (1:i+floor(nBins/2)); 
    elseif i >= length(ts) - nBins
        ind = (i-floor(nBins/2):length(ts));
    else
        ind = (i-floor(nBins/2):i+floor(nBins/2));
    end
    
    [loc] = ~ismember(ind,exclude);
    if ~isempty(loc) 
        switch method
            case 'median'
                ts_smooth(i) = circ_median(ts(ind(loc))');
            case 'mean'
                ts_smooth(i) = circ_mean(ts(ind(loc))');
=======
ts_smooth = zeros(length(ts),1);

for i =1:length(ff)  % populate list with single spikes that occur sparsely
    if keep(ff(i))>ceil(nBins/2) & keep(ff(i))+ceil(nBins/2) < length(ts) % prevents negative indices from being added
        ts_smooth(keep(ff(i))-ceil(nBins/2):keep(ff(i))+ceil(nBins/2)) = ts(keep(ff(i)));
    elseif keep(ff(i))+ceil(nBins/2) < length(ts) 
        ts_smooth(1:keep(ff(i))+ceil(nBins/2)) = ts(keep(ff(i)));    
    elseif keep(ff(i))>ceil(nBins/2) 
        ts_smooth(keep(ff(i))-ceil(nBins/2):end) = ts(keep(ff(i)));
    end
end 

for i=1:length(f) % populate list with spikes that occur within smoothing window
    ind = (keep(f(i))-ceil(nBins/2):keep(f(i))+ceil(nBins/2));
    ind(ind<1) = [];
    ind(ind>length(ts)) = [];
    keep = [keep; ind'];
%     if keep(f(i)) > ceil(nBins/2) & keep(f(i)+1)+ceil(nBins/2) < length(ts) % prevents negative indices from being added
%         keep = [keep; [keep(f(i))-ceil(nBins/2):keep(f(i)+1)+ceil(nBins/2)]'];
%     elseif ~(keep(f(i)) > ceil(nBins/2)) &  keep(f(i)+1)+ceil(nBins/2) < length(ts) 
%         keep = [keep; [ceil(nBins/2) + 1:keep(f(i)+1)+ceil(nBins/2)]'];    
%     elseif keep(f(i)) > ceil(nBins/2) & ~(keep(f(i)+1)+ceil(nBins/2) < length(ts))
%         keep = [keep; [keep(f(i))-ceil(nBins/2):length(ts)- ceil(nBins/2)]'];    
%     end
end

keep = sort(unique(keep));
% keep(keep>0)=[];

%% start smoothing
for ii = 1:length(keep)
    i = keep(ii);
    ind = (i-ceil(nBins/2):i+ceil(nBins/2));
    ind(ind<1) = [];
    ind(ind>length(ts)) = [];
    [loc] = ~ismember(ind,exclude);
    
%     if ~isempty(loc) & sum(loc) > 0
        switch method
            case 'median'
                ts_smooth(i) = circ_median(ts(ind(loc)));
            case 'mean'
                ts_smooth(i) = circ_mean(ts(ind(loc)));
>>>>>>> master
            case 'guassian'

            case 'interp' 
                
        end
<<<<<<< HEAD
    end
    
end

=======
%     else
%         ts_smooth(ind) = ts(i);    
%     end
    
end

ts_smooth(isnan(ts_smooth)) = 0;
% there's a lot of indexing going on, so let's double check the returned
% time series didn't change length...
if length(ts_smooth) ~= length(ts)
   error('output TS is the wrong length!') 
end
>>>>>>> master








