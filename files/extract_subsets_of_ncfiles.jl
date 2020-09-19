# # Extract subsets of data

# Load modules
using Plots
using NCDatasets
using Statistics: mean
using DataStructures
#import Pkg; Pkg.add("DataStructures")

# Setup run-time enviromnent
ENV["GKSwstype"] = "100"

# Find required files and print their info
CLIMA_NETCDF = "../netcdf/"; #location of .nc files
fnames = filter(x -> occursin("Spectra", x), readdir( CLIMA_NETCDF ) );
ds = NCDataset("$CLIMA_NETCDF/"fnames[1], "r")

# Load data of which the subset will be taken 
m = ds["m"][:];
m_t = ds["m_t"][:]; 
n = ds["n"][:]; 
lat = ds["lat"][:]; 
z = ds["level"][:] / 1e3; # height in kilometers
time = ds["time"][:];
spectrum_1d = ds["spectrum_1d"][:];

# Here, spectral output is truncated in height and time
new_time_ind = collect(2:1:3)
level_ind = 5

new_vars = Any["spectrum_1d"];
new_filename = "$CLIMA_NETCDF/subset_i_"*fnames[1]

new_dims = OrderedDict("m" => (m, Dict()),
                       "lat" => (lat, Dict()),
                       "time" => (time[new_time_ind], Dict()),)

new_vars = OrderedDict("spectrum_1d" => (spectrum_1d[:,:,level_ind,new_time_ind], ("m","lat","time"), Dict()))

# Open the new file
dss = Dataset(new_filename, "c") 

# Set dims and save them as vars
for (dn, (dv, da)) in new_dims
    defDim(dss, dn, length(dv))
end

for (dn, (dv, da)) in new_dims
    defVar(dss, dn, dv, (dn,), attrib = da)
end

# save physical variables
for (vn, (vv, vd, va)) in new_vars
    println(vd)
    defVar(dss, vn, vv, vd, attrib = va)
end

# Check the new file

dss_loaded = NCDataset(new_filename, "r")
m_ld = dss_loaded["m"][:];
lat_ld = dss_loaded["lat"][:]; 
time_ld = dss_loaded["time"][:];
spectrum_1d_ld = dss_loaded["spectrum_1d"][:];
fig = contourf( m_ld, lat_ld, (spectrum_1d_ld[:,:,2])', ylabel="lat", xlabel="m");
display(fig)

