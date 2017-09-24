defmodule BitcoinSupervisor do
    use Supervisor

    def start_link(args) do
        Supervisor.start_link(__MODULE__,args)
    end
    def init(args) do
        ##IO.puts Enum.at(args,0) <>"\t"<> Enum.at(args,1)
        actors = 8 #String.to_integer(Enum.at(args,0))

        zeros = args
        k=[actors,zeros]
        children = [
            worker(ManagerModule,k)
        ]
        supervise(children, strategy: :one_for_one)
    end
end
