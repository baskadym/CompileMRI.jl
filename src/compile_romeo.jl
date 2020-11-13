function compile_romeo(path;
        app_name="romeo",
        filter_stdlibs=false,
        precompile_execution_file=abspath(joinpath(@__DIR__, "..", "test", "romeo_test.jl")),
        kw...)
    romeopath = joinpath(pathof(RomeoApp), "..", "..")
    tmp_romeopath = mktempdir()
    cp(romeopath, tmp_romeopath; force=true)
    create_app(tmp_romeopath, path; app_name=app_name, filter_stdlibs=filter_stdlibs, precompile_execution_file=precompile_execution_file, kw...)
    test_romeo(path, app_name)
end

function test_romeo(path, app_name)
    file = tempname()
    phasefile = abspath(joinpath(@__DIR__, "..", "test", "data", "small", "Phase.nii"))
    args = [phasefile, "-o", file]
    name = app_name * (Sys.iswindows() ? ".exe" : "")
    romeofile = joinpath(path, "bin", name)
    @assert isfile(romeofile)
    cmd = `$romeofile $args`
    @assert success(run(cmd))
end
