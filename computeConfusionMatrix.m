%  [mAP, APs]= relja_retrievalMAP(db, searcher, verbose, kTop)
%
%  Author: Relja Arandjelovic (relja@relja.info)

function computeConfusionMatrix(db, searcher, verbose, suffix)
    if nargin<3, verbose= true; end
    
    %ds adjust accordingly based on subsampling
    minimum_query_interspace = 500;
    disp(minimum_query_interspace);
    
    if isa(searcher, 'function_handle')
        disp('using default searcher');
    else
        disp('using YAEL searcher');
    end
    
    %ds allocate confusion matrix
    confusion_matrix = zeros(db.numQueries, db.numQueries);

    for iQuery= 1:db.numQueries
        if verbose
            relja_progress(iQuery, db.numQueries);
        end
        
        %ds highest possible reference image number
        iReferenceMax = max(iQuery-minimum_query_interspace, 1);
        
        %ds if we can match
        if (iReferenceMax > 1)
            if isa(searcher, 'function_handle')
                ids= searcher(iQuery);
            else
                % this is likely to be faster:
                reference_db = searcher.db(:,1:iReferenceMax);
                [ids, ~]= yael_nn(reference_db, searcher.qs(:,iQuery), size(reference_db, 2));
                % if you don't have yael_nn, do this:
                % distsSq= sum( bsxfun(@minus, searcher.qs(:, iQuery), searcher.db).^2, 1 );
                % [~, ids]= sort(distsSq); ids= ids';
            end

            %ds save score to matrix
            %disp(['matches for query id: ', num2str(iQuery), ' = ', num2str(ids(1:10)')]);
            %disp(['top confidence 1: ', num2str(norm(searcher.db(:,ids(1))-searcher.qs(:,iQuery), 2))]);
            %disp(['top confidence 2: ', num2str(norm(searcher.db(:,ids(2))-searcher.qs(:,iQuery), 2))]);
            %disp(['top confidence 3: ', num2str(norm(searcher.db(:,ids(3))-searcher.qs(:,iQuery), 2))]);
            for i = 1:length(ids)
                iReference = ids(i);
                confusion_matrix(iQuery, iReference) = 1/norm(searcher.db(:,iReference)-searcher.qs(:,iQuery), 2);
            end
        end
    end
    
    %ds save map to file
    file_name = strcat('confusion_matrix_', suffix, '.txt');
    save(file_name, 'confusion_matrix', '-ascii');
end
