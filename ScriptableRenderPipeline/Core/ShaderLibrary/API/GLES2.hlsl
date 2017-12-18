#ifndef SHADER_API_GLES
#error GLES.hlsl should not be included if SHADER_API_GLES is not defined
#endif

#define UNITY_UV_STARTS_AT_TOP 0
#define UNITY_REVERSED_Z 0
#define UNITY_GATHER_SUPPORTED 0
#define UNITY_NEAR_CLIP_VALUE (-1.0)

// This value will not go through any matrix projection convertion
#define UNITY_RAW_FAR_CLIP_VALUE (1.0)
#define FRONT_FACE_SEMATIC VFACE
#define FRONT_FACE_TYPE float
#define IS_FRONT_VFACE(VAL, FRONT, BACK) ((VAL > 0.0) ? (FRONT) : (BACK))

#define CBUFFER_START(name)
#define CBUFFER_END

#define uint int
#define uint1 int1
#define uint2 int2
#define uint3 int3
#define uint4 int4

#define min16uint int
#define min16uint1 int1
#define min16uint2 int2
#define min16uint3 int3
#define min16uint4 int4

#define uint1x1 int1x1
#define uint1x2 int1x2
#define uint1x3 int1x3
#define uint1x4 int1x4
#define uint2x1 int2x1
#define uint2x2 int2x2
#define uint2x3 int2x3
#define uint2x4 int2x4
#define uint3x1 int3x1
#define uint3x2 int3x2
#define uint3x3 int3x3
#define uint3x4 int3x4
#define uint4x1 int4x1
#define uint4x2 int4x2
#define uint4x3 int4x3
#define uint4x4 int4x4

#define rcp(x) 1.0 / x
#define ddx_fine ddx
#define ddy_fine ddy
#define asfloat
#define asuint(x) asint(x)
#define f32tof16
#define f16tof32

#define ERROR_ON_UNSUPPORTED_FUNCTION(funcName) #error ##funcName is not supported on GLES 2.0

// Initialize arbitrary structure with zero values.
// Do not exist on some platform, in this case we need to have a standard name that call a function that will initialize all parameters to 0
#define ZERO_INITIALIZE(type, name) name = (type)0;
#define ZERO_INITIALIZE_ARRAY(type, name, arraySize) { for (int arrayIndex = 0; arrayIndex < arraySize; arrayIndex++) { name[arrayIndex] = (type)0; } }

// GLES2 might not have shadow hardware comparison support
#if defined(UNITY_ENABLE_NATIVE_SHADOWS_LOOKUPS)
#define SHADOW2D_TEXTURE_AND_SAMPLER sampler2DShadow
#define SHADOWCUBE_TEXTURE_AND_SAMPLER samplerCUBEShadow
#define SHADOW2D_SAMPLE(textureName, samplerName, coord3) shadow2D(textureName, coord3)
#define SHADOWCUBE_SAMPLE(textureName, samplerName, coord4) ((texCUBE(textureName,(coord4).xyz) < (coord4).w) ? 0.0 : 1.0)
#else
// emulate hardware comparison
#define SHADOW2D_TEXTURE_AND_SAMPLER sampler2D_float
#define SHADOWCUBE_TEXTURE_AND_SAMPLER samplerCUBE_float
#define SHADOW2D_SAMPLE(textureName, samplerName, coord3) ((SAMPLE_DEPTH_TEXTURE(textureName, samplerName, (coord3).xy) < (coord3).z) ? 0.0 : 1.0)
#define SHADOWCUBE_SAMPLE(textureName, samplerName, coord4) ((texCUBE(textureName,(coord4).xyz).r < (coord4).w) ? 0.0 : 1.0)
#endif

// Texture util abstraction

#define CALCULATE_TEXTURE2D_LOD(textureName, samplerName, coord2) #error calculate Level of Detail not supported in GLES2

// Texture abstraction

#define TEXTURE2D(textureName)                          sampler2D textureName
#define TEXTURE2D_ARRAY(textureName)                    samplerCUBE textureName // No support to texture2DArray
#define TEXTURECUBE(textureName)                        samplerCUBE textureName
#define TEXTURECUBE_ARRAY(textureName)                  samplerCUBE textureName // No supoport to textureCubeArray and can't emulate with texture2DArray
#define TEXTURE3D(textureName)                          sampler3D textureName

#define TEXTURE2D_SHADOW(textureName)                   SHADOW2D_TEXTURE_AND_SAMPLER textureName
#define TEXTURE2D_ARRAY_SHADOW(textureName)             TEXTURECUBE_SHADOW(textureName) // No support to texture array
#define TEXTURECUBE_SHADOW(textureName)                 SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
#define TEXTURECUBE_ARRAY_SHADOW(textureName)           TEXTURECUBE_SHADOW(textureName) // No support to texture array

#define RW_TEXTURE2D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture2D)
#define RW_TEXTURE3D(type, textureNam)                  ERROR_ON_UNSUPPORTED_FUNCTION(RWTexture3D)

#define SAMPLER(samplerName)
#define SAMPLER_CMP(samplerName)

#define TEXTURE2D_ARGS(textureName, samplerName)                sampler2D textureName
#define TEXTURE2D_ARRAY_ARGS(textureName, samplerName)          samplerCUBE textureName
#define TEXTURECUBE_ARGS(textureName, samplerName)              samplerCUBE textureName
#define TEXTURECUBE_ARRAY_ARGS(textureName, samplerName)        samplerCUBE textureName
#define TEXTURE3D_ARGS(textureName, samplerName)                sampler3D textureName
#define TEXTURE2D_SHADOW_ARGS(textureName, samplerName)         SHADOW2D_TEXTURE_AND_SAMPLER textureName
#define TEXTURE2D_ARRAY_SHADOW_ARGS(textureName, samplerName)   SHADOWCUBE_TEXTURE_AND_SAMPLER textureName
#define TEXTURECUBE_SHADOW_ARGS(textureName, samplerName)       SHADOWCUBE_TEXTURE_AND_SAMPLER textureName

#define TEXTURE2D_PARAM(textureName, samplerName)               textureName
#define TEXTURE2D_ARRAY_PARAM(textureName, samplerName)         textureName
#define TEXTURECUBE_PARAM(textureName, samplerName)             textureName
#define TEXTURECUBE_ARRAY_PARAM(textureName, samplerName)       textureName
#define TEXTURE3D_PARAM(textureName, samplerName)               textureName
#define TEXTURE2D_SHADOW_PARAM(textureName, samplerName)        textureName
#define TEXTURE2D_ARRAY_SHADOW_PARAM(textureName, samplerName)  textureName
#define TEXTURECUBE_SHADOW_PARAM(textureName, samplerName)      textureName

#define SAMPLE_TEXTURE2D(textureName, samplerName, coord2) tex2D(textureName, coord2)

#if (SHADER_TARGET >= 30)
    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) tex2Dlod(textureName, float4(coord2, 0, lod))
#else
    // No lod support. Very poor approximation with bias.
    #define SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, lod)
#endif

#define SAMPLE_TEXTURE2D_BIAS(textureName, samplerName, coord2, bias) tex2Dbias(textureName, float4(coord2, 0, bias))
#define SAMPLE_TEXTURE2D_GRAD(textureName, samplerName, coord2, ddx, ddy) SAMPLE_TEXTURE2D(textureName, coord2)
#define SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index) SAMPLE_TEXTURECUBE(textureName, samplerName, float3(coord2, index))
#define SAMPLE_TEXTURE2D_ARRAY_LOD(textureName, samplerName, coord2, index, lod) SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, float3(coord2, index), lod)
#define SAMPLE_TEXTURE2D_ARRAY_BIAS(textureName, samplerName, coord2, index, bias) SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, float3(coord2, index), bias)
#define SAMPLE_TEXTURECUBE(textureName, samplerName, coord3) texCUBE(textureName, coord3)
// No lod support. Very poor approximation with bias.
#define SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod) SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, lod)
#define SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias) texCUBEbias(textureName, float4(coord3, bias))
#define SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index) SAMPLE_TEXTURECUBE(textureName, samplerName, coord3)
#define SAMPLE_TEXTURECUBE_ARRAY_LOD(textureName, samplerName, coord3, index, lod) SAMPLE_TEXTURECUBE_LOD(textureName, samplerName, coord3, lod)
#define SAMPLE_TEXTURECUBE_ARRAY_BIAS(textureName, samplerName, coord3, index, bias) SAMPLE_TEXTURECUBE_BIAS(textureName, samplerName, coord3, bias)
#define SAMPLE_TEXTURE3D(textureName, samplerName, coord3) tex3D(textureName, coord3)

#define SAMPLE_TEXTURE2D_SHADOW(textureName, samplerName, coord3) SHADOW2D_SAMPLE(textureName, samplerName, coord3)
#define SAMPLE_TEXTURE2D_ARRAY_SHADOW(textureName, samplerName, coord3, index) SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, float4(coord3.xy, index, coord3.w))
#define SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4) SHADOWCUBE_SAMPLE(textureName, samplerName, coord4)
#define SAMPLE_TEXTURECUBE_ARRAY_SHADOW(textureName, samplerName, coord4, index) SAMPLE_TEXTURECUBE_SHADOW(textureName, samplerName, coord4)

#define SAMPLE_DEPTH_TEXTURE(textureName, samplerName, coord2) SAMPLE_TEXTURE2D(textureName, samplerName, coord2).r
#define SAMPLE_DEPTH_TEXTURE_LOD(textureName, samplerName, coord2, lod) SAMPLE_TEXTURE2D_LOD(textureName, samplerName, coord2, lod).r

#define LOAD_TEXTURE2D(textureName, unCoord2)                       half4(0, 0, 0, 0) // Not supported
#define LOAD_TEXTURE2D_LOD(textureName, unCoord2, lod)              half4(0, 0, 0, 0) // Not supported
#define LOAD_TEXTURE2D_MSAA(textureName, unCoord2, sampleIndex)     half4(0, 0, 0, 0) // Not supported
#define LOAD_TEXTURE2D_ARRAY(textureName, unCoord2, index)          half4(0, 0, 0, 0) // Not supported
#define LOAD_TEXTURE2D_ARRAY_LOD(textureName, unCoord2, index, lod) half4(0, 0, 0, 0) // Not supported

// Gather not supported. Fallback to regular texture sampling.
#define GATHER_TEXTURE2D(textureName, samplerName, coord2)                  SAMPLE_TEXTURE2D(textureName, samplerName, coord2).rrrr
#define GATHER_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index)     SAMPLE_TEXTURE2D_ARRAY(textureName, samplerName, coord2, index).rrrr
#define GATHER_TEXTURECUBE(textureName, samplerName, coord3)                SAMPLE_TEXTURECUBE(textureName, samplerName, coord3).rrrr
#define GATHER_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index)   SAMPLE_TEXTURECUBE_ARRAY(textureName, samplerName, coord3, index).rrrr