defmodule App.Reporting do
    alias NimbleCSV.RFC4180, as: Nimble
    def list_transactions do
        IO.puts "Listing tx's..."
        # File.read("lib/transactions-jan.csv") # returns full tuple

        # returns content directly (or error if file is missing... don't have conditional logic to apply to an error tuple, so this works)
        File.read!("lib/transactions-jan.csv")
            |> parse
            |> filter # account is always the same... drop
    end
    defp parse(string) do
        Nimble.parse_string(string)
    end
    defp filter(rows) do
        # Enum.map(rows, fn(row) -> Enum.drop(row, 1) end) # Enum, standard lib
        Enum.map(rows, &Enum.drop(&1, 1))
    end
end
