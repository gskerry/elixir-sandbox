defmodule Mix.Tasks.ListTransactions do
    use Mix.Tasks # core module

    def run(_) do # argument underscore... avoid compiler warnings
        Budget.Reporting.list_transactions |> IO.inspect
    end
end
