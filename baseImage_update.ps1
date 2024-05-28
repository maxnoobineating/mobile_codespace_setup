# build.ps1
param(
    [Parameter(Mandatory=$true)]
    [string]$BaseImage
)

docker build --build-arg BASE_IMAGE=$BaseImage -t $BaseImage -f ./dockerfileUpdate.dockerfile .