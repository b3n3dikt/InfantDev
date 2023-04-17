
file1="/home/bramirez/projects/InfantDevelopment/NKIdev/info/fixing_new_asegs_subs_and_sessions.txt"
file2="/home/bramirez/projects/InfantDevelopment/NKIdev/info/Original_aseg_paths.txt"

i=1
while read -r line_file1 && read -r line_file2 <&3; do
  echo $i

  echo ${line_file1}
  sesh=$(echo $line_file1 | cut -d '/' -f 2-)
  echo $sesh
  sub=$(echo $line_file1 | cut -d '/' -f 1)
  echo $sub

  # Extract osub and osesh using grep and a regular expression
  osub=$(echo "$line_file2" | grep -oP '(?<=/)(sub-[a-zA-Z0-9]+)(?=/)')
  osesh=$(echo "$line_file2" | grep -oP '(?<=/)(ses-[a-zA-Z0-9]+)(?=/)')
  # Print the extracted values
  echo "osub: $osub"
  echo "osesh: $osesh"

  i=$((i + 1))
done < "$file1" 3< "$file2"