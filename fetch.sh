#!/bin/bash
set -e

STATIC_BUILD_CFG=$(
  cat <<EOF
{
    "rg": {
        "version": "14.1.1"
    }
}
EOF
)

function static-build-fetch() (
  set -x
  local arch_m="$1"
  local os="$2"
  if [[ -z "$arch_m" ]]; then
    arch_m=$(uname -m)
  fi
  if [[ -z "$os" ]]; then
    os=$(uname)
  fi
  echo "arch_m $arch_m"
  echo "os $os"

  local rg_version=$(echo "$STATIC_BUILD_CFG" | jq -r ".rg.version")
  echo "rg_version $rg_version"
  local arch="$arch_m"
  local base="ripgrep-${rg_version}-${arch}"
  if [[ "$arch_m" == "arm64" && "$os" == "Darwin" ]]; then
    base="ripgrep-${rg_version}-aarch64-apple-darwin"
  elif [[ $arch_m == "aarch64" ]]; then
    base="ripgrep-${rg_version}-${arch}-unknown-linux-gnu"
  else
    base="ripgrep-${rg_version}-${arch}-unknown-linux-musl"
  fi
  local rg_url="https://github.com/BurntSushi/ripgrep/releases/download/${rg_version}/${base}.tar.gz"
  local rg_name="${base}"
  echo "rg $rg_url"
  curl -L -o ./$rg_name.tar.gz $rg_url
  tar -xzf ./$rg_name.tar.gz
  mv ./$rg_name/rg ./tools/
  rm -rf ./$rg_name.tar.gz
  rm -rf ./$rg_name
)

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  static-build-fetch "$@"
fi
