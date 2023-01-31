defmodule BaseballDigitalManager.Libraries do
	@moduledoc """
	The Libraries context.
	"""

	import Ecto.Query, warn: false
	alias BaseballDigitalManager.Repo

	alias BaseballDigitalManager.Libraries.Library

	def get_library!(id), do: Repo.get!(Library, id)
end