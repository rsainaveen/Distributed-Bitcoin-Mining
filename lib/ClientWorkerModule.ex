
defmodule ClientWorkerModule do
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

           alphabets = "abcdefghijklmnopqrstuvwxyz"
          numbers = "0123456789"
          lists = alphabets <> String.upcase(alphabets) <> numbers |> String.split("", trim: true)
          length = 5
          string = do_randomizer(length, lists)
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
            ClientManagerModule.collect_bitcoins(superpid, bitcoin, process_id)
        end
          randomizer(process_id, k, superpid)
        end
        def generate_message(message,k) when k == 0 do
          message
        end
        def generate_message(message,k) do
          generate_message(message<>"0",k-1)
        end

        @doc false
        defp get_range(length) when length > 1, do: (1..length)
        defp get_range(length), do: [1]

        @doc false
        defp do_randomizer(length, lists) do
          len = get_range(length)
          len |> Enum.reduce([],fn(_,acc) -> [Enum.random(lists) | acc] end) |> Enum.join("")
        end
        
      end
      #Bitcoin.start([3])
