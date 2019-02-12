# defmodule BackMath.AddRenameCompleteTest do
#   use ExUnit.Case

#   test "lifecycle event" do
#     [first | remaining] = Jason.decode!(load_data())

#     Perspective.call("missing_token", first)

#     # todo_id = "laskdjf"

#     # remaining
#     # |> Enum.map(fn json ->
#     #   put_in(json, [:data, :id], todo_id)
#     # end)
#   end

#   defp load_data() do
#     File.read!("./test/backmath/lifecycle_tests/todo/add_rename_complete_test.json")
#   end
# end
