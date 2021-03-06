
defmodule Routeguide.RouteGuide.Service do
  use GRPC.Service, name: "routeguide.RouteGuide"

  rpc :GetFeature, Routeguide.Point, Routeguide.Feature
  rpc :ListFeatures, Routeguide.Rectangle, stream(Routeguide.Feature)
  rpc :RecordRoute, stream(Routeguide.Point), Routeguide.RouteSummary
  rpc :RouteChat, stream(Routeguide.RouteNote), stream(Routeguide.RouteNote)
end

defmodule Routeguide.RouteGuide.Stub do
  use GRPC.Stub, service: Routeguide.RouteGuide.Service
end

defmodule Routeguide do
  use Protobuf, """
syntax = "proto3";

option java_multiple_files = true;
option java_package = "io.grpc.examples.routeguide";
option java_outer_classname = "RouteGuideProto";

package routeguide;

service RouteGuide {
  rpc GetFeature(Point) returns (Feature) {}
  rpc ListFeatures(Rectangle) returns (stream Feature) {}
  rpc RecordRoute(stream Point) returns (RouteSummary) {}
  rpc RouteChat(stream RouteNote) returns (stream RouteNote) {}
}

message Point {
  int32 latitude = 1;
  int32 longitude = 2;
}

message Rectangle {
  Point lo = 1;
  Point hi = 2;
}

message Feature {
  string name = 1;
  Point location = 2;
}

message RouteNote {
  Point location = 1;
  string message = 2;
}

message RouteSummary {
  int32 point_count = 1;
  int32 feature_count = 2;
  int32 distance = 3;
  int32 elapsed_time = 4;
}
  """
end
