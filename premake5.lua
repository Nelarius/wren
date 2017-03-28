workspace "wren"
    local root = "util/".._ACTION
    local libuv = "deps/libuv/"

    if _ACTION then
        location(root)
    end

    configurations { "Debug", "Release" }
    platforms { "Win32", "x64" }

    filter "platforms:Win32"
        architecture "x86"

    filter "platforms:x64"
        architecture "x86_64"

    filter "configurations:Debug"
        targetsuffix "_d"
        symbols "On"

    filter "configurations:Release"
        defines "NDEBUG"
        optimize "On"

    filter "action:vs*"
        defines { "_CRT_SECURE_NO_WARNINGS" }

    project "wren"
        location(root.."/wren")
        kind "ConsoleApp"
        language "C"
        targetdir "bin"
        includedirs { "src/include", "src/vm", "src/optional", "src/module", "src/cli", libuv.."/include" }
        files { "src/**.c", "src/**.h" }
        -- filter "platforms:Win32"
        --     prebuildcommands { "python ../../build_libuv.py -32"}
        -- filter "platforms:x64"
        --     prebuildcommands { "python ../../build_libuv.py -64"}
        filter "*"
        libdirs { libuv.."/Release/lib" }
        links { "libuv", "userenv", "advapi32", "iphlpapi", "psapi", "shell32", "ws2_32" }

    project "wren_lib"
        location(root.."/lib")
        kind "StaticLib"
        language "C"
        targetdir "lib"
        targetname "wren_static"
        files { "src/vm/**.c", "src/vm/**.h", "src/optional/**.c", "src/optional/**.h" }
        includedirs { "src/include", "src/vm", "src/optional" }
