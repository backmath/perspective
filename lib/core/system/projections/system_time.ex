defmodule Core.System.SystemTime do
  use Perspective.Projection

  expose("system://time", Core.Services.SystemClock)
end
