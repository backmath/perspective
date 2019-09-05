defmodule Perspective.Reactor.MacroParser.Test do
  use ExUnit.Case, async: true

  defmodule ExampleEvent do
    defstruct data: :b
  end

  test "capture_event_name 1" do
    quoted_signature =
      quote do
        %ExampleEvent{}
      end

    result = Perspective.Reactor.MacroParser.capture_event_name(quoted_signature)

    assert result == {:__aliases__, [alias: Perspective.Reactor.MacroParser.Test.ExampleEvent], [:ExampleEvent]}
  end

  test "capture_event_name 2" do
    quoted_signature =
      quote do
        %ExampleEvent{} = event
      end

    result = Perspective.Reactor.MacroParser.capture_event_name(quoted_signature)

    assert result == {:__aliases__, [alias: Perspective.Reactor.MacroParser.Test.ExampleEvent], [:ExampleEvent]}
  end

  test "capture_event_name 3" do
    quoted_signature =
      quote do
        %ExampleEvent{data: %ExampleEvent{data: b}} = event
      end

    result = Perspective.Reactor.MacroParser.capture_event_name(quoted_signature)

    assert result == {:__aliases__, [alias: Perspective.Reactor.MacroParser.Test.ExampleEvent], [:ExampleEvent]}
  end
end
