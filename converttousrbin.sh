#!/usr/bin/env bash

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

_startdir=$(pwd)
shopt -s extglob
shopt -s nullglob

for _package in !(*usrbinmove)+(.pkg.tar.xz); do
  _name=${_package/.pkg.tar.xz}
  rm -rf $_name
  mkdir $_name
  bsdtar -xf $_package -C $_name
  cd $_name
  for _dir in bin sbin usr/sbin; do
    if [ -d $_dir ]; then
      mkdir -p usr/bin
      mv -n $_dir/* usr/bin
      rmdir $_dir || exit
    fi
  done
  bsdtar -cf - .??* * | xz -c -z - > $_startdir/$_name-usrbinmove.pkg.tar.xz
  cd $_startdir
  rm -r $_name
  echo "${_name/-*} done"
done
echo "All done. Now install with pacman -U *usrbinmove*"
