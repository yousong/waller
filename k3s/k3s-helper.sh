#!/usr/bin/env bash

set -o errexit
set -o pipefail

ver=v1.0.0
baseu="https://github.com/rancher/k3s/releases/download/$ver"

fns=(
	k3s
	k3s-arm64
	k3s-armhf
)

sums=(
	sha256sum-amd64.txt
	sha256sum-arm64.txt
	sha256sum-arm.txt
)

arches=(
	amd64
	arm64
	armhf
)

n="${#fns[@]}"
n1=$(($n-1))

dlfn() {
	local i

	for i in $(seq 0 $n1); do
		wget -c "$baseu/${fns[$i]}"
		chmod a+x "${fns[$i]}"
	done
}

dlsum() {
	local i

	for i in $(seq 0 $n1); do
		wget -c "$baseu/${sums[$i]}"
	done
}

mkhash() {
	local i
	local sum

	for i in $(seq 0 $n1); do
		sum="$(grep " ${fns[$i]}\$" "${sums[$i]}" | cut -f1 -d' ')"
		echo "k3s_${arches[$i]}_hash:=$sum"
	done
}

if [ "$#" = 0 ]; then
	dlsum
	mkhash
else
	"$@"
fi
