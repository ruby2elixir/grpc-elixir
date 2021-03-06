<%= if use_proto_path do %>
defmodule <%= top_mod %> do
  @external_resource Path.expand("<%= proto_path %>", __DIR__)
  use Protobuf, from: Path.expand("<%= proto_path %>", __DIR__)
end
<% end %>
<%= Enum.map proto.services, fn(service) -> %>
defmodule <%= top_mod %>.<%= service.name %>.Service do
  use GRPC.Service, name: "<%= service_prefix %><%= service.name %>"

  <%= for rpc <- service.rpcs do %>
  <%= compose_rpc.(rpc, top_mod) %>
  <% end %>
end

defmodule <%= top_mod %>.<%= service.name %>.Stub do
  use GRPC.Stub, service: <%= top_mod %>.<%= service.name %>.Service
end
<% end %>
<%= if !use_proto_path do %>
defmodule <%= top_mod %> do
  use Protobuf, """
  <%= proto_content %>
  """
end
<% end %>
