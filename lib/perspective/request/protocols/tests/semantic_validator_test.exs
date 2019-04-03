defmodule Perspective.ActionRequest.SemanticValidator.Test do
  use ExUnit.Case

  test "validate_semantics returns the provided data as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      @domain_event nil
    end

    assert [] == Perspective.ActionRequest.SemanticValidator.validate_semantics(DefaultExample.new())
  end
end
