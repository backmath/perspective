defmodule Perspective.ActionRequest.SyntaxValidator.Test do
  use ExUnit.Case

  test "validate_syntax returns the provided data as a fallback" do
    defmodule DefaultExample do
      use Perspective.ActionRequest
      @domain_event nil
    end

    assert [] == Perspective.ActionRequest.SyntaxValidator.validate_syntax(DefaultExample.new())
  end
end
