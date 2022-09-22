OVERRIDE="$1"
IMAGE_NAME="$2"
TAG_INFO="$3"

echo "IMAGE_NAME=$IMAGE_NAME"
echo "OVERRIDE=$OVERRIDE"

docker-compose -f $OVERRIDE up --no-start --remove-orphans
IMAGES=$(docker inspect --format='{{.Image}}' $(docker ps -aq))

echo "IMAGES: $IMAGES"
for IMAGE in $IMAGES; do
    echo "IMAGE: $IMAGE"
    
    #NAME=$(basename).$(docker inspect --format '{{ index .Config.Labels "name" }}' $IMAGE)
    #NAME=${{ env.IMAGE_NAME }}
    NAME=$IMAGE_NAME
    NEW_TAG="$DOCKERHUB_USERNAME/$NAME:$TAG_INFO"

    docker tag $IMAGE $NEW_TAG
    docker push $TAG
done
