% Representation Similarity Analysis (RSA) based on the pattern of activation in the 
% right subiculum as identified in the a priori ROI analysis. Written for Matlab and 
% employs the AFNI Matlab Toolbox (https://sscc.nimh.nih.gov/afni/matlab/)
%
% This is step 1 in the analysis
%
% Brock Kirwan
% kirwan@byu.edu
% May 11, 2020

prefs.subjects = {...
'sub-1425'
'sub-1428'
'sub-1435'
'sub-1443'
'sub-1461'
'sub-1475'
'sub-1476'
'sub-1479'
'sub-1514'
'sub-1515'
'sub-1516'
'sub-1537'
'sub-1538'
'sub-1539'
'sub-1540'
'sub-1542'
'sub-1543'
'sub-1544'
'sub-1545'
'sub-1548'
'sub-1549'
'sub-1565'
'sub-1568'
'sub-1569'
'sub-1570'
'sub-1572'
'sub-1573'
'sub-1587'
'sub-1588'
'sub-1589'
'sub-1591'
'sub-1592'
'sub-1593'
'sub-1594'
'sub-1597'
'sub-1963'
'sub-2259'
'sub-2313'
'sub-2347'
'sub-2384'
'sub-2395'
'sub-2411'
'sub-2413'
'sub-2436'
'sub-2459'
'sub-2552'
'sub-2555'
'sub-2560'
};



%Hippocampal subfield mask (w/o partial voluming). Made with this command:
% 3dcalc -a Mask_L_Multi+tlrc. -b Mask_R_Multi+tlrc. -c Mask_L_CA1+tlrc. -d Mask_R_CA1+tlrc. -e Mask_L_Sub+tlrc. -f Mask_R_Sub+tlrc. -prefix Mask_all -expr "1*a+2*b+3*c+4*d+5*e+6*f"
prefs.title = 'Anatomical ROIS';
prefs.filename = 'mask_all_yassa_fractionized+tlrc';
prefs.validROInum = [1:18]; 
% ROIs: 
prefs.validROIname = {'LalEC', 'RalEC', 'LpmEC', 'RpmEC', 'LTPC', 'RTPC', 'LPRC', 'RPRC', 'LRSC', 'RRSC', 'LPHC', 'RPHC', 'LDGCA3', 'RDGCA3', 'LCA1', 'RCA1', 'LSUB', 'RSUB'};


%new deconv using REML method
prefs.deconv = 'mst_stats_REML+tlrc';
prefs.conds = [2 5 8 11]; %these are not 0-indexed.
prefs.condNames = {'CR' 'Hit' 'LureFA' 'LureCR'};

outName = [prefs.filename '.txt'];

% if exist(outName, 'file')
%     command = ['rm ' prefs.filename '.txt'];
%     unix(command);
% end


%Run 3dROIstats
meanData = zeros(length(prefs.conds),length(prefs.validROInum));

%generate the 3dROIstats output if haven't already
if ~exist(outName,'file')
    %put all the subjects into a string for the loop
    subjects = [];
    for i = 1:length(prefs.subjects)
        subjects = [subjects ' ../../' prefs.subjects{i} ...
            '/' prefs.deconv ' '];
    end
    
    %you'll have to change the relative path for AFNI
    %[status, path2program] = unix('which 3dROIstats');
    %path2program = path2program(1:end-1);
    %path2program = '/usr/local/afni/3dROIstats';
    path2program = '/usr/local/bin/afni/3droistats';
    
    cmd =['for i in ' subjects '; do ' path2program ' -mask '...
        prefs.filename ' -mask_f2short ${i} >> '...
        outName '; done'];
    unix(cmd);
end

fid = fopen(outName);
temp = textscan(fid, '%s', 'delimiter', '\t'); %read whole thing into temp variable
fclose(fid);

%count the number of ROIs
nroi = 0;
for i = 3:length(temp{:}) %assumes first 2 elements are 'File' and 'Sub-brik'
    if strncmpi('Mean',temp{1}(i),4) == 1;
        nroi = nroi + 1;
    else
        break
    end
end

%set up the string format according to how many ROIs you have
form = ['%s %s'];
for i = 1:nroi;
    form = [form ' %s'];
end

%open the file and read in the data again in correct format
%this gives you an array of cells with #ROIs + 2 columns
fid = fopen(outName);
file = textscan(fid, form, 'delimiter', '\t');
fclose(fid);

%now count how many conditions you have
ncond = 0;
for i = 2:length(file{1}) %assumes the first one is 'File'
    if strcmp('File',file{1}(i)) == 0
        ncond = ncond + 1;
    else
        break
    end
end

%count the number of subjects
nsub = 0;
for i = 1:length(file{1})
    if strcmp('File',file{1}(i)) == 1
        nsub = nsub + 1;
    end
end

%put the data into a matrix
data = zeros(ncond,nroi,nsub);
for cond = 1:ncond
    sub = 1;
    for i = 1:length(file{2})
        condName = char(file{2}(i)); %3dROIstats compile date May 27 2008 outputs more info than it used to...
        numEnd = strfind(condName,'[')-1;
        if strcmp(condName(1:numEnd),num2str(cond-1)) == 1;
            for roi = 1:nroi
                data(cond,roi,sub) = str2num(file{roi+2}{i});
            end
            sub = sub+ 1;
        end
    end
end

%drop the conditions you don't care about, keep the ones you do
data = data(prefs.conds,:,:);
ncond = length(prefs.conds);

%and drop the ROI's you're not interested in
data = data(:,prefs.validROInum,:);
nroi = length(prefs.validROInum);


%% Correlation analysis

%load the cortical mask
[mask_err, mask, mask_info] = BrikLoad('Intersection_GM_mask+tlrc.BRIK');

%loop through subjects
 for sub = 1:nsub

    %tell me who you're working on
    display(['working on subject ' prefs.subjects{sub}]);
    
    %load deconvolve data. Hard-coding the blurred version of the
    %deconvolve
    %[err, V, Info, ErrMessage] = BrikLoad(['../../' prefs.subjects{sub} '/mst_stats_REML_blur2+tlrc']);
    %not hard-coded; use whatever is specified above. In this case, the not-blurred version.
    [err, V, Info, ErrMessage] = BrikLoad(['../../' prefs.subjects{sub} '/'  prefs.deconv]);

    %loop through the voxels, calculate correlation with mean betas from
    %RSUB ROI (also loop through ROIs?)
    dims = size(V);
    r=zeros(dims(1:3));
    for x = 1:dims(1)
        for y = 1:dims(2)
            for z = 1:dims(3)
                if mask(x,y,z) == 1 %if it's within the cortical mask
                    r(x,y,z) = corr(squeeze(V(x,y,z,prefs.conds)),data(:,18,sub));
                end
            end
        end
    end
   
%     %write out the correlation file for this subject
%     opt.Prefix = [prefs.subjects{sub} '_r'];
%     opt.View = '+tlrc';
%     Info.BRICK_LABS='Correl';
%     if ~isfile([opt.Prefix opt.View '.BRIK'])
%         WriteBrik(r,Info,opt);
%     end

    %z-transform the correlation
    z = atanh(r);
    
    %get rid of NANs
    z(isnan(z)) = 0;
    
    %write out the correlation file for this subject
    opt.Prefix = [prefs.subjects{sub} '_z'];
    opt.View = '+tlrc';
    Info.BRICK_LABS='zCorrel';
    if ~isfile([opt.Prefix opt.View '.BRIK'])
        %WriteBrik(r,Info,opt); %ugh. I was writing out the raw correlations, not the z-transformed values
        WriteBrik(z,Info,opt);
    end

%     %the input was blurred, so I don't need this
%     %blur the output
%     [status, path2program] = unix('which 3dmerge');
%     path2program = path2program(1:end-1);
%     
%     cmd = [path2program ' -prefix ' opt.Prefix '_blur5 -1blur_fwhm 5 -doall ' opt.Prefix opt.View];
%     unix(cmd)
    
end

    