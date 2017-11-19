
running="$(docker ps -f 'name=elixir_container' -q)"

echo "running container: $running"

docker exec -it $running /bin/bash
