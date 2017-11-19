defmodule App.Reporting do
    def list_transactions do
        "Listing tx's..."
        # File.read("lib/transactions-jan.csv") # returns full tuple
        File.read!("lib/transactions-jan.csv") # returns content directly (or error if file is missing... don't have conditional logic to apply to an error tuple, so this works)
    end
end
