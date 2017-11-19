defmodule App.Conversion do
    @doc """
    FYI, internals on parsing
    Returned JSON from conversion API...
    [
        { "currency": "euro", "rate": 0.94 },
        { "currency": "pound", "rate": 0.79 }
    ]
    Conversion...
    Elixir tuple
    {:ok, [ # list of maps...
        %{"currency" => "euro", "rate" => 0.94},
        %{"currency" => "pound", "rate" => 0.79}
    ]}
    """
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
    defp convert({:ok, rates}, amount) do
        rate = find_euro(rates) # new function being called* To be defined.
        amount / rate
    end
    # recall, no if statements
    defp find_euro([%{"currency" => "euro", "rate" => rate} | _]) do
        rate
        # more than a little odd that pattern matching and variable setting are ocurring in the 'arguments' to the function...
    end
    defp find_euro([_ | tail]) do # defining a separate function?... with the same name?!?
        find_euro(tail)
    end
    defp find_euro([]) do
        raise "no rate found for Euro" # analog to 'throw'
    end
end
