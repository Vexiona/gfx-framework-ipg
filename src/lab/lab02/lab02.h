#pragma once

#include "components/software_rendering_scene.h"
#include "core/gpu/frame_buffer.h"

#include "triangle_rasterizer.h"

namespace lab
{
    class Lab02 : public gfxc::SoftwareRenderScene
    {
     public:
        Lab02();
        ~Lab02();

        void Initialize() override;

     private:
        void Rasterize(
            const std::span<VertexFormat const> &vertices,
            const std::span<std::size_t const> &indices);
    };
}   // namespace lab
