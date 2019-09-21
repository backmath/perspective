defmodule Perspective.ActionRequest.SyntaxValidator.Test do
  use ExUnit.Case, async: true

  test "validate_syntax returns the provided data as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      domain_event(Perspective.ActionRequest.SyntaxValidator.Test.DefaultExample.Event, "1.0")
    end

    assert [] == Perspective.ActionRequest.SyntaxValidator.validate_syntax(DefaultExample.new())
  end
end
