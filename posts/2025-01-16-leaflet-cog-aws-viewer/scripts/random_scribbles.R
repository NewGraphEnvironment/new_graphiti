# see the size of al the filles in the bucket

# add the viewer
aws s3 cp /Users/airvine/Projects/repo/new_graphiti/posts/2025-01-16-leaflet-cog-aws-viewer/scripts/viewer.html s3://23cog/viewer.html \
--content-type "text/html" \
--acl public-read \
--cache-control "no-cache, no-store, must-revalidate"

s3fs::s3_dir_info(
  "s3://23cog",
  recurse = TRUE
)

s3fs::s3_dir_ls("s3://23cog")

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

path_dirname <- "/Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199174_necr_trib_dog_settlement"
path_upload <- "/Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199174_necr_trib_dog_settlement/odm_orthophoto/odm_orthophoto.tif"
dir_subname <- stringr::str_replace_all(basename(path_dirname), "_", "-")
path_s3 <- paste0("s3://23cog", "/",dir_subname, "/", basename(path_upload))
ngr::ngr_s3_path_to_https(path_s3, website = TRUE)

fs::path("http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/", fs::path(dir_subname, basename(path_upload)))

s3fs::s3_file_copy(
  path = path_upload,
  new_path = path_s3,
  ACL = "public-read"
)

path_dirname <- "/Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199173_necr_trib_dog"
path_upload <- "/Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199173_necr_trib_dog/odm_orthophoto/odm_orthophoto.tif"
dir_subname <- stringr::str_replace_all(basename(path_dirname), "_", "-")
path_s3 <- paste0("s3://23cog", "/",dir_subname, "/", basename(path_upload))
ngr::ngr_s3_path_to_https(path_s3, website = TRUE)

s3fs::s3_file_copy(
  path = path_upload,
  new_path = path_s3,
  ACL = "public-read"
)

ngr::ngr_s3_path_to_https(path_s3, website = TRUE)

fs::path("http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/", fs::path(dir_subname, basename(path_upload)))


path_dirname <- "/Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199171_burnt_cabin_gala"
path_upload <- "/Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199171_burnt_cabin_gala/odm_orthophoto/odm_orthophoto.tif"
dir_subname <- stringr::str_replace_all(basename(path_dirname), "_", "-")
path_s3 <- paste0("s3://23cog", "/",dir_subname, "/", basename(path_upload))
ngr::ngr_s3_path_to_https(path_s3, website = TRUE)

s3fs::s3_file_copy(
  path = path_upload,
  new_path = path_s3,
  ACL = "public-read"
)

fs::path("http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/", fs::path(dir_subname, basename(path_upload)))




aws s3 cp /Volumes/backup_2022/backups/new_graph/archive/uav_imagery/fraser/nechacko/2024/199174_necr_trib_dog_settlement/odm_orthophoto/odm_orthophoto.tif s3://23cog/199174-necr-trib-dog-settlement/odm_orthophoto.tif --acl public-read

aws s3api get-object-acl --bucket 23cog --key 199174-necr-trib-dog-settlement/odm_orthophoto.tif


# create the sub-directory
s3fs::s3_dir_create(
  path = paste0("s3://23cog", "/", stringr::str_replace_all(basename(path_dirname), "_", "-"))
)

aws s3 cp /Users/airvine/Projects/repo/dff-2022/data/lidar/20210906lampreymoricetribv220230317.tif s3://23cog/test-viewer/20210906lampreymoricetribv220230317.tif --acl public-read

aws s3 cp /Users/airvine/Projects/repo/new_graphiti/posts/2025-01-16-leaflet-cog-aws-viewer/scripts/viewer.html s3://23cog/viewer.html --content-type "text/html" --acl public-read

# aws s3 cp /Users/airvine/Projects/repo/new_graphiti/posts/2025-01-16-leaflet-cog-aws-viewer/scripts/viewer.html s3://new-graphiti/viewer.html --content-type "text/html" --acl public-read

# thisis our favicon logo that shows up on the browser tab!!
aws s3 cp /Users/airvine/Projects/repo/new_graphiti/assets/logos/favicon_io/favicon.ico s3://new-graphiti/favicon.ico --content-type "image/x-icon"
aws s3 cp /Users/airvine/Projects/repo/new_graphiti/assets/logos/favicon_io/favicon.ico s3://23cog/favicon.ico --content-type "image/x-icon"
# this works
http://23cog.s3.amazonaws.com/viewer.html?cog=https://23cog.s3.amazonaws.com/20210906lampreymoricetribv220230317.tif
http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/199174-necr-trib-dog-settlement/odm_orthophoto.tif
http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/199173-necr-trib-dog/odm_orthophoto.tif


# wtf - this dl the file
http://23cog.s3.amazonaws.com/199173-necr-trib-dog/odm_orthophoto.tif


http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/glen_valle_lidar_2019_cog.tif

http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/xli1m_utm09_2019_093L04843.tif

aws_region <- "ca-central-1"
s3://sentinel-s2-l2a/tiles/10/U/GA/2022/7/27/0/R10m/B04.jp2

# the index.html file metadata type needs to be

http://23cog.s3.amazonaws.com/viewer.html?cog=http://23cog.s3.amazonaws.com/199174-necr-trib-dog-settlement/odm_orthophoto.tif


aws s3 cp /Users/airvine/Projects/repo/dff-2022/data/lidar/20210906lampreymoricetribv220230317.tif s3://23cog/test-viewer/20210906lampreymoricetribv220230317.tif --acl public-read

aws s3 cp ~/Projects/repo/new_graphiti/S2A_MSIL2A_T09UUA/S2A_MSIL2A_20220115T200801_N0510_R128_T09UUA_20240429T225829.SAFE/GRANULE/L2A_T09UUA_A034302_20220115T200759/IMG_DATA/R10m/T09UUA_20220115T200801_RGB.tif s3://23cog/test-viewer/test.tif --acl public-read


aws s3api put-object-acl --bucket 23cog --key 20210906lampreymoricetribv220230317.tif --acl public-read

# we see what it is with

aws s3api head-object --bucket 23cog --key test-viewer/index.html

# see permissions
aws s3api get-object-acl --bucket 23cog --key test-viewer/index.html

# make permissions public read
aws s3api put-object-acl --bucket 23cog --key test-viewer/index.html --acl public-read

http://23cog.s3.amazonaws.com/199174-necr-trib-dog-settlement/odm_orthophoto.tif

http://23cog.s3-website-us-west-2.amazonaws.com/20210906lampreymoricetribv220230317.tif

ngr::ngr_s3_path_to_https("s3://23cog/199173-necr-trib-dog/odm_orthophoto.tif", website = TRUE)

gdal_translate -scale -ot Byte dtm.tif dtm_greyscale.tif
gdaldem color-relief dtm.tif /Users/airvine/Projects/repo/new_graphiti/posts/2025-01-24-aws-s3-storage-setup/data/grayscale_palette.txt dtm_greyscale_palette.tif
gdaldem hillshade dtm.tif dtm_hillshade.tif
gdaldem color-relief dtm.tif /Users/airvine/Projects/repo/new_graphiti/posts/2025-01-24-aws-s3-storage-setup/data/colorramp.txt dtm_color.tif


fs::file_chmod("/Users/airvine/Projects/repo/new_graphiti/posts/2025-01-24-aws-s3-storage-setup/scripts/gdal_colorramp.sh", mode = "777")

./gdal_colorramp.sh dtm.tif

https://titiler.xyz/cog/WebMercatorQuad/map?url=https%3A%2F%2Foin-hotosm-temp.s3.us-east-1.amazonaws.com%2F6792ba3731dc480001b23405%2F0%2F6792ba3731dc480001b23406.tif&bidx=1&bidx=2&bidx=3

##THIS ENDPOINT WORKS FINE
https://titiler.xyz/cog/WebMercatorQuad/map?url=

##WHEN WE UPLOAD OUR IMAGERY TO OPEN AERIAL MAP IT IS AVAILAVLE IN PUBLIC S3 BUCKETS!!
https://titiler.xyz/cog/WebMercatorQuad/map?url=https%3A%2F%2Foin-hotosm-temp.s3.us-east-1.amazonaws.com%2F6792ba3731dc480001b23405%2F0%2F6792ba3731dc480001b23406.tif&bidx=1&bidx=2&bidx=3

# WE KNOW THAT BECAUSE WE CAN SEE THAT WITH CURL WHEN WE GET INFO FOR THE URL THEY SERVE US FROM OAM
curl -I https://tiles.openaerialmap.org/6794a29f8fbd620001a3d1bc/0/6794a29f8fbd620001a3d1bd/{z}/{x}/{y}

http://your-titiler-endpoint/cog/tiles/{z}/{x}/{y}.png?url={DEM_URL}&algorithm=hillshade
http://23cog.s3.amazonaws.com/viewer.html?cogtiles/{z}/{x}/{y}.png?url=https://23cog.s3.amazonaws.com/20210906lampreymoricetribv220230317-DEM.tif&algorithm=hillshade
