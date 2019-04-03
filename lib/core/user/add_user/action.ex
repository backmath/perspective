defmodule Core.AddUser do
  use Perspective.ActionRequest

  @domain_event Core.UserAdded

  defmodule Data do
    use Vex.Struct
    defstruct [:username, :password, :password_confirmation]

    validates(:username, presence: true)
    validates(:password, presence: true)
    validates(:password_confirmation, &Data.matches_password_confirmation/2)

    def matches_password_confirmation(password_confirmation, %{password: password}) do
      case password_confirmation do
        ^password -> :ok
        _no_match -> {:error, :password_and_password_confirmation_do_not_match}
      end
    end
  end

  validate_syntax(%{data: data}) do
    Vex.errors(struct(Data, data))
  end

  def skip_authentication? do
    true
  end
end
