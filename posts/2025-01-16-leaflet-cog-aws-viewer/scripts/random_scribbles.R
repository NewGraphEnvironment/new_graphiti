# use s3fs to list buckets
s3fs::


s3fs::s3_dir_create(
  path = paste0("s3://23cog", "/test-viewer")
)


# upload our index.html to the new dir
s3fs::s3_file_copy(
  path = "/Users/airvine/Downloads/index.html",
  new_path = "s3://23cog/test-viewer"
)

s3fs::s3_dir_ls("s3://23cog")
s3fs::s3_dir_ls("s3://23cog/test-viewer")

ngr::ngr_s3_path_to_https("s3://23cog/20210906lampreymoricetribv220230317.tif", website = TRUE)

ngr::ngr_s3_path_to_https("s3://sentinel-s2-l2a/tiles/9/U/XA/2020/7/28/0/", website = TRUE, aws_region = "eu-central-1")

aws s3 cp /Users/airvine/Projects/repo/new_graphiti/posts/2025-01-16-leaflet-cog-aws-viewer/scripts/viewer.html s3://23cog/viewer.html --content-type "text/html" --acl public-read

# aws s3 cp /Users/airvine/Projects/repo/new_graphiti/posts/2025-01-16-leaflet-cog-aws-viewer/scripts/viewer.html s3://new-graphiti/viewer.html --content-type "text/html" --acl public-read

# thisis our favicon logo that shows up on the browser tab!!
aws s3 cp /Users/airvine/Projects/repo/new_graphiti/assets/logos/favicon_io/favicon.ico s3://new-graphiti/favicon.ico --content-type "image/x-icon"
aws s3 cp /Users/airvine/Projects/repo/new_graphiti/assets/logos/favicon_io/favicon.ico s3://23cog/favicon.ico --content-type "image/x-icon"
# this works
http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/20210906lampreymoricetribv220230317.tif

http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/glen_valle_lidar_2019_cog.tif
http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/glen_valle_lidar_2019_cog.tif

aws_region <- "ca-central-1"
s3://sentinel-s2-l2a/tiles/10/U/GA/2022/7/27/0/R10m/B04.jp2

# the index.html file metadata type needs to be


# add the index
aws s3 cp /Users/airvine/Downloads/index.html s3://23cog/test-viewer/index.html --content-type "text/html" --acl public-read


aws s3 cp /Users/airvine/Projects/repo/dff-2022/data/lidar/20210906lampreymoricetribv220230317.tif s3://23cog/test-viewer/20210906lampreymoricetribv220230317.tif --acl public-read

aws s3 cp ~/Projects/repo/new_graphiti/S2A_MSIL2A_T09UUA/S2A_MSIL2A_20220115T200801_N0510_R128_T09UUA_20240429T225829.SAFE/GRANULE/L2A_T09UUA_A034302_20220115T200759/IMG_DATA/R10m/T09UUA_20220115T200801_RGB.tif s3://23cog/test-viewer/test.tif --acl public-read


aws s3api get-object-acl --bucket 23cog --key test-viewer/20210906lampreymoricetribv220230317.tif
aws s3api put-object-acl --bucket 23cog --key 20210906lampreymoricetribv220230317.tif --acl public-read

# we see what it is with

aws s3api head-object --bucket 23cog --key test-viewer/index.html

# see permissions
aws s3api get-object-acl --bucket 23cog --key test-viewer/index.html

# make permissions public read
aws s3api put-object-acl --bucket 23cog --key test-viewer/index.html --acl public-read

