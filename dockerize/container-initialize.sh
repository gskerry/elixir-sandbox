
echo $(pwd)
docker run --rm -v $(pwd):/home/apps -w /home/apps elixir-proj_img:0.0.2 /bin/sh mix-setup.sh
