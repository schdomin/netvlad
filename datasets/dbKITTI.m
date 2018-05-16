% Author: Relja Arandjelovic (relja@relja.info)

function db= dbKITTI(sequence)
    
    %ds configure
    db.name= 'kitti';
    paths= localPaths();
   
    %ds set folders
    dsetRootKITTI= relja_expandUser(paths.dsetRootKITTI);
    db.dbPath= [dsetRootKITTI, 'images_', sequence, '/'];
    db.qPath= db.dbPath;
    disp(['reference image path: ', db.dbPath]);
    disp(['query image path: ', db.qPath]);

    file_names = relja_dir(db.dbPath);
    
    %ds subsample images - for value 1, no subsampling is done
    db.dbImageFns = file_names(1);
    subsampling_factor = 1;
    disp(['loading images with subsampling: ', num2str(subsampling_factor)]);
    for i = 2:length(file_names)
        if (mod(i, subsampling_factor) == 0)
            db.dbImageFns = [db.dbImageFns, file_names(i)];
        end
    end
    
    db.numImages = length(db.dbImageFns);
    disp(['total number of images: ', num2str(db.numImages)]);
    
    %ds get gt info
    %gtDir= sprintf('%sgroundtruth/', dsetRoot);
    %dirlist= dir(gtDir);
    %dirlist= sort({dirlist.name});
    
    %ds initialize query structure
    db.numQueries= db.numImages;
    db.qImageFns= cell( db.numQueries, 1 );
    
    %ds add all queries
    for i = 1:length(db.dbImageFns)
        db.qImageFns(i) = db.dbImageFns(i);
    end
end
