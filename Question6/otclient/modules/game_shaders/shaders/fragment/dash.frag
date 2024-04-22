uniform sampler2D u_Tex0;
uniform sampler2D u_Tex1;
varying vec2 v_TexCoord;
uniform int u_PlayerDirection;

// Constants
// Creatures in game are not placed exactly at the centre of a tile, and this is the displacement value found in OTC's
// source code
const int CREATURE_DISPLACEMENT = 8;
// Trail is the afterimage behind the player
const int TRAIL_COUNT = 4;
const int TRAIL_DISTANCE = 16;
// This constant controls how transparent the trail is
const float TRAIL_FADE_STEP = 0.15;
// This constant determines if we should draw an outline at that pixel
// It won't draw if that pixel is too transparent
const float OUTLINE_ALPHA_TOLERANCE = 0.5;

// These are basically the enums of Direction
const int NORTH = 0;
const int EAST = 1;
const int SOUTH = 2;
const int WEST = 3;
// This array turns a direction into a 2D vector that represents the direction
vec2 DIRECTIONS[4] = vec2[4](vec2(0, 1), vec2(1, 0), vec2(0, -1), vec2(-1, 0));

// These are the variables that are used in multiple functions
vec2 outfitSize;
vec2 position;
vec2 bottomLeft;
vec2 topRight;

// Draw a trail depending on factor, which is the ordinal of the trail (0 being exactly on the player, and the larger
// the factor, the farther from the player)
void DrawTrail(int factor)
{
    // Calculate how far is the trail from the player in 2D
    vec2 trailDisplacement = DIRECTIONS[u_PlayerDirection] * TRAIL_DISTANCE * factor;
    // Calculate the rectangular box of the trail
    vec2 newBottomLeft = bottomLeft - trailDisplacement;
    vec2 newTopRight = topRight - trailDisplacement;

    // If the pixel being drawn is inside the rectangular box, draw the trail
    if (position.x >= newBottomLeft.x && position.x < newTopRight.x && position.y >= newBottomLeft.y && position.y < newTopRight.y)
    {
        vec2 outfitTexCoord = vec2((position.x - newBottomLeft.x) / outfitSize.x, (position.y - newBottomLeft.y) / outfitSize.y);
        vec4 outfitColor = texture2D(u_Tex1, outfitTexCoord);
        // Blend the outfit color to the background according to its transparency (calculated using factor)
        gl_FragColor = vec4(mix(gl_FragColor.rgb, outfitColor.rgb, outfitColor.a * (1 - TRAIL_FADE_STEP * factor)), 1.0);
    }
}

// Draw a red outline around the player
void DrawOutline()
{
    // The logic is that we try to move the rectangular box of the outfit texture by 1 pixel in all eight directions
    // If the pixel being drawn is inside the rectangular box, draw the pixel as red and return it (no need to test for
    // the remaining directions)
    // The centre is also tested for cleaner code
    for (int i = -1; i <= 1; ++i)
    {
        for (int j = -1; j <= 1; ++j)
        {
            if (position.x >= bottomLeft.x + i && position.x < topRight.x + i && position.y >= bottomLeft.y + j && position.y < topRight.y + j)
            {
                vec2 outfitTexCoord = vec2((position.x - bottomLeft.x - i) / outfitSize.x, (position.y - bottomLeft.y - j) / outfitSize.y);
                vec4 outfitColor = texture2D(u_Tex1, outfitTexCoord);

                // Draw an outline only when the pixel is opaque enough
                if (outfitColor.a >= OUTLINE_ALPHA_TOLERANCE)
                {
                    gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);
                    return;
                }
            }
        }
    }
}

void main(void)
{
    // This effect consists of three parts, which should be rendered in the following order
    //     1. Trails
    //     2. Outline
    //     3. The "trail" on the player
    // The order is important since the one that is rendered earlier will be covered by the one that is rendered later
    // The outline should be on top of the trails, so it is rendered later than the trails
    // When drawing the outline, the pixel on the player is also rendered as red, so the player needs to be on top of
    // the outline, and thus it is rendered last

    gl_FragColor = texture2D(u_Tex0, v_TexCoord);
    vec2 screenSize = textureSize(u_Tex0, 0);
    outfitSize = textureSize(u_Tex1, 0);
    // This is the coordinates of the pixel being drawn
    position = screenSize * v_TexCoord;
    // This is the coordinates of the centre of the screen
    vec2 center = screenSize / 2;
    // Calculate the rectangular box of the player (the player is placed at the upper left of the centre)
    bottomLeft = vec2(center.x - outfitSize.x - CREATURE_DISPLACEMENT, center.y + CREATURE_DISPLACEMENT);
    topRight = vec2(bottomLeft.x + outfitSize.x, bottomLeft.y + outfitSize.y);

    // When the player is facing east or south, the trails should be rendered backwards since a farther trail should
    // be covered by a closer one
    // Otherwise, render them forwards
    if (u_PlayerDirection == EAST || u_PlayerDirection == SOUTH)
    {
        for (int i = TRAIL_COUNT; i >= 1; --i)
        {
            DrawTrail(i);
        }
    }
    else
    {
        for (int i = 1; i <= TRAIL_COUNT; ++i)
        {
            DrawTrail(i);
        }
    }

    // Draw the outline
    DrawOutline();
    // Draw the "trail" on the player
    DrawTrail(0);
}
