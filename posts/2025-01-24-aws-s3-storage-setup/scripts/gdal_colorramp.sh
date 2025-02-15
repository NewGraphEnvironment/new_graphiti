#!/bin/bash

# Check if an input file is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <input_dem.tif>"
  exit 1
fi

# Input DEM file (from the first argument)
input_dem="$1"

# Output color-relief file
output_color="${input_dem%.tif}_color.tif"

# Extract min and max values from the DEM metadata
min=$(gdalinfo "$input_dem" | grep 'STATISTICS_MINIMUM' | awk -F= '{print $2}')
max=$(gdalinfo "$input_dem" | grep 'STATISTICS_MAXIMUM' | awk -F= '{print $2}')

# Check if min and max values were extracted successfully
if [ -z "$min" ] || [ -z "$max" ]; then
  echo "Error: Unable to extract elevation range from $input_dem."
  exit 1
fi

# Generate colorramp.txt dynamically using `bc` for floating-point math
cat <<EOF > colorramp.txt
$min 0 0 255  # Blue for low elevations
$(echo "$min + ($max - $min) / 4" | bc -l) 0 255 255  # Cyan
$(echo "$min + ($max - $min) / 2" | bc -l) 0 255 0  # Green
$(echo "$min + 3 * ($max - $min) / 4" | bc -l) 255 255 0  # Yellow
$max 255 0 0  # Red for high elevations
nv 255 255 255  # No data values are white
EOF

echo "Generated color ramp:"
cat colorramp.txt

# Apply the color ramp to create the color-relief GeoTIFF
gdaldem color-relief "$input_dem" colorramp.txt "$output_color"

# Check if the process was successful
if [ $? -eq 0 ]; then
  echo "Color relief applied successfully. Output saved to $output_color."
else
  echo "Error: Failed to apply color relief."
fi
