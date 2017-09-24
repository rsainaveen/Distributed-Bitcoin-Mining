defmodule Dosassignment1BitcoinMiner do
  @interval 2000
  @name :server
  def main(args) do
      k = 0
      if  Enum.at(args,0) =~ "." do
               Client.start_link(args)
               #IO.puts "Added Worker to Server"
      else
        initServerNode(String.to_integer(Enum.at(args,0)))
        BitcoinSupervisor.start_link( String.to_integer(Enum.at(args,0)))
        #IO.puts "Server is running"
      end
  end

  def initServerNode(k) do
        {_,addresses}=:inet.getif()
        ips = for {ip, _, _} <- addresses, do: to_string(:inet.ntoa(ip))
       server_ip = to_string(hd(ips))
        head_adress=hd(addresses)
        fullname="server"<>"@"<>to_string(server_ip)
        #IO.puts "#{fullname}"
        Node.start :"#{fullname}"
        # Node.start :"server@192.168.0.6"
        Node.set_cookie :hello
        #pid = spawn(__MODULE__, :generator,[k])
        #:global.register_name(@name, pid)
        :global.sync()
    end
end
