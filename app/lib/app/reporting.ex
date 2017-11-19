defmodule App.Reporting do
    alias NimbleCSV.RFC4180, as: Nimble
    def list_transactions do
        # File.read("lib/transactions-jan.csv") # returns full tuple

        # returns content directly (or error if file is missing... don't have conditional logic to apply to an error tuple, so this works)
        File.read!("lib/transactions-jan.csv")
            |> parse
            |> filter # account is always the same... drop
            |> normalize
            |> sort
            |> print
    end
    defp parse(string) do
        string
        |> String.replace("\r", "")
        |> Nimble.parse_string
    end
    defp filter(rows) do
        # Enum.map(rows, fn(row) -> Enum.drop(row, 1) end) # Enum, standard lib
        Enum.map(rows, &Enum.drop(&1, 1))
    end
    defp normalize(rows) do
        Enum.map(rows, &parse_amount(&1))
    end
    defp parse_amount([date, descrip, amount]) do # can pass data structure in via arguments... very cool
        [date, descrip, parse_float(amount)]
    end
    defp parse_float(string) do
        string
        |> String.to_float
        |> abs # absolute value convenience method
    end
    defp sort(rows) do
        Enum.sort(rows, &customsort(&1, &2))
    end
    # defp customsort(row1, row2) do # could do this way, and parse columns from there... or pattern matching:
    defp customsort([_, _, prev], [_, _, next]) do
        prev < next # N.B. this is from specs for Enum.sort which is looking for a boolean true/false... so this will feed it what it wants.
    end
    defp print(rows) do
        IO.puts "\nTransactions:"
        Enum.each(rows, &print_console(&1))
    end
    defp print_console([date, descrip, amount]) do
        IO.puts "#{date} #{descrip} \t$#{:erlang.float_to_binary(amount, decimals: 2)}"
    end
end
