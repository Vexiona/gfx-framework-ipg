#pragma once

#include "utils/glm_utils.h"

namespace transform2D
{
    // Translation matrix
    inline glm::mat3 Translate(float translateX, float translateY)
    {
        // TODO(student): Ex. 1
        return glm::mat3(1, 0, 0, 0, 1, 0, translateX, translateY, 1);
    }

    // Scaling matrix
    inline glm::mat3 Scale(float scaleX, float scaleY)
    {
        // TODO(student): Ex. 1
        return glm::mat3(scaleX, 0, 0, 0, scaleY, 0, 0, 0, 1);
    }

    // Rotation matrix
    inline glm::mat3 Rotate(float radians)
    {
        // TODO(student): Ex. 1
        float sin = glm::sin(radians);
        float cos = glm::cos(radians);

        return glm::mat3(cos, sin, 0, -sin, cos, 0, 0, 0, 1);
    }

    struct ViewportSpace
    {
        ViewportSpace() : x(0), y(0), width(1), height(1) {}
        ViewportSpace(int x, int y, int width, int height)
            : x(x), y(y), width(width), height(height) {}
        int x;
        int y;
        int width;
        int height;
    };

    struct LogicSpace
    {
        LogicSpace() : x(0), y(0), width(1), height(1) {}
        LogicSpace(float x, float y, float width, float height)
            : x(x), y(y), width(width), height(height) {}
        float x;
        float y;
        float width;
        float height;
    };

    // Viewport transformation
    inline glm::mat3 Viewport(
        const LogicSpace& logic_space,
        const ViewportSpace& viewport_space)
    {
        // TODO(student): Ex. 1
        //
        // You can use the translation and scaling transformations
        float ratio_x = viewport_space.width/logic_space.width;
        float ratio_y = viewport_space.height/logic_space.height;
        return glm::transpose(glm::mat3(ratio_x, 0, -logic_space.x * ratio_x + viewport_space.x, 
                         0, ratio_y, -logic_space.y * ratio_y + viewport_space.y,
                         0, 0, 1));
    }

}   // namespace transform2D