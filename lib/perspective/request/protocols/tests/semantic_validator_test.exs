defmodule Perspective.ActionRequest.SemanticValidator.Test do
  use ExUnit.Case, async: true

  test "validate_semantics returns the provided data as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      domain_event(Perspective.ActionRequest.SemanticValidator.Test.DefaultExampleEvent, "1.0")
    end

    assert [] == Perspective.ActionRequest.SemanticValidator.validate_semantics(DefaultExample.new())
  end
end
