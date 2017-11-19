
echo $(pwd)
docker run -it --rm --name elixir_container -p 4000:4000 -v $(pwd):/home/myapp -w /home/myapp elixir-proj_img:0.0.2 iex
