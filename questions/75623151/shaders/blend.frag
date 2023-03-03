#version 440

layout(location = 0) in vec2 qt_TexCoord0;
layout(location = 0) out vec4 fragColor;

layout(binding = 1) uniform sampler2D sourceTop;
layout(binding = 2) uniform sampler2D sourceBottom;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
};

void main()
{
    vec4 top = texture(sourceTop, qt_TexCoord0);
    vec4 bottom = texture(sourceBottom, qt_TexCoord0);
    fragColor = mix(top, bottom, qt_TexCoord0.y);
}
