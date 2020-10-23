workspace "Tron"
    architecture "x64"

    configurations {
        "Debug",
        "Release",
        "Dist"
    }

startproject "Sandbox"

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

-- Include directories relative to root folder (solution directory)
IncludeDir = {}
IncludeDir["GLFW"] = "Tron/vendor/GLFW/include"
IncludeDir["Glad"] = "Tron/vendor/Glad/include"
IncludeDir["ImGui"] = "Tron/vendor/imgui"

group "Dependencias"
    include "Tron/vendor/GLFW"
    include "Tron/vendor/Glad"
    include "Tron/vendor/imgui"

group ""


project "Tron"
    location "Tron"
    kind "SharedLib"
    language "C++"
    staticruntime "off"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    pchheader "tnpch.h"
    pchsource "Tron/src/tnpch.cpp"

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs {
        "%{prj.name}/src",
        "%{prj.name}/vendor/spdlog/include",
        "%{IncludeDir.GLFW}",
        "%{IncludeDir.Glad}",
        "%{IncludeDir.ImGui}"
    }

    links {
        "GLFW",
        "Glad",
        "ImGui",
        "opengl32.lib"
    }

    filter "system:windows"
        cppdialect "C++17"
        systemversion "latest"

        defines {
            "TN_PLATFORM_WINDOWS",
            "TN_BUILD_DLL",
            "GLFW_INCLUDE_NONE"
        }

        postbuildcommands {
            ("{COPY} %{cfg.buildtarget.relpath} \"../bin/" .. outputdir .. "/Sandbox/\"")
        }

    filter "configurations:Debug"
        defines "TN_DEBUG"
        runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "TN_RELEASE"
        runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        defines "TN_DIST"
        runtime "Release"
        optimize "On"

project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"
    staticruntime "off"

    targetdir ("bin/" .. outputdir .. "/%{prj.name}")
    objdir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files {
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp"
    }

    includedirs {
        "Tron/src",
        "Tron/vendor/spdlog/include"
    }

    links {
        "Tron"
    }

    filter "system:windows"
        cppdialect "C++17"
        systemversion "latest"

        defines {
            "TN_PLATFORM_WINDOWS"
        }

    filter "configurations:Debug"
        defines "TN_DEBUG"
        runtime "Debug"
        symbols "On"

    filter "configurations:Release"
        defines "TN_RELEASE"
        runtime "Release"
        optimize "On"

    filter "configurations:Dist"
        defines "TN_DIST"
        runtime "Release"
        optimize "On"