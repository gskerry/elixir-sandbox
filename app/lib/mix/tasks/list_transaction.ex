defmodule Mix.Tasks.ListTransactions do
    use Mix.Task # core module

    @shortdoc "list transactions from CSV file."
    def run(_) do # argument underscore... avoid compiler warnings
        App.Reporting.list_transactions
    end
end
