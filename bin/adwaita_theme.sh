#!/usr/bin/env bash

config_dir="$HOME/.config"
declare -A gtk_dirs=(
  ['gtk-3.0']="$config_dir/gtk-3.0"
  ['gtk-4.0']="$config_dir/gtk-4.0"
)

themes_dirlist=(
  "$HOME/.themes"
  "/usr/share/themes"
)
theme=''
theme_files=(
  'gtk.css'
  'gtk-dark.css'
  'thumbnail.png'
  'assets'
)
force='no'
verbose='no'

function usage() {
  echo "Usage: $0 [OPTIONS...]"
  echo "OPTIONS:"
  echo "  -d | --themes-dir Themes directory to add to lookup list. Can be specified multiple times (default order: ${themes_dirlist[*]})"
  echo "  -t | --theme      Theme name to switch to"
  echo "  -f | --force      Overwrite existing theme"
  echo "  -v | --verbose    Verbose output"
  echo "  -h | --help       Show this help message and exit"
}

while [ $# -gt 0 ]; do
  case "$1" in
    '-d' | '--themes-dir')
      themes_dirlist=("$2" "${themes_dirlist[@]}")
      shift 2
      continue
      ;;
    '-t' | '--theme')
      theme="$2"
      shift 2
      continue
      ;;
    '-f' | '--force')
      force='yes'
      shift
      continue
      ;;
    '-v' | '--verbose')
      verbose='yes'
      shift
      continue
      ;;
    '-h' | '--help')
      usage
      exit 0
      ;;
    '--')
      shift
      break
      ;;
    *)
      echo "Unknown argument $1" >&2
      exit 1
      ;;
  esac
done

theme_dir=''
for dir in "${themes_dirlist[@]}"; do
  [ ! -d "$dir" ] && { echo "Skipping non-existent theme directory '$dir'"; continue; }

  theme_dir="$dir/$theme"
  [ ! -d "$theme_dir" ] && continue

  break
done

echo "Found theme '$theme' in '$theme_dir'"

ln_opts=('-s')
[ "$verbose" = 'yes' ] && ln_opts+=('-v')
[ "$force" = 'yes' ] && ln_opts+=('-f')


for gtk in "${!gtk_dirs[@]}"; do
  theme_gtk_dir="$theme_dir/$gtk"
  [ ! -d "$theme_gtk_dir" ] && { echo "Skipping missing '$gtk'"; continue; }

  echo -e "\nInstalling for $gtk"
  for file in "${theme_files[@]}"; do
    theme_file="$theme_gtk_dir/$file"
    [ ! -e "$theme_file" ] && { echo "Skipping missing file or directory '$theme_file'"; continue; }

    dest_file="${gtk_dirs[$gtk]}/$file"
    [ -e "$dest_file" ] && [ "$force" != 'yes' ] && { echo "Skipping existing file or directory '$theme_file'"; continue; }

    ln "${ln_opts[@]}" "$theme_file" "${gtk_dirs[$gtk]}"
  done
done
