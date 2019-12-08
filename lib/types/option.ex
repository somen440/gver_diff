defmodule GverDiffType do
  defstruct name: nil

  @type t(name) :: %GverDiffType{name: name}

  @type name_atom :: :string | :integer | :float | :daettime | :date | :version

  @type t :: %GverDiffType{name: name_atom}

  @spec new(binary) :: GverDiffType.t()
  def new(name) do
    %GverDiffType{:name => String.to_atom(name)}
  end
end
