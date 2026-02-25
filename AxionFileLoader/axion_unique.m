function values = axion_unique(input_values)
%AXION_UNIQUE Minimal unique() replacement for numeric vectors.

    if isempty(input_values)
        values = input_values;
        return;
    end

    sorted_values = sort(input_values(:).');
    keep_mask = [true, diff(double(sorted_values)) ~= 0];
    values = sorted_values(keep_mask);
end
