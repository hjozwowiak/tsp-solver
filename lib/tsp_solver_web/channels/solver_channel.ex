defmodule TspSolverWeb.SolverChannel do
  use Phoenix.Channel

  def join("solver:" <> _id, _params, socket) do
    {:ok, socket}
  end

  def handle_in("solve", %{"body" => body}, socket) do
    broadcast!(socket, "solution", %{body: body})
    {:noreply, socket}
  end
end
