module Mesopelagic

using NCDatasets, Glob, Missings

if (pwd() in LOAD_PATH) == false
    push!(LOAD_PATH, pwd());
end

mutable struct Map
    lon::Array{Float64}
    lat::Array{Float64}
    value::Array{Float64}
    z::Array{Float64}
end

woadatadir = ENV["HOME"] + "WM_GDrive" + "Data" + "WOA18"
