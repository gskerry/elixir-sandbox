defmodule App.Reporting do
    alias NimbleCSV.RFC4180, as: Nimble
    def list_transactions do
        IO.puts "Listing tx's..."
        # File.read("lib/transactions-jan.csv") # returns full tuple

        # returns content directly (or error if file is missing... don't have conditional logic to apply to an error tuple, so this works)
        File.read!("lib/transactions-jan.csv") |> parse
    end
    defp parse(string) do
        Nimble.parse_string(string)
    end
end
