
set -e -o pipefail

SBO_PATCHDIR=${CWD}/patches

unset PATCH_VERBOSE_OPT
[ "${PATCH_VERBOSE}" = "YES" ] && PATCH_VERBOSE_OPT="--verbose"
[ "${PATCH_SVERBOSE}" = "YES" ] && set -o xtrace

PATCHCOM="patch -p1 -s -F1 --backup ${PATCH_VERBOSE_OPT}"

ApplyPatch() {
  local patch=$1
  shift
  if [ ! -f ${SBO_PATCHDIR}/${patch} ]; then
    exit 1
  fi
  echo "Applying ${patch}"
  case "${patch}" in
  *.bz2) bzcat "${SBO_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *.gz) zcat "${SBO_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *) ${PATCHCOM} ${1+"$@"} -i "${SBO_PATCHDIR}/${patch}" ;;
  esac
}

# patch -p0 -E --backup --verbose -i ${SBO_PATCHDIR}/${NAME}.patch
#patch -p1 -E --backup --verbose -i ${SBO_PATCHDIR}/su1.patch
#patch -p1 -E --backup --verbose -i ${SBO_PATCHDIR}/su2.patch

# Set to YES if autogen is needed
SBO_AUTOGEN=NO

set +e +o pipefail
