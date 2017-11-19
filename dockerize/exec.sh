
cd app
mix run -e "Budget.current_balance(100, 20) |> IO.puts"

# alternatively.. multiple lines
# mix run \
#     -e "Budget.current_balance(100, 20) |> IO.puts"

# Mix RUN:
#> compile (into bytecode)
#> loads bytecode into erland virtual machine
#> detects -e flag and evals the argument passed to it as elixir code

# .ex files : production (lib)... generate artifacts like .beam files (?)
# .exs files : scripting (e.g. configs and test files)... do not produce production artifacts
