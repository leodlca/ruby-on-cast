# ruby-on-cast
Ruby-on-cast is a simple script that reads the html from Jovem Nerd's root website, parses it using nokogiri, and extracts the titles and download links so the user can choose which podcasts he wants to download.

## How to use it (windows users)
Simply download the .exe file in the "releases" tab and run it.

## How to use it (*nix users)
1. Clone the repository
2. Install ruby.
3. Install the nokogiri, openssl and progress_bar gems.
4. Run the init.rb script.

## Troubleshooting
If you experience certificate errors, try installing the latest ruby version using rvm, rbenv or any other ruby version manager you want.

## Changelog
1. Added progress bar.
2. Corrected a few inconsistencies.

## Known bugs
1. In windows, the progress bar keeps printing in a new line every time it refreshes.