VERSION="$1"
OVERRIDE="$2"

echo "VERSION=$VERSION"
echo "OVERRIDE=$OVERRIDE"

VERSION=$VERSION docker-compose -f $OVERRIDE up --no-start --remove-orphans
IMAGES=$(docker inspect --format='{{.Image}}' $(docker ps -aq))

echo "IMAGES: $IMAGES"
for IMAGE in $IMAGES; do
    echo "IMAGE: $IMAGE"
    
    NAME=$(basename ${DOCKERHUB_USERNAME}).$(docker inspect --format '{{ index .Config.Labels "name" }}' $IMAGE)
    TAG="$DOCKERHUB_USERNAME/$NAME:$VERSION"

    docker tag $IMAGE $TAG
    docker push $TAG
done
