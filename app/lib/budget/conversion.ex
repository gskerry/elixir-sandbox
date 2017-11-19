defmodule Budget.Conversion do
    def euro_to_dollar(amount) do
        url = "cs-currency-rates.codeschool.com/currency-rates"
        case HTTPoison.get(url) do
            {:ok, response} -> parse(response) |> convert(amount)
            {:error, _} -> "Error fetching rates"
        end
    end
    # intro "private" functions
    defp parse(%{status_code: 200, body: json_response}) do
        Poison.Parser.parse(json_response) # returns a tuple
    end
end
