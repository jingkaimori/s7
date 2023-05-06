
set_allowedmodes("debug","release")
set_allowedplats("bsd", "cross", "cygwin", "linux", "macosx", "mingw", "msys", "wasm", "windows")
option("repl") 
    set_default(false)
option_end()
option("lib") 
    set_default(true)
option_end()
option("gmp")
    set_default(false)
    add_defines("WITH_GMP")
option_end()

if is_config("gmp", true) then
    add_requires("gmp")
end
if is_plat("windows", "linux", "macosx", "mingw") then
    add_requires("icu4c")
end

target("libs7") do
    set_enabled(is_config("lib", true))
    set_optimize("faster")
    add_packages("icu4c")
    add_files("s7.c")
    add_headerfiles("s7.h")
    add_includedirs(".", {public = true})
    add_options("gmp")
    set_kind("static")
    add_cflags({"-Wall","-Wextra"})
    if is_config("gmp", true) then
        add_packages("gmp")
    end
    if is_mode("debug") then
        add_defines("S7_DEBUGGING")
    end
end

target("s7") do
    set_enabled(is_config("repl", true))
    set_optimize("faster")
    add_defines("WITH_MAIN")
    add_packages("icu4c")
    add_files("s7.c")
    add_headerfiles("s7.h")
    add_includedirs(".", {public = true})
    add_options("gmp")
    set_kind("binary")
    if is_config("gmp", true) then
        add_packages("gmp")
    end
    if is_mode("debug") then
        add_defines("S7_DEBUGGING")
    end
    add_ldflags({"-static", "-static-libgcc"})
end

target("test-block") do 
    add_packages("icu4c")
    set_kind("shared")
    add_deps("libs7")
    add_files("tools/s7test-block.c")
    set_optimize("faster")
end

target("test-sample") do 
    add_linkdirs("$(projectdir)")
    set_kind("binary")
    add_deps("libs7")
    add_files("tools/s7test.c")
    set_optimize("faster")
    add_ldflags({"-static", "-static-libgcc"})
end

target("test-ffi") do 
    add_packages("icu4c")
    set_kind("binary")
    add_deps("libs7")
    if is_config("gmp", true) then
        add_packages("gmp")
    end
    add_options("gmp")
    add_files("tools/ffitest.c")
    set_optimize("faster")
end

