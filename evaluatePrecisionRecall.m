function evaluatePrecisionRecall(sequence_number)

    %ds load saved confusion matrix
    confusion_matrix = dlmread(strcat('confusion_matrix_', sequence_number, '.txt'));
    disp(['loaded confusion matrix: ', num2str(size(confusion_matrix))]);
    dim = length(confusion_matrix);

    %ds retrieve maximum score
    maximum_score = max(max(confusion_matrix));
    disp(['maximum score: ', num2str(maximum_score)]);

    %ds load closure ground truth
    valid_closures = dlmread(strcat('datasets/kitti/ground_truth/closures_', sequence_number, '.txt'));
    disp(['loaded closures: ', num2str(length(valid_closures))]);
    number_of_feasible_closures = length(valid_closures);

    %ds while decreasing the matching score from maximum to zero in 100 steps
    recall = 0;
    minimum_score = maximum_score;
    results = [0, 0, 1, 0];
    while (recall < 1)

       %ds decrease minimum required score by 5%
       minimum_score = 0.99*minimum_score;

       %ds counters
       number_of_reported_closures = 0;
       number_of_valid_closures    = 0;

       %ds scan the complete confusion matrix
       for query = 1:dim
           for reference = 1:dim
               if (confusion_matrix(query, reference) > minimum_score)
                   number_of_reported_closures = number_of_reported_closures+1;

                   if (ismember([query, reference], valid_closures, 'rows'))
                        number_of_valid_closures = number_of_valid_closures+1;
                   end
               end
           end
       end

       precision = number_of_valid_closures/number_of_reported_closures;
       recall    = number_of_reported_closures/number_of_feasible_closures;
       disp(['score: ', num2str(minimum_score), ...
             ' precision: ', num2str(precision), ...
             ' recall: ', num2str(recall)]);
       results = [results; [minimum_score, number_of_reported_closures, precision, recall]];
    end

    %ds save to file
    save('precision_recall-netvlad.txt', 'results', '-ascii');
end
