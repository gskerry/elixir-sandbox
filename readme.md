## Learning Elixir

Tutorials courtesy of [Code School](http://campus.codeschool.com/courses/mixing-it-up-with-elixir)

---

### Docker Setup

#### Build
`./dockerize/docker-build.sh`

#### Initialize project
`./dockerize/docker-initialize.sh`

* This assumes no existing Elixir or Mix installation on host.
* Uses Mix to generate project scaffolding - via container - onto the mounted volume

#### Run Container and mount project
`./dockerize/docker-run.sh`

#### Launch container shell
`docker exec -it elixir_container /bin/bash`

---

### Elixir Project Setup

#### Install dependencies
`mix deps.get`

#### Compile
`mix compile`

#### Run Program
`mix`

#### Consult Mix Help
`mix help`

#### To Launch Interactive Console
`iex`

#### Launching Console with Project in Context
`iex -S mix`
* (must be from the project directory)
