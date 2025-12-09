#include "lab/lab02/lab02.h"
#include "core/gpu/vertex_format.h"

#include <ranges>
#include <vector>
#include <gcem.hpp>

using namespace lab;

Lab02::Lab02()
{
    window->SetSize(1280, 720);
}


Lab02::~Lab02()
{
}

void Lab02::Initialize()
{
    image->Init(1280, 720, 3 /* channels */);
    depthImage->Init(1280, 720);

    {
        std::vector<VertexFormat> vertices
        {
            VertexFormat(glm::vec3(290, 90,  0.5), glm::vec3(1, 0, 0)),
            VertexFormat(glm::vec3(1099, 450,  0.5), glm::vec3(0, 1, 0)),
            VertexFormat(glm::vec3(650, 719,  0.5), glm::vec3(0, 0, 1)),

            VertexFormat(glm::vec3(200, 450,  0), glm::vec3(0, 1, 1)),
            VertexFormat(glm::vec3(830, 719,  1), glm::vec3(1, 1, 0)),
            VertexFormat(glm::vec3(1099, 0,  1), glm::vec3(1, 0, 1)) };

        std::vector<std::size_t> indices
        {
            0, 1, 2,    // indices for first triangle
            3, 4, 5,    // indices for second triangle
        };

        Rasterize(vertices, indices);
    }
    
    // bonus: un disc
    {
        constexpr int NVERTICES = 1000;
        constexpr std::array<VertexFormat, NVERTICES+1> vertices = []{
            std::array<VertexFormat, NVERTICES+1> v{};
            v[0] = VertexFormat(glm::vec3(640, 360, 0), glm::vec3(1, 0, 0));
            for(std::size_t i=0; i<NVERTICES; ++i)
                v[i+1] = VertexFormat(v[0].position + 100.0f * glm::vec3(gcem::cos(2*std::numbers::pi_v<float>*i/NVERTICES), 
                                                                         gcem::sin(2*std::numbers::pi_v<float>*i/NVERTICES),
                                                                         0), 
                                      glm::vec3(1, 0, 0));
            return v;
        }();
        // constexpr std::array<VertexFormat, NVERTICES> vertices = []<std::size_t... I>(std::index_sequence<I...>){
        //     constexpr auto vertex_i = [](std::size_t i){
        //         return VertexFormat(glm::vec3(2*gcem::cos(std::numbers::pi_v<float>*i/NVERTICES), 
        //                                         gcem::sin(2*std::numbers::pi_v<float>*i/NVERTICES),
        //                                         0.5), 
        //                             glm::vec3(1, 0, 0));
        //     };
        //     return std::array <VertexFormat, NVERTICES>{ vertex_i(I)... };
        // }(std::make_index_sequence<NVERTICES>{});

        constexpr std::array<std::size_t, 3*NVERTICES> indices = []{
            std::array<std::size_t, 3*NVERTICES> v{};
            for(std::size_t i=0; i<NVERTICES; ++i)
            {
                v[3*i] = 0;
                v[3*i+1] = i+1;
                v[3*i+2] = i+2;
            }
            v[3*NVERTICES-1] = 1;
            return v;
        }();
        
        Rasterize(std::span<VertexFormat const, NVERTICES+1>(vertices), std::span<std::size_t const, 3*NVERTICES>(indices));
    }
}

void Lab02::Rasterize(
    const std::span<VertexFormat const> &vertices,
    const std::span<std::size_t const> &indices)
{
    for (int i = 0; i < indices.size(); i += 3) {
        auto v1 = vertices[indices[i]];
        auto v2 = vertices[indices[i+1]];
        auto v3 = vertices[indices[i+2]];

        TriangleRasterizer::Rasterize(
            v1, v2, v3, image, depthImage
        );
    }
}
