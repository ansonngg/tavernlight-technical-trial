/*
 * Copyright (c) 2010-2020 OTClient <https://github.com/edubart/otclient>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include "paintershaderprogram.h"
#include "painter.h"
#include "texture.h"
#include "texturemanager.h"
#include "graphics.h"

// Change start
#include "client/map.h"
#include "client/game.h"
// Change end

#include <framework/core/clock.h>
#include <framework/platform/platformwindow.h>

// Change start
#include <client/creature.h>
// Change end

PainterShaderProgram::PainterShaderProgram()
{
    m_startTime = g_clock.seconds();
    m_opacity = 1;
    m_color = Color::white;
    m_time = 0;
}

void PainterShaderProgram::setupUniforms()
{
    bindUniformLocation(TRANSFORM_MATRIX_UNIFORM, "u_TransformMatrix");
    bindUniformLocation(PROJECTION_MATRIX_UNIFORM, "u_ProjectionMatrix");
    bindUniformLocation(TEXTURE_MATRIX_UNIFORM, "u_TextureMatrix");
    bindUniformLocation(COLOR_UNIFORM, "u_Color");
    bindUniformLocation(OPACITY_UNIFORM, "u_Opacity");
    bindUniformLocation(TIME_UNIFORM, "u_Time");
    bindUniformLocation(TEX0_UNIFORM, "u_Tex0");
    bindUniformLocation(TEX1_UNIFORM, "u_Tex1");
    bindUniformLocation(TEX2_UNIFORM, "u_Tex2");
    bindUniformLocation(TEX3_UNIFORM, "u_Tex3");
    bindUniformLocation(RESOLUTION_UNIFORM, "u_Resolution");

    setUniformValue(TRANSFORM_MATRIX_UNIFORM, m_transformMatrix);
    setUniformValue(PROJECTION_MATRIX_UNIFORM, m_projectionMatrix);
    setUniformValue(TEXTURE_MATRIX_UNIFORM, m_textureMatrix);
    setUniformValue(COLOR_UNIFORM, m_color);
    setUniformValue(OPACITY_UNIFORM, m_opacity);
    setUniformValue(TIME_UNIFORM, m_time);
    setUniformValue(TEX0_UNIFORM, 0);
    setUniformValue(TEX1_UNIFORM, 1);
    setUniformValue(TEX2_UNIFORM, 2);
    setUniformValue(TEX3_UNIFORM, 3);
    setUniformValue(RESOLUTION_UNIFORM, (float)m_resolution.width(), (float)m_resolution.height());
}

bool PainterShaderProgram::link()
{
    m_startTime = g_clock.seconds();
    bindAttributeLocation(VERTEX_ATTR, "a_Vertex");
    bindAttributeLocation(TEXCOORD_ATTR, "a_TexCoord");
    if(ShaderProgram::link()) {
        bind();
        setupUniforms();
        release();
        return true;
    }
    return false;
}

void PainterShaderProgram::setTransformMatrix(const Matrix3& transformMatrix)
{
    if(transformMatrix == m_transformMatrix)
        return;

    bind();
    setUniformValue(TRANSFORM_MATRIX_UNIFORM, transformMatrix);
    m_transformMatrix = transformMatrix;
}

void PainterShaderProgram::setProjectionMatrix(const Matrix3& projectionMatrix)
{
    if(projectionMatrix == m_projectionMatrix)
        return;

    bind();
    setUniformValue(PROJECTION_MATRIX_UNIFORM, projectionMatrix);
    m_projectionMatrix = projectionMatrix;
}

void PainterShaderProgram::setTextureMatrix(const Matrix3& textureMatrix)
{
    if(textureMatrix == m_textureMatrix)
        return;

    bind();
    setUniformValue(TEXTURE_MATRIX_UNIFORM, textureMatrix);
    m_textureMatrix = textureMatrix;
}

void PainterShaderProgram::setColor(const Color& color)
{
    if(color == m_color)
        return;

    bind();
    setUniformValue(COLOR_UNIFORM, color);
    m_color = color;
}

void PainterShaderProgram::setOpacity(float opacity)
{
    if(m_opacity == opacity)
        return;

    bind();
    setUniformValue(OPACITY_UNIFORM, opacity);
    m_opacity = opacity;
}

void PainterShaderProgram::setResolution(const Size& resolution)
{
    if(m_resolution == resolution)
        return;

    bind();
    setUniformValue(RESOLUTION_UNIFORM, (float)resolution.width(), (float)resolution.height());
    m_resolution = resolution;
}

void PainterShaderProgram::updateTime()
{
    float time = g_clock.seconds() - m_startTime;
    if(m_time == time)
        return;

    bind();
    setUniformValue(TIME_UNIFORM, time);
    m_time = time;
}

void PainterShaderProgram::addMultiTexture(const std::string& file)
{
    if(m_multiTextures.size() > 3)
        g_logger.error("cannot add more multi textures to shader, the max is 3");

    TexturePtr texture = g_textures.getTexture(file);
    if(!texture)
        return;

    texture->setSmooth(true);
    texture->setRepeat(true);

    m_multiTextures.push_back(texture);
}

// Change start
// Update a creature outfit texture that will be binded to the shader
// It basically shares the same logic with PainterShaderProgram::addMultiTexture except the points explained below
void PainterShaderProgram::updateCreatureOutfitMultiTexture(uint32 creatureId)
{
    // Find the index of the creature's outfit texture using its ID
    auto iterator = m_creatureIdToTextureIndexMap.find(creatureId);

    // Log the error message only when any outfit texture of the specified creature hasn't been added before
    if(iterator == m_creatureIdToTextureIndexMap.end() && m_multiTextures.size() > 3)
        g_logger.error("cannot add more multi textures to shader, the max is 3");

    CreaturePtr creature = g_map.getCreatureById(creatureId);

    // Return if creature is invalid
    if(!creature)
        return;

    // We get the texture from the creature rather than from g_textures
    TexturePtr texture = creature->getOutfitTexture();
    if (!texture)
        return;
    
    texture->setSmooth(true);
    texture->setRepeat(true);

    // Since we shouldn't have more than one outfit textures for each creature, we need to use the index found above
    if(iterator != m_creatureIdToTextureIndexMap.end()) {
        // If we can find the index, i.e. an outfit texture of the specified creature has been added before, we should
        // only update the texture
        m_multiTextures[iterator->second] = texture;
    } else {
        // If we can't find one, we add a new texture into m_multiTextures
        m_creatureIdToTextureIndexMap.emplace(creatureId, m_multiTextures.size());
        m_multiTextures.push_back(texture);
    }
}
// Change end

void PainterShaderProgram::bindMultiTextures()
{
    if(m_multiTextures.empty())
        return;

    int i=1;
    for(const TexturePtr& tex : m_multiTextures) {
        glActiveTexture(GL_TEXTURE0 + i++);
        glBindTexture(GL_TEXTURE_2D, tex->getId());
    }

    glActiveTexture(GL_TEXTURE0);
}
