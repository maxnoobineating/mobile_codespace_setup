param(
    [string]$containerName = "cont_name",
    [string]$imageName = "cont_source_image"
)

docker stop $containerName
docker rm $containerName
docker run -itd --name $containerName $imageName