#!/bin/bash
librewolf_extensions_install() {
	# Loop through the list and download each extension
	for url in "${extension_urls[@]}"; do
	    # If the URL is from addons.mozilla.org, extract the direct .xpi link, otherwise use the provided URL
	    if [[ "$url" == *"addons.mozilla.org"* ]]; then
		wget -P "$librewolf_profiledir/extensions" "$(curl -s "$url" | grep -oE 'https://[^"]+\.xpi' | head -n 1)"
	    else
		wget -P "$librewolf_profiledir/extensions" "$url"
	    fi
	done
}
librewolf_extensions_rename() {
	local dir="$librewolf_profiledir/extensions"

	# Check if the directory exists.
	if [[ ! -d "$dir" ]]; then
		echo "The directory does not exist: $dir"
	return 1
	fi

	# Check for .xpi files in the directory
	for xpi_file in "$dir"/*.xpi; do
		# If no .xpi files are found, the loop will get the literal string "$dir/*.xpi", so it'll break out in that case.
		[[ ! -f "$xpi_file" ]] && break

		# Extract the filename without the path
		local filename=$(basename "$xpi_file")
			
		# Unzip the .xpi to a temporary directory
		local tmp_dir=$(mktemp -d)
		unzip "$xpi_file" -d "$tmp_dir"

		# Extract the id from manifest.json
		local extension_id=$(jq -r '.applications.gecko.id // .browser_specific_settings.gecko.id' "$tmp_dir/manifest.json")

		# Check if the .xpi is already renamed
		if [[ "$filename" != "${extension_id}.xpi" ]]; then
			echo "Renaming $filename to ${extension_id}.xpi"
			mv "$xpi_file" "$dir/${extension_id}.xpi"
		else
			echo "Extension $filename is already renamed."
		fi

		# Cleanup the temporary directory
		rm -rf "$tmp_dir"
		done
}