defmodule Mix.Tasks.ListTransactions do
    use Mix.Task # core module

    def run(_) do # argument underscore... avoid compiler warnings
        App.Reporting.list_transactions |> IO.inspect
    end
end
