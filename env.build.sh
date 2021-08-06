GIT_HASH="$(git describe --dirty --always)"
VERSION=${OP_VERSION:-${GIT_HASH}}

# Image version created by build procedure
IMAGE="k8sschool/debugtools:$VERSION"
