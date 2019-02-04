defimpl Perspective.ActionTransformer, for: BackMath.AddToDo do
  @action BackMath.AddToDo
  @event BackMath.ToDoAdded

  def transform(%@action{} = action) do
    %@event{
      id: UUID.uuid4(),
      name: action
    }
  end
end
