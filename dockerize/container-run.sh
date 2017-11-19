
echo $(pwd)
docker run -it --rm --name elixir_container -p 4000:4000 -v $(pwd):/home/apps -w /home/apps elixir-proj_img:0.0.1 iex
