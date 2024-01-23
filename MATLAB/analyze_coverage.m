function [k, sd, fc] = analyze_coverage(filepath)
    k = [];
    sd = [];
    fc = [];

    fp = fopen(filepath, "r");

    while ~feof(fp)
        line = fgetl(fp);
        if contains(line, "K =")
            k_i = sscanf(line, "K = %f");
            k = [k k_i];
        end

        if contains(line, "Simulation duration")
            sd_i = sscanf(line, "Simulation duration: %ds");
            sd = [sd sd_i];
        end

        if contains(line, "Fault coverage")
            fc_i = sscanf(line, "Fault coverage: %f%%");
            fc = [fc fc_i];
        end
    end

    fclose(fp);
end