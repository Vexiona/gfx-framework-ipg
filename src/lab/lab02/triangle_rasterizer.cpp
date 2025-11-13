#include "lab/lab02/triangle_rasterizer.h"

#include <vector>
#include <iostream>

using namespace std;
using namespace lab;

void TriangleRasterizer::Rasterize(
    const VertexFormat &v1,
    const VertexFormat &v2,
    const VertexFormat &v3,
    Image *image,
    DepthImage *depthImage)
{
    float xMin = min(v1.position.x, min(v2.position.x, v3.position.x));
    float yMin = min(v1.position.y, min(v2.position.y, v3.position.y));
    float xMax = max(v1.position.x, max(v2.position.x, v3.position.x));
    float yMax = max(v1.position.y, max(v2.position.y, v3.position.y));

    for (int row = yMin; row < yMax; row++) {
        for (int column = xMin; column < xMax; column++) {

            if (row < 0 || row >= image->GetHeight() ||
                column < 0 || column >= image->GetWidth()) {
                continue;
            }

            glm::vec2 p(column + 0.5f, row + 0.5f);



            const float EPSILON = 5.0f;

            float bari_c = (v2.position.x - v1.position.x) * (p.y - v2.position.y) - (v2.position.y - v1.position.y) * (p.x - v2.position.x);
            float bari_a = (v3.position.x - v2.position.x) * (p.y - v3.position.y) - (v3.position.y - v2.position.y) * (p.x - v3.position.x);
            float bari_b = (v1.position.x - v3.position.x) * (p.y - v1.position.y) - (v1.position.y - v3.position.y) * (p.x - v1.position.x);



            if((bari_a < EPSILON && bari_b < EPSILON && bari_c < EPSILON) || (bari_a > -EPSILON && bari_b > -EPSILON && bari_c > -EPSILON))
            {
                float depth = (bari_a * v1.position.z + bari_b * v2.position.z + bari_c * v3.position.z) / (bari_a + bari_b + bari_c);
                float pixelDepth = depthImage->Get(row, column).x;

                if (pixelDepth > depth) {
                    glm::vec3 color((bari_a * v1.color + bari_b * v2.color + bari_c * v3.color) / (bari_a + bari_b + bari_c));
                    image->Set(row, column, color);
                    depthImage->Set(row, column, glm::vec3(depth, 0, 0));
                }
            }
        }
    }
}

// float TriangleRasterizer::ComputeTriangleArea(
//     const glm::vec2 &v1,
//     const glm::vec2 &v2,
//     const glm::vec2 &v3)
// {
//     // TODO(student): Ex. 1

//     //twice the signed area
//     return (v2.x-v1.x)*(v3.y-v2.y) - (v2.y-v1.y)*(v3.x-v2.x);
// }

// bool TriangleRasterizer::CheckPointInsideTriangle(
//     const glm::vec2 &p,
//     const VertexFormat &v1,
//     const VertexFormat &v2,
//     const VertexFormat &v3)
// {
//     const float EPSILON = 5.0f;

//     // TODO(student): Ex. 1

//     glm::vec2 v12 = v2.position-v1.position;
//     glm::vec2 v23 = v3.position-v2.position;
//     glm::vec2 v31 = v1.position-v3.position;

//     float bari_c = v12.x * (p.y - v2.position.y) - v12.y * (p.x - v2.position.x);
//     float bari_b = v23.x * (p.y - v3.position.y) - v23.y * (p.x - v3.position.x);
//     float bari_a = v31.x * (p.y - v1.position.y) - v31.y * (p.x - v1.position.x);

//     return (bari_a < EPSILON && bari_b < EPSILON && bari_c < EPSILON) || (bari_a > -EPSILON && bari_b > -EPSILON && bari_c > -EPSILON);
// }

// glm::vec3 TriangleRasterizer::ComputePixelColor(
//     const glm::vec2 &p,
//     const VertexFormat &v1,
//     const VertexFormat &v2,
//     const VertexFormat &v3)
// {
//     // TODO(student): Ex. 2

//     return v3.color;
// }

// float TriangleRasterizer::ComputePixelDepth(
//     const glm::vec2 &p,
//     const VertexFormat &v1,
//     const VertexFormat &v2,
//     const VertexFormat &v3)
// {
//     // TODO(student): Ex. 3

//     return v3.position.z;
// }
