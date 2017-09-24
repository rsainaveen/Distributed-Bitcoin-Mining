
defmodule WorkerModule do
        use GenServer

        def start_link do
            GenServer.start_link(__MODULE__,[])
            #WorkerModule.get_bitcoins(pid, no_of_zeros)
        end

        def get_bitcoins(process_id, k, superpid) do
            GenServer.cast(process_id,{:get_bitcoins, process_id, k, superpid})
        end

        def handle_cast({:get_bitcoins,process_id, k, superpid}, my_state) do
            randomizer(process_id, k, superpid)
            {:noreply, my_state}
        end

        def randomizer(process_id, k, superpid) do
          length = 5
          string = get_string(length)
          #string = RandomBytes.base16(4)
          #string = "COP5615 is a boring class"
          #ufid = IO.gets("Enter UFID: ")
          ufid = "naveen41;"
          string = ufid<>string
          digest = Base.encode16(:crypto.hash(:sha256,string))
          encrypted_message = String.slice(""<>digest,0..k-1)
          zero_message = generate_message("",k)
          bitcoin = ""
          if String.starts_with?(zero_message,encrypted_message) === true do
            bitcoin = string <> "\t" <> digest
            ManagerModule.collect_bitcoins(superpid, bitcoin, process_id)
        end
          randomizer(process_id, k, superpid)
        end

        def generate_message(message,k) when k == 0 do
          message
        end
        def generate_message(message,k) do
          generate_message(message<>"0",k-1)
        end

      def seed_random do
          use_monotonic = :erlang.module_info
              |> Keyword.get( :exports )
              |> Keyword.get( :monotonic_time )
          time_bif = case use_monotonic do
            1   -> &:erlang.monotonic_time/0
            nil -> &:erlang.now/0
          end
          :random.seed( time_bif.() )
      end

      def string( length ) do
          get_string( length)
      end

      def string() do
          get_string( 8 )
      end
      defp get_string(length) do
        seed_random
        alphabets = "abcdefghijklmnopqrstuvwxyz"
        numbers = "0123456789"
        lists = alphabets <> String.upcase(alphabets) <> numbers
          #len = get_range(length)
          #len |> Enum.reduce([],fn(_,acc) -> [Enum.random(lists) | acc] end) |> Enum.join("")
        lists_length = lists |> String.length
        1..length |> Enum.map_join(
          fn(_) ->
            lists |> String.at( :random.uniform( lists_length ) - 1 )
          end
          )
      end
      def number( length ) do
        get_number( length )
    end

    def get_number( length ) do
        seed_random

        { number, "" } =
          Integer.parse 1..length
          |> Enum.map_join( fn(_) ->  :random.uniform(10) - 1 end )

        number
   end

end
      #Bitcoin.start([3])
