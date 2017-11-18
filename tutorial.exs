
# functions:
    # Can be assigned to variables
    # Can be assigned to other functions


# full module
defmodule AccountMax do
    def max_balance(amount) do
        "Max: #{amount}"
    end
end

AccountMax.max_balance(500)
# js => method on an object/class


# No module
# "Anonymous"
# function assigned its own variable.
max_balance = fn(amount) -> "Max: #{amount}" end
# not sure what is anonymous about a defined variable...

# invoke
max_balance.(500)
max_balance.() # will return error: BadArityError


# "Decoupling"
defmodule AccountValid do
    def run_transaction(balance, amount, transaction) do
        if balance <= 0 do
            "Cannot perform any transaction"
        else
            transaction.(balance, amount) # The 'Callback'
        end
    end
end

# :/ kind of odd...
# running a function 'transaction(bal, amount)'... but passing the whole thing through a function to essentially validate the arguments to transaction...
# rather than just placing the validation logic inside transaction...
# Guess that is what's been decoupled...
# But seems to be done at the cost of introducing Russian dolls... potential 'callback hell'


# the callbacks
deposit = fn(balance, amount) -> balance + amount end
withdrawal = fn(balance, amount) -> balance - amount end

AccountValid.run_transaction(1000, 20, withdrawal)
AccountValid.run_transaction(1000, 20, deposit)
AccountValid.run_transaction(0, 20, deposit)



# function "clauses"
account_transaction = fn
    (balance, amount, :deposit) -> balance + amount
    (balance, amount, :withdrawal) -> balance - amount
end
# syntax convenience allows for variable logic, depending on a (special) argument, without the use of if, else

account_transaction.(100, 40, :deposit)
account_transaction.(100, 40, :withdrawal)


# Shorthand
deposit = fn(balance, amount) -> balance + amount end
#  ='s'
deposit = &(&1 + &2)
deposit.(2, 2)
# > 4
# (remember the dot)

# Shorthand callback (inline)
AccountValid.run_transaction(1000, 20, &(&1 + &2))

# shorthand inline to a map function
Enum.map([1,2,3,4], &(&1 * 2))
# array is arg1... mapped... each item in array (n * 2)...
# > [2, 4, 6, 8]
# outputs a new array



######
# 2
######

languages = ["Elixir", "JavaScript", "Ruby"]
# some sort of analogue to push, pop, and array dot notation...

defmodule LanguagePrint do
    def print_list ([head | tail]) do
        IO.puts "Head:  #{head}"
        IO.puts "Tail:  #{tail}"
    end
end

LanguagePrint.print_list(["Elixir", "JavaScript", "Ruby"])
LanguagePrint.print_list(languages)


# *** No For loops in elixir *** RECURSION ONLY
defmodule LanguageRecur do
    def print_list ([head | tail]) do # recursive case
        IO.puts "Head:  #{head}"
        print_list(tail)
    end
    def print_list([]) do # "base case" or "terminating scenario"
        "...all done."
    end
end

LanguageRecur.print_list(languages)




######
# 3
######

# Tuples: ordered lists of elements
{:functional, "elixir", 2012}
# varying types

# matching...
{status, content} = {:ok, "some content"}
{:error, message} = {:error, "some error occurred"}

# ???
# have to backfill on the 'standard library'...
# but there are essentially known output formats from existing functions...
# using atoms
# ...
# Tutorial GAP:
# Defined how to take atom inputs...
account_transaction = fn
    (balance, amount, :deposit) -> balance + amount
    (balance, amount, :withdrawal) -> balance - amount
end
# But not atom outputs...
# presumbly in this tuple format...
# But don't see xplicit example.


defmodule AccountAtoms do
    def parse_file({:ok, content}) do
        IO.puts "Transactions: #{content}"
    end
    def parse_file({:error, error}) do
    # def parse_file({:error, _ }) do # if want to ignore error returned but not trigger a warning (elixir will warn when arguments go unused)
        IO.puts "Error parsing file: #{error}"
    end
end

# *PIPE operator
File.read("transactions.csv") |> AccountAtoms.parse_file()


# KEYWORD LIST
AccountAtoms.balance(..., currency: "dollar", symbol: "$")
# shorthand convenience syntax, cleaner
# ='s
AccountAtoms.balance(..., [{:currency, "dollar"}, {:symbol, "$"}])


# inside function, can then use something analogous to object or array dot notation
defmodule AccountBalance do
    def balance(balance, options \\ []) do # (!) no arguments are optional automatically, visavi js. Have to specify.
        currency = options[:currency]
        symbol = options[:symbol]
        # to define...
        balance = calculate_balance(transactions)
        "Balance in #{:currency}: #{:symbol}#{:balance}"
    end
end

# In above version, if options are blank, the output will return with spaces/gaps for those variables. Can instead use OR operators to allow for defaults
defmodule AccountBalance do
    def balance(balance, options \\ []) do # (!) no arguments are optional automatically, visavi js. Have to specify.
        currency = options[:currency] || "dollar" # dollar returned if left evals to false/blank
        symbol = options[:symbol] || "$"
        # to define...
        balance = calculate_balance(transactions)
        "Balance in #{:currency}: #{:symbol}#{:balance}"
    end
end

# *** Ecto ***
# SQL ODM that uses tuples to build queries


# So how do you store state or data? We don't have any objects in FP...
# MAPs...

person = %{ "name" => "Brooke", "age" => 42 }
# presume the map is a map *function (2confirm, elixir standard lib)

# 2 ways of retrieving
Map.fetch(person, "name")
Map.fetch!(person, "name")
# key is present, OK, both return the same

# Difference is in error handling
Map.fetch(person, "banana") # returns the error atom :error
Map.fetch!(person, "banana") # returns the error message



person = %{ "name" => "Brooke", "age" => 42 }
# (?) below apparently also a map...
# setting keys to variables
# 2backfill: creation of map vs fetch, retrieval of map... same syntax?
%{ "name" => name, "age" => age} = person
IO.puts name
# (!!!) But is this not creating global variables? (variables that are not functions)
# risk for all the same state headaches as OOP, no?

# further confusion... tutorial says above should produce a "age variable not used" warning...
# it doesn't, presumably b/c these are global... there's no scope for which it's not used...
# seems IRL scenario this would all be within a properly defined module

# point being that, unlike options arguments, in the map you can just remove what you don't plan to use
%{ "name" => name} = person # 2backfill... this flipping syntax... apparently used when righthand side is defined and you're pulling something from it.
IO.puts name


# MAPS vs TUPLES
person = %{ "name" => "Brooke", "age" => 42 }
%{ "name" => name} = person
IO.puts name

person = [{:name, "Barbara"}, {:age, 50}]
[{:name, name}] = person
# > ** (MatchError) no match of right hand side value: [name: "Booke", age: 42]
# 2backfill 'right-hand-side' syntax
IO.puts name
# > Brooke (i.e. setting name var through tuples fails completely)


# Nested Objects, er, Maps...
person = %{"name" => "Brooke",
    "address" => %{"city" => "Orlando", "state" => "FL"}
}

%{ "address" => %{ "state" => state }} = person
IO.puts "State: #{state}"
# var state = person.address.state
# Perhaps not surprisingly, FP seems to lag OOP in conveying structured data
# Storage via functions is predictably a little wonky




######
# 4
######
defmodule AccountNested do
    def list_transactions(filename) do
        { result, content } = File.read(filename)

        if result == :ok do
            "Content: #{content}"
        else
            if result == :error do # nested if = "code smell"
                "Error: #{content}"
            end
        end
    end
end

defmodule AccountCase do
    def list_transactions(filename) do
        {result, content} = File.read(filename) # Recall File.read returns tuple-formatted with a status atom and message. Here, setting to 'result' and 'content' variables
        case result do
            :ok -> "Content: #{content}"
            :error -> "Error: #{content}" # yes, this is still sub-optimal... setting generic variable name to 'content'... doesn't convey when error message and not file content
        end
    end
end
# "test value"
# "patterns"

defmodule AccountBetterCase do
    def list_transactions(filename) do
        case File.read(filename) do # remove temp variables... call the fileread directly within the case structure
            {:ok, content} -> "Content: #{content}" # now setting variables on the fly... can use more logical naming
            {:error, type} -> "Error: #{type}"
        end
    end
end

Account.list_transactions("transactions.csv")


defmodule AccountGuarded do
    def list_transactions(filename) do
        case File.read(filename) do
            {:ok, content} # not clear why this needs to be defined twice...
                when byte_size(content) > 10 -> "Content: (...)"
            {:ok, content} -> "Content: #{content}"
            {:error, type} -> "Error: #{type}"
        end
    end
end
# ???
# why 2 {:ok, content} ?
# Diff btw when case and {:ok, content} case? They're both returning the content?

AccountGuarded.list_transactions("transactions.csv")

defmodule AccountGuarded do
    def list_transactions(filename) do
        case File.read(filename) do
            {:ok, content} when byte_size(content) > 10 -> "Content: (...)"
            {:ok, content} -> "Content: #{content}"
            {:error, type} -> "Error: #{type}"
        end
    end
end
# Think it was just the nested format throwing off
# (!) Still unclear whether logic is inclusive/exclusive
    # is 2nd {:ok, content} automatically size < 10? Or is it as written? (Returns for everything?)


defmodule AccountTransfer do
    def validate_transfer(amount, hourOfDay) do
        if hourOfDay < 12 do
            amount <= 5000
        else
            if hourOfDay < 18 do
                amount <= 1000
            else
                amount <= 300
            end
        end # Nested ifs :(
    end
    def perform_transfer(from_acct, to_acct, amount) do
        {:success, "#{amount} transfered from #{from_acct} to #{to_acct}"}
    end
    def transfer_amount(from_acct, to_acct, amount) do
        hourOfDay=DateTime.utc_now.hour # elixir standard library
        if !validate_transfer(amount, hourOfDay) do
            {:error, "Invalid Transfer"}
        else
            perform_transfer(from_acct, to_acct, amount)
        end
    end
end

# The COND statement
defmodule AccountTransfer do
    def validate_transfer(amount, hourOfDay) do
        cond do
            hourOfDay < 12 -> amount <= 5000
            hourOfDay < 18 -> amount <= 1000
            true -> amount <=300 # catch
        end
    end
    def perform_transfer(from_acct, to_acct, amount) do
        {:success, "#{amount} transfered from #{from_acct} to #{to_acct}"}
    end
    def transfer_amount(from_acct, to_acct, amount) do
        hourOfDay=DateTime.utc_now.hour # elixir standard library
        if !validate_transfer(amount, hourOfDay) do
            {:error, "Invalid Transfer"}
        else
            perform_transfer(from_acct, to_acct, amount)
        end
    end
end

AccountTransfer.transfer_amount(112233, 445566, 5001)
AccountTransfer.transfer_amount(112233, 445566, 299)



# CASE vs COND
case File.read(filename) do
    {:ok, content} when byte_size(content) > 10 -> "Content: (...)"
    {:ok, content} -> "Content: #{content}"
    {:error, type} -> "Error: #{type}"
end
# "matching on multiple patterns"

cond do
    hourOfDay < 12 -> amount <= 5000
    hourOfDay < 18 -> amount <= 1000
    true -> amount <=300 # catch
end
# "checking on multiple conditions"

# ??
# Think this may answer the question on case inclusive/exclusive...
# A: exlcusive... case logic produces 1 match.
# COND logic can present *overlapping conditionals. Deciphers which takes precedent.
    # e.g. 10am is < 12 AND < 18... but the <12 logic is applied.
