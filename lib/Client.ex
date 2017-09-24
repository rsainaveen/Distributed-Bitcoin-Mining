defmodule Client do
    @name :client
    @clientNum 1

    use GenServer
    defp do_randomizer(length, lists) do
          len = get_range(length)
          len |> Enum.reduce([],fn(_,acc) -> [Enum.random(lists) | acc] end) |> Enum.join("")
        end

        @doc false
        defp get_range(length) when length > 1, do: (1..length)
        defp get_range(length), do: [1]

    def start_link(args) do
        :global.sync()
        {_,addresses}=:inet.getif()
        ips = for {ip, _, _} <- addresses, do: to_string(:inet.ntoa(ip))
        client_ip = to_string(hd(ips))
        #head_adress=hd(addresses)
        number = :rand.uniform(1000)
        fullname="client"<>Integer.to_string(number)<>"@"<>to_string(client_ip)
        #IO.puts "#{fullname}"
        Node.start :"#{fullname}"
        Node.set_cookie :hello
        Node.connect :"server@#{args}"
        :global.sync()
        id = :global.whereis_name(:servermod)
        k = ManagerModule.get(id, [])
        #IO.puts k
        ClientManagerModule.start_link([8,k])
        #Dosassignment1BitcoinMiner.register(:"#{fullname}")
        #Dosassignment1BitcoinMiner.register(pid)

        ##IO.puts Node.list
        ##IO.puts "#{inspect erlang:nodes()}"
    end


end
