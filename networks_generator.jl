using CSV, DataFrames, Dates
using PyCall

include("./src/cubes.jl")
include("./src/network.jl")
include("./src/motifs_discovery.jl")
include("./src/motifs_analysis.jl")


# Read data
path = "./data/"
region = "california"
filepath = path * region * ".csv"

df_full = CSV.read(filepath, DataFrame);

# Filters
if region == "vrancea"
    df = df_full[df_full.Datetime .> DateTime(1988,1,1,0,0,0),:];
elseif region == "california"
    df = df_full[df_full.Datetime .> DateTime(1988,1,1,0,0,0),:];
elseif region == "italy"
    df = df_full[df_full.Datetime .> DateTime(1988,1,1,0,0,0),:];
elseif region == "japan"
    df = df_full[df_full.Datetime .> DateTime(1988,1,1,0,0,0),:];
end


#######################################################################################################
### NETWORKS
#######################################################################################################

for side in [1, 3, 5, 7, 10, 15, 20]
    # Make target path for results
    network_target_path = "./networks/$(region)/side_$(string(side))km/"
    mkpath(network_target_path)

    for minimum_magnitude in [2, 3, 4]
        # filter database based on minimum Magnitude
        df_filtered = df[df.Magnitude .> minimum_magnitude,:] 

        # Split into cubes
        df_filtered, df_filtered_cubes = region_cube_split(df_filtered,side=side,energyRelease=true);

        # Create network
        MG = create_network(df_filtered, df_filtered_cubes; edgeWeight=false)
        # connectivity = degree(MG);

        # Collect edge list for nemomap
        df_filtered_edge_list = collect(edges(MG)) |> DataFrame;
        
        # Choose filename
        network_filename = "$(region)_side_$(string(side))km_minmag_$(string(minimum_magnitude)).txt"

        # Save to path (defined earlier) with proper filename
        CSV.write(network_target_path * network_filename, df_filtered_edge_list, delim=" ", header=false);
    end
end



#######################################################################################################
### MOTIFS
#######################################################################################################

#######################################################################################################
# TESTS #

motif = "Triangle"
side = 5
minimum_magnitude = 3

network_target_path = "./networks/$(region)/side_$(string(side))km/"
network_filename = "$(region)_side_$(string(side))km_minmag_$(string(minimum_magnitude)).txt"
inputName = network_target_path * network_filename
queryName = "query$(motif).txt"

stats =  motifs_discovery(inputName,queryName)

# Move csv and rename
motif_filename = "motif$(motif)_$(region)_side_$(string(side))km_minmag_$(string(minimum_magnitude)).csv"
mv("output.csv", network_target_path * motif_filename)

# TESTS #
#######################################################################################################




for side in [1, 3, 5, 7, 10, 15, 20]
    # select target path for networks
    network_target_path = "./networks/$(region)/side_$(string(side))km/"

    for minimum_magnitude in [2, 3, 4]
        network_filename = "$(region)_side_$(string(side))km_minmag_$(string(minimum_magnitude)).txt"

        queryName = network_target_path * network_filename
        inputName = "query$(motif)"


    end
end