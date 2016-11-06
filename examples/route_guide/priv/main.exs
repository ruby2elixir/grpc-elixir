features = Routeguide.RouteGuide.Server.load_features
state = %{route_notes: %{}}
# state = %{features: features, route_notes: %{}}
GRPC.Server.start(Routeguide.RouteGuide.Server, "localhost:50051", insecure: true, state: state)

RouteGuide.Client.main()

:ok = GRPC.Server.stop(Routeguide.RouteGuide.Server)
