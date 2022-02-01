defmodule Exqueue.Queue do
  use GenServer

  # Client

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state)
  end

  def enqueue(pid, element) do
    GenServer.cast(pid, {:push, element})
  end

  def dequeue(pid) do
    GenServer.call(pid, :pop)
  end

  # Server

  @impl true
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  @impl true
  def handle_call(_, _from, queue), do: {:reply, "Invalid parameters", queue}

  @impl true
  def handle_cast({:push, element}, queue) do
    updated_queue = List.insert_at(queue, -1, element)
    {:noreply, updated_queue}
  end
end
