
# functions:
    # Can be assigned to variables
    # Can be assigned to other functions


# full module
defmodule Account do
    def max_balance(amount) do
        "Max: #{amount}"
    end
end

Account.max_balance(500)
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
defmodule Account do
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

Account.run_transaction(1000, 20, withdrawal)
Account.run_transaction(1000, 20, deposit)
Account.run_transaction(0, 20, deposit)



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
Account.run_transaction(1000, 20, &(&1 + &2))

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

defmodule Language do
    def print_list ([head | tail]) do
        IO.puts "Head:  #{head}"
        IO.puts "Tail:  #{tail}"
    end
end

Language.print_list(["Elixir", "JavaScript", "Ruby"])
Language.print_list(languages)


# *** No For loops in elixir *** RECURSION ONLY
defmodule Language2 do
    def print_list ([head | tail]) do # recursive case
        IO.puts "Head:  #{head}"
        print_list(tail)
    end
    def print_list([]) do # "base case" or "terminating scenario"
        "...all done."
    end
end

Language2.print_list(languages)




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


defmodule Account2 do
    def parse_file({:ok, content}) do
        IO.puts "Transactions: #{content}"
    end
    def parse_file({:error, error}) do
    # def parse_file({:error, _ }) do # if want to ignore error returned but not trigger a warning (elixir will warn when arguments go unused)
        IO.puts "Error parsing file: #{error}"
    end
end

# *PIPE operator
File.read("transactions.csv") |> Account2.parse_file()
