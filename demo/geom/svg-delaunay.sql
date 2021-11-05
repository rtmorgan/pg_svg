------------------------------------------------------------------
-- Demo of using SVG functions to display PostGIS Delaunay Triangulation
-- Author: Martin Davis  2019

-- psql -At -o delaunay.svg  < svg-delaunay.sql
------------------------------------------------------------------

WITH data AS (
  SELECT 'MULTIPOINT ((50 50), (50 120), (100 100), (130 70), (130 150), (70 160), (160 110), (70 80))'::geometry geom
),
result AS (
  SELECT ST_DelaunayTriangles( geom ) AS geom FROM data
),
shapes AS (
  SELECT geom, svgShape( geom,
    title => 'Delaunay Triangulation',
    style => svgStyle('fill', '#a0a0ff',
                      'stroke', '#0000ff',
                      'stroke-width', 1::text,
                      'stroke-linejoin', 'round' ) )
    AS svg FROM result
  UNION ALL
  SELECT geom, svgShape( geom, radius => 2,
                  title => 'Site',
                  style => svgStyle( 'fill', '#ff0000'  ) )
    AS svg FROM data
)
SELECT svgDoc( array_agg( svg ),
    viewbox => svgViewbox( ST_Expand( ST_Extent(geom), 20) )
  ) AS svg FROM shapes;