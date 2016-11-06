defmodule GRPC.Adapter.Cowboy.Handler do
  alias GRPC.Transport.HTTP2

  @adapter GRPC.Adapter.Cowboy

  def init(req, {server, state, opts}) do
    raise "test"
    IO.inspect state
    stream = %GRPC.Server.Stream{server: server, adapter: @adapter, state: state}
    req = :cowboy_req.stream_reply(200, HTTP2.server_headers, req)
    stream = %{stream | payload: req}
    trailers = HTTP2.server_trailers
    case server.__call_rpc__(:cowboy_req.path(req), stream) do
      {:ok, %{payload: req, state: new_state} = stream, response} ->
        GRPC.Server.stream_send(stream, response)
        :cowboy_req.stream_trailers(trailers, req)
        {:ok, req, {server, new_state, opts}}
      {:ok, %{payload: req, state: new_state}} ->
        IO.puts "=================="
        IO.inspect new_state
        :cowboy_req.stream_trailers(trailers, req)
        {:ok, req, {server, new_state, opts}}
      {:error, %{payload: req}, _reason} ->
        # TODO handle error branch
        {:ok, req, {server, state, opts}}
    end
  end
end


# [{'Elixir.GRPC.Adapter.Cowboy.Handler',init,2,[{file,"lib/grpc/adapter/cowboy/handler.ex"},{line,7}]},
# {cowboy_handler,execute,2,[{file,"src/cowboy_handler.erl"},{line,39}]},
# {'Elixir.GRPC.Adapter.Cowboy.StreamHandler',execute,3,[{file,"lib/grpc/adapter/cowboy/stream_handler.ex"},{line,121}]},
# {'Elixir.GRPC.Adapter.Cowboy.StreamHandler',proc_lib_hack,3,[{file,"lib/grpc/adapter/cowboy/stream_handler.ex"},{line,110}]},
# {proc_lib,init_p_do_apply,3,[{file,"proc_lib.erl"},{line,247}]}]
