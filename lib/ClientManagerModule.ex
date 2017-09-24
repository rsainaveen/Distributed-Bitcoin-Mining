defmodule ClientManagerModule do
    use GenServer

    def start_link(args) do

        ##IO.puts "#{no_of_actors} #{no_of_zeros}"
        #args = [no_of_actors,no_of_zeros]
        no_of_actors = Enum.at(args,0)
        no_of_zeros = Enum.at(args,1)
        {:ok, superpid} = GenServer.start_link(__MODULE__,[])
        #IO.puts "Process Manager Module started: "
        #IO.inspect superpid
        ##IO.puts "Creating #{no_of_actors} actors:"
        pids = create_actors(no_of_zeros,no_of_actors,[])
        #IO.puts "Following number of pids created: "
        #IO.puts length(pids)
        bitcoins = []
        Enum.each(pids, fn(pid) ->
            #IO.puts "In here"
            #IO.inspect pid
            ClientWorkerModule.get_bitcoins(pid, no_of_zeros, superpid)
        end )
        :timer.sleep(10000000)
        #IO.puts length(bitcoins)
        {:ok, pids}
    end
    def collect_bitcoins(process_id, bitcoin, sender_id) do
        GenServer.cast(process_id, {:collect_bitcoin_async, bitcoin,sender_id})
    end
    def handle_cast({:collect_bitcoin_async, bitcoin, sender_id},my_state) do
        #bitcoins = []
        #Enum.concat(bitcoins, [bitcoin])
        ManagerModule.collect_bitcoins(:global.whereis_name(:servermod), bitcoin, sender_id)
        #IO.puts "worker"<>bitcoin
        #IO.inspect Node.self
        {:noreply, my_state}
    end

    def create_actors(k,actors,pids) do
        if actors == 1 do
         {:ok, pid} = WorkerModule.start_link
         #WorkerModule.get_bitcoins(pid, k)
         #IO.inspect pid
         pids = Enum.concat([pid],pids)
        else
            {:ok, pid} = WorkerModule.start_link
            #WorkerModule.get_bitcoins(pid, k)
            #IO.inspect pid
            pids = Enum.concat([pid],pids)
            create_actors(k,actors-1,pids)
        end
    end
end


#{:ok, basic_pid} = Basic.start_link()
#greeting = Basic.get_the_status(basic_pid)
##IO.puts greeting
#Basic.set_the_status(basic_pid, "hello all")
#greeting = Basic.get_the_status(basic_pid)
##IO.puts greeting
