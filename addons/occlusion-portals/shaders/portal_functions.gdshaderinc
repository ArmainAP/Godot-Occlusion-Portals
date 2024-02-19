// Function to calculate the normal of a plane defined by three points
vec3 CalculateNormal(const vec3 A, const vec3 B, const vec3 C)
{
    const vec3 AB = B - A;
    const vec3 AC = C - A;
    return normalize(cross(AB, AC));
}

// Function to check if the ray intersects with the plane
bool CheckRayPlaneIntersection(const vec3 RayOrigin, const vec3 RayDirection, const vec3 Normal, const vec3 PointOnPlane)
{
    const float PlaneD = -dot(Normal, PointOnPlane);
    const float Denom = dot(Normal, RayDirection);
    
    // Check if the ray is parallel to the plane
    if (abs(Denom) < 1e-6)
    {
        return false; // No intersection
    }

    const float t = -(PlaneD + dot(Normal, RayOrigin)) / Denom;
    return t >= 0.0; // Intersection occurs if t is positive
}

// Function to check if a point is inside a square defined by its vertices
bool IsPointInsideSquare(const vec3 P, vec3 Vertices[4], const vec3 Normal)
{
    for (int i = 0; i < 4; i++)
    {
        vec3 Edge = Vertices[(i + 1) % 4] - Vertices[i];
        vec3 ToP = P - Vertices[i];
        if (dot(Normal, cross(Edge, ToP)) < 0.0)
        {
            return false; // Point is outside the square
        }
    }
    return true;
}

// Main function to calculate ray-square intersection
bool CalculateRaySquareIntersection(vec3 PixelWS, vec3 CameraWS, vec3 A, vec3 B, vec3 C, vec3 D)
{
    vec3 RayDirection = normalize(CameraWS - PixelWS);
    vec3 Normal = CalculateNormal(A, B, C);
    
    // Determine the side of the plane on which the camera is located
    bool bIsCameraInFront = dot(Normal, CameraWS - A) < 0.0;
    
    // Adjust the check based on the camera's side
    if (bIsCameraInFront)
    {
        // Camera in front, normal direction towards camera
        if (dot(Normal, RayDirection) >= 0.0)
        {
            return false; // Ray is pointing away from or parallel to the plane
        }
    }
    else
    {
        // Camera behind, normal direction away from camera
        if (dot(Normal, RayDirection) <= 0.0)
        {
            return false; // Ray is pointing away from or parallel to the plane
        }
    }

    // Check for ray-plane intersection
    if (!CheckRayPlaneIntersection(PixelWS, RayDirection, Normal, A))
    {
        return false; // No intersection with the plane
    }
    
    // Calculate the intersection point
    float PlaneD = -dot(Normal, A);
    float t = -(PlaneD + dot(Normal, PixelWS)) / dot(Normal, RayDirection);
    vec3 P = PixelWS + t * RayDirection;
    
    // Check if the intersection point is inside the square
    vec3 Vertices[4] = {A, B, C, D};
    if (IsPointInsideSquare(P, Vertices, Normal))
    {
        return true; // Inside the square
    }
    return false; // Outside the square
}

uniform vec3 A;
uniform vec3 B;
uniform vec3 C;
uniform vec3 D;
uniform bool IsSameWorld;

bool PortalOcclusion(vec3 PixelWS, vec3 CameraWS)
{
	return IsSameWorld || CalculateRaySquareIntersection(PixelWS, CameraWS, A, B, C, D);
}